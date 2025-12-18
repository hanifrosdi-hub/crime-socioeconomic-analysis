# Exploring Socioeconomic and Crime Patterns in Malaysia

This project explores the relationship between socioeconomic indicators and crime patterns across Malaysian states. Using official datasets, I analyzed trends in income, poverty, labor force participation, and gender differences, and examined how these factors correlate with crime statistics over time.

The analysis is conducted entirely in R and presented via R Markdown (.Rmd) with a fully rendered HTML report (.html), making it easy to review both code and results.

________________________________________________________________________________________

Objective

The primary goals of this project are:

1. Understand the distribution of crime across Malaysian states.

2. Analyze socioeconomic indicators such as median income, poverty rates, and labor participation by gender.

3. Identify potential correlations between socioeconomic conditions and crime patterns.

4. Present insights visually and interactively to support decision-making or policy evaluation.

_________________________________________________________________________________________

Data Sources

1. Crime Data – District-level or state-level crime statistics over recent years.

2. Income Data – Mean and median income by state.

3. Poverty Data – Absolute, hardcore, and relative poverty rates.

4. Labor Force Participation Data – Participation rates by gender and state.

5. All datasets are processed and cleaned for consistency, missing values are handled appropriately, and column names are standardized for analysis.

___________________________________________________________________________________________

Methodology

1. Data Cleaning & Preparation

      1.1 Imported CSV datasets into R.

      1.2 Standardized column names using janitor::clean_names().

      1.3 Handled missing values and ensured consistent date formats.

2. Exploratory Data Analysis (EDA)

      2.1 Visualized income distribution and poverty rates by state.

      2.2 Compared male vs. female labor participation rates.

      2.3 Examined crime rates over time and by region.

3. Correlation Analysis

      3.1 Investigated potential relationships between socioeconomic indicators and crime rates.

      3.2 Highlighted states or periods with notable trends.

4. Visualization

      4.1 Created clear, interpretable plots using ggplot2.

      4.2 Combined multiple indicators into comparative charts for easy insights.

__________________________________________________________________________________________________

Tools and Packages Used

1. R – Data manipulation and analysis

2. R Markdown (.Rmd) – Reproducible research report

3. tidyverse – Data wrangling and visualization (dplyr, ggplot2, readr)

4. janitor – Data cleaning

5. lubridate – Date handling

6. tibble / tidyr – Data structure and reshaping

_____________________________________________________________________________________________

Key Insights (Summary)

1. High-income states tend to report higher crime rates, suggesting a moderate positive correlation between income and crime.

2. Socioeconomic factors alone do not fully explain crime distribution; other factors such as urbanization, population density, reporting intensity, and policing coverage likely play significant roles.

3. Temporal trends highlight how crime patterns evolve over time, providing context for evaluating policies and socioeconomic programs.

4. Gender differences in labor participation and poverty rates provide additional context but are not sufficient to explain state-level crime variations.

*Detailed visualizations and interactive charts are available in the HTML report for deeper exploration.*
