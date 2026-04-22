#' Extract RNA_SEQ data from the AlphaGenome API response
#'
#' @param response_body The response body from the AlphaGenome API
#' @return A list with 'values' (numeric matrix) and 'metadata' (data.frame)
#' @importFrom reticulate py_to_r
#' @export
#'
#' @examples
#' \dontrun{
#' response <- alphagenome_query(access_token = "YOUR_API_KEY", genomic_region = "chr1:1000000-1001000")
#' data <- alphagenome_get_rna_seq(response)
#' }
alphagenome_get_rna_seq <- function(response_body) {

  # EXTRACT THE RNA_SEQ DATA
  track_data <- response_body$rna_seq

  if (is.null(track_data)) return(NULL)

  list(
    values   = reticulate::py_to_r(track_data$values),
    metadata = reticulate::py_to_r(track_data$metadata)
  )

}
