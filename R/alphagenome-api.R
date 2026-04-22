#' Query the AlphaGenome API
#'
#' @param access_token API key for the AlphaGenome API
#' @param genomic_region Genomic region to query (e.g., "chr17:42560601-43609177")
#' @param organism Character string for organism. Default "HOMO_SAPIENS"
#' @param requested_outputs Character vector of modalities. Default: c("RNA_SEQ", "ATAC", "CAGE")
#' @param ontology_terms Character vector of tissue/cell type terms (e.g., "UBERON:0002048")
#' @return A list containing the multimodal predictions
#' @export
alphagenome_query <- function(access_token, 
                              genomic_region, 
                              organism = "HOMO_SAPIENS",
                              requested_outputs = c("RNA_SEQ", "ATAC", "CAGE"),
                              ontology_terms = NULL) {

  # INPUT VALIDATION
  if (missing(access_token)) {
    stop("API key is not provided.")
  }

  if (missing(genomic_region)) {
    stop("Genomic region is not provided.")
  }

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
  # Expected format "chr:start-end"
  parts <- strsplit(genomic_region, "[:-]")[[1]]
  if (length(parts) < 3) {
    stop("genomic_region must be in 'chr:start-end' format.")
  }
  
  chrom <- parts[1]
  start <- as.integer(parts[2])
  end <- as.integer(parts[3])

  # INITIALIZE CLIENT
  client <- ag_dna$create(api_key = access_token)

  # CREATE INTERVAL
  interval <- ag_genome$Interval(chromosome = chrom, start = start, end = end)

  # EXECUTE PREDICTION
  # Note: 1MB resolution is often required by the model
  ont_terms <- if (is.null(ontology_terms)) list() else as.list(ontology_terms)

  results <- client$predict_interval(
    interval = interval,
    organism = py_organism,
    requested_outputs = py_outputs,
    ontology_terms = ont_terms
  )

  # CONVERT TO R LIST
  return(reticulate::py_to_r(results))

}
