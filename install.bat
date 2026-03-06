@echo off
setlocal

echo.
echo   ███╗   ███╗██╗    ██╗███╗   ███╗
echo   ████╗ ████║██║    ██║████╗ ████║
echo   ██╔████╔██║██║ █╗ ██║██╔████╔██║
echo   ██║╚██╔╝██║██║███╗██║██║╚██╔╝██║
echo   ██║ ╚═╝ ██║╚███╔███╔╝██║ ╚═╝ ██║
echo   ╚═╝     ╚═╝ ╚══╝╚══╝ ╚═╝     ╚═╝
echo.
echo   MWM Framework Installer
echo.

:: Get the directory where install.bat lives
set "MWM_DIR=%~dp0"
set "MWM_DIR=%MWM_DIR:~0,-1%"

:: Check for Git Bash
set "GITBASH="
if exist "C:\Program Files\Git\bin\bash.exe" (
    set "GITBASH=C:\Program Files\Git\bin\bash.exe"
    echo   [+] Found Git Bash
) else if exist "C:\Program Files (x86)\Git\bin\bash.exe" (
    set "GITBASH=C:\Program Files (x86)\Git\bin\bash.exe"
    echo   [+] Found Git Bash (x86)
) else (
    echo   [!] Git Bash not found. Please install Git for Windows.
    echo       https://git-scm.com/download/win
    pause
    exit /b 1
)

:: Check for Python
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo   [!] Python not found. Webcam feature will use fallback.
    echo       Install Python from https://python.org for full features.
) else (
    echo   [+] Found Python
    :: Install opencv for cam feature (optional, don't fail if it errors)
    echo   [*] Installing opencv-python for webcam feature...
    python -m pip install opencv-python --quiet >nul 2>&1
    if %errorlevel% equ 0 (
        echo   [+] opencv-python installed
    ) else (
        echo   [~] opencv-python install skipped (webcam will use fallback)
    )
)

:: Create the mwm.bat launcher in a PATH-accessible location
set "INSTALL_TO=%USERPROFILE%\bin"
if not exist "%INSTALL_TO%" mkdir "%INSTALL_TO%"

:: Write the launcher
(
echo @echo off
echo "%GITBASH%" "%MWM_DIR%\mwm.sh" %%*
) > "%INSTALL_TO%\mwm.bat"

echo   [+] Launcher created: %INSTALL_TO%\mwm.bat

:: Check if bin is in PATH
echo %PATH% | findstr /i "%INSTALL_TO%" >nul 2>&1
if %errorlevel% neq 0 (
    :: Add to user PATH
    echo   [*] Adding %INSTALL_TO% to your PATH...
    setx PATH "%PATH%;%INSTALL_TO%" >nul 2>&1
    if %errorlevel% equ 0 (
        echo   [+] Added to PATH. Restart your terminal for it to take effect.
    ) else (
        echo   [!] Could not add to PATH automatically.
        echo       Manually add this to your PATH: %INSTALL_TO%
    )
) else (
    echo   [+] PATH already configured
)

echo.
echo   ══════════════════════════════════════════════
echo   Installation complete!
echo.
echo   Usage:
echo     mwm           - Launch interactive shell
echo     mwm help      - Show all commands
echo     mwm scan      - Network scan
echo     mwm cam       - Webcam capture
echo.
echo   Open a NEW terminal window, then type: mwm
echo   ══════════════════════════════════════════════
echo.
pause
