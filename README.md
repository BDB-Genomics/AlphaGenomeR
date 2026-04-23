<p align="center">
  <img width="900" alt="AlphaGenomeR Banner" src="https://github.com/user-attachments/assets/6cfcde71-c013-487f-8970-0879924088a6" />
</p>

<p align="center">
  <b>High-Resolution R Interface for Functional Genomic Predictions</b>
</p>

<p align="center">
  <a href="https://github.com/Bioconductor/Contributions/issues/4256">
    <img src="https://img.shields.io/badge/Bioconductor-Submission-blue.svg" />
  </a>
  <a href="https://opensource.org/licenses/Apache-2.0">
    <img src="https://img.shields.io/badge/License-Apache%202.0-orange.svg" />
  </a>
  <a href="https://mintlify.wiki/BDB-Genomics/AlphaGenomeR">
    <img src="https://img.shields.io/badge/docs-mintlify-6366f1?logo=mintlify&logoColor=white" />
  </a>
</p>

---

<h2 align="center">🚀 Try in 60 Seconds</h2>

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

<p align="center">
From raw genomic region → multimodal predictions in seconds.
</p>

---

<h2>Overview</h2>

<p>
<b>AlphaGenomeR</b> brings <b>state-of-the-art AlphaGenome predictions into R</b>, enabling multimodal functional genomic analysis at single-base resolution across large genomic regions.
</p>

<p>
It bridges the official gRPC-based Python SDK with Bioconductor-native workflows, making advanced deep learning predictions directly accessible to R users.
</p>

---

<h2>💡 Why AlphaGenomeR?</h2>

<ul>
  <li>🧬 Direct access to AlphaGenome predictions in R</li>
  <li>⚡ No Python workflow management required</li>
  <li>🔬 Single-base resolution across 11+ modalities</li>
  <li>📊 Native Bioconductor compatibility</li>
  <li>🚀 Designed for real research workflows</li>
</ul>

---

<h2>📌 Status</h2>

<ul>
  <li>🚧 Bioconductor submission (v0.99.0)</li>
  <li>🧪 Tested on real AlphaGenome API outputs</li>
  <li>🔬 Actively developed</li>
</ul>

---

<h2>Core Functions and Biological Modalities</h2>

<p>
AlphaGenomeR provides specialized extractors for 11 distinct biological modalities. The figure below demonstrates a <b>Multimodal Genomic Atlas</b> generated for the <i>MYC</i> locus.
</p>

<p align="center">
  <img src="man/figures/modality_atlas.png" width="1000">
</p>

---

<h2>🧪 Typical Workflow</h2>

<ol>
  <li>Query a genomic region</li>
  <li>Extract modality (RNA-seq, ATAC, DNase, etc.)</li>
  <li>Convert to R-native structures</li>
  <li>Visualize with ggplot2</li>
  <li>Integrate with downstream analysis</li>
</ol>

<p>
AlphaGenomeR fits directly into existing Bioconductor pipelines.
</p>

---

<h2>High-Resolution Modality Gallery</h2>

<p>
Real predictions retrieved for the <i>MYC</i> locus (chr8:127.7Mb).
</p>

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

<h2>Technical Specifications</h2>

<ul>
  <li><b>Resolution:</b> Single-base (most tracks), 128bp (epigenetic marks)</li>
  <li><b>Architecture:</b> gRPC streaming via reticulate</li>
  <li><b>Ontology:</b> UBERON & CL support</li>
  <li><b>Integration:</b> GenomicRanges, DESeq2, ggplot2</li>
</ul>

---

<h2>Installation</h2>

<h3>Prerequisites</h3>

<pre><code>
pip install alphagenome
</code></pre>

<h3>R Package</h3>

<pre><code class="language-r">
if (!require("devtools")) install.packages("devtools")
devtools::install_github("BDB-Genomics/AlphaGenomeR")
</code></pre>

---

<h2>Quick Start</h2>

<pre><code class="language-r">
library(AlphaGenomeR)

results <- alphagenome_query(
  access_token = "YOUR_API_KEY",
  genomic_region = "chr17:42560601-43609177",
  ontology_terms = "UBERON:0002048"
)

rna_data <- alphagenome_get_rna_seq(results)
head(rna_data$values)
</code></pre>

---

<h2>📜 Citation</h2>

<p>If you use AlphaGenomeR, please cite:</p>

<ol>
  <li><b>AlphaGenomeR</b> (R package)</li>
  <li><b>AlphaGenome Model</b> (<i>Nature</i>, 2026)</li>
</ol>

<p>Run <code>citation("AlphaGenomeR")</code> for BibTeX.</p>

---

<h2>🚀 Get Started</h2>

<p>
AlphaGenomeR brings cutting-edge genomic prediction models directly into your R workflow.
</p>

<p>
👉 Try it on your favorite locus.<br>
👉 Explore signals you couldn’t access before.<br>
👉 Build something new.
</p>
