import requests
from bs4 import BeautifulSoup

def scrape_website(url):
    """
    Performs web scraping on the given URL and returns the parsed HTML content.

    Args:
        url (str): The URL of the website to scrape.

    Returns:
        BeautifulSoup: A BeautifulSoup object representing the parsed HTML, or None if an error occurs.
    """
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raise an HTTPError for bad responses (4xx or 5xx)
        soup = BeautifulSoup(response.text, 'html.parser')
        return soup
    except requests.exceptions.RequestException as e:
        print(f"Error during web scraping: {e}")
        return None

if __name__ == '__main__':
    # Example usage:
    target_url = "https://www.example.com"  # Replace with the URL you want to scrape
    print(f"Scraping data from: {target_url}")
    scraped_data = scrape_website(target_url)

    if scraped_data:
        # You can now work with the 'scraped_data' (BeautifulSoup object)
        # For example, to print the title of the page:
        title_tag = scraped_data.find('title')
        if title_tag:
            print(f"Page Title: {title_tag.text}")
        else:
            print("No title found.")

        # Example: Find all paragraph tags
        paragraphs = scraped_data.find_all('p')
        print(f"\nFound {len(paragraphs)} paragraph(s):")
        for i, p in enumerate(paragraphs[:5]):  # Print first 5 paragraphs
            print(f"  Paragraph {i+1}: {p.text.strip()}")
    else:
        print("Failed to retrieve data from the website.")
