# 01_generate_data.R
# Creates a synthetic dataset for learning only.
# No real patient data are used.

set.seed(20261004)

n <- 800
invlogit <- function(x) 1 / (1 + exp(-x))

childhood_obesity <- rbinom(n, 1, 0.25)
age <- pmin(pmax(rnorm(n, 30.5, 5.0), 20), 45)
female <- rbinom(n, 1, 0.54)
smoking <- rbinom(n, 1, invlogit(-1.6 + 0.35 * (1 - female)))
drinking <- rbinom(n, 1, invlogit(-1.0 + 0.45 * (1 - female)))
physical_activity <- rbinom(n, 1, invlogit(-0.05 - 0.35 * childhood_obesity))
ses_z <- rnorm(n, -0.10 * childhood_obesity, 1)

adult_bmi <- pmin(
  pmax(rnorm(n,
             23.0 + 3.5 * childhood_obesity + 0.03 * (age - 30) -
               0.45 * physical_activity,
             2.7), 17), 40
)

neutrophils <- pmin(pmax(rnorm(n,
  3.55 + 0.28 * childhood_obesity + 0.035 * (adult_bmi - 23), 0.75), 1.2), 8)
lymphocytes <- pmin(pmax(rnorm(n,
  2.02 - 0.06 * childhood_obesity, 0.38), 0.7), 4)
monocytes <- pmin(pmax(rnorm(n,
  0.43 + 0.035 * childhood_obesity, 0.10), 0.15), 1)
platelets <- pmin(pmax(rnorm(n,
  245 + 10 * childhood_obesity + 1.2 * (adult_bmi - 23), 42), 120), 450)

NLR <- neutrophils / lymphocytes
SII <- platelets * neutrophils / lymphocytes
SIRI <- neutrophils * monocytes / lymphocytes

logit_dep <- -2.35 +
  0.50 * childhood_obesity +
  0.30 * female +
  0.35 * smoking +
  0.18 * drinking -
  0.28 * physical_activity -
  0.18 * ses_z +
  0.25 * log(SII / median(SII))

adult_depression <- rbinom(n, 1, invlogit(logit_dep))

phq9 <- ifelse(
  adult_depression == 1,
  pmin(pmax(round(rnorm(n, 13, 3)), 10), 24),
  pmin(pmax(round(rnorm(n, 4.2, 2.6)), 0), 9)
)

dat <- data.frame(
  id = 1:n,
  childhood_obesity,
  age = round(age, 1),
  female,
  smoking,
  drinking,
  physical_activity,
  ses_z = round(ses_z, 3),
  adult_bmi = round(adult_bmi, 2),
  neutrophils_10e9_L = round(neutrophils, 3),
  lymphocytes_10e9_L = round(lymphocytes, 3),
  monocytes_10e9_L = round(monocytes, 3),
  platelets_10e9_L = round(platelets, 1),
  NLR = round(NLR, 3),
  SII = round(SII, 2),
  SIRI = round(SIRI, 3),
  phq9,
  adult_depression
)

dir.create("data", showWarnings = FALSE)
write.csv(dat, "data/synthetic_data.csv", row.names = FALSE)
cat("Synthetic dataset created: data/synthetic_data.csv\n")
