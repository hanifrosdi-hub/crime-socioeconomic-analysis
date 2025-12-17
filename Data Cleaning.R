# ====================================
# 02_data_cleaning.R
# Purpose: Load and clean datasets for crime and socioeconomic analysis
# ====================================


# -----------------------------
# 1. Load CSV files and clean column names
# -----------------------------
crime   <- read_csv("data/crime_district.csv") %>% clean_names()
income  <- read_csv("data/income_state.csv") %>% clean_names()
poverty <- read_csv("data/poverty_state.csv") %>% clean_names()
sex     <- read_csv("data/state_sex.csv") %>% clean_names()


# -----------------------------
# 3. Inspect datasets
# -----------------------------
# Quick view of column names
names(crime)
names(income)
names(poverty)
names(sex)

# Quick glimpse of data structure
glimpse(crime)
glimpse(income)
glimpse(poverty)
glimpse(sex)

# Optional: view first few rows
head(crime)
head(income)
head(poverty)
head(sex)

# -----------------------------
# 4. Check for missing values
# -----------------------------
sapply(crime, function(x) sum(is.na(x)))
sapply(income, function(x) sum(is.na(x)))
sapply(poverty, function(x) sum(is.na(x)))
sapply(sex, function(x) sum(is.na(x)))

#------- After run the above 
# Income property have 11 missing value. 
# Income: Check rows where income_median is missing
income[is.na(income$income_median), ]

# Outcome: 11 median income is missing
# Assumptions: It may simply be that the median wasn’t calculated for 1970, or the original source didn’t report it.
# Fill it incorrectly, it could bias analyses, especially if you are looking at income distribution or inequality.

# Poverty: rows where any column is missing
poverty[rowSums(is.na(poverty)) > 0, ]

# Assumption: No record 
