
# Setup -------------------------------------------------------------------

library(tidyverse)
library(scales)
library(hrbrthemes)

# Load Data ---------------------------------------------------------------

beers <- read_csv(here::here("data - raw", "Beers.csv"))
beers <- janitor::clean_names(beers)
glimpse(beers)

breweries <- read_csv(here::here("data - raw", "Breweries.csv"))
breweries <- janitor::clean_names(breweries)
glimpse(breweries)

# Merge Data --------------------------------------------------------------

beer_brew <- left_join(beers, breweries, by = c("brewery_id" = "brew_id"))

# External Data -----------------------------------------------------------
# As we discussed this in class, I thought it might be useful in our analysis to
# know which are already owned by one of the big manufacturers. This is one site
# I found that appears to be pretty recent.

# Load libraries
library(rvest)
library(xml2)

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

