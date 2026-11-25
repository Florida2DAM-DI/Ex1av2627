
@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo   DESACTIVACIO D'EXTENSIONS D'IA - VSCODE
echo ==========================================
echo.

REM Extensions d'intel.ligencia artificial

set EXTENSIONS=GitHub.copilot GitHub.copilot-chat anthropic.claude-code openai.chatgpt saoudrizwan.claude-dev Google.geminicodeassist Codeium.codeium

for %%E in (%EXTENSIONS%) do (
    echo Desactivant %%E...
    code --disable-extension %%E --workspace
)

echo.
echo ==========================================
echo   OPERACIO FINALITZADA
echo ==========================================
echo.
echo.
pause

endlocal
