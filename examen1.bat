
@echo off
setlocal DisableDelayedExpansion

title Git Author Tracking

REM ==========================================
REM DETECTAR MODE
REM ==========================================

if /i "%~1"=="--record" goto RECORD

echo.
echo ==========================================
echo       GIT AUTHOR TRACKING INSTALLER
echo ==========================================
echo.

REM ==========================================
REM 1. COMPROVAR VS CODE
REM ==========================================

echo [1/5] Comprovant VS Code...

where code >nul 2>&1

if errorlevel 1 (
    echo ERROR: VS Code CLI no disponible.
    pause
    exit /b 1
)

REM ==========================================
REM 2. INSTAL.LAR EXTENSIO
REM ==========================================

echo [2/5] Instal.lant Run On Save...

code --install-extension emeraldwalk.RunOnSave --force

if errorlevel 1 (
    echo ERROR: No s'ha pogut instal.lar l'extensio.
    pause
    exit /b 1
)

REM ==========================================
REM 3. LOCALITZAR GIT
REM ==========================================

echo [3/5] Localitzant repositori Git...

set "GITROOT="

for /f "delims=" %%A in ('git -C "%CD%" rev-parse --show-toplevel 2^>nul') do (
    set "GITROOT=%%A"
)

if not defined GITROOT (
    echo ERROR: No existeix cap repositori Git.
    pause
    exit /b 1
)

for %%A in ("%GITROOT%") do set "GITROOT=%%~fA"

REM ==========================================
REM 4. COPIAR INSTAL.LADOR AL PROJECTE
REM ==========================================

set "DEST=%GITROOT%\install-author-tracking.bat"

if /i not "%~f0"=="%DEST%" (
    copy /y "%~f0" "%DEST%" >nul

    if errorlevel 1 (
        echo ERROR: No s'ha pogut copiar el BAT.
        pause
        exit /b 1
    )
)

if not exist "%GITROOT%\.file-metadata" (
    mkdir "%GITROOT%\.file-metadata"
)

REM ==========================================
REM 5. CONFIGURAR VS CODE
REM ==========================================

echo [4/5] Configurant VS Code...

if not exist "%GITROOT%\.vscode" (
    mkdir "%GITROOT%\.vscode"
)

set "SETTINGS=%GITROOT%\.vscode\settings.json"

if exist "%SETTINGS%" (
    copy /y "%SETTINGS%" "%SETTINGS%.backup" >nul
    echo.
    echo AVIS: S'ha guardat una copia de settings.json.
    echo La configuracio anterior es reemplacara.
)

(
echo {
echo     "emeraldwalk.runonsave": {
echo         "message": "Registrant autor...",
echo         "showElapsed": true,
echo         "commands": [
echo             {
echo                 "match": "\\.[jJ][sS]$",
echo                 "message": "Actualitzant contribuents de ${fileBasename}",
echo                 "autoShowOutputPanel": "error",
echo                 "cmd": "call \"${workspaceFolder}\\install-author-tracking.bat\" --record \"${file}\" \"${workspaceFolder}\""
echo             }
echo         ]
echo     }
echo }
) > "%SETTINGS%"

REM ==========================================
REM FINALITZACIO
REM ==========================================

echo.
echo [5/5] Instal.lacio completada!

echo.
echo ==========================================
echo       SISTEMA CONFIGURAT
echo ==========================================
echo.
echo Repositori: %GITROOT%
echo Registre: .file-metadata\contributors.txt
echo.
echo Recarrega VS Code:
echo Ctrl + Shift + P
echo Developer: Reload Window
echo.
pause
exit /b 0


REM ==========================================
REM MODE REGISTRE AUTOMATIC
REM ==========================================

:RECORD

set "FILE=%~f2"
set "WORKSPACE=%~3"

if not exist "%FILE%" exit /b 1

REM LOCALITZAR GIT

set "GITROOT="

for /f "delims=" %%A in ('git -C "%WORKSPACE%" rev-parse --show-toplevel 2^>nul') do (
    set "GITROOT=%%A"
)

if not defined GITROOT exit /b 1

for %%A in ("%GITROOT%") do set "GITROOT=%%~fA"

REM OBTINDRE AUTOR

set "AUTHOR="

for /f "delims=" %%A in ('git -C "%GITROOT%" config user.name 2^>nul') do (
    if not defined AUTHOR set "AUTHOR=%%A"
)

if not defined AUTHOR exit /b 1

REM PREPARAR FITXER DE METADADES

set "METADATA=%GITROOT%\.file-metadata"
set "DB=%GITROOT%\.file-metadata\contributors.txt"

if not exist "%METADATA%" mkdir "%METADATA%"

if not exist "%DB%" type nul > "%DB%"

REM COMPROVAR SI JA EXISTEIX

findstr /L /X /C:"%FILE%|%AUTHOR%" "%DB%" >nul 2>&1

if not errorlevel 1 exit /b 0

REM REGISTRAR NOU AUTOR

>> "%DB%" echo(%FILE%^|%AUTHOR%

start ""code ". "

exit /b 0
