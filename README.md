# Childhood Obesity, Adult Depression, and Systemic Inflammation

A reproducible **R learning prototype** for the research question:

> Is childhood obesity associated with adult depression, and could systemic inflammation statistically mediate part of that association?

> **Important:** This repository uses **synthetic data only**. It contains no real patient information and no identifiable clinical data. The results are for learning and workflow demonstration only.

## Conceptual framework

```mermaid
flowchart LR
    A[Childhood obesity] --> B[Systemic inflammation]
    B --> C[Adult depression]
    A --> C
```

## Main variables

- Exposure: childhood obesity
- Outcome: adult depression
- Candidate mediators: NLR, SII, SIRI
- Covariates: age, sex, smoking, drinking, physical activity, socioeconomic status
- Sensitivity variable: adult BMI

Inflammation indices:

- `NLR = neutrophils / lymphocytes`
- `SII = platelets × neutrophils / lymphocytes`
- `SIRI = neutrophils × monocytes / lymphocytes`

## Project structure

```text
.
├─ README.md
├─ run_all.R
├─ .gitignore
├─ R/
│  ├─ 01_generate_data.R
│  ├─ 02_table1.R
│  ├─ 03_logistic_regression.R
│  ├─ 04_inflammation.R
│  └─ 05_mediation_demo.R
├─ data/
├─ results/
└─ figures/
```

## Analysis workflow

### 1. Generate synthetic data
`R/01_generate_data.R`

Creates a simulated cohort with obesity history, CBC-derived inflammation indices, adult BMI, PHQ-9 score, and a binary adult-depression outcome.

### 2. Table 1
`R/02_table1.R`

- Categorical variables: chi-square test
- Approximately normal continuous variables: Welch t-test
- Skewed inflammation indices: Wilcoxon rank-sum test

### 3. Logistic regression
`R/03_logistic_regression.R`

Estimates crude and adjusted odds ratios for:

`childhood obesity -> adult depression`

Adult BMI is added in a separate sensitivity model because it may lie on the pathway between childhood obesity and later inflammation/depression.

### 4. Inflammation analysis
`R/04_inflammation.R`

Examines whether childhood obesity is associated with NLR, SII, and SIRI.

### 5. Mediation demo
`R/05_mediation_demo.R`

Demonstrates:

`childhood obesity -> log(SII) -> adult depression`

using the R package `mediation`.

A mediation model alone does **not** prove a causal biological mechanism. Causal interpretation requires appropriate temporality, confounder control, model specification, and assumptions about unmeasured confounding.

## Quick start

Clone/download the repository, open it in RStudio, set the repository root as the working directory, then run:

```r
source("run_all.R")
```

For the mediation example:

```r
install.packages("mediation")  # first time only
source("R/05_mediation_demo.R")
```

## Before using real data

The real study protocol should define:

- how childhood obesity is measured and at what age
- whether childhood BMI is measured prospectively or recalled
- how adult depression is defined
- timing of inflammatory biomarker measurements
- missing-data handling
- survey weights/clustering/stratification if relevant
- confounder selection based on subject-matter knowledge and a DAG
- the role of adult BMI
- subgroup and sensitivity analyses

## Current status

This is a **pre-analysis learning prototype** designed to show understanding of the study question, data structure, statistical workflow, and reproducible R analysis before access to the real dataset.
