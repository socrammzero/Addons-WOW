@echo off
chcp 65001 >nul
setlocal
title Actualizador de Traducciones esES - WoW Forever

echo.
echo ======================================================================
echo   ACTUALIZADOR DE TRADUCCIONES AL ESPAÑOL (esES) - WoW Forever
echo ======================================================================
echo.
echo   ¿Para qué sirve este archivo?
echo   - Descarga las últimas traducciones de los addons directamente desde
echo     el repositorio de Marcos en GitHub (socrammzero/Addons-WOW).
echo   - Copia únicamente las carpetas de addons traducidos dentro de tu
echo     carpeta de World of Warcraft (...\Interface\AddOns).
echo   - NO instala ningún programa en tu PC, NO cambia tus ajustes ni
echo     toca tus partidas o SavedVariables.
echo.
echo   Si no quieres actualizar ahora, simplemente cierra esta ventana.
echo ======================================================================
echo.

if not exist "%LOCALAPPDATA%\Addons-WOW\updater.json" (
    echo Primera ejecución detectada.
    echo Pulsa cualquier tecla para continuar y buscar tu carpeta de WoW...
    pause >nul
    echo.
)

set "SELF_BAT=%~f0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$raw = Get-Content -LiteralPath $env:SELF_BAT -Raw -Encoding UTF8; $marker = '#__POWERSHELL_' + 'START__'; $idx = $raw.IndexOf($marker); if ($idx -lt 0) { throw 'No se encontro el bloque de actualizacion.' }; $code = $raw.Substring($idx); [ScriptBlock]::Create($code).Invoke()"

echo.
pause
exit /b

#__POWERSHELL_START__
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$RepoOwner = "socrammzero"
$RepoName = "Addons-WOW"
$Branch = "main"
$ApiUrl = "https://api.github.com/repos/$RepoOwner/$RepoName/commits/$Branch"
$ZipUrl = "https://github.com/$RepoOwner/$RepoName/archive/refs/heads/$Branch.zip"

$StateDir = Join-Path $env:LOCALAPPDATA "Addons-WOW"
$ConfigFile = Join-Path $StateDir "updater.json"
if (-not (Test-Path $StateDir)) {
    New-Item -ItemType Directory -Path $StateDir -Force | Out-Null
}

function Load-State {
    if (Test-Path $ConfigFile) {
        try {
            return (Get-Content -LiteralPath $ConfigFile -Raw -Encoding UTF8 | ConvertFrom-Json)
        } catch {
            return $null
        }
    }
    return $null
}

function Save-State([string]$wowPath, [string]$sha) {
    $obj = [ordered]@{
        wowAddonsPath = $wowPath
        lastSha       = $sha
        updatedAt     = (Get-Date).ToString("s")
    }
    $obj | ConvertTo-Json | Set-Content -LiteralPath $ConfigFile -Encoding UTF8
}

function Normalize-WowAddonsPath([string]$inputPath) {
    if (-not $inputPath) { return $null }
    $p = $inputPath.Trim().Trim('"').TrimEnd('\', '/')
    if (-not (Test-Path -LiteralPath $p)) { return $null }

    if ($p -match '[\\/]Interface[\\/]AddOns$') { return $p }
    if (Test-Path -LiteralPath (Join-Path $p "Interface\AddOns")) {
        return (Join-Path $p "Interface\AddOns")
    }
    if (Test-Path -LiteralPath (Join-Path $p "_forever_\Interface\AddOns")) {
        return (Join-Path $p "_forever_\Interface\AddOns")
    }
    return $null
}

function Find-WowAddonsPath {
    $saved = Load-State
    if ($saved -and $saved.wowAddonsPath -and (Test-Path -LiteralPath $saved.wowAddonsPath)) {
        return $saved.wowAddonsPath
    }

    $candidates = New-Object System.Collections.Generic.List[string]
    foreach ($drive in (Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -match '^[A-Z]:\\$' })) {
        $root = $drive.Root
        $candidates.Add((Join-Path $root "World of Warcraft\_forever_\Interface\AddOns"))
        $candidates.Add((Join-Path $root "Games\World of Warcraft\_forever_\Interface\AddOns"))
        $candidates.Add((Join-Path $root "Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns"))
        $candidates.Add((Join-Path $root "Program Files\World of Warcraft\_forever_\Interface\AddOns"))
    }

    foreach ($regPath in @(
        "HKLM:\SOFTWARE\WOW6432Node\Blizzard Entertainment\World of Warcraft",
        "HKLM:\SOFTWARE\Blizzard Entertainment\World of Warcraft"
    )) {
        if (Test-Path $regPath) {
            try {
                $installPath = (Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue).InstallPath
                if ($installPath) {
                    $norm = Normalize-WowAddonsPath $installPath
                    if ($norm) { $candidates.Insert(0, $norm) }
                }
            } catch {}
        }
    }

    foreach ($cand in $candidates) {
        if (Test-Path -LiteralPath $cand) {
            return $cand
        }
    }
    return $null
}

