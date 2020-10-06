library(rvest)
library(xml2)

# Links -------------------------------------------------------------------

# Web Scraping with R: https://www.scrapingbee.com/blog/web-scraping-r/
# AB InBev Brands: https://en.wikipedia.org/wiki/AB_InBev#Brands
# Beer Stats: https://www.ttb.gov/beer/statistics
# beer.db: https://openbeer.github.io
# Open Brewery API: https://github.com/openbrewerydb/openbrewerydb
# Open Beer Database: https://data.opendatasoft.com/explore/dataset/open-beer-database%40public-us/api/

# External Data -----------------------------------------------------------
# As we discussed this in class, I thought it might be useful in our analysis to
# know which are already owned by one of the big manufacturers. This is one site
# I found that appears to be pretty recent.

# Define the URL
owner_url <- "https://www.craftbeerjoe.com/brewery-who-owns-who-list/"

# Scrape the data
owner_page <- xml2::read_html(owner_url)

# Parse the data into a tibble
owner_raw <- rvest::html_table(owner_page)[[1]]

# Clean names
owner_clean <- janitor::clean_names(owner_raw)

# One cleanup thing I'd like to do is convert the ownership percentage into a
# numeric value. I wonder if janitor can handle that?
owner_clean <- owner_clean %>%
  mutate(ownership_pct = parse_number(percent_owned))

# Save the data so it doesn't need to be scraped every time
write_csv(owner_clean, here::here("data - raw", "owner_data.csv"))

# Read data in again
owner_data <- read_csv(here::here("data - raw", "owner_data.csv"))

# AB InBev Brands ---------------------------------------------------------

# Get URL
wiki_html <- read_html("https://en.wikipedia.org/wiki/AB_InBev")

# Scrape and parse HTML
wiki <- wiki_html %>% 
  html_nodes(xpath = "/html/body/div[3]/div[3]/div[5]/div[1]/div[9]") %>% 
  html_text()

# Split names
wiki <- wiki %>% 
  str_split(pattern = "\n")

# Convert to tibble
wiki <- as_tibble(wiki, .name_repair = "minimal")

# Set variable name
names(wiki) <- "brewery"

# Remove extra [] on some of the records
wiki %>% 
  filter(brewery == str_detect())