# 03_logistic_regression.R
# Logistic models for childhood obesity and adult depression.

dat <- read.csv("data/synthetic_data.csv")

models <- list(
  "Model 1: crude" = glm(adult_depression ~ childhood_obesity,
                         data=dat, family=binomial()),
  "Model 2: age + sex" = glm(adult_depression ~ childhood_obesity + age + female,
                             data=dat, family=binomial()),
  "Model 3: main adjusted" = glm(adult_depression ~ childhood_obesity + age + female +
                                  smoking + drinking + physical_activity + ses_z,
                                  data=dat, family=binomial()),
  "Model 4: + adult BMI (sensitivity)" = glm(adult_depression ~ childhood_obesity + age + female +
                                              smoking + drinking + physical_activity + ses_z + adult_bmi,
                                              data=dat, family=binomial())
)

extract_or <- function(model, name) {
  s <- summary(model)$coefficients
  beta <- s["childhood_obesity", "Estimate"]
  se <- s["childhood_obesity", "Std. Error"]
  p <- s["childhood_obesity", "Pr(>|z|)"]
  data.frame(Model=name,
             OR=exp(beta),
             CI_low=exp(beta - 1.96*se),
             CI_high=exp(beta + 1.96*se),
             P_value=p)
}

res <- do.call(rbind, Map(extract_or, models, names(models)))
res$OR <- round(res$OR, 2)
res$CI_low <- round(res$CI_low, 2)
res$CI_high <- round(res$CI_high, 2)
res$P_value <- ifelse(res$P_value < 0.001, "<0.001", sprintf("%.3f", res$P_value))

dir.create("results", showWarnings = FALSE)
write.csv(res, "results/logistic_results.csv", row.names = FALSE)
print(res, row.names = FALSE)
