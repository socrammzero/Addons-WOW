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
#>
[CmdletBinding()]
param (
    [string]$AddonName = "",
    [switch]$DryRun
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

foreach ($addon in $targetAddons) {
    $srcAddonDir = Join-Path $projectRoot "src\$($addon.folderName)"
    $destAddonDir = Join-Path $wowPath $addon.folderName

    Write-Host "Procesando: $($addon.name) [$($addon.folderName)]" -ForegroundColor Yellow

    if (-not (Test-Path $srcAddonDir)) {
        Write-Warning "  El directorio fuente no existe: $srcAddonDir. Omitiendo."
        continue
    }

    $sourceFiles = Get-ChildItem -Path $srcAddonDir -Recurse -File | Where-Object { $_.Name -ne "README.md" -and $_.Name -ne ".gitkeep" }

    if (-not $sourceFiles) {
        Write-Host "  Sin archivos de traduccion en 'src/$($addon.folderName)'. Omitiendo." -ForegroundColor DarkGray
        continue
    }

    if (-not (Test-Path $destAddonDir)) {
        Write-Warning "  El addon no parece estar instalado en WoW ($destAddonDir)."
        if (-not $DryRun) {
            New-Item -ItemType Directory -Path $destAddonDir -Force | Out-Null
            Write-Host "  Directorio de destino creado." -ForegroundColor DarkGray
        }
    }

    foreach ($file in $sourceFiles) {
        $relativePath = $file.FullName.Substring($srcAddonDir.Length).TrimStart("\", "/")
        $targetFilePath = Join-Path $destAddonDir $relativePath
        $targetDir = Split-Path -Parent $targetFilePath

        if ($DryRun) {
            Write-Host "  [Simulacion] Se copiaria: $relativePath" -ForegroundColor DarkCyan
        } else {
            if (-not (Test-Path $targetDir)) {
                New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            }
            Copy-Item -Path $file.FullName -Destination $targetFilePath -Force
            Write-Host "  [Copiado] $relativePath" -ForegroundColor Green
            $copiedCount++
        }
    }
}

Write-Host "`n----------------------------------------------------------" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host "Simulacion completada exitosamente." -ForegroundColor Cyan
} else {
    Write-Host "Sincronizacion completada con exito. Total de archivos transferidos: $copiedCount" -ForegroundColor Green
    Write-Host "Recordatorio: Si el juego esta abierto, escriba '/reload' en el chat para aplicar los cambios." -ForegroundColor Yellow
}
Write-Host "----------------------------------------------------------`n" -ForegroundColor Cyan
