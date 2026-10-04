# Learning notes

## 2026-10-04

I started this repository to prepare for a possible project on childhood obesity and adult depression.

Things I understand better now:

- For a simple Table 1, categorical variables such as sex or depression status can be compared with a chi-square test.
- Continuous variables may use a t test or a Wilcoxon test depending on their distribution.
- Logistic regression can give an OR with a 95% confidence interval for a binary outcome.
- NLR, SII and SIRI can be calculated from routine blood cell counts.
- A significant association in a regression model does not automatically mean causation.

Things I still need to ask / learn:

- What exactly counts as childhood obesity in the real dataset?
- Is adult depression defined by PHQ-9, diagnosis, or another scale?
- Are inflammation markers measured before the depression outcome?
- Which variables are considered confounders by the research team?
- Adult BMI is tricky: it may explain part of the pathway from childhood obesity to later outcomes, so I should not add it automatically.
- I have only a basic idea of mediation analysis and need to learn it after the study design is clear.

Next step:

Try to understand the real codebook and reproduce Table 1 first. Then move to regression and mediation.
