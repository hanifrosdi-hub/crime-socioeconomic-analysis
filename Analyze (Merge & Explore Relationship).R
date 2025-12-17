# ================================================
# 04_analysis.R (RECOMMENDED – Stakeholder-Ready)
# Phase 4 — ANALYZE: Crime & Socioeconomic Patterns

# ================================================

library(tidyverse)
library(lubridate)
library(scales)

# ---------------------------
# 0️⃣ Prepare output folders
# ---------------------------
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

# ---------------------------
# 1️⃣ Prepare crime data
# ---------------------------
crime <- crime %>%
  mutate(
    year = year(ymd(date)),
    total_crime = crimes
  )

# ---------------------------
# 2️⃣ Aggregate crime to state-year
# ---------------------------
crime_state <- crime %>%
  group_by(state, year) %>%
  summarise(total_crime = sum(total_crime, na.rm = TRUE), .groups = "drop")

# ---------------------------
# 3️⃣ Aggregate socioeconomic indicators (state-level)
# ---------------------------
income_state <- income %>%
  group_by(state) %>%
  summarise(median_income = mean(income_median, na.rm = TRUE), .groups = "drop")

poverty_state <- poverty %>%
  group_by(state) %>%
  summarise(poverty_rate = mean(poverty_relative, na.rm = TRUE), .groups = "drop")

# ---------------------------
# 4️⃣ Merge datasets
# ---------------------------
combined <- crime_state %>%
  left_join(income_state, by = "state") %>%
  left_join(poverty_state, by = "state")

combined_plot <- combined %>%
  filter(!is.na(total_crime), !is.na(median_income), !is.na(poverty_rate))

# ==================================================
# STATE-LEVEL SUMMARY (for stakeholder visuals)
# ==================================================
state_summary <- combined_plot %>%
  group_by(state) %>%
  summarise(
    avg_crime = mean(total_crime),
    avg_income = mean(median_income),
    avg_poverty = mean(poverty_rate),
    .groups = "drop"
  )

write_csv(state_summary, "outputs/tables/state_summary.csv")

# ==================================================
# 1️⃣ HOW DO CRIME RATES DIFFER ACROSS STATES?
# → Ranked bar chart (BEST for comparison)
# ==================================================
p1 <- ggplot(state_summary,
             aes(x = reorder(state, avg_crime), y = avg_crime)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Average Crime by State",
    subtitle = "Clear comparison across states",
    x = "State",
    y = "Average Total Crime"
  ) +
  theme_minimal()

ggsave("outputs/figures/01_avg_crime_by_state.png", p1, width = 9, height = 6)

# ==================================================
# 2️⃣ IS CRIME ASSOCIATED WITH INCOME?
# → Quadrant (risk segmentation)
# ==================================================
p2 <- ggplot(state_summary, aes(x = avg_income, y = avg_crime)) +
  geom_point(size = 4, color = "steelblue") +
  geom_vline(xintercept = mean(state_summary$avg_income), linetype = "dashed") +
  geom_hline(yintercept = mean(state_summary$avg_crime), linetype = "dashed") +
  geom_text(aes(label = state), vjust = -0.8, size = 3) +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Crime vs Income (State Risk Quadrants)",
    subtitle = "Identifies high-income but high-crime states",
    x = "Average Median Income (MYR)",
    y = "Average Crime"
  ) +
  theme_minimal()

ggsave("outputs/figures/02_crime_vs_income_quadrant.png", p2, width = 9, height = 6)

# ==================================================
# 3️⃣ IS CRIME ASSOCIATED WITH POVERTY?
# → Quadrant (policy relevance)
# ==================================================
p3 <- ggplot(state_summary, aes(x = avg_poverty, y = avg_crime)) +
  geom_point(size = 4, color = "darkgreen") +
  geom_vline(xintercept = mean(state_summary$avg_poverty), linetype = "dashed") +
  geom_hline(yintercept = mean(state_summary$avg_crime), linetype = "dashed") +
  geom_text(aes(label = state), vjust = -0.8, size = 3) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Crime vs Poverty (State Risk Quadrants)",
    subtitle = "Crime is not purely poverty-driven",
    x = "Average Poverty Rate (%)",
    y = "Average Crime"
  ) +
  theme_minimal()

ggsave("outputs/figures/03_crime_vs_poverty_quadrant.png", p3, width = 9, height = 6)

# ==================================================
# 4️⃣ DO CRIME PATTERNS CHANGE OVER TIME?
# → Top states vs national trend
# ==================================================

# Identify top crime states
top_states <- state_summary %>%
  arrange(desc(avg_crime)) %>%
  slice_head(n = 3) %>%
  pull(state)

trend_data <- combined_plot %>%
  mutate(group = ifelse(state %in% top_states, state, "Other States"))

p4 <- ggplot(trend_data,
             aes(x = year, y = total_crime, color = group)) +
  stat_summary(fun = mean, geom = "line", linewidth = 1.2) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Crime Trends Over Time",
    subtitle = "Top crime states vs national pattern",
    x = "Year",
    y = "Average Crime"
  ) +
  theme_minimal()

ggsave("outputs/figures/04_crime_trends_top_vs_others.png", p4, width = 10, height = 6)

# ==================================================
# 5️⃣ HIGH CRIME DESPITE GOOD SOCIOECONOMIC CONDITIONS
# → Table for decision-makers
# ==================================================
high_crime_good_conditions <- state_summary %>%
  filter(
    avg_crime > mean(avg_crime),
    avg_income > mean(avg_income) | avg_poverty < mean(avg_poverty)
  ) %>%
  arrange(desc(avg_crime))

write_csv(high_crime_good_conditions,
          "outputs/tables/high_crime_good_indicators.csv")

# ==================================================
# END OF ANALYSIS
# ==================================================
