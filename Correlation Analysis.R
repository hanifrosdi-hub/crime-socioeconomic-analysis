# CORRELATION to assess whether crime levels tend to move together with income and poverty across states — without claiming causality.
#=============================================
#Use state-level averages (policy-appropriate)
#do not correlate raw yearly data (too noisy).
#use state-level averages → stable, interpretable.

cor_data <- state_summary %>%
  select(avg_crime, avg_income, avg_poverty)

cor_matrix <- cor(cor_data, use = "complete.obs")

round(cor_matrix, 2)
#OUTCOME
#avg_crime avg_income avg_poverty
#avg_crime        1.00       0.70        0.32
#avg_income       0.70       1.00        0.22
#avg_poverty      0.32       0.22        1.00

write_csv(
  as.data.frame(round(cor_matrix, 2)),
  "outputs/tables/correlation_matrix.csv"
)

#Conclusion
#High income correlated with high crime does not mean income causes crime
#It may reflect:
#1. urbanisation
#2. Population density
#3. Reporting intensity
#4. Policing coverage

cor_df <- cor_data %>%
  cor(use = "complete.obs") %>%
  as.data.frame() %>%
  rownames_to_column("Variable1") %>%
  pivot_longer(-Variable1, names_to = "Variable2", values_to = "Correlation")

p_cor <- ggplot(cor_df, aes(Variable1, Variable2, fill = Correlation)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(Correlation, 2)), size = 4) +
  scale_fill_gradient2(
    low = "blue",
    mid = "white",
    high = "red",
    midpoint = 0
  ) +
  labs(
    title = "Correlation Between Crime and Socioeconomic Indicators",
    subtitle = "Correlation shows association, not causation"
  ) +
  theme_minimal()

ggsave("outputs/figures/05_correlation_heatmap.png", p_cor, width = 7, height = 6)

#COMMENT
#We conducted a correlation analysis to assess whether crime levels tend to move together with income and poverty across states.
#The results show moderate associations, indicating that socioeconomic factors are related to crime but do not fully explain it.
#Importantly, correlation does not imply causation — these patterns likely reflect broader structural and urban factors.”