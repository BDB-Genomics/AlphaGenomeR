# <p align="center">🧬 AlphaGenomeR</p>

<p align="center">
  <b>The official Bioconductor bridge to Google DeepMind's AlphaGenome API.</b>
</p>

<p align="center">
  <img src="man/figures/banner.png" width="100%">
</p>

<p align="center">
  <a href="https://github.com/Bioconductor/Contributions/issues/4256">
    <img src="https://img.shields.io/badge/Bioconductor-Submission-blue.svg" alt="Bioconductor Submission">
  </a>
  <a href="https://opensource.org/licenses/Apache-2.0">
    <img src="https://img.shields.io/badge/License-Apache%202.0-orange.svg" alt="License">
  </a>
  <a href="https://github.com/BDB-Genomics/AlphaGenomeR/actions">
    <img src="https://github.com/BDB-Genomics/AlphaGenomeR/actions/workflows/check.yml/badge.svg" alt="R-CMD-check">
  </a>
  <a href="https://deepwiki.com/BDB-Genomics/AlphaGenomeR">
    <img src="https://deepwiki.com/badge.svg" alt="Ask DeepWiki">
  </a>
</p>

---

## ✨ Overview

**AlphaGenomeR** is a high-performance R package providing a seamless interface to **AlphaGenome**, DeepMind's unifying transformer model for functional genomics. Access multimodal predictions for DNA sequences at **single-base resolution** across 1MB genomic windows.

By bridging the official gRPC-based Python SDK, AlphaGenomeR allows researchers to integrate state-of-the-art AI predictions directly into established Bioconductor workflows.

## 🚀 Key Features

- 💎 **Multimodal Precision**: Simultaneous prediction of RNA-seq, ATAC-seq, CAGE, ChIP-seq, and 3D contact maps.
- ⚡ **High-Throughput gRPC**: Optimized data streaming using a robust `reticulate` bridge.
- 🧠 **Tissue Intelligence**: Filter predictions using specific **UBERON** and **CL** ontology terms.
- 📊 **R-Native Output**: Direct conversion to standard R `matrix` and `data.frame` objects.

---

## 🛠️ Installation

### Prerequisites

AlphaGenomeR requires Python 3.10+ and the official SDK:

```bash
pip install alphagenome
```

### R Package

```r
# Install from GitHub
devtools::install_github("BDB-Genomics/AlphaGenomeR")
```

---

## 📖 Quick Start

Get functional genomic predictions in under 60 seconds:

```r
library(AlphaGenomeR)

# 1. Initialize API Key & Region
api_key <- "YOUR_API_KEY"
region  <- "chr17:42560601-43609177" # 1MB hg38 region

# 2. Query Multimodal Predictions
results <- alphagenome_query(
  access_token = api_key,
  genomic_region = region,
  ontology_terms = c("UBERON:0002048"), # Lung
  requested_outputs = c("RNA_SEQ", "ATAC")
)

# 3. Extract & Plot
rna_seq <- alphagenome_get_rna_seq(results)
plot(rna_seq$values[,1], type="l", col="#E41A1C", main="Predicted RNA-seq Signal")
```

---

## 📑 Supported Modalities

| Category | Function | Modality |
| :--- | :--- | :--- |
| **Expression** | `alphagenome_get_rna_seq()` | RNA-seq Gene Expression |
| | `alphagenome_get_cage()` | CAGE TSS Signal |
| **Chromatin** | `alphagenome_get_atac()` | ATAC-seq Accessibility |
| | `alphagenome_get_dnase()` | DNase-seq Hypersensitivity |
| **Epigenome** | `alphagenome_get_chip_tf()` | ChIP-seq (Transcription Factors) |
| | `alphagenome_get_chip_histone()` | ChIP-seq (Histone Marks) |
| **Splicing** | `alphagenome_get_splice_sites()` | Predicted Splice Sites |
| | `alphagenome_get_splice_junctions()` | Splice Junction Predictions |
| **3D Genome** | `alphagenome_get_contact_maps()` | Chromatin Contact Maps |

---

## 📜 License

AlphaGenomeR is distributed under the **Apache License 2.0**.
Usage of the AlphaGenome API is restricted to **non-commercial research purposes**.

---

<p align="center">
  Developed by <b>AncientHearings</b> & The <b>BDB Genomics</b> Team
</p>
