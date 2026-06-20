#' Query the AlphaGenome API
#'
#' Query a genomic interval and return multimodal predictions (RNA, ATAC, CAGE, etc.).
#'
#' The function performs input validation in the following order:
#' 1) `api_key` presence, 2) `requested_outputs` validity, 3) `genomic_region`
#' format and coordinate checks, and 4) availability of the Python package
#' `alphagenome` via reticulate. Input validation is performed before the
#' Python availability check so that invalid parameters are caught first.
#'
#' @param api_key Character. API key for the AlphaGenome API. Must be a
#' non-empty string; otherwise the function errors with
#' "API key is not provided".
#' @param genomic_region Character. Genomic region to query in the form
#' "chr:start-end" (for example, "chr17:42560601-43560601"). The context
#' window (end - start) must be <= 1,000,000 (1 MB).
#' @param organism Character. Organism enum name to use on the Python side.
#' Default: "HOMO_SAPIENS".
#' @param requested_outputs Character vector. One or more output modality names
#' requested from the API. Valid values include: "RNA_SEQ", "ATAC",
#' "CAGE", "CHIP_HISTONE", "CHIP_TF", "DNASE", "PROCAP",
#' "SPLICE_SITES", "SPLICE_SITE_USAGE", "SPLICE_JUNCTIONS",
#' "CONTACT_MAPS". An error is raised if any entry is not supported.
#' @param ontology_terms Character vector or NULL. Optional ontology
#' (tissue/cell-type) terms, e.g. "UBERON:0002048".
#' @return A named list of modality predictions with elements such as
#' `rna_seq`, `atac`, `cage`, etc., plus a `citation_agreement` entry.
#' @details
#' - The function relies on the Python package `alphagenome` accessed via the
#' reticulate bridge. If the Python package is not available the function
#' errors with: "The Python module 'alphagenome' is not available. Install it
#' (e.g. pip install alphagenome) or ensure reticulate is configured to use
#' the correct Python environment.".
#' - Tests may mock `reticulate::py_module_available()` to simulate
#' Python-present/absent states; ensure the validation ordering described
#' above is preserved so unit tests behave deterministically.
#' @section Citation Agreement:
#' By using this function you agree to cite the AlphaGenomeR package in any
#' resulting publications. Run `citation("AlphaGenomeR")` for the formal
#' reference.
#' @seealso reticulate
#' @importFrom reticulate py_module_available import py_to_r
#' @importFrom utils packageVersion
#' @export
#'
#' @examples
#' \dontrun{
#' response <- alphagenome_query(
#'   api_key = "YOUR_API_KEY",
#'   genomic_region = "chr17:42560601-43560601",
#'   ontology_terms = "UBERON:0002048",
#'   requested_outputs = c("RNA_SEQ", "ATAC")
#' )
#' rna <- alphagenome_get_rna_seq(response)
#' atac <- alphagenome_get_atac(response)
#' }

