#' AlphaGenomeR: R Interface to Google DeepMind's AlphaGenome API
#'
#' AlphaGenomeR provides an R interface to the Google DeepMind AlphaGenome
#' API for high-resolution functional genomic predictions. It bridges the
#' official Python SDK into Bioconductor-friendly R workflows via
#' \code{reticulate}, returning native R objects (matrices, data frames)
#' for downstream analysis.
#'
#' The package supports 11 prediction modalities: RNA-seq, ATAC-seq,
#' DNase-seq, CAGE, TF ChIP-seq, histone ChIP-seq, PRO-cap, splicing
#' (sites, junctions, usage), and 3D genome contact maps.
#'
#' @details
#' A dedicated Python environment with the \code{alphagenome} package
#' (>= 0.6.1) is required. See the vignette for installation instructions.
#'
#' @section Environment variables:
#' \describe{
#'   \item{\code{RETICULATE_PYTHON}}{Path to the Python executable in the
#'     dedicated AlphaGenomeR Conda environment. Set before loading the
#'     package.}
#' }
#'
#' @references
#' \itemize{
#'   \item AlphaGenomeR package: \doi{10.5281/zenodo.19774275}
#'   \item AlphaGenome model: (add Nature article when available)
#' }
#'
#' @docType package
#' @name AlphaGenomeR-package
#' @aliases AlphaGenomeR
NULL
