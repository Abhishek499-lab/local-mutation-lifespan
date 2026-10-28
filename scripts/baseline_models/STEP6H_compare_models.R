
suppressPackageStartupMessages(library(nlme))

data_path <- Sys.getenv("STEP6E_DATA")
out_dir <- Sys.getenv("STEP6H_OUT")

# Read CSV without changing spaces in header names
d <- read.csv(data_path, check.names = FALSE, stringsAsFactors = FALSE)

life_candidates <- grep("Lifespan_80", names(d), value = TRUE)
if (length(life_candidates) != 1) {
  stop("Could not uniquely identify lifespan column.")
}
life_col <- life_candidates[1]

rate_candidates <- grep("Substitution rate per year", names(d), value = TRUE)
if (length(rate_candidates) != 1) {
  stop("Could not uniquely identify rate column.")
}
rate_col <- rate_candidates[1]

names(d)[names(d) == rate_col] <- "rate"
names(d)[names(d) == life_col] <- "lifespan80"

d$rate <- as.numeric(d$rate)
d$lifespan80 <- as.numeric(d$lifespan80)
d$inverse_lifespan <- 1 / d$lifespan80

d <- d[
  is.finite(d$rate) & d$rate >= 0 &
  is.finite(d$inverse_lifespan) & d$inverse_lifespan > 0 &
  !is.na(d$Species) & !is.na(d$Individual),
]

d$Species <- factor(d$Species)
# Explicitly make the individual ID unique across species
d$Individual_nested <- interaction(
  d$Species, d$Individual, drop = TRUE
)

# Fit with ML for model comparison
# Model A: species-specific random slope + species-specific residual SD
mA <- lme(
  fixed = rate ~ 0 + inverse_lifespan,
  random = ~ 0 + inverse_lifespan | Species,
  weights = varIdent(form = ~ 1 | Species),
  data = d,
  method = "ML",
  control = lmeControl(
    maxIter = 200, msMaxIter = 200,
    opt = "optim", returnObject = TRUE
  )
)

# Model B: nested structure. Species-specific random slope + individual random intercept nested inside Species.
mB <- lme(
  fixed = rate ~ 0 + inverse_lifespan,
  random = list(
    Species = pdDiag(~ 0 + inverse_lifespan),
    Individual_nested = ~ 1
  ),
  weights = varIdent(form = ~ 1 | Species),
  data = d,
  method = "ML",
  control = lmeControl(
    maxIter = 200, msMaxIter = 200,
    opt = "optim", returnObject = TRUE
  )
)

sink(file.path(out_dir, "STEP6H_model_comparison.txt"))

cat("STEP 6H — MODEL STRUCTURE SENSITIVITY\n\n")
cat("Rows:", nrow(d), "\n")
cat("Individuals:", length(unique(d$Individual_nested)), "\n")
cat("Species:", length(unique(d$Species)), "\n\n")

cat("MODEL A: species random slope; species-specific residual variance\n")
print(summary(mA))
cat("\nMODEL B: species random slope + nested individual random intercept\n")
print(summary(mB))

cat("\nLikelihood comparison (ML fits):\n")
print(anova(mA, mB))

cat("\nPublished reference (not a pass/fail criterion):\n")
cat("k = 3206.4; 95% CI = 2683.9–3728.9; FVE = 0.82\n")

sink()

extract_fixed <- function(model, label) {
  ci <- intervals(model, which = "fixed")$fixed
  data.frame(
    model = label,
    estimate = as.numeric(fixef(model)[1]),
    lower_95 = ci[1, "lower"],
    upper_95 = ci[1, "upper"],
    AIC = AIC(model),
    BIC = BIC(model),
    logLik = as.numeric(logLik(model))
  )
}

results <- rbind(
  extract_fixed(mA, "A_species_slope"),
  extract_fixed(mB, "B_species_slope_plus_individual_intercept")
)

write.csv(
  results,
  file.path(out_dir, "STEP6H_fixed_effect_comparison.csv"),
  row.names = FALSE
)

write.csv(
  d,
  file.path(out_dir, "STEP6H_model_input.csv"),
  row.names = FALSE
)

cat("STEP 6H COMPLETE\n")
cat("Output:", out_dir, "\n")