alphagenome_query <- function(api_key,
                              genomic_region,
                              organism = "HOMO_SAPIENS",
                              requested_outputs = c("RNA_SEQ", "ATAC", "CAGE"),
                              ontology_terms = NULL) {
  # 1. Validate api_key
  if (!is.character(api_key) || length(api_key) != 1 || !nzchar(api_key)) {
    stop("API key is not provided")
  }

  # 2. Validate requested_outputs
  valid_outputs <- c("RNA_SEQ", "ATAC", "CAGE", "CHIP_HISTONE", "CHIP_TF",
                     "DNASE", "PROCAP", "SPLICE_SITES", "SPLICE_SITE_USAGE",
                     "SPLICE_JUNCTIONS", "CONTACT_MAPS")
  if (!is.character(requested_outputs) || !all(requested_outputs %in% valid_outputs)) {
    stop("requested_outputs must be one of: ", paste(valid_outputs, collapse = ", "))
  }

  # 3. Validate genomic_region format and coordinates
  parts <- strsplit(genomic_region, "[:-]+")[[1]]
  if (length(parts) != 3) {
    stop("Genomic region must adhere to format 'chr:start-end'")
  }

  chrom <- parts[1]
  start <- as.integer(parts[2])
  end <- as.integer(parts[3])

  if (is.na(start) || is.na(end)) {
    stop("Genomic region must adhere to format 'chr:start-end'")
  }
  if (start < 1L) {
    stop("start must be >= 1")
  }
  if (end <= start) {
    stop("end must be greater than start")
  }
  if ((end - start) > 1000000L) {
    stop("context window must be <= 1 MB")
  }
  valid_chroms <- paste0("chr", c(1:22, "X", "Y", "M"))
  if (!(chrom %in% valid_chroms)) {
    stop("invalid chromosome: must be one of ", paste(valid_chroms, collapse = ", "))
  }

  # 4. Validate ontology_terms
  if (!is.null(ontology_terms)) {
    if (!is.character(ontology_terms)) {
      stop("ontology_terms must be a character vector or NULL")
    }
  }

  # 5. Check Python module availability (after all input validation)
  if (!reticulate::py_module_available("alphagenome")) {
    stop("The Python module 'alphagenome' is not available. Install it (e.g. pip install alphagenome) or ensure reticulate is configured to use the correct Python environment.")
  }

  ag_dna <- reticulate::import("alphagenome.models.dna_client")
  ag_genome <- reticulate::import("alphagenome.data.genome")

  # MAP ORGANISM ENUM
  py_organism <- tryCatch({
    ag_dna$Organism[[organism]]
  }, error = function(e) {
    stop("Invalid organism. Available: ", paste(names(ag_dna$Organism), collapse = ", "))
  })

  # MAP OUTPUT TYPES ENUMS
  py_outputs <- list()
  if (!is.null(requested_outputs)) {
    py_outputs <- lapply(requested_outputs, function(out) {
      tryCatch({
        ag_dna$OutputType[[out]]
      }, error = function(e) {
        stop("Invalid output type: ", out, ". Available: ", paste(names(ag_dna$OutputType), collapse = ", "))
      })
    })
  }

  # INITIALIZE CLIENT
  client <- ag_dna$create(api_key = api_key)

  py_start <- start - 1L
  py_end <- as.integer(end) # R's fully-closed `end` corresponds directly to Python's half-open `end`

  # CREATE INTERVAL
  interval <- ag_genome$Interval(chromosome = chrom, start = py_start, end = py_end)

  # EXECUTE PREDICTION (single call inside tryCatch)
  ont_terms <- if (is.null(ontology_terms)) list() else as.list(ontology_terms)

  results <- tryCatch({
    client$predict_interval(
      interval = interval,
      organism = py_organism,
      requested_outputs = py_outputs,
      ontology_terms = ont_terms
    )
  }, error = function(e) {
    stop("API response failed: ", conditionMessage(e))
  })

  # MANUALLY CONSTRUCT R LIST
  results_r <- list()

  output_map <- c(
    "RNA_SEQ" = "rna_seq",
    "ATAC" = "atac",
    "CAGE" = "cage",
    "CHIP_HISTONE" = "chip_histone",
    "CHIP_TF" = "chip_tf",
    "DNASE" = "dnase",
    "PROCAP" = "procap",
    "SPLICE_SITES" = "splice_sites",
    "SPLICE_SITE_USAGE" = "splice_site_usage",
    "SPLICE_JUNCTIONS" = "splice_junctions",
    "CONTACT_MAPS" = "contact_maps"
  )

  for (req in requested_outputs) {
    attr_name <- output_map[[req]]
    if (!is.null(results[[attr_name]])) {
      results_r[[attr_name]] <- reticulate::py_to_r(results[[attr_name]])
    }
  }

  # ATTACH MANDATORY CITATION INFO
  pkg_version <- as.character(packageVersion("AlphaGenomeR"))
  current_year <- format(Sys.Date(), "%Y")
  results_r$citation_agreement <- paste0(
    "Himanshu (", current_year, "). AlphaGenomeR: An R/Bioconductor Interface ",
    "for High-Resolution Genomic Predictions. R package version ", pkg_version,
    ". https://github.com/BDB-Genomics/AlphaGenomeR"
  )

  results_r
}
