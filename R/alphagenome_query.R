#' Query the AlphaGenome API
#'
#' Query a genomic interval and return multimodal predictions (RNA, ATAC, CAGE, etc.)
#'
#' @param access_token Character. API key for the AlphaGenome API. This must be provided
#'   (non-empty); the function will error with \"API key is not provided\" if missing.
#' @param genomic_region Character. Genomic region to query in the form
#'   \"chr:start-end\" (e.g., \"chr17:42560601-43560601\"). The context window (end - start)
#'   must be <= 1,000,000 (1 MB).
#' @param organism Character. Organism enum name to use on the Python side. Default \"HOMO_SAPIENS\".
#' @param requested_outputs Character vector. One or more output modality names requested from the API.
#'   Valid values include: \"RNA_SEQ\", \"ATAC\", \"CAGE\", \"CHIP_HISTONE\", \"CHIP_TF\",
#'   \"DNASE\", \"PROCAP\", \"SPLICE_SITES\", \"SPLICE_SITE_USAGE\", \"SPLICE_JUNCTIONS\", \"CONTACT_MAPS\".
#'   An error will be raised if any entry is not a supported output type.
#' @param ontology_terms Character vector or NULL. Optional ontology (tissue/cell-type) terms (e.g., \"UBERON:0002048\").
#' @return A named list of modality predictions (elements such as `rna_seq`, `atac`, `cage`, etc.)
#' @details
#' - The function relies on the Python package `alphagenome` accessed via the reticulate bridge.
#'   If the Python package is not available the function errors with a message instructing
#'   the user to `pip install alphagenome`. Tests may mock `reticulate::py_module_available`.
#' - Input validation is performed in the following order: access token presence, validity of
#'   requested_outputs, Python module availability, genomic_region format and size constraints.
#'   This ordering ensures that tests which expect errors for requested_outputs or Python
#'   availability are reached before region-length checks.
#' @section Citation Agreement:
#' By using this function, you agree to cite the AlphaGenomeR package in any resulting publications.
#' Run `citation(\"AlphaGenomeR\")` for the formal reference.
#' @importFrom reticulate py_module_available import py_to_r
#' @export
#'
#' @examples
#' \dontrun{
#' results <- alphagenome_query(
#'   access_token = Sys.getenv("ALPHAGENOME_API_KEY"),
#'   genomic_region = "chr17:42560601-43560601",  # <= 1,000,000 bp
#'   requested_outputs = c("RNA_SEQ")
#' )
#' str(results)
#' }

alphagenome_query <- function(access_token, 
                              genomic_region, 
                              organism = "HOMO_SAPIENS",
                              requested_outputs = c("RNA_SEQ", "ATAC", "CAGE"),
                              ontology_terms = NULL) {

  # 0. API key must be provided (test expects this message)
  stopifnot(
    "API key is not provided" = nzchar(access_token)
  )

  # 1. Validate requested_outputs early so tests for invalid types run first
  valid_outputs <- c("RNA_SEQ", "ATAC", "CAGE", "CHIP_HISTONE", "CHIP_TF", 
                     "DNASE", "PROCAP", "SPLICE_SITES", "SPLICE_SITE_USAGE", 
                     "SPLICE_JUNCTIONS", "CONTACT_MAPS")
  stopifnot(
    "requested_outputs" = all(requested_outputs %in% valid_outputs)
  )

  # 2. Check Python module availability early so tests mocking py_module_available hit it
  if (!reticulate::py_module_available("alphagenome")) {
    stop("The 'alphagenome' Python package is not installed. Please run: pip install alphagenome")
  }

  # 3. Validate genomic_region format before parsing
  parts <- strsplit(genomic_region, "[:-]+")[[1]]
  stopifnot(
    "Genomic region must adhere to format 'chr:start-end'" = length(parts) == 3
  )

  # 4. Parse and validate coordinates
  chrom <- parts[1]
  start <- as.integer(parts[2])
  end <- as.integer(parts[3])

  stopifnot(
    "start must be >= 1" = start >= 1L,
    "end must be greater than start" = end > start,
    "context window must be <= 1 MB" = end - start <= 1000000L,
    "invalid chromosome" = chrom %in% paste0("chr", c(1:22, "X", "Y", "M"))
  )
  
  # INITIALIZE PYTHON BRIDGE
  if (!reticulate::py_module_available("alphagenome")) {
    stop("The 'alphagenome' Python package is not installed. Please run: pip install alphagenome")
  }

  ag_dna <- reticulate::import("alphagenome.models.dna_client")
  ag_genome <- reticulate::import("alphagenome.data.genome")

  # MAP ORGANISM ENUM
  py_organism <- tryCatch({
    ag_dna$Organism[[organism]]
  }, error = function(e) {
    stop(paste("Invalid organism. Available:", paste(names(ag_dna$Organism), collapse=", ")))
  })

  # MAP OUTPUT TYPES ENUMS
  py_outputs <- list()
  if (!is.null(requested_outputs)) {
    py_outputs <- lapply(requested_outputs, function(out) {
      tryCatch({
        ag_dna$OutputType[[out]]
      }, error = function(e) {
        stop(paste("Invalid output type:", out, ". Available:", paste(names(ag_dna$OutputType), collapse=", ")))
      })
    })
  }

  # PARSE REGION
  parts <- strsplit(genomic_region, "[:-]")[[1]]
  chrom <- parts[1]
  start <- as.integer(parts[2])
  end <- as.integer(parts[3])

  # INITIALIZE CLIENT
  client <- ag_dna$create(api_key = access_token)

  # CREATE INTERVAL
  interval <- ag_genome$Interval(chromosome = chrom, start = start, end = end)

  # EXECUTE PREDICTION
  ont_terms <- if (is.null(ontology_terms)) list() else as.list(ontology_terms)

  results <- client$predict_interval(
    interval = interval,
    organism = py_organism,
    requested_outputs = py_outputs,
    ontology_terms = ont_terms
  )

  tryCatch({
    results <- client$predict_interval(
      interval = interval,
      organism = py_organism,
      requested_outputs = py_outputs,
      ontology_terms = ont_terms
    )     
  }, error = function(e) {
    stop("API response failed.")  
  })

  # MANUALLY CONSTRUCT R LIST TO BYPASS FROZEN DATACLASS RESTRICTIONS
  results_r <- list(
    atac              = reticulate::py_to_r(results$atac),
    cage              = reticulate::py_to_r(results$cage),
    dnase             = reticulate::py_to_r(results$dnase),
    rna_seq           = reticulate::py_to_r(results$rna_seq),
    chip_histone      = reticulate::py_to_r(results$chip_histone),
    chip_tf           = reticulate::py_to_r(results$chip_tf),
    splice_sites      = reticulate::py_to_r(results$splice_sites),
    splice_site_usage = reticulate::py_to_r(results$splice_site_usage),
    splice_junctions  = reticulate::py_to_r(results$splice_junctions),
    contact_maps      = reticulate::py_to_r(results$contact_maps),
    procap            = reticulate::py_to_r(results$procap)
  )
  
  # ATTACH MANDATORY CITATION INFO
  results_r$citation_agreement <- "Himanshu (2026). AlphaGenomeR: An R/Bioconductor Interface for High-Resolution Genomic Predictions. R package version 0.99.0, https://github.com/BDB-Genomics/AlphaGenomeR"
  
  return(results_r)

}
