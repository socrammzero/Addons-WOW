<#
.SYNOPSIS
    Sincroniza los archivos traducidos de Addons-WOW a la carpeta de World of Warcraft.
.DESCRIPTION
    Lee la configuración de config.json y copia los archivos fuente de cada addon activo
    hacia la ruta de AddOns del juego.
.PARAMETER AddonName
    (Opcional) Nombre o carpeta del addon específico a sincronizar. Si se omite, sincroniza todos los activos.
.PARAMETER DryRun
    Si se especifica, simula la copia sin modificar ningún archivo en el juego.
.PARAMETER ForceAll
    Fuerza la copia de todos los archivos aunque ya sean idénticos en destino.
#>
[CmdletBinding()]
param (
    [string]$AddonName = "",
    [switch]$DryRun,
    [switch]$ForceAll
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
$configFile = Join-Path $projectRoot "config.json"

if (-not (Test-Path $configFile)) {
    Write-Error "No se encontro el archivo de configuracion: $configFile"
    return
}

$config = Get-Content $configFile -Raw -Encoding UTF8 | ConvertFrom-Json
$wowPath = $config.wowAddonsPath

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Arthur: Sincronizacion de Traducciones esES hacia WoW" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

if (-not (Test-Path $wowPath)) {
    Write-Warning "La ruta de World of Warcraft especificada no existe:"
    Write-Warning "  $wowPath"
    Write-Warning "Por favor, configure la ruta real de su juego en: config.json"
    return
}

Write-Host "Ruta destino de WoW: $wowPath`n" -ForegroundColor DarkGray

$targetAddons = $config.addons | Where-Object { $_.sync -eq $true }
if ($AddonName) {
    $targetAddons = $targetAddons | Where-Object { 
        $_.folderName -like "*$AddonName*" -or $_.name -like "*$AddonName*" 
    }
}

if (-not $targetAddons) {
    Write-Warning "No se encontraron addons activos para sincronizar con el filtro actual."
    return
}

$copiedCount = 0
$skippedCount = 0

function Test-FilesIdentical([System.IO.FileInfo]$srcFile, [string]$destPath) {
    if (-not (Test-Path -LiteralPath $destPath)) { return $false }
    $dstInfo = Get-Item -LiteralPath $destPath
    if ($srcFile.Length -ne $dstInfo.Length) { return $false }
    if ([Math]::Abs(($srcFile.LastWriteTimeUtc - $dstInfo.LastWriteTimeUtc).TotalMilliseconds) -le 10) {
        return $true
    }
    $sBytes = [System.IO.File]::ReadAllBytes($srcFile.FullName)
    $dBytes = [System.IO.File]::ReadAllBytes($destPath)
    if ($sBytes.Length -ne $dBytes.Length) { return $false }
    for ($i = 0; $i -lt $sBytes.Length; $i++) {
        if ($sBytes[$i] -ne $dBytes[$i]) { return $false }
    }
    return $true
}

foreach ($addon in $targetAddons) {
    $srcAddonDir = Join-Path $projectRoot "src\$($addon.folderName)"
    $destAddonDir = Join-Path $wowPath $addon.folderName

    if (-not (Test-Path $srcAddonDir)) {
        Write-Warning "  El directorio fuente no existe: $srcAddonDir. Omitiendo."
        continue
    }

    $sourceFiles = Get-ChildItem -Path $srcAddonDir -Recurse -File | Where-Object { $_.Name -ne "README.md" -and $_.Name -ne ".gitkeep" }

    if (-not $sourceFiles) {
        continue
    }

    $addonCopied = 0

    foreach ($file in $sourceFiles) {
        $relativePath = $file.FullName.Substring($srcAddonDir.Length).TrimStart("\", "/")
        $targetFilePath = Join-Path $destAddonDir $relativePath
        $targetDir = Split-Path -Parent $targetFilePath

        $same = (-not $ForceAll) -and (Test-FilesIdentical $file $targetFilePath)
        if ($same) {
            $skippedCount++
            continue
        }

        if ($DryRun) {
            if ($addonCopied -eq 0) { Write-Host "Procesando: $($addon.name) [$($addon.folderName)]" -ForegroundColor Yellow }
            Write-Host "  [Simulacion] Se copiaria: $relativePath" -ForegroundColor DarkCyan
            $addonCopied++
        } else {
            if ($addonCopied -eq 0) { Write-Host "Procesando: $($addon.name) [$($addon.folderName)]" -ForegroundColor Yellow }
            if (-not (Test-Path $targetDir)) {
                New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            }
            Copy-Item -Path $file.FullName -Destination $targetFilePath -Force
            Write-Host "  [Copiado] $relativePath" -ForegroundColor Green
            $copiedCount++
            $addonCopied++
        }
    }
}

Write-Host "`n----------------------------------------------------------" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host "Simulacion completada exitosamente." -ForegroundColor Cyan
} else {
    Write-Host "Sincronizacion completada con exito. Copiados: $copiedCount | Sin cambios: $skippedCount" -ForegroundColor Green
    Write-Host "Recordatorio: Si el juego esta abierto, escriba '/reload' en el chat para aplicar los cambios." -ForegroundColor Yellow
}
Write-Host "----------------------------------------------------------`n" -ForegroundColor Cyan
