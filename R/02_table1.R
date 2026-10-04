# 02_table1.R
# Baseline comparison by childhood obesity status.

dat <- read.csv("data/synthetic_data.csv")

g0 <- dat[dat$childhood_obesity == 0, ]
g1 <- dat[dat$childhood_obesity == 1, ]

fmt_mean_sd <- function(x) sprintf("%.1f ± %.1f", mean(x), sd(x))
fmt_median_iqr <- function(x) {
  q <- quantile(x, c(.25, .5, .75))
  sprintf("%.1f [%.1f, %.1f]", q[2], q[1], q[3])
}
fmt_n_pct <- function(x) sprintf("%d (%.1f%%)", sum(x == 1), 100 * mean(x == 1))

add_cont <- function(label, var) {
  p <- t.test(dat[[var]] ~ dat$childhood_obesity)$p.value
  data.frame(Variable=label,
             No_childhood_obesity=fmt_mean_sd(g0[[var]]),
             Childhood_obesity=fmt_mean_sd(g1[[var]]),
             P_value=p,
             Test="Welch t-test")
}

add_cat <- function(label, var) {
  p <- chisq.test(table(dat[[var]], dat$childhood_obesity), correct=FALSE)$p.value
  data.frame(Variable=label,
             No_childhood_obesity=fmt_n_pct(g0[[var]]),
             Childhood_obesity=fmt_n_pct(g1[[var]]),
             P_value=p,
             Test="Chi-square")
}

add_skew <- function(label, var) {
  p <- wilcox.test(dat[[var]] ~ dat$childhood_obesity, exact=FALSE)$p.value
  data.frame(Variable=label,
             No_childhood_obesity=fmt_median_iqr(g0[[var]]),
             Childhood_obesity=fmt_median_iqr(g1[[var]]),
             P_value=p,
             Test="Wilcoxon rank-sum")
}

rows <- list(
  add_cont("Age, years", "age"),
  add_cat("Female", "female"),
  add_cat("Current smoking", "smoking"),
  add_cat("Current drinking", "drinking"),
  add_cat("Physically active", "physical_activity"),
  add_cont("Adult BMI, kg/m2", "adult_bmi"),
  add_cont("NLR", "NLR"),
  add_skew("SII", "SII"),
  add_skew("SIRI", "SIRI"),
  add_cat("Adult depression", "adult_depression")
)

table1 <- do.call(rbind, rows)
table1$P_value <- ifelse(table1$P_value < 0.001, "<0.001", sprintf("%.3f", table1$P_value))

names(table1)[2] <- paste0("No childhood obesity (n=", nrow(g0), ")")
names(table1)[3] <- paste0("Childhood obesity (n=", nrow(g1), ")")

dir.create("results", showWarnings = FALSE)
write.csv(table1, "results/table1.csv", row.names = FALSE)
print(table1, row.names = FALSE)
