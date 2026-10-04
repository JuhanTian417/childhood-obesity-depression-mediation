# 04_inflammation.R
# Association between childhood obesity and systemic inflammation indices.

dat <- read.csv("data/synthetic_data.csv")
markers <- c("NLR", "SII", "SIRI")
out <- data.frame()

for (m in markers) {
  dat$log_marker <- log(dat[[m]])
  fit <- lm(log_marker ~ childhood_obesity + age + female +
              smoking + drinking + physical_activity + ses_z,
            data=dat)
  s <- summary(fit)$coefficients
  beta <- s["childhood_obesity", "Estimate"]
  se <- s["childhood_obesity", "Std. Error"]
  p <- s["childhood_obesity", "Pr(>|t|)"]
  out <- rbind(out, data.frame(
    Marker=m,
    Beta_on_log_scale=beta,
    CI_low=beta - 1.96*se,
    CI_high=beta + 1.96*se,
    P_value=p
  ))
}

out$Beta_on_log_scale <- round(out$Beta_on_log_scale, 3)
out$CI_low <- round(out$CI_low, 3)
out$CI_high <- round(out$CI_high, 3)
out$P_value <- ifelse(out$P_value < 0.001, "<0.001", sprintf("%.3f", out$P_value))

dir.create("results", showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)
write.csv(out, "results/inflammation_associations.csv", row.names = FALSE)
print(out, row.names = FALSE)

png("figures/SII_by_childhood_obesity.png", width=1000, height=700, res=130)
boxplot(log(SII) ~ childhood_obesity, data=dat,
        names=c("No childhood obesity", "Childhood obesity"),
        ylab="log(SII)", xlab="",
        main="SII by childhood obesity status")
dev.off()
