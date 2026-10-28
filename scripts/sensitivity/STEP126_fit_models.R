suppressPackageStartupMessages(library(nlme))

args <- commandArgs(trailingOnly=TRUE)
input_dir <- args[1]
output_file <- args[2]

model_names <- c("baseline", "cat_added", "mouse_added", "both_added")
results <- list()

for (nm in model_names) {
  d <- read.csv(file.path(input_dir, paste0(nm, "_input.csv")),
                stringsAsFactors=FALSE)
  d <- d[is.finite(d$rate) & is.finite(d$inverse_lifespan) &
         !is.na(d$Species) & !is.na(d$Individual), ]

  d$Species <- factor(d$Species)
  d$Individual <- factor(d$Individual)

  fit <- tryCatch(
    lme(
      fixed = rate ~ 0 + inverse_lifespan,
      random = ~ 0 + inverse_lifespan | Species/Individual,
      weights = varIdent(form = ~ 1 | Species),
      data = d,
      method = "ML",
      na.action = na.omit,
      control = lmeControl(opt="optim", msMaxIter=200)
    ),
    error=function(e) e
  )

  if (inherits(fit, "error")) {
    results[[nm]] <- data.frame(
      model=nm, n=nrow(d), species=length(unique(d$Species)),
      individuals=length(unique(d$Individual)),
      k=NA, SE=NA, CI_lower=NA, CI_upper=NA,
      AIC=NA, logLik=NA, status=conditionMessage(fit)
    )
    next
  }

  ci <- tryCatch(
    intervals(fit, which="fixed")$fixed[1, c("lower", "upper")],
    error=function(e) c(NA_real_, NA_real_)
  )
  co <- summary(fit)$tTable[1, ]

  results[[nm]] <- data.frame(
    model=nm, n=nrow(d), species=length(unique(d$Species)),
    individuals=length(unique(d$Individual)),
    k=unname(co["Value"]), SE=unname(co["Std.Error"]),
    CI_lower=unname(ci[1]), CI_upper=unname(ci[2]),
    AIC=AIC(fit), logLik=as.numeric(logLik(fit)),
    status="fit"
  )
}

out <- do.call(rbind, results)
write.csv(out, output_file, row.names=FALSE)
print(out, row.names=FALSE)
