@echo off
echo.
echo   MWM Framework Uninstaller
echo.

if exist "%USERPROFILE%\bin\mwm.bat" (
    del "%USERPROFILE%\bin\mwm.bat"
    echo   [+] Removed launcher from %USERPROFILE%\bin\mwm.bat
) else (
    echo   [~] Launcher not found, skipping
)

echo.
echo   Note: The mwm-framework folder was NOT deleted.
echo   Delete it manually if you want to fully remove MWM.
echo.
pause
