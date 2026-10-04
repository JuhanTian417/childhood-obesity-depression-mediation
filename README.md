# Childhood obesity and adult depression

This is a small R practice project I made while trying to understand a possible research topic about **childhood obesity, adult depression and systemic inflammation**.

All data in this repository are simulated. There is no real patient data here.

## What I have done so far

- generated a simple synthetic dataset
- made a basic Table 1
- used chi-square tests for categorical variables
- used t tests / Wilcoxon tests for continuous variables
- tried logistic regression and learned how to read OR, 95% CI and P values
- calculated several inflammation indices: NLR, SII and SIRI

The main question I am thinking about is:

`childhood obesity -> systemic inflammation -> adult depression`

At this stage I am mainly using the project to learn the analysis workflow before seeing the real dataset.

## Files

- `R/01_generate_data.R` — generate simulated data
- `R/02_table1.R` — basic descriptive statistics and group comparison
- `R/03_logistic_regression.R` — crude and adjusted logistic regression
- `R/04_inflammation.R` — a first attempt at analysing inflammation indices
- `R/05_mediation_demo.R` — draft only; I have not decided on the final mediation model
- `notes.md` — things I have learned and questions I still need to discuss

## Run

From the repository folder in RStudio:

```r
source("R/01_generate_data.R")
source("R/02_table1.R")
source("R/03_logistic_regression.R")
```

## Things I still need to figure out

The real analysis depends on the actual database and study design. I still need to confirm:

- how childhood obesity is defined
- how adult depression is measured
- when the inflammation markers were measured
- which confounders should be adjusted for
- whether adult BMI should be in the main model
- whether the database needs survey weights or other special handling
- how the mediation analysis should be specified

So this repository is still a learning draft and will change after I understand the real data better.
