@echo off
setlocal ENABLEDELAYEDEXPANSION
set setup_script="setup\SphinxInstaller_x64.iss"
set setup_dir=_out

echo [!TIME!]:
echo [!TIME!]: ------------------
echo [!TIME!]:    Packaging...   
echo [!TIME!]: ------------------

rmdir /Q/S %setup_dir% 2> nul

if not !ERRORLEVEL! EQU 0 goto :ErrorOccured

CALL iscc %setup_script%

if not !ERRORLEVEL! EQU 0 goto :ErrorOccured

echo [!TIME!]:
echo [!TIME!]: -------------------------
echo [!TIME!]:    Finished packaging!   
echo [!TIME!]: -------------------------
GOTO :eof

:ErrorOccured
echo [!TIME!]:
echo [!TIME!]: ---------------------
echo [!TIME!]:    Error occurred!   
echo [!TIME!]: ---------------------
endlocal
pause
goto :eof
