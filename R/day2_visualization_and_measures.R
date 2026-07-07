## =============================================================================
## Disease Surveillance and Outbreak Analytics with R
## DAY 2 -- Descriptive Analysis, Epidemic Curves & Outbreak Measures
## =============================================================================
## Continue from the clean line list produced on Day 1.
## If you missed Day 1, use data/awd_linelist_clean.csv (answer key) instead.
## =============================================================================


## 0. SETUP -------------------------------------------------------------------

library(tidyverse)
library(janitor)
library(lubridate)
# install.packages("scales")   # for nicer axis labels
library(scales)

linelist <- read_csv("data/awd_linelist_clean_inclass.csv")
# if needed: linelist <- read_csv("data/awd_linelist_clean.csv")

population <- read_csv("data/ward_population.csv")

glimpse(linelist)


## 1. DESCRIPTIVE TABLES ------------------------------------------------------

# how many cases, and over what period?
nrow(linelist)
range(linelist$date_onset)

# case counts by sex
tabyl(linelist, sex) %>%
  adorn_pct_formatting(digits = 1)

# case counts by ward
tabyl(linelist, ward) %>%
  arrange(desc(n))

# cross-tabulation: age group x sex
linelist %>%
  tabyl(age_group, sex) %>%
  adorn_totals(c("row", "col")) %>%
  adorn_percentages("row") %>%
  adorn_pct_formatting(digits = 1) %>%
  adorn_ns()

# outcome by hospitalization status
linelist %>%
  tabyl(hospitalized, outcome) %>%
  adorn_totals(c("row", "col"))


## 2. THE EPIDEMIC CURVE ------------------------------------------------------

# simplest version: daily case counts
ggplot(linelist, aes(x = date_onset)) +
  geom_histogram(binwidth = 1, fill = "steelblue", colour = "white") +
  labs(
    title = "Epidemic Curve: Suspected AWD Cases, Ogun North LGA",
    subtitle = "By date of symptom onset",
    x = "Date of onset",
    y = "Number of cases"
  ) +
  theme_minimal()

# weekly epicurve, coloured by outcome (more useful for surveillance meetings)
linelist <- linelist %>%
  mutate(epiweek = floor_date(date_onset, unit = "week", week_start = 1))

ggplot(linelist, aes(x = epiweek, fill = outcome)) +
  geom_bar(colour = "white") +
  scale_fill_manual(
    values = c("Recovered" = "seagreen", "Died" = "firebrick"),
    na.value = "grey70"
  ) +
  labs(
    title = "Weekly Epidemic Curve by Outcome",
    x = "Week of onset (Monday start)",
    y = "Number of cases",
    fill = "Outcome"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# epicurve faceted by ward - useful to spot where transmission is ongoing
ggplot(linelist, aes(x = epiweek)) +
  geom_bar(fill = "darkorange") +
  facet_wrap(~ward) +
  labs(title = "Weekly Cases by Ward", x = "Week", y = "Cases") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 7))


## 3. KEY OUTBREAK MEASURES ----------------------------------------------------

# a) Attack rate by ward (cases per population, expressed per 10,000)
cases_by_ward <- linelist %>%
  count(ward, name = "cases")

attack_rate <- cases_by_ward %>%
  left_join(population, by = "ward") %>%
  mutate(attack_rate_per_10000 = round(cases / population * 10000, 1)) %>%
  arrange(desc(attack_rate_per_10000))

attack_rate

ggplot(attack_rate, aes(x = reorder(ward, attack_rate_per_10000), y = attack_rate_per_10000)) +
  geom_col(fill = "tomato") +
  coord_flip() +
  labs(title = "Attack Rate by Ward", x = NULL, y = "Cases per 10,000 population") +
  theme_minimal()

# b) Case Fatality Ratio (CFR)
cfr <- linelist %>%
  filter(!is.na(outcome)) %>%
  summarise(
    total_with_known_outcome = n(),
    deaths = sum(outcome == "Died"),
    cfr_percent = round(deaths / total_with_known_outcome * 100, 2)
  )
cfr

# c) Proportion hospitalized
linelist %>%
  filter(!is.na(hospitalized)) %>%
  summarise(pct_hospitalized = round(mean(hospitalized == "Yes") * 100, 1))

# d) Mean/median reporting delay (a data-quality / surveillance-timeliness indicator)
linelist %>%
  summarise(
    mean_delay = round(mean(reporting_delay, na.rm = TRUE), 1),
    median_delay = median(reporting_delay, na.rm = TRUE),
    max_delay = max(reporting_delay, na.rm = TRUE)
  )


## 4. SIMPLE TREND: 7-DAY MOVING AVERAGE OF DAILY CASES -----------------------

daily_cases <- linelist %>%
  count(date_onset, name = "cases") %>%
  complete(
    date_onset = seq.Date(min(date_onset), max(date_onset), by = "day"),
    fill = list(cases = 0)
  ) %>%
  arrange(date_onset) %>%
  mutate(moving_avg_7d = zoo::rollmean(cases, k = 7, fill = NA, align = "right"))
# install.packages("zoo") if not already installed

ggplot(daily_cases, aes(x = date_onset)) +
  geom_col(aes(y = cases), fill = "grey80") +
  geom_line(aes(y = moving_avg_7d), colour = "darkblue", linewidth = 1) +
  labs(
    title = "Daily Cases with 7-Day Moving Average",
    x = "Date of onset", y = "Number of cases"
  ) +
  theme_minimal()


## 5. A ONE-PAGE SURVEILLANCE SUMMARY (preview of reporting) ------------------

summary_stats <- tibble(
  Indicator = c(
    "Total cases", "Date range", "Wards affected",
    "Overall attack rate (per 10,000)", "Case Fatality Ratio (%)",
    "% Hospitalized", "Median reporting delay (days)"
  ),
  Value = c(
    nrow(linelist),
    paste(range(linelist$date_onset), collapse = " to "),
    n_distinct(linelist$ward),
    round(nrow(linelist) / sum(population$population) * 10000, 1),
    cfr$cfr_percent,
    round(mean(linelist$hospitalized == "Yes", na.rm = TRUE) * 100, 1),
    median(linelist$reporting_delay, na.rm = TRUE)
  )
)

summary_stats
