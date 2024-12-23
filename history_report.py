import requests

# List of websites visited (replace this with the actual visited websites)
websites_visited = [
    "https://example1.com",
    "https://www.pornhub.com",
    "https://example2.com",
    "https://xvideos.com",
    "https://example3.com",
    "https://redtube.com",
    "https://example4.com",
    "https://tube8.com",
    "https://example5.com",
    "https://youporn.com",
    "https://javhub.net",
    "https://xxnx.com",
    "https://spankbang.com",
    "https://porn.com",
    "https://bravotube.com",
    "https://hqporner.com",
    "https://erome.com",
    "https://tnaflix.com",
    "https://youporn.com",
    "https://xhamster.com"
]

# List of adult keywords to search in the websites
adult_keywords = [
    "pornhub", "xvideos", "redtube", "tube8", "youporn",
    "javhub", "xxnx", "spankbang", "porn", "bravotube",
    "hqporner", "erome", "tnaflix", "xhamster"
]

# Function to check for adult websites
def check_for_adult_websites(websites_visited):
    adult_sites_found = []
    for website in websites_visited:
        if any(keyword in website.lower() for keyword in adult_keywords):
            adult_sites_found.append(website)
    
    if adult_sites_found:
        return f"Adult websites found: {', '.join(adult_sites_found)}. This dude is a gooner."
    else:
        return "No adult websites found. This guy is safe."

# Send result to Discord webhook
def send_to_discord(result):
    webhook_url = 'https://discord.com/api/webhooks/1320743687109476393/03lSr_qHl0gJyrBWxBRg1uzLwTdwnWhp0p-mM-AWlaHxqn5bbL3ALjfVZUkiV01ReXee'
    data = {
        "content": result
    }
    requests.post(webhook_url, json=data)

# Run the check and send the result to Discord
result = check_for_adult_websites(websites_visited)
send_to_discord(result)
