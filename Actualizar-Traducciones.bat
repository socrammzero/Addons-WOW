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
echo   - La primera vez instala los addons completos; después solo descarga
echo     y actualiza los archivos que hayan cambiado.
echo   - Incluye modo «Vigilar mientras juegas» para avisarte si hay
echo     novedades sin tener que abrir y cerrar esta ventana.
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
if errorlevel 1 (
    echo.
    echo [ERROR] Ocurrió un problema inesperado durante la ejecución.
    pause
)
exit /b

#__POWERSHELL_START__
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$RepoOwner = "socrammzero"
$RepoName = "Addons-WOW"
$Branch = "main"
$ApiUrl = "https://api.github.com/repos/$RepoOwner/$RepoName/commits/$Branch"
$CompareBaseUrl = "https://api.github.com/repos/$RepoOwner/$RepoName/compare"
$ZipUrl = "https://github.com/$RepoOwner/$RepoName/archive/refs/heads/$Branch.zip"
$WatchIntervalSeconds = 180

$StateDir = Join-Path $env:LOCALAPPDATA "Addons-WOW"
$ConfigFile = Join-Path $StateDir "updater.json"
$KnownAddons = @(
    "Auctionator", "Baganator", "Books_on_map_Forever", "ForeverLootSparkles",
    "ForeverLootSparkles_Coloring", "GearQuestForever", "GearQuestForever_DRUID",
    "GearQuestForever_HUNTER", "GearQuestForever_Languages", "GearQuestForever_MAGE",
    "GearQuestForever_PALADIN", "GearQuestForever_PRIEST", "GearQuestForever_ROGUE",
    "GearQuestForever_SHAMAN", "GearQuestForever_WARLOCK", "GearQuestForever_WARRIOR",
    "HealBot", "HealBot_ExtraSkins", "HealBot_Tips", "Journey",
    "Leatrix_Maps", "Leatrix_Plus", "MoveAny", "Socram_Addons_esES", "Syndicator", "WhatsTraining"
)

$script:TrayIcon = $null

function Show-WindowsNotification([string]$title, [string]$message) {
    try {
        if (-not $script:TrayIcon) {
            Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
            Add-Type -AssemblyName System.Drawing -ErrorAction Stop
            $script:TrayIcon = New-Object System.Windows.Forms.NotifyIcon
            $script:TrayIcon.Icon = [System.Drawing.SystemIcons]::Information
            $script:TrayIcon.Text = "Actualizador Addons-WOW esES"
            $script:TrayIcon.Visible = $true
        }
        $script:TrayIcon.ShowBalloonTip(7000, $title, $message, [System.Windows.Forms.ToolTipIcon]::Info)
    } catch {}
}

