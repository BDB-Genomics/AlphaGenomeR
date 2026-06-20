# AlphaGenomeR

An R interface to Google DeepMind's AlphaGenome API.

## Overview

AlphaGenomeR provides a small set of wrapper functions for querying AlphaGenome and extracting common output modalities in R.

## Installation

### Development version

```r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

BiocManager::install("BDB-Genomics/AlphaGenomeR")
```

### Bioconductor release

```r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

BiocManager::install("AlphaGenomeR")
```

## Requirements

- R >= 4.0
- Python >= 3.10
- `alphagenome` Python package
- valid AlphaGenome API key
- internet access for live API queries

## Setup

AlphaGenomeR uses `reticulate` to call the Python client. Point `reticulate` to the Python environment that has `alphagenome` installed before loading the package:

```r
Sys.setenv(
  RETICULATE_PYTHON = "/path/to/miniconda3/envs/alphagenomer/bin/python"
)

library(AlphaGenomeR)
```

## Quick Start

```r
results <- alphagenome_query(
  access_token = "YOUR_API_KEY",
  genomic_region = "chr17:42560601-43560601",
  ontology_terms = "UBERON:0002048",
  requested_outputs = c("RNA_SEQ", "ATAC")
)

rna <- alphagenome_get_rna_seq(results)
atac <- alphagenome_get_atac(results)
```

## Output Structure

`alphagenome_query()` returns a named list of modality results.

Each extractor returns one modality as a list with:

- `values` - numeric matrix or array of predictions
- `metadata` - data frame describing each track

## Supported Outputs

- `alphagenome_get_rna_seq()`
- `alphagenome_get_atac()`
- `alphagenome_get_cage()`
- `alphagenome_get_dnase()`
- `alphagenome_get_chip_tf()`
- `alphagenome_get_chip_histone()`
- `alphagenome_get_splice_sites()`
- `alphagenome_get_splice_junctions()`
- `alphagenome_get_splice_usage()`
- `alphagenome_get_procap()`
- `alphagenome_get_contact_maps()`

## Development

Run checks locally before submitting changes:

```r
devtools::test()
devtools::check()
```

The GitHub Actions workflow runs the same checks in CI.

## Citation

If you use AlphaGenomeR, please cite the package:

```r
citation("AlphaGenomeR")
```

## License

Apache License 2.0
