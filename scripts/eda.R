
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

# Clean up column names
beer_brew <- beer_brew %>% 
  rename(beer_name = name.x,
         brewery_name = name.y)

# EDA ---------------------------------------------------------------------

colnames(beer_brew)

# Breweries by State
beer_brew %>% 
  count(state)

# Style & ABV
beer_brew %>% 
  ggplot(aes(abv, style)) +
  geom_jitter()

# That's a lot of styles! What are the 10 most popular?

beer_brew %>% 
  count(style) %>% 
  arrange(desc(n)) %>% 
  top_n(10) %>% 
  ggplot(aes(n, style)) +
  geom_col(fill = "steelblue") +
  theme_ipsum()

# Not surprising the American IPA is the top. Interesting that 8 of the top 10
# are "American" style beers.

beer_brew %>% 
  group_by(ounces) %>% 
  count(ounces) %>% 
  mutate(ounces = as_factor(ounces)) %>% 
  ggplot(aes(ounces, n)) +
  geom_col(fill = "steelblue") +
  theme_ipsum()
