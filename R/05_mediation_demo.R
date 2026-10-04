# 05_mediation_demo.R
# Statistical mediation demo: childhood obesity -> log(SII) -> adult depression
# Causal interpretation requires strong assumptions and appropriate temporality.

dat <- read.csv("data/synthetic_data.csv")
dat$log_SII <- log(dat$SII)

if (!requireNamespace("mediation", quietly=TRUE)) {
  stop("Install package first: install.packages('mediation')")
}

m_model <- lm(
  log_SII ~ childhood_obesity + age + female +
    smoking + drinking + physical_activity + ses_z,
  data=dat
)

y_model <- glm(
  adult_depression ~ childhood_obesity + log_SII + age + female +
    smoking + drinking + physical_activity + ses_z,
  data=dat, family=binomial()
)

set.seed(20261004)
med_fit <- mediation::mediate(
  model.m=m_model,
  model.y=y_model,
  treat="childhood_obesity",
  mediator="log_SII",
  boot=TRUE,
  sims=1000
)

print(summary(med_fit))

dir.create("results", showWarnings = FALSE)
sink("results/mediation_summary.txt")
print(summary(med_fit))
sink()
