# Local Somatic Mutation Burden and Mammalian Lifespan

## Project overview

This repository documents preliminary reproducibility checks and
data-readiness audits related to cross-species somatic mutation research.

The work is motivated by the question of how local mutational burden
may relate to mammalian lifespan. The published study by Cagan et al.
(2022) provides the starting point for the baseline checks.

## Research question

Can local somatic mutation patterns be compared reliably across
mammalian species, and do local patterns provide information about
species lifespan beyond genome-wide mutation-rate associations?

## Work completed

The preliminary work includes:

- Matching published species-level mutation-rate and lifespan data
  for 15 species.
- Rechecking the species-level log-log association.
- Conducting leave-one-species-out sensitivity analysis.
- Inspecting selected sample-level modelling scripts and inputs.
- Auditing sample identifiers and callable-genome denominators.
- Conducting a limited rat reference-coordinate validation pilot.
- Documenting data provenance, missing denominators, and unresolved
  analysis limitations.

## Selected baseline finding

The audited species-level log-log regression across 15 species gave
a slope of approximately -0.862 and R-squared of approximately 0.851.
The estimated association remained negative in leave-one-species-out
analyses.

These findings concern the published species-level mutation-rate
and lifespan relationship. They do not establish a new relationship
between local mutational burden and lifespan.

## Important limitations

- The complete original sample-level pipeline has not been independently
  rerun from beginning to end.
- The broader inventory contains 249 sample IDs, while callable-genome
  information was identified for 208 samples.
- The callable denominator for 41 samples remains unresolved in the
  audited data.
- Coverage depth and coverage-bin totals have not been validated as
  substitutes for callable genomic bases.
- Comparable positional mutation data across all species have not yet
  been established.
- The local-mutational-burden/lifespan relationship remains to be tested.
- The species-level analysis includes only 15 species and is observational.

## Repository structure

- `docs/`: reproducibility report and data provenance notes.
- `scripts/`: selected R analysis scripts.
- `results/`: selected tables, model inputs, and audit outputs.
- `figures/`: selected plots from preliminary analyses.
- `environment/`: software and package notes.
- `data/`: source-data access and handling notes.

## Software

The selected R scripts explicitly load the `nlme` package.

See `environment/README.md` for setup and execution notes. Input paths
may need to be configured for the local environment before scripts run.

## Data availability

Large source archives, reference genomes, and extensive variant-call
files are not included in this repository.

See `docs/DATA_PROVENANCE.md` for source identification and data-handling
notes. Obtain source data from the original providers and follow their
access and reuse conditions.

## Reference and upstream resources

Cagan, A. et al. (2022). *Somatic mutation rates scale with lifespan
across mammals*. Nature 604, 517–524.
https://doi.org/10.1038/s41586-022-04618-z

- Processed mutation calls and associated data: Zenodo
  https://doi.org/10.5281/zenodo.5554777
- Original study analysis code: Zenodo
  https://doi.org/10.5281/zenodo.5554801
- Original study code repository:
  https://github.com/baezortega/CrossSpecies2021

These are upstream resources, not a claim that this repository
contains the complete original dataset or reproduces the full pipeline.
Check each provider's access conditions and licence before reuse.

## Scope of this repository

This repository records preliminary audit work. It does not claim that
the proposed local-mutational-burden analysis has been completed.
