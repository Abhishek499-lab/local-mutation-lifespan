
suppressPackageStartupMessages({
  library(nlme)
})

data_path <- Sys.getenv("STEP6E_DATA")
out_dir <- Sys.getenv("STEP6G_OUT")

# Use check.names = FALSE so R preserves spaces in 'Substitution rate per year'
d <- read.csv(data_path, stringsAsFactors = FALSE, check.names = FALSE)

lifespan_col <- "Lifespan_80 (y) [Species 360/Human Mortality Database]"

if (!lifespan_col %in% names(d)) {
  candidates <- grep("Lifespan_80", names(d), value = TRUE)
  if (length(candidates) != 1) {
    stop("Could not uniquely identify Lifespan_80 column.")
  }
  lifespan_col <- candidates[1]
}

needed <- c(
  "Sample", "Individual", "Species",
  "Substitution rate per year", lifespan_col
)

missing <- setdiff(needed, names(d))
if (length(missing) > 0) {
  stop(paste("Missing columns:", paste(missing, collapse = ", ")))
}

names(d)[names(d) == "Substitution rate per year"] <- "rate"
names(d)[names(d) == lifespan_col] <- "lifespan80"

d$rate <- as.numeric(d$rate)
d$lifespan80 <- as.numeric(d$lifespan80)
d$inverse_lifespan <- 1 / d$lifespan80

d <- d[
  is.finite(d$rate) &
  d$rate >= 0 &
  is.finite(d$inverse_lifespan) &
  d$inverse_lifespan > 0 &
  !is.na(d$Individual) &
  !is.na(d$Species),
]

d$Species <- factor(d$Species)
d$Individual <- factor(d$Individual)

cat("Rows:", nrow(d), "\n")
cat("Individuals:", length(unique(d$Individual)), "\n")
cat("Species:", length(unique(d$Species)), "\n")

fit <- try(
  nlme::lme(
    fixed = rate ~ 0 + inverse_lifespan,
    random = ~ 0 + inverse_lifespan | Species,
    weights = varIdent(form = ~ 1 | Species),
    data = d,
    method = "REML",
    control = lmeControl(
      maxIter = 200,
      msMaxIter = 200,
      opt = "optim",
      returnObject = TRUE
    )
  ),
  silent = TRUE
)

sink(file.path(out_dir, "STEP6G_model_output.txt"))

cat("STEP 6G — CANDIDATE ZERO-INTERCEPT LME\n\n")
cat("Rows:", nrow(d), "\n")
cat("Individuals:", length(unique(d$Individual)), "\n")
cat("Species:", length(unique(d$Species)), "\n\n")

if (inherits(fit, "try-error")) {
  cat("MODEL FIT FAILED\n")
  print(fit)
} else {
  print(summary(fit))
  cat("\nConfidence intervals:\n")
  print(try(intervals(fit, which = "fixed"), silent = TRUE))

  cat("\nPublished benchmark for comparison:\n")
  cat("k = 3206.4\n")
  cat("95% CI = 2683.9 to 3728.9\n")
  cat("FVE = 0.82\n")

  cat("\nImportant: FVE has not been calculated here using the paper's\n")
  cat("exact inter-species variance formula. Do not compare an arbitrary\n")
  cat("model R-squared directly with the paper's FVE.\n")

  coef_table <- as.data.frame(summary(fit)$tTable)
  write.csv(
    coef_table,
    file.path(out_dir, "STEP6G_fixed_effects.csv")
  )
}

sink()

write.csv(
  d,
  file.path(out_dir, "STEP6G_model_input.csv"),
  row.names = FALSE
)

cat("\nSaved results to:", out_dir, "\n")
