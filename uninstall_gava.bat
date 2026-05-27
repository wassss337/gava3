@echo off
title Gava + GPM Uninstaller v2.0
color 0C

echo ============================================
echo     GAVA + GPM UNINSTALLER v2.0
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

:: Menu
echo  Choose what to remove:
echo.
echo    [1] Remove Gava only
echo    [2] Remove GPM only
echo    [3] Remove BOTH Gava and GPM
echo    [4] FULL wipe (search entire C: drive)
echo    [0] Exit
echo.
set /p choice="  Your choice: "

if "%choice%"=="0" exit /b 0
if "%choice%"=="1" goto :remove_gava
if "%choice%"=="2" goto :remove_gpm
if "%choice%"=="3" goto :remove_both
if "%choice%"=="4" goto :full_wipe
echo  [!] Invalid choice
pause
exit /b 1

:remove_gava
echo.
echo  [*] Removing Gava...
call :do_remove_gava
goto :done

:remove_gpm
echo.
echo  [*] Removing GPM...
call :do_remove_gpm
goto :done

:remove_both
echo.
echo  [*] Removing Gava and GPM...
call :do_remove_gava
call :do_remove_gpm
goto :done

:full_wipe
echo.
echo  [WARNING] This will scan entire C: drive!
echo  This may take a few minutes.
echo.
set /p confirm="  Continue? (y/n): "
if /i not "%confirm%"=="y" exit /b 0

echo.
echo  [*] Full wipe in progress...
call :do_remove_gava
call :do_remove_gpm

echo  [*] Scanning C: drive for remaining files...
for /r C:\ %%f in (gava.exe) do (
    echo %%f | findstr /i "System32" >nul
    if errorlevel 1 (
        echo     Deleting: %%f
        del /f /q "%%f" 2>nul
    )
)
for /r C:\ %%f in (gava.bat) do (
    echo     Deleting: %%f
    del /f /q "%%f" 2>nul
)
for /r C:\ %%f in (gpm.exe) do (
    echo     Deleting: %%f
    del /f /q "%%f" 2>nul
)
for /r C:\ %%f in (gpm.bat) do (
    echo     Deleting: %%f
    del /f /q "%%f" 2>nul
)
goto :done

:do_remove_gava
if exist "C:\Windows\gava.bat" (
    del /f /q "C:\Windows\gava.bat"
    echo  [OK] Removed C:\Windows\gava.bat
)
if exist "%USERPROFILE%\Gava\gava.exe" (
    del /f /q "%USERPROFILE%\Gava\gava.exe"
    echo  [OK] Removed gava.exe
)
if exist "%USERPROFILE%\Gava\gava.bat" (
    del /f /q "%USERPROFILE%\Gava\gava.bat"
    echo  [OK] Removed gava.bat
)
exit /b

:do_remove_gpm
if exist "C:\Windows\gpm.bat" (
    del /f /q "C:\Windows\gpm.bat"
    echo  [OK] Removed C:\Windows\gpm.bat
)
if exist "%USERPROFILE%\Gava\gpm.exe" (
    del /f /q "%USERPROFILE%\Gava\gpm.exe"
    echo  [OK] Removed gpm.exe
)
if exist "%USERPROFILE%\Gava\gpm.bat" (
    del /f /q "%USERPROFILE%\Gava\gpm.bat"
    echo  [OK] Removed gpm.bat
)
exit /b

:done
:: Remove empty Gava folder
if exist "%USERPROFILE%\Gava" (
    rmdir "%USERPROFILE%\Gava" 2>nul
    if exist "%USERPROFILE%\Gava" (
        echo  [!] Folder not empty, kept: %USERPROFILE%\Gava
    ) else (
        echo  [OK] Removed Gava folder
    )
)

echo.
echo ============================================
echo     UNINSTALL COMPLETE!
echo ============================================
echo.
echo  Check PATH manually for old entries:
echo    Win+R - sysdm.cpl - Advanced - Environment
echo.
pause