@echo off
chcp 65001 >nul
cd /d "%~dp0"

where node >nul 2>&1
if errorlevel 1 (
    echo [ERROR] No se encontro Node.js en el sistema.
    pause
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_Process -Filter \"Name='node.exe'\" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like '*editor_server.js*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }" >nul 2>&1

echo Iniciando Editor Visual de Traducciones esES...
node tools\editor_server.js
if errorlevel 1 (
    echo.
    echo [ERROR] El editor se detuvo con un error.
    pause
)
