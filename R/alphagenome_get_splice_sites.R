#' Extract SPLICE_SITES data from the AlphaGenome API response
#'
#' @param response_body The response body from the AlphaGenome API
#' @return A list with 'values' (numeric matrix) and 'metadata' (data.frame)
#' @importFrom reticulate py_to_r
#' @export
#'
#' @examples
#' \dontrun{
#' response <- alphagenome_query(access_token = "YOUR_API_KEY", genomic_region = "chr1:1000000-1001000")
#' data <- alphagenome_get_splice_sites(response)
#' }
alphagenome_get_splice_sites <- function(response_body) {

  # EXTRACT THE SPLICE_SITES DATA
  track_data <- response_body$splice_sites

  if (is.null(track_data)) return(NULL)

  list(
    values   = reticulate::py_to_r(track_data$values),
    metadata = reticulate::py_to_r(track_data$metadata)
  )

}
