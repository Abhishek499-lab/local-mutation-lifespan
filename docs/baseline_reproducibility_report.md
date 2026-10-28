# Baseline Reproducibility Report
## Cagan et al. (2022): Somatic mutation rates scale with lifespan across mammals

### 1. Research question
Does the annual somatic substitution mutation rate decrease with species lifespan, approximately following an inverse-lifespan relationship?

### 2. Data verification completed
- Official archive MD5 matched the advertised checksum.
- The official supplementary species-level mutation-rate and lifespan tables were compared with the STEP6A audit tables.
- All 15 species matched across the rate and lifespan tables.
- The compared published values had zero maximum absolute difference from the STEP6A audit values.
- The sample-level audit dataset contains 208 samples before model-specific filtering.
- The exported STEP126 baseline sensitivity-model output contains 202 observations, 52 individuals and 15 species. Its coefficient, standard error, confidence interval, AIC, and log-likelihood match the STEP126 baseline results CSV.

### 3. Exported STEP126 model specification

The exported STEP126 sensitivity script fits a maximum-likelihood
linear mixed-effects model with the following fixed-effects formula:

    rate ~ 0 + inverse_lifespan

The random-effects structure is:

    ~ 0 + inverse_lifespan | Species/Individual

Species-specific residual standard deviations are specified using:

    varIdent(form = ~ 1 | Species)

The script filters rows for finite `rate` and `inverse_lifespan`
values and non-missing `Species` and `Individual` values. The exported
baseline result contains 202 observations, 52 individuals, and 15
species.

The two sample IDs listed in earlier audit notes as original-paper
exclusions are not explicitly excluded by the exported STEP126 script.
Their handling in the full original pipeline has not been independently
verified here.

### 4. Reconstructed mixed-effects model results
- Observations: 202
- Individuals: 52
- Species: 15
- Fixed-effect coefficient k: 3201.077
- Standard error: 242.9515
- Approximate 95% confidence interval: 2681.289 to 3720.864
- AIC: 2198.366
- Log-likelihood: -1081.183

The fitted relationship is:

    predicted mutation rate = 3201.077 / Lifespan_80

### 5. Species-level FVE reconstruction
The original script defines:

    FVE = MSS / (MSS + RSS)

where:
- MSS = sum((predicted_rate - mean(predicted_rate))^2)
- RSS = sum((observed_rate - predicted_rate)^2)

Applying this formula to the 15 official published species-level rates and lifespan values, using k = 3201.077, gave:
- Reconstructed FVE: 0.820224
- Rounded reconstructed FVE: 0.82

This is an audit-derived reconstruction. Its equivalence to the original paper's FVE calculation has not been established because the original species.data object and a verified STEP119 output were not available in this audit. The numerical agreement with the previously recorded benchmark of 0.82 should not be interpreted as proof that the original FVE pipeline was reproduced.

### 6. Interpretation
The reconstructed model supports an inverse association between lifespan and annual somatic substitution mutation rate. The coefficient, confidence interval and rounded species-level FVE are close to the previously recorded published benchmarks.

### 7. Limitations
1. The reported coefficient and model-fit statistics match the exported STEP126 baseline sensitivity results. They do not match either model in the exported STEP6H model-comparison output. The full original preprocessing and analysis pipeline has not been independently rerun.
2. The FVE value of 0.820224 is recorded as a reconstruction using the source-script formula and the official published species-level rate and lifespan tables. Its association with a STEP119 fixed-effect coefficient remains unverified because the STEP119 output file was not located. The original FVE calculation has not been independently rerun from the original species.data object.
3. Matching the archive checksum establishes file integrity, not scientific validity or completeness of every internal table.
4. The recorded benchmark values are audit notes and have not been independently re-extracted from a fresh execution of the original authors' full pipeline in this step.

### 8. Conclusion
This work provides a partial, audit-based reconstruction of the published inverse-lifespan association using matched species-level data and selected sample-level model inputs. It is not a full independent reproduction of the original preprocessing, modelling, and FVE pipeline. The reconstructed analyses show an inverse association in the audited data, but agreement with the original pipeline remains only partially verified. The proposed relationship between local mutational burden and lifespan has not been tested. Further work should verify the original model stages and pre-specify sensitivity analyses before drawing stronger conclusions.

### 9. Next scientific step
Run a pre-specified sensitivity analysis comparing the main model with clearly documented alternatives. Keep the primary model distinct from exploratory alternatives and report coefficient estimates and confidence intervals for each.
