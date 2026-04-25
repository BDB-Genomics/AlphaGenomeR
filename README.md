<!-- HERO -->
<p align="center">
  <img src="https://github.com/user-attachments/assets/6cfcde71-c013-487f-8970-0879924088a6" width="900"/>
</p>

<h1 align="center">AlphaGenomeR</h1>

<p align="center">
  <b>High-Resolution Functional Genomic Predictions — Directly in R</b>
</p>

<p align="center">
  <a href="https://github.com/Bioconductor/Contributions/issues/4256">
    <img src="https://img.shields.io/badge/Bioconductor-Submission-blue.svg"/>
  </a>
  <a href="https://opensource.org/licenses/Apache-2.0">
    <img src="https://img.shields.io/badge/License-Apache%202.0-orange.svg"/>
  </a>
  <a href="https://mintlify.wiki/BDB-Genomics/AlphaGenomeR">
    <img src="https://img.shields.io/badge/docs-mintlify-6366f1?logo=mintlify&logoColor=white"/>
  </a>
</p>

<p align="center">
  <img src="assets/architecture_diagram.svg" alt="AlphaGenomeR Architecture" width="860" />
</p>

<p align="center">
  <sub>Bridging state-of-the-art deep learning genomics with Bioconductor-native workflows</sub>
</p>

---

<!-- QUICK START -->
<h2 align="center">⚡ Try in 60 Seconds</h2>

<pre><code class="language-r">
install.packages("devtools")
devtools::install_github("BDB-Genomics/AlphaGenomeR")

library(AlphaGenomeR)

results <- alphagenome_query(
  access_token = "YOUR_API_KEY",
  genomic_region = "chr17:42560601-43609177",
  ontology_terms = "UBERON:0002048"
)

alphagenome_get_rna_seq(results)
</code></pre>

<p align="center"><i>From genomic coordinates → multimodal predictions in seconds.</i></p>

---

<!-- VALUE -->
<h2>💡 Design & Features</h2>

<p align="center">
  <img src="assets/readme_animation.svg" alt="AlphaGenomeR Features" width="820" />
</p>

---

<!-- STATUS -->
<h2>📌 Project Status</h2>

<ul>
  <li>🚧 Bioconductor submission (v0.99.0)</li>
  <li>🧪 Validated on real AlphaGenome API outputs</li>
  <li>🔬 Actively developed</li>
</ul>

---

<!-- OVERVIEW -->
<h2>Overview</h2>

<p>
<b>AlphaGenomeR</b> enables high-resolution functional genomic predictions across large genomic regions using the AlphaGenome model.
</p>

<p>
It bridges the official gRPC-based Python SDK into R, allowing seamless integration with Bioconductor pipelines while maintaining performance and reproducibility.
</p>

---

<!-- WORKFLOW -->
<h2>🧪 Typical Workflow</h2>

<ol>
  <li>Query genomic region</li>
  <li>Retrieve predictions (RNA, ATAC, DNase, etc.)</li>
  <li>Convert to R-native structures</li>
  <li>Visualize signals</li>
  <li>Integrate into downstream analysis</li>
</ol>

---

<!-- ATLAS -->
<h2>📊 Multimodal Genomic Atlas</h2>

<p align="center">
  <img src="man/figures/modality_atlas.png" width="1000">
</p>

<p align="center"><i>Example: MYC locus multimodal prediction landscape</i></p>

---

<!-- GALLERY -->
<h2>🔬 Modality Gallery</h2>

<h3>RNA-seq</h3>
<img src="man/figures/gallery/res_rna.png">

<h3>ATAC-seq</h3>
<img src="man/figures/gallery/res_atac.png">

<h3>DNase-seq</h3>
<img src="man/figures/gallery/res_dnase.png">

<h3>CAGE</h3>
<img src="man/figures/gallery/res_cage.png">

<h3>Histone Modifications</h3>
<img src="man/figures/gallery/res_histone.png">

<h3>Splicing</h3>

<p align="center">
  <img src="man/figures/gallery/res_splice_sites.png" width="45%">
  <img src="man/figures/gallery/res_splice_usage.png" width="45%">
</p>

---

<!-- TECH -->
<h2>⚙️ Technical Specifications</h2>

<ul>
  <li><b>Resolution:</b> Single-base (most tracks), 128bp bins</li>
  <li><b>Backend:</b> gRPC streaming via reticulate</li>
  <li><b>Ontology:</b> UBERON & CL integration</li>
  <li><b>Compatible with:</b> GenomicRanges, DESeq2, ggplot2</li>
</ul>

---

<!-- INSTALL -->
<h2>📦 Installation</h2>

<h3>Prerequisites</h3>

<pre><code>pip install alphagenome</code></pre>

<h3>R Package</h3>
Once the package is accepted into Bioconductor, install it using:
```r
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("AlphaGenomeR")
```

For the development version from GitHub:
```r
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("BDB-Genomics/AlphaGenomeR")
```

---

<!-- CITATION -->
<h2>📜 Citation</h2>

<p>If you use AlphaGenomeR, please cite:</p>

<ul>
  <li><b>AlphaGenomeR</b> (R package)</li>
  <li><b>AlphaGenome Model</b> (Nature, 2026)</li>
</ul>

<p><code>citation("AlphaGenomeR")</code></p>

---

**Developed by Himanshu Bhandary**