$wowAddonsPath = Find-WowAddonsPath
if (-not $wowAddonsPath) {
    Write-Host "No he encontrado automáticamente la carpeta _forever_\Interface\AddOns." -ForegroundColor Yellow
    Write-Host "Arrastra aquí tu carpeta de World of Warcraft (o _forever_\Interface\AddOns) y pulsa ENTER:" -ForegroundColor Cyan
    while (-not $wowAddonsPath) {
        $userInput = Read-Host "Ruta"
        $wowAddonsPath = Normalize-WowAddonsPath $userInput
        if (-not $wowAddonsPath) {
            Write-Host "Esa ruta no contiene Interface\AddOns. Inténtalo de nuevo:" -ForegroundColor Red
        }
    }
}

Write-Host "Carpeta de addons detectada: $wowAddonsPath" -ForegroundColor Gray
Write-Host "Comprobando si hay actualizaciones en GitHub..." -ForegroundColor Cyan

$remoteSha = ""
$remoteMsg = ""
try {
    $commitInfo = Invoke-RestMethod -Uri $ApiUrl -Headers @{ "User-Agent" = "Addons-WOW-Updater" } -TimeoutSec 15
    $remoteSha = [string]$commitInfo.sha
    if ($commitInfo.commit -and $commitInfo.commit.message) {
        $remoteMsg = ($commitInfo.commit.message -split "`n")[0]
    }
} catch {
    Write-Host ""
    Write-Host "[AVISO] No se pudo conectar con GitHub para comprobar la versión." -ForegroundColor Red
    Write-Host "Motivo: $($_.Exception.Message)" -ForegroundColor DarkGray
    Write-Host "Comprueba tu conexión a internet o si el repositorio en GitHub está privado." -ForegroundColor Yellow
    return
}

$state = Load-State
$journeyInstalled = Test-Path -LiteralPath (Join-Path $wowAddonsPath "Journey")
if ($state -and $state.lastSha -eq $remoteSha -and $journeyInstalled) {
    $shortSha = $remoteSha.Substring(0, [Math]::Min(7, $remoteSha.Length))
    Write-Host ""
    Write-Host "Ya tienes la última versión instalada ($shortSha)." -ForegroundColor Green
    if ($remoteMsg) { Write-Host "Último cambio: $remoteMsg" -ForegroundColor DarkGray }
    $reinstall = Read-Host "¿Quieres reinstalar todos los addons de nuevo por si acaso? [s/N]"
    if ($reinstall -notmatch '^(s|si|sí)$') {
        Write-Host "Todo al día. No hace falta hacer nada más." -ForegroundColor Green
        return
    }
}

$tempDir = Join-Path $env:TEMP ("AddonsWOW_" + [Guid]::NewGuid().ToString("N").Substring(0, 8))
$zipFile = Join-Path $tempDir "addons.zip"
$extractDir = Join-Path $tempDir "extracted"

try {
    New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
    Write-Host "Descargando paquete de traducciones..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $ZipUrl -OutFile $zipFile -Headers @{ "User-Agent" = "Addons-WOW-Updater" } -UseBasicParsing -TimeoutSec 120

    Write-Host "Extrayendo archivos..." -ForegroundColor Cyan
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFile, $extractDir)

    $repoRootFolder = Get-ChildItem -LiteralPath $extractDir -Directory | Select-Object -First 1
    if (-not $repoRootFolder) { throw "El archivo descargado no contiene carpetas válidas." }
    $srcFolder = Join-Path $repoRootFolder.FullName "src"
    if (-not (Test-Path -LiteralPath $srcFolder)) { throw "No se encontró la carpeta src dentro de la descarga." }

    $addonDirs = Get-ChildItem -LiteralPath $srcFolder -Directory
    $count = 0
    foreach ($addon in $addonDirs) {
        $destAddon = Join-Path $wowAddonsPath $addon.Name
        if (-not (Test-Path -LiteralPath $destAddon)) {
            New-Item -ItemType Directory -Path $destAddon -Force | Out-Null
        }
        Copy-Item -Path (Join-Path $addon.FullName "*") -Destination $destAddon -Recurse -Force
        $count++
        Write-Host "  [Actualizado] $($addon.Name)" -ForegroundColor Green
    }

    Save-State -wowPath $wowAddonsPath -sha $remoteSha
    $shortSha = $remoteSha.Substring(0, [Math]::Min(7, $remoteSha.Length))

    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Green
    Write-Host "  Actualización completada: $count addons actualizados ($shortSha)" -ForegroundColor Green
    if ($remoteMsg) { Write-Host "  Último cambio: $remoteMsg" -ForegroundColor Gray }
    Write-Host "======================================================================" -ForegroundColor Green

    $wowRunning = Get-Process -Name "Wow*" -ErrorAction SilentlyContinue
    if ($wowRunning) {
        Write-Host ""
        Write-Host "  World of Warcraft está abierto ahora mismo." -ForegroundColor Yellow
        Write-Host "  Escribe /reload en el chat del juego para aplicar los cambios." -ForegroundColor Yellow
    } else {
        Write-Host ""
        Write-Host "  Ya puedes abrir World of Warcraft con las traducciones al día." -ForegroundColor Cyan
    }
} finally {
    if (Test-Path -LiteralPath $tempDir) {
        Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
