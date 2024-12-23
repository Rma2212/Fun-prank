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

:: Step 3: Install necessary Python libraries (requests and pyinstaller)
echo Installing requests and pyinstaller...
pip install --upgrade requests pyinstaller

:: Step 4: Download the Python script and .bat file from GitHub
echo Downloading Python script...
powershell -Command "Invoke-WebRequest -Uri https://github.com/yourusername/yourrepo/raw/main/history_report.py -OutFile history_report.py"

echo Downloading .bat file for running silently...
powershell -Command "Invoke-WebRequest -Uri https://github.com/yourusername/yourrepo/raw/main/install_run_silent.bat -OutFile install_run_silent.bat"

:: Step 5: Check if the Python script exists
if not exist "history_report.py" (
    echo Script file not found. Please make sure history_report.py is in the same folder as this batch file.
    pause
    exit /b
)

:: Step 6: Convert the Python script to an executable using PyInstaller
echo Converting script to executable...
pyinstaller --onefile --noconsole history_report.py

:: Step 7: Check if the executable was created
if not exist "dist\history_report.exe" (
    echo Failed to create executable. Exiting...
    pause
    exit /b
)

:: Step 8: Run the executable silently
echo Running the executable silently...
start /B dist\history_report.exe

:: Step 9: Clean up PyInstaller files (optional)
echo Cleaning up PyInstaller files...
rd /s /q "build"
del /q "history_report.spec"

:: Step 10: Clean up the downloaded files
del history_report.py
del install_run_silent.bat

pause
