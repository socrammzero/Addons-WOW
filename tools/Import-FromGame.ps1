<#
.SYNOPSIS
    Importa o actualiza archivos de addons desde la carpeta de World of Warcraft hacia Addons-WOW.
.DESCRIPTION
    Util cuando CurseForge descarga una nueva version oficial de un addon o tras instalarlo por primera vez.
    Permite traer la estructura original para trabajar la traduccion en Addons-WOW sin riesgo.
.PARAMETER AddonName
    Nombre o carpeta del addon especifico a importar.
.PARAMETER OverwriteAll
    Fuerza la sobreescritura de archivos locales aunque ya existan modificaciones.
.PARAMETER DryRun
    Si se especifica, simula la importacion mostrando los archivos a transferir.
#>
[CmdletBinding()]
param (
    [string]$AddonName = "",
    [switch]$OverwriteAll,
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
Write-Host "  Arthur: Importacion de Addons desde WoW hacia Addons-WOW" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

if (-not (Test-Path $wowPath)) {
    Write-Warning "La ruta de World of Warcraft especificada no existe:"
    Write-Warning "  $wowPath"
    Write-Warning "Por favor, configure la ruta real de su juego en: config.json"
    return
}

$targetAddons = $config.addons
if ($AddonName) {
    $targetAddons = $targetAddons | Where-Object { 
        $_.folderName -like "*$AddonName*" -or $_.name -like "*$AddonName*" 
    }
}

if (-not $targetAddons) {
    Write-Warning "No se encontro ningun addon configurado para el criterio especificado."
    return
}

$importedCount = 0

foreach ($addon in $targetAddons) {
    $srcGameDir = Join-Path $wowPath $addon.folderName
    $destProjectDir = Join-Path $projectRoot "src\$($addon.folderName)"

    Write-Host "Comprobando: $($addon.name) [$($addon.folderName)]" -ForegroundColor Yellow

    if (-not (Test-Path $srcGameDir)) {
        Write-Warning "  El addon aun no esta instalado en el directorio del juego: $srcGameDir"
        continue
    }

    if (-not (Test-Path $destProjectDir)) {
        if (-not $DryRun) {
            New-Item -ItemType Directory -Path $destProjectDir -Force | Out-Null
        }
    }

    $gameFiles = Get-ChildItem -Path $srcGameDir -Recurse -File

    foreach ($file in $gameFiles) {
        $relativePath = $file.FullName.Substring($srcGameDir.Length).TrimStart("\", "/")
        $targetFilePath = Join-Path $destProjectDir $relativePath
        $targetDir = Split-Path -Parent $targetFilePath

        $shouldCopy = $OverwriteAll -or (-not (Test-Path $targetFilePath))

        if ($DryRun) {
            if ($shouldCopy) {
                Write-Host "  [Simulacion Importacion] $relativePath" -ForegroundColor DarkCyan
            }
        } else {
            if ($shouldCopy) {
                if (-not (Test-Path $targetDir)) {
                    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                }
                Copy-Item -Path $file.FullName -Destination $targetFilePath -Force
                Write-Host "  [Importado] $relativePath" -ForegroundColor Green
                $importedCount++
            }
        }
    }
}

Write-Host "`n----------------------------------------------------------" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host "Simulacion de importacion completada." -ForegroundColor Cyan
} else {
    Write-Host "Importacion finalizada. Archivos incorporados: $importedCount" -ForegroundColor Green
    Write-Host "Siguiente paso recomendado: Registre los cambios con 'git commit' antes de traducir." -ForegroundColor Yellow
}
Write-Host "----------------------------------------------------------`n" -ForegroundColor Cyan
