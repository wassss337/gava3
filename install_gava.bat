@echo off
title Gava + GPM Installer v2.0
color 0B

echo ============================================
echo     GAVA + GPM INSTALLER v2.0
echo ============================================
echo.

:: Check admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo  [ERROR] Administrator rights required!
    echo  Right-click - Run as Administrator
    echo.
    pause
    exit /b 1
)

:: Find source files
set "SOURCE_DIR=%~dp0"
set "SOURCE_DIR=%SOURCE_DIR:~0,-1%"

echo  [*] Searching for Gava and GPM...
echo.

set "GAVA_FOUND=0"
set "GPM_FOUND=0"

if exist "%SOURCE_DIR%\gava.exe" (
    echo  [OK] gava.exe found
    set "GAVA_FOUND=1"
) else if exist "%USERPROFILE%\Downloads\gava.exe" (
    echo  [OK] gava.exe found in Downloads
    set "GAVA_FOUND=1"
    set "SOURCE_DIR=%USERPROFILE%\Downloads"
) else (
    echo  [!] gava.exe not found
    echo      Please place gava.exe in this folder or Downloads
)

if exist "%SOURCE_DIR%\gpm.exe" (
    echo  [OK] gpm.exe found
    set "GPM_FOUND=1"
) else (
    echo  [!] gpm.exe not found
    echo      Please place gpm.exe in this folder
)

if "%GAVA_FOUND%"=="0" if "%GPM_FOUND%"=="0" (
    echo.
    echo  [ERROR] Nothing to install!
    pause
    exit /b 1
)

:: Create install directory
set "INSTALL_DIR=%USERPROFILE%\Gava"
echo.
echo  [*] Installing to %INSTALL_DIR%...
mkdir "%INSTALL_DIR%" 2>nul
mkdir "%INSTALL_DIR%\vendor\gava" 2>nul

:: Copy gava.exe
if "%GAVA_FOUND%"=="1" (
    copy /Y "%SOURCE_DIR%\gava.exe" "%INSTALL_DIR%\gava.exe" >nul
    echo  [OK] gava.exe installed
)

:: Copy gpm.exe
if "%GPM_FOUND%"=="1" (
    copy /Y "%SOURCE_DIR%\gpm.exe" "%INSTALL_DIR%\gpm.exe" >nul
    echo  [OK] gpm.exe installed
)

:: Create gava.bat
(
    echo @echo off
    echo "%INSTALL_DIR%\gava.exe" %%*
) > "%INSTALL_DIR%\gava.bat"
copy /Y "%INSTALL_DIR%\gava.bat" "C:\Windows\gava.bat" >nul 2>&1

:: Create gpm.bat
if "%GPM_FOUND%"=="1" (
    (
        echo @echo off
        echo "%INSTALL_DIR%\gpm.exe" %%*
    ) > "%INSTALL_DIR%\gpm.bat"
    copy /Y "%INSTALL_DIR%\gpm.bat" "C:\Windows\gpm.bat" >nul 2>&1
)

:: Add to PATH
echo  [*] Adding to PATH...
setx PATH "%PATH%;%INSTALL_DIR%" >nul 2>&1

:: Verify
echo.
echo  [*] Verifying installation...
echo.

if exist "C:\Windows\gava.bat" (
    echo  [OK] gava - works from anywhere
) else (
    echo  [!] gava - may need restart
)

if "%GPM_FOUND%"=="1" (
    if exist "C:\Windows\gpm.bat" (
        echo  [OK] gpm  - works from anywhere
    ) else (
        echo  [!] gpm  - may need restart
    )
)

echo.
echo ============================================
echo     INSTALLATION COMPLETE!
echo ============================================
echo.
echo  Available commands:
echo    gava start main.gava
echo    gava build main.gava
if "%GPM_FOUND%"=="1" (
    echo    gpm install log
    echo    gpm list
)
echo.
echo  Open a NEW console and try!
echo.
pause