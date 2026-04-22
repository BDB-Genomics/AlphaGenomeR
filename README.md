# <p align="center"><img src="man/figures/logo.png" width="400"></p>

<p align="center">
  <b>Bridging Deep Learning and Functional Genomics for the Bioconductor Ecosystem</b>
</p>

<p align="center">
  <a href="https://github.com/Bioconductor/Contributions/issues/4256">
    <img src="https://img.shields.io/badge/Bioconductor-Submission-blue?style=for-the-badge&logo=bioconductor" alt="Bioconductor">
  </a>
  <a href="https://mintlify.wiki/BDB-Genomics/AlphaGenomeR">
    <img src="https://img.shields.io/badge/Documentation-Mintlify-6366f1?style=for-the-badge&logo=gitbook" alt="Docs">
  </a>
  <a href="https://deepwiki.com/BDB-Genomics/AlphaGenomeR">
    <img src="https://img.shields.io/badge/Ask-DeepWiki-FF69B4?style=for-the-badge&logo=openai" alt="Ask">
  </a>
  <a href="https://opensource.org/licenses/Apache-2.0">
    <img src="https://img.shields.io/badge/License-Apache%202.0-orange?style=for-the-badge" alt="License">
  </a>
</p>

---

## 🧬 Scientific Overview

**AlphaGenomeR** provides a unified R interface to the **AlphaGenome** API, a state-of-the-art transformer model for functional genomics. It enables researchers to predict a comprehensive suite of regulatory features directly from DNA sequences at **single-base resolution**.

Traditional genomic analysis relies on expensive wet-lab assays. AlphaGenomeR allows you to generate **in silico** predictions for any 1MB genomic window, facilitating rapid hypothesis testing and discovery of novel regulatory elements.

---

## 🚀 Key Capabilities

*   🛡️ **Multi-Modal Integration**: Query 11+ biological modalities (Expression, Chromatin, Splicing, 3D Architecture) in a single API call.
*   🧠 **Tissue-Specific Logic**: Predict how sequences function across different biological contexts using UBERON and CL ontologies.
*   ⚡ **High-Performance gRPC**: Efficient data streaming built on a robust `reticulate` bridge.
*   📊 **Bioinformatics Native**: Standard R `matrix` and `data.frame` outputs compatible with `GenomicRanges`, `DESeq2`, and `Gviz`.

---

## 🎨 Modality Atlas: Real Results

The following tracks were generated using `AlphaGenomeR` core extractor functions for a 1MB region on Chromosome 17.

<p align="center">
  <img src="man/figures/modality_atlas.png" width="100%">
</p>

### 💎 Comparative Tissue Analysis
Captured subtle regulatory differences across tissues. Below is the predicted RNA-seq signal for Lung vs. Liver.

<p align="center">
  <img src="man/figures/tissue_comparison.png" width="90%">
</p>

### 🧬 Integrated Signal Stack
Synchronized view of chromatin accessibility and gene expression to identify active regulatory hubs.

<p align="center">
  <img src="man/figures/multimodal_stack.png" width="90%">
</p>

---

## 🛠️ Installation

### 1. System Requirements
AlphaGenomeR requires Python 3.10+ and the official SDK:
```bash
pip install alphagenome
```

### 2. R Package
```r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("BDB-Genomics/AlphaGenomeR")
```

---

## 📖 Quick Start

```r
library(AlphaGenomeR)

# 1. Query a 1MB genomic region
results <- alphagenome_query(
  access_token = "YOUR_API_KEY",
  genomic_region = "chr17:42560601-43609177",
  ontology_terms = "UBERON:0002048",
  requested_outputs = c("RNA_SEQ", "ATAC", "CAGE")
)

# 2. Extract and Plot using native R structures
rna_data <- alphagenome_get_rna_seq(results)
head(rna_data$values)
```

---

## 📑 Supported Extractors

| Modality | Function | Description |
| :--- | :--- | :--- |
| **RNA-seq** | `alphagenome_get_rna_seq()` | Predicted Gene Expression levels |
| **ATAC-seq** | `alphagenome_get_atac()` | Chromatin Accessibility signal |
| **DNase-seq** | `alphagenome_get_dnase()` | Hypersensitivity peaks |
| **CAGE** | `alphagenome_get_cage()` | Transcription Start Site (TSS) signal |
| **ChIP-seq** | `alphagenome_get_chip_tf()` | Transcription Factor Binding sites |
| **Histone** | `alphagenome_get_chip_histone()` | Histone Modification marks |
| **3D Genome** | `alphagenome_get_contact_maps()` | Chromatin Contact maps |
| **Splicing** | `alphagenome_get_splice_sites()` | Predicted Splice Sites |
| **Splicing** | `alphagenome_get_splice_junctions()` | Predicted Junctions |

---

## 📜 Citation & License

If you use AlphaGenomeR in your work, please cite the repository:
> **Himanshu.** "AlphaGenomeR: R Interface to AlphaGenome API." GitHub (2026). https://github.com/BDB-Genomics/AlphaGenomeR

Licensed under **Apache License 2.0**. API usage is for **non-commercial research only**.

<p align="center">
  Developed with ❤️ by <b>Himanshu</b>
</p>
