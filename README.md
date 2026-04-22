# AlphaGenomeR: R Interface to Google DeepMind's AlphaGenome API

<p align="center">
  <img src="man/figures/banner.png" width="100%">
</p>

[![Bioconductor Status](https://bioconductor.org/shields/availability/release/AlphaGenomeR.svg)](https://bioconductor.org/packages/AlphaGenomeR)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![R-CMD-check](https://github.com/BDB-Genomics/AlphaGenomeR/actions/workflows/check.yml/badge.svg)](https://github.com/BDB-Genomics/AlphaGenomeR/actions)

**AlphaGenomeR** provides a high-performance R wrapper for the [AlphaGenome API](https://deepmind.google/science/alphagenome/) developed by Google DeepMind.
 AlphaGenome is a transformer-based model capable of predicting a wide array of functional genomic features from DNA sequences at single-base resolution.

This package bridges the official **AlphaGenome Python SDK** using the `reticulate` package, enabling R users to access high-throughput gRPC-based predictions for gene expression, chromatin accessibility, splicing, and 3D genome architecture.

## Key Features

- **Multimodal Predictions**: Support for 11+ genomic modalities including RNA-seq, ATAC-seq, CAGE, ChIP-seq (TF and Histone), DNASE, and more.
- **Bioconductor Integration**: Designed to return R-native data structures (`matrix`, `data.frame`) compatible with standard Bioconductor workflows.
- **Tissue Specificity**: Query predictions filtered by specific tissues or cell types using UBERON/CL ontology terms.
- **High Resolution**: Access predictions for 1MB genomic intervals at single-base pair resolution.

## Prerequisites

AlphaGenomeR requires Python and the official AlphaGenome SDK to handle gRPC communication.

1.  **Python (>= 3.10)**
2.  **AlphaGenome Python Package**:
    ```bash
    pip install alphagenome
    ```
3.  **API Key**: Obtain a free, non-commercial API key from the [AlphaGenome Science Page](https://deepmind.google/science/alphagenome/).

## Installation

### From Bioconductor (Upcoming)
```r
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("AlphaGenomeR")
```

### From GitHub
```r
# install.packages("devtools")
devtools::install_github("himanshu/AlphaGenomeR")
```

## Quick Start

```r
library(AlphaGenomeR)

# 1. Provide your API Key
api_key <- "YOUR_ALPHAGENOME_API_KEY"

# 2. Define a 1MB genomic region (hg38 coordinates)
region <- "chr17:42560601-43609177"

# 3. Query the API for specific tissue (e.g., Lung)
results <- alphagenome_query(
  access_token = api_key,
  genomic_region = region,
  ontology_terms = c("UBERON:0002048"),
  requested_outputs = c("RNA_SEQ", "ATAC")
)

# 4. Extract and analyze data
rna_data <- alphagenome_get_rna_seq(results)
atac_data <- alphagenome_get_atac(results)

# Access the prediction matrix (Positions x Tracks)
head(rna_data$values)

# Access metadata (Cell types, experimental details)
print(rna_data$metadata)
```

## Supported Modalities

AlphaGenomeR provides specialized extractor functions for the following data types:

| Function | Modality |
| :--- | :--- |
| `alphagenome_get_rna_seq()` | RNA-seq Gene Expression |
| `alphagenome_get_atac()` | ATAC-seq Chromatin Accessibility |
| `alphagenome_get_cage()` | CAGE Transcription Start Sites |
| `alphagenome_get_dnase()` | DNase-seq Hypersensitivity |
| `alphagenome_get_chip_tf()` | ChIP-seq (Transcription Factors) |
| `alphagenome_get_chip_histone()` | ChIP-seq (Histone Marks) |
| `alphagenome_get_splice_sites()` | Predicted Splice Sites |
| `alphagenome_get_splice_junctions()` | Splice Junction Predictions |
| `alphagenome_get_procap()` | PRO-cap (Capped RNA) |
| `alphagenome_get_contact_maps()` | 3D Chromatin Contact Maps |

## Citation

If you use AlphaGenome in your research, please cite:
> DeepMind AlphaGenome Team. "Predicting the regulatory code of DNA sequences with AlphaGenome." *Nature* (2026).

## License

AlphaGenomeR is licensed under the **Apache License 2.0**. Note that usage of the AlphaGenome API is restricted to non-commercial research purposes.
