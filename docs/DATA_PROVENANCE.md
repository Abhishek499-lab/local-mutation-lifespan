# Data provenance and contribution notes

## Scientific starting point

The audit was motivated by the published study:

Cagan et al. (2022), "Somatic mutation rates scale with lifespan
across mammals", Nature.

DOI: https://doi.org/10.1038/s41586-022-04618-z

The study's supplementary tables and associated public data archive
were used as starting points for the preliminary checks.

## Materials included

The selected export contains:

- A matched species-level mutation-rate/lifespan table.
- A baseline reproducibility report.
- Leave-one-species-out results.
- Selected model scripts and model inputs.
- Sensitivity and bootstrap summaries.
- Sample-completeness and callable-genome data-readiness outputs.
- Selected plots from preliminary analyses.

## Original study code and audit code

Original study code and audit code are different sources of work.

The selected scripts from STEP6G, STEP6H, and STEP126 are included as
audit/model scripts from the project workspace. They must not be
represented as original authors' scripts unless their provenance has
been independently confirmed.

Before publication, verify attribution and the applicable licence or
reuse terms for any third-party code.

## Sample and callable-genome limitations

The broader inventory contains 249 sample IDs, while callable-genome
information was identified for 208 samples. The reasons for all 41
missing callable denominators have not been resolved.

Coverage depth, coverage-bin totals, and matching normal-sample names
were not treated as valid substitutes for a missing callable denominator.

## Interpretation boundary

The inverse species-level mutation-rate/lifespan association was
checked in the available 15-species dataset.

The local-mutational-burden/lifespan relationship has not yet been
tested by this work and remains a research question.

## Upstream data and code resources

The published study identifies these resources:

- Processed mutation calls and associated data: Zenodo
  https://doi.org/10.5281/zenodo.5554777
- Original study analysis code: Zenodo
  https://doi.org/10.5281/zenodo.5554801
- Original study code repository:
  https://github.com/baezortega/CrossSpecies2021

These links identify upstream resources. They do not imply that all
source files are included in this repository or that the selected
audit scripts are original author code.

The publication states that raw sequence data are deposited in the
European Genome-Phenome Archive under accession EGAD00001008032.
Access restrictions may apply. The publication also states that raw
Species360 mortality records cannot be publicly shared and require
an authorised research request.

Large source archives, reference genomes, and extensive variant-call
datasets are not bundled here. Check provider access conditions and
applicable licences before downloading, redistributing, or reusing
any upstream material. Record the actual versions and access dates
when these resources are retrieved for a reproducible rerun.
