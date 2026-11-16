@echo off
setlocal
rem ============================================================
rem  Executa aquest .bat a l'arrel del projecte (on esta .expo).
rem  1) Instala l'extensio Run on Save (emeraldwalk.RunOnSave)
rem  2) Crea .expo\log-save.js (helper que escriu a log.json)
rem  3) Configura .vscode\settings.json per executar-lo en guardar .js
rem ============================================================

echo [1/4] Comprovant requisits...
where code >nul 2>&1
if errorlevel 1 (
    echo ERROR: no es troba "code" al PATH. Obri VS Code i executa "Shell Command: Install 'code' command in PATH".
    exit /b 1
)
where node >nul 2>&1
if errorlevel 1 (
    echo ERROR: no es troba Node.js. Instala'l des de https://nodejs.org
    exit /b 1
)
where git >nul 2>&1
if errorlevel 1 (
    echo ERROR: no es troba Git.
    exit /b 1
)

echo [2/4] Instalant l'extensio Run on Save...
call code --install-extension emeraldwalk.RunOnSave --force
if errorlevel 1 (
    echo ERROR: no s'ha pogut instalar l'extensio.
    exit /b 1
)

echo [3/4] Creant .expo\log-save.js...
if not exist ".expo" mkdir ".expo"
powershell -NoProfile -Command "Get-Content -LiteralPath '%~f0' | Where-Object { $_.StartsWith('//LOG//') } | ForEach-Object { $_.Substring(7) } | Set-Content -LiteralPath '.expo\log-save.js' -Encoding ASCII"

echo [4/4] Configurant .vscode\settings.json...
powershell -NoProfile -Command "Get-Content -LiteralPath '%~f0' | Where-Object { $_.StartsWith('//CFG//') } | ForEach-Object { $_.Substring(7) } | Set-Content -LiteralPath '%TEMP%\cfg-runonsave.js' -Encoding ASCII"
node "%TEMP%\cfg-runonsave.js"
set RESULT=%errorlevel%
del "%TEMP%\cfg-runonsave.js" >nul 2>&1
if not "%RESULT%"=="0" (
    echo AVIS: no s'ha pogut actualitzar settings.json automaticament.
    exit /b 2
)

echo.
echo Fet! Reinicia VS Code 

exit /b 0

//LOG//const fs = require('fs');
//LOG//const path = require('path');
//LOG//const { execSync } = require('child_process');
//LOG//
//LOG//const file = process.argv[2] || '';
//LOG//let user = 'desconegut';
//LOG//try {
//LOG//  user = execSync('git config user.name', { encoding: 'utf8' }).trim() || user;
//LOG//} catch (e) {}
//LOG//
//LOG//const logPath = path.join(__dirname, 'log.json');
//LOG//let log = [];
//LOG//try {
//LOG//  log = JSON.parse(fs.readFileSync(logPath, 'utf8'));
//LOG//  if (!Array.isArray(log)) log = [];
//LOG//} catch (e) {}
//LOG//
//LOG//log.push({ usuari: user, fitxer: file, data: new Date().toISOString() });
//LOG//fs.writeFileSync(logPath, JSON.stringify(log, null, 2));

//CFG//const fs = require('fs');
//CFG//const path = require('path');
//CFG//const dir = path.join(process.cwd(), '.vscode');
//CFG//const f = path.join(dir, 'settings.json');
//CFG//fs.mkdirSync(dir, { recursive: true });
//CFG//let s = {};
//CFG//if (fs.existsSync(f)) {
//CFG//  try {
//CFG//    s = JSON.parse(fs.readFileSync(f, 'utf8').replace(/^\uFEFF/, ''));
//CFG//  } catch (e) {
//CFG//    console.log('settings.json conte comentaris o es invalid. Afig-hi manualment "emeraldwalk.runonsave".');
//CFG//    process.exit(2);
//CFG//  }
//CFG//}
//CFG//s['emeraldwalk.runonsave'] = {
//CFG//  commands: [
//CFG//    {
//CFG//      match: '^(?!.*node_modules).*\\.js$',
//CFG//      cmd: 'node "${workspaceFolder}/.expo/log-save.js" "${file}"'
//CFG//    }
//CFG//  ]
//CFG//};
//CFG//fs.writeFileSync(f, JSON.stringify(s, null, 4));