function Dispose-TrayIcon {
    if ($script:TrayIcon) {
        try {
            $script:TrayIcon.Visible = $false
            $script:TrayIcon.Dispose()
        } catch {}
        $script:TrayIcon = $null
    }
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

function Save-State([string]$wowPath, [string]$sha, [string[]]$addonsList = $null) {
    if (-not (Test-Path -LiteralPath $StateDir)) {
        New-Item -ItemType Directory -Path $StateDir -Force | Out-Null
    }
    $prev = Load-State
    $mergedAddons = if ($addonsList -and $addonsList.Count -gt 0) {
        @($addonsList)
    } elseif ($prev -and $prev.installedAddons) {
        @($prev.installedAddons)
    } else {
        @($KnownAddons)
    }
    $obj = [ordered]@{
        wowAddonsPath   = $wowPath
        lastSha         = $sha
        updatedAt       = (Get-Date).ToString("s")
        installedAddons = $mergedAddons
    }
    $obj | ConvertTo-Json | Set-Content -LiteralPath $ConfigFile -Encoding UTF8
}

function Download-FileFast([string]$url, [string]$destFile) {
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("User-Agent", "Addons-WOW-Updater")
    try {
        $wc.DownloadFile($url, $destFile)
    } finally {
        $wc.Dispose()
    }
}

function Resolve-SafeAddonTarget([string]$baseAddonsDir, [string]$repoRelPath) {
    if (-not $repoRelPath -or -not $repoRelPath.StartsWith("src/")) { return $null }
    $subRel = $repoRelPath.Substring(4)
    if (-not $subRel -or $subRel.Contains("..") -or $subRel.Contains([char]0)) { return $null }
    $winRel = $subRel -replace '/', '\'
    $baseFull = [System.IO.Path]::GetFullPath($baseAddonsDir).TrimEnd('\') + '\'
    $targetFull = [System.IO.Path]::GetFullPath((Join-Path $baseFull $winRel))
    if (-not $targetFull.StartsWith($baseFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $null
    }
    return $targetFull
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

function Show-FinishReminder([bool]$notifyDesktop = $false, [string]$detailText = "") {
    $wowRunning = Get-Process -Name "Wow*" -ErrorAction SilentlyContinue
    if ($wowRunning) {
        Write-Host ""
        Write-Host "  World of Warcraft está abierto ahora mismo." -ForegroundColor Yellow
        Write-Host "  Escribe /reload en el chat del juego para aplicar los cambios." -ForegroundColor Yellow
        if ($notifyDesktop) {
            $msg = if ($detailText) { "$detailText — Escribe /reload en WoW." } else { "Traducciones actualizadas. Escribe /reload en WoW." }
            Show-WindowsNotification -title "Traducciones WoW actualizadas" -message $msg
            try { [Console]::Beep(880, 150) } catch {}
        }
    } else {
        Write-Host ""
        Write-Host "  Ya puedes abrir World of Warcraft con las traducciones al día." -ForegroundColor Cyan
        if ($notifyDesktop) {
            $msg = if ($detailText) { "$detailText — Listo para jugar." } else { "Traducciones actualizadas y listas." }
            Show-WindowsNotification -title "Traducciones WoW actualizadas" -message $msg
        }
    }
}

function Install-FullZip([string]$wowAddonsPath, [string]$remoteSha, [string]$remoteMsg) {
    $shortSha = $remoteSha.Substring(0, [Math]::Min(7, $remoteSha.Length))
    $tempDir = Join-Path $env:TEMP ("AddonsWOW_" + [Guid]::NewGuid().ToString("N").Substring(0, 8))
    $zipFile = Join-Path $tempDir "addons.zip"
    $extractDir = Join-Path $tempDir "extracted"

    try {
        New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
        Write-Host "Descargando paquete completo de traducciones..." -ForegroundColor Cyan
        Download-FileFast -url $ZipUrl -destFile $zipFile

        Write-Host "Extrayendo archivos..." -ForegroundColor Cyan
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFile, $extractDir)

        $repoRootFolder = Get-ChildItem -LiteralPath $extractDir -Directory | Select-Object -First 1
        if (-not $repoRootFolder) { throw "El archivo descargado no contiene carpetas válidas." }
        $srcFolder = Join-Path $repoRootFolder.FullName "src"
        if (-not (Test-Path -LiteralPath $srcFolder)) { throw "No se encontró la carpeta src dentro de la descarga." }

        $addonDirs = Get-ChildItem -LiteralPath $srcFolder -Directory
        $count = 0
        $installedNames = @()
        foreach ($addon in $addonDirs) {
            $destAddon = Join-Path $wowAddonsPath $addon.Name
            if (-not (Test-Path -LiteralPath $destAddon)) {
                New-Item -ItemType Directory -Path $destAddon -Force | Out-Null
            }
            Copy-Item -Path (Join-Path $addon.FullName "*") -Destination $destAddon -Recurse -Force
            $installedNames += $addon.Name
            $count++
            Write-Host "  [Actualizado] $($addon.Name)" -ForegroundColor Green
        }

        Save-State -wowPath $wowAddonsPath -sha $remoteSha -addonsList $installedNames
        Write-Host ""
        Write-Host "======================================================================" -ForegroundColor Green
        Write-Host "  Instalación completa finalizada: $count addons actualizados ($shortSha)" -ForegroundColor Green
        if ($remoteMsg) { Write-Host "  Último cambio: $remoteMsg" -ForegroundColor Gray }
        Write-Host "======================================================================" -ForegroundColor Green
        return @{ updated = $true; summary = "$count addons actualizados ($shortSha)" }
    } finally {
        if (Test-Path -LiteralPath $tempDir) {
            Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

function Invoke-SyncStep([string]$wowAddonsPath, [bool]$forceFull = $false, [bool]$quietWhenCurrent = $false) {
    $now = (Get-Date).ToString("HH:mm:ss")
    $remoteSha = ""
    $remoteMsg = ""
    try {
        $commitInfo = Invoke-RestMethod -Uri $ApiUrl -Headers @{ "User-Agent" = "Addons-WOW-Updater" } -TimeoutSec 15
        $remoteSha = [string]$commitInfo.sha
        if ($commitInfo.commit -and $commitInfo.commit.message) {
            $remoteMsg = ($commitInfo.commit.message -split "`n")[0]
        }
    } catch {
        Write-Host "[$now] No se pudo conectar con GitHub: $($_.Exception.Message)" -ForegroundColor Yellow
        return @{ status = "network_error"; updated = $false }
    }

    $shortSha = $remoteSha.Substring(0, [Math]::Min(7, $remoteSha.Length))
    $state = Load-State
    $journeyInstalled = Test-Path -LiteralPath (Join-Path $wowAddonsPath "Journey")

    if (-not $forceFull -and $state -and $state.lastSha -eq $remoteSha -and $journeyInstalled) {
        if ($quietWhenCurrent) {
            Write-Host "[$now] Sin cambios nuevos ($shortSha). Vigilando..." -ForegroundColor DarkGray
        } else {
            Write-Host ""
            Write-Host "Ya tienes la última versión instalada ($shortSha). No se ha descargado ni escrito nada." -ForegroundColor Green
            if ($remoteMsg) { Write-Host "Último cambio: $remoteMsg" -ForegroundColor DarkGray }
        }
        return @{ status = "up_to_date"; updated = $false; sha = $shortSha }
    }

    if (-not $forceFull -and $state -and $state.lastSha -and ($state.lastSha -ne $remoteSha) -and $journeyInstalled) {
        try {
            $cmpUrl = "$CompareBaseUrl/$($state.lastSha)...$remoteSha"
            $cmp = Invoke-RestMethod -Uri $cmpUrl -Headers @{ "User-Agent" = "Addons-WOW-Updater" } -TimeoutSec 15
            if ($cmp -and $cmp.status -eq "ahead" -and $cmp.total_commits -le 250 -and $cmp.files.Count -lt 300) {
                $srcChanges = @($cmp.files | Where-Object { $_.filename -like "src/*" -or ($_.previous_filename -and $_.previous_filename -like "src/*") })
                if ($srcChanges.Count -eq 0) {
                    Save-State -wowPath $wowAddonsPath -sha $remoteSha
                    Write-Host "[$now] Commit $shortSha sin cambios en addons de WoW. Todo al día." -ForegroundColor DarkGray
                    return @{ status = "up_to_date"; updated = $false; sha = $shortSha }
                }
                if ($srcChanges.Count -lt 40) {
                    Write-Host ""
                    Write-Host "[$now] Nueva actualización ($shortSha): descargando $($srcChanges.Count) archivo(s)..." -ForegroundColor Cyan
                    $updatedAddons = New-Object System.Collections.Generic.HashSet[string]
                    $updatedFiles = 0
                    foreach ($f in $srcChanges) {
                        if ($f.previous_filename -and $f.previous_filename -like "src/*") {
                            $oldTarget = Resolve-SafeAddonTarget $wowAddonsPath $f.previous_filename
                            if ($oldTarget -and (Test-Path -LiteralPath $oldTarget)) {
                                Remove-Item -LiteralPath $oldTarget -Force -ErrorAction SilentlyContinue
                            }
                        }
                        if (-not ($f.filename -like "src/*")) { continue }
                        $target = Resolve-SafeAddonTarget $wowAddonsPath $f.filename
                        if (-not $target) { continue }

                        $addonName = ($f.filename.Substring(4) -split '/')[0]
                        if ($f.status -eq "removed") {
                            if (Test-Path -LiteralPath $target) {
                                Remove-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
                                $null = $updatedAddons.Add($addonName)
                                $updatedFiles++
                            }
                            continue
                        }

                        $parentDir = Split-Path -Parent $target
                        if (-not (Test-Path -LiteralPath $parentDir)) {
                            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
                        }
                        Download-FileFast -url $f.raw_url -destFile $target
                        $null = $updatedAddons.Add($addonName)
                        $updatedFiles++
                        Write-Host "  [Actualizado] $($f.filename.Substring(4))" -ForegroundColor Green
                    }

                    Save-State -wowPath $wowAddonsPath -sha $remoteSha
                    $summary = "$updatedFiles archivo(s) en $($updatedAddons.Count) addon(s) ($shortSha)"
                    Write-Host "======================================================================" -ForegroundColor Green
                    Write-Host "  Actualización incremental completada: $summary" -ForegroundColor Green
                    if ($remoteMsg) { Write-Host "  Último cambio: $remoteMsg" -ForegroundColor Gray }
                    Write-Host "======================================================================" -ForegroundColor Green
                    return @{ status = "updated"; updated = $true; summary = $summary }
                }
            }
        } catch {
            Write-Host "[$now] No se pudo hacer actualización incremental; descargando paquete completo..." -ForegroundColor Yellow
        }
    }

    $fullRes = Install-FullZip -wowAddonsPath $wowAddonsPath -remoteSha $remoteSha -remoteMsg $remoteMsg
    return @{ status = "updated"; updated = $true; summary = $fullRes.summary }
}

function Wait-WatchInterval([int]$seconds) {
    $deadline = (Get-Date).AddSeconds($seconds)
    while ((Get-Date) -lt $deadline) {
        try {
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.Key -eq [ConsoleKey]::S -or $key.Key -eq [ConsoleKey]::Q) {
                    return "exit"
                }
                if ($key.Key -eq [ConsoleKey]::Enter -or $key.Key -eq [ConsoleKey]::C -or $key.Key -eq [ConsoleKey]::Spacebar) {
                    return "check_now"
                }
            }
        } catch {}
        Start-Sleep -Milliseconds 250
    }
    return "timeout"
}

function Start-WatchLoop([string]$wowAddonsPath) {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "  MODO VIGILAR MIENTRAS JUEGAS ACTIVO (cada 3 minutos)" -ForegroundColor Cyan
    Write-Host "  Puedes minimizar esta ventana y jugar tranquilo." -ForegroundColor Gray
    Write-Host "  - Pulsa [ENTER] o [C] para comprobar al instante." -ForegroundColor Gray
    Write-Host "  - Pulsa [S] o cierra la ventana para salir." -ForegroundColor Gray
    Write-Host "======================================================================" -ForegroundColor Cyan

    while ($true) {
        $action = Wait-WatchInterval -seconds $WatchIntervalSeconds
        if ($action -eq "exit") {
            Write-Host "Saliendo del modo vigilancia. ¡Buen juego!" -ForegroundColor Cyan
            return
        }
        if ($action -eq "check_now") {
            Write-Host ""
            Write-Host "Comprobando ahora mismo..." -ForegroundColor Cyan
        }
        $res = Invoke-SyncStep -wowAddonsPath $wowAddonsPath -forceFull $false -quietWhenCurrent $true
        if ($res.updated) {
            Show-FinishReminder -notifyDesktop $true -detailText $res.summary
        }
    }
}

function Remove-UpdaterTraces {
    $removed = 0
    if (Test-Path -LiteralPath $StateDir) {
        Remove-Item -LiteralPath $StateDir -Recurse -Force
        $removed++
    }
    foreach ($tmpItem in (Get-ChildItem -LiteralPath $env:TEMP -Filter "AddonsWOW_*" -ErrorAction SilentlyContinue)) {
        Remove-Item -LiteralPath $tmpItem.FullName -Recurse -Force -ErrorAction SilentlyContinue
        $removed++
    }
    return $removed
}

function Invoke-CleanupMenu([string]$wowAddonsPath) {
    $state = Load-State
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Yellow
    Write-Host "  BORRAR / DESINSTALAR RASTROS DEL ACTUALIZADOR" -ForegroundColor Yellow
    Write-Host "======================================================================" -ForegroundColor Yellow
    Write-Host "  Este script NO modifica el Registro de Windows ni instala programas."
    Write-Host "  Lo único que guarda en tu PC es:"
    Write-Host "    - $StateDir (solo updater.json con ruta y versión)"
    Write-Host "    - Y los addons traducidos dentro de: $wowAddonsPath"
    Write-Host ""
    Write-Host "  [1] Borrar SOLO caché/configuración del actualizador (dejar addons de WoW)" -ForegroundColor White
    Write-Host "  [2] Borrar caché del actualizador Y eliminar los addons traducidos de WoW" -ForegroundColor Red
    Write-Host "  [3] Cancelar y volver" -ForegroundColor Gray

    $sub = Read-Host "Elige [1/2/3]"
    if ($sub -eq "1") {
        Remove-UpdaterTraces | Out-Null
        Write-Host ""
        Write-Host "Limpieza completada: eliminado $StateDir y temporales." -ForegroundColor Green
        Write-Host "Tus addons de World of Warcraft siguen intactos." -ForegroundColor Gray
        $null = Read-Host "Pulsa ENTER para cerrar"
        return $true
    }
    if ($sub -eq "2") {
        Write-Host ""
        $confirm = Read-Host "Se eliminarán de WoW las carpetas de los addons de este paquete (sin tocar otros addons ni SavedVariables). Escribe BORRAR para confirmar"
        if ($confirm -ne "BORRAR") {
            Write-Host "Operación cancelada. No se borró nada." -ForegroundColor Yellow
            return $false
        }
        $targetAddons = if ($state -and $state.installedAddons) { @($state.installedAddons) } else { @($KnownAddons) }
        $baseFull = [System.IO.Path]::GetFullPath($wowAddonsPath).TrimEnd('\') + '\'
        $deletedAddons = 0
        foreach ($name in $targetAddons) {
            if (-not $name -or $name.Contains("..") -or $name.Contains("/") -or $name.Contains("\")) { continue }
            $addonDir = [System.IO.Path]::GetFullPath((Join-Path $baseFull $name))
            if (-not $addonDir.StartsWith($baseFull, [System.StringComparison]::OrdinalIgnoreCase)) { continue }
            if (Test-Path -LiteralPath $addonDir) {
                Remove-Item -LiteralPath $addonDir -Recurse -Force
                $deletedAddons++
                Write-Host "  [Eliminado] $name" -ForegroundColor DarkYellow
            }
        }
        Remove-UpdaterTraces | Out-Null
        Write-Host ""
        Write-Host "Desinstalación completada: $deletedAddons carpeta(s) de addons eliminadas y configuración borrada." -ForegroundColor Green
        Write-Host "Ya puedes borrar este archivo Actualizar-Traducciones.bat si no lo necesitas más." -ForegroundColor Gray
        $null = Read-Host "Pulsa ENTER para cerrar"
        return $true
    }
    Write-Host "Cancelado." -ForegroundColor Gray
    return $false
}

try {
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

    $initial = Invoke-SyncStep -wowAddonsPath $wowAddonsPath -forceFull $false -quietWhenCurrent $false
    if ($initial.updated) {
        Show-FinishReminder -notifyDesktop $false -detailText $initial.summary
    }

    while ($true) {
        Write-Host ""
        Write-Host "¿Qué quieres hacer ahora?" -ForegroundColor Cyan
        Write-Host "  [V] Vigilar actualizaciones mientras juegas (por defecto al pulsar ENTER)" -ForegroundColor White
        if ($initial.status -eq "up_to_date") {
            Write-Host "  [R] Reinstalar todos los addons desde cero" -ForegroundColor Gray
        }
        Write-Host "  [D] Desinstalar / borrar datos del actualizador" -ForegroundColor Gray
        Write-Host "  [S] Salir" -ForegroundColor Gray

        $choice = Read-Host "Elige [V/R/D/S]"
        if ($choice -match '^(s|salir|q)$') {
            return
        }
        if ($choice -match '^(d|desinstalar|borrar|limpiar)$') {
            $didClean = Invoke-CleanupMenu -wowAddonsPath $wowAddonsPath
            if ($didClean) { return }
            continue
        }
        if ($choice -match '^(r|reinstalar)$') {
            $reinstallRes = Invoke-SyncStep -wowAddonsPath $wowAddonsPath -forceFull $true -quietWhenCurrent $false
            if ($reinstallRes.updated) {
                Show-FinishReminder -notifyDesktop $false -detailText $reinstallRes.summary
            }
            Write-Host ""
            $afterRe = Read-Host "¿Dejar vigilando actualizaciones mientras juegas? [V/s]"
            if ($afterRe -match '^(s|n|no|salir)$') { return }
        }

        Start-WatchLoop -wowAddonsPath $wowAddonsPath
        return
    }
} finally {
    Dispose-TrayIcon
}
