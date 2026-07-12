## =============================================================================
## Disease Surveillance and Outbreak Analytics with R
## DAY 1 -- Importing, Exploring & Cleaning an Outbreak Line List
## =============================================================================
## Scenario: A suspected Acute Watery Diarrhoea (AWD) outbreak has been
## reported in Ogun North LGA. You have received a raw line list exported
## from the field data collection tool.
## =============================================================================


## 0. SETUP -------------------------------------------------------------------

# Install packages
# install.packages(c("tidyverse", "janitor", "lubridate", "here", "epikit", "skimr"))

library(tidyverse) # dplyr, ggplot2, stringr, tidyr, readr, etc.
library(janitor) # clean_names(), tabyl(), get_dupes()
library(lubridate) # working with dates
library(skimr) # quick data overview
library(pacman)


## 1. IMPORT THE DATA -----------------------------------------------------

linelist_raw <- read_csv("data/awd_linelist_raw.csv")

# first look
dim(linelist_raw)
glimpse(linelist_raw)
skim(linelist_raw)


## 2. CLEAN COLUMN NAMES --------------------------------------------------
# Raw exports rarely have tidy column names ("Sex ", " Ward", "date of report")

linelist <- linelist_raw %>%
  clean_names()


names(linelist)
# case_id, name, age, sex, ward, date_onset, date_of_report,
# hospitalized, rdt_result, outcome, source_of_water


## 3. INSPECT AND REMOVE DUPLICATES ---------------------------------------

# a) exact duplicate rows
get_dupes(linelist) # view them
linelist <- linelist %>% distinct() # drop exact duplicates

# b) near-duplicate case_ids (e.g. "AWD-0043" and "AWD-0043b")
linelist %>%
  count(case_id) %>%
  filter(n > 1)


# For the course: strip any trailing letter appended to case_id, then
# keep only the first occurrence of each true case_id
linelist <- linelist %>%
  mutate(case_id_clean = str_remove(case_id, "[a-z]$")) %>%
  distinct(case_id_clean, .keep_all = TRUE) %>%
  select(-case_id) %>%
  rename(case_id = case_id_clean) %>%
  relocate(case_id)

nrow(linelist) # should now be close to the true number of cases


## 4. CLEAN TEXT / CATEGORICAL VARIABLES ----------------------------------

# a) Sex: standardise casing and abbreviations
linelist <- linelist %>%
  mutate(
    sex = str_trim(sex),
    sex = case_when(
      str_to_upper(sex) %in% c("M", "MALE", "MLE") ~ "Male",
      str_to_upper(sex) %in% c("F", "FEMALE") ~ "Female",
      TRUE ~ NA_character_
    )
  )


tabyl(linelist, sex)

# b) Ward: trim whitespace, standardise case, fix known typos
linelist <- linelist %>%
  mutate(
    ward = str_trim(ward),
    ward = str_to_title(ward),
    ward = recode(ward,
      "Iwo Rd"  = "Iwo Road",
      "Ring Rd" = "Ring Road"
    )
  )


tabyl(linelist, ward)

# c) Hospitalized: standardise Yes/No coding
linelist <- linelist %>%
  mutate(
    hospitalized = str_to_lower(hospitalized),
    hospitalized = str_trim(hospitalized),
    hospitalized = case_when(
      hospitalized %in% c("yes", "y", "1") ~ "Yes",
      hospitalized %in% c("no", "n", "0") ~ "No",
      TRUE ~ NA_character_
    )
  )



tabyl(linelist, hospitalized)

# d) Outcome: standardise and collapse categories
linelist <- linelist %>%
  mutate(
    outcome = str_trim(str_to_lower(outcome)),
    outcome = case_when(
      outcome %in% c("recovered", "alive") ~ "Recovered",
      outcome == "died" ~ "Died",
      TRUE ~ NA_character_ # blank / "unknown" / "unk" -> NA
    )
  )

tabyl(linelist, outcome)

# e) RDT result and source of water: simple case standardisation
linelist <- linelist %>%
  mutate(
    rdt_result = str_to_title(str_trim(rdt_result)),
    source_of_water = str_to_title(str_trim(source_of_water))
  )

tabyl(linelist, rdt_result)
tabyl(linelist, source_of_water)


## 5. CLEAN NUMERIC VARIABLES (AGE) ---------------------------------------

summary(linelist$age)

# Rule for the course: valid age is 0-100. Anything else -> NA
linelist <- linelist %>%
  mutate(age = if_else(age < 0 | age > 100, NA_real_, age))

summary(linelist$age)

# create age groups for later analysis
linelist <- linelist %>%
  mutate(age_group = cut(
    age,
    breaks = c(0, 5, 15, 30, 45, 60, Inf),
    labels = c("0-4", "5-14", "15-29", "30-44", "45-59", "60+"),
    right = FALSE
  ))

# create age groups for later analysis
linelist <- linelist %>%
  mutate(age_group_2 = cut(
    age,
    breaks = c(0, 5, 15, 30, 45, 60, 65, 70, 75, 80, Inf),
    labels = c("0-4", "5-14", "15-29", "30-44", "45-59", "60-64", "65-69", "70-74", "75-79", "80+"),
    right = FALSE
  ))

tabyl(linelist, age_group)


## 6. CLEAN DATES -----------------------------------------------------------
# Dates arrive in several formats: "2026-05-03", "03/05/2026", "03-May-2026"
# lubridate::parse_date_time() can try multiple formats in order

linelist <- linelist %>%
  mutate(
    date_onset = parse_date_time(
      date_onset,
      orders = c("ymd", "dmy", "mdy"), quiet = TRUE
    ) %>% as_date(),
    date_of_report = parse_date_time(
      date_of_report,
      orders = c("ymd", "dmy", "mdy"), quiet = TRUE
    ) %>% as_date()
  )

# check for dates that failed to parse, or are impossible
linelist %>%
  filter(is.na(date_onset)) %>%
  select(case_id, date_onset)


linelist %>%
  filter(date_onset < as_date("2026-01-01") | date_onset > as_date("2026-07-04")) %>%
  select(case_id, date_onset, date_of_report)

# for the course: drop rows with an impossible/missing onset date, and
# fix the reporting date if it is earlier than onset (data entry error)
linelist <- linelist %>%
  filter(
    !is.na(date_onset),
    date_onset >= as_date("2026-01-01"),
    date_onset <= as_date("2026-07-04")
  ) %>%
  mutate(
    date_of_report = if_else(date_of_report < date_onset | is.na(date_of_report),
      date_onset, date_of_report
    ),
    reporting_delay = as.numeric(date_of_report - date_onset)
  )

summary(linelist$reporting_delay)




## 7. FINAL CHECK AND EXPORT ------------------------------------------------

glimpse(linelist)
skim(linelist)

# save the cleaned line list for Day 2
write_csv(linelist, "data/awd_linelist_clean_inclass.csv")

## -----------------------------------------------------------------------
## END OF DAY 1
## You should now have a clean, analysis-ready line list saved as:
##   data/awd_linelist_clean_inclass.csv
## Bring this file back for Day 2!
## -----------------------------------------------------------------------
