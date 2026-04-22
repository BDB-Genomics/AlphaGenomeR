#' Extract CONTACT_MAPS data from the AlphaGenome API response
#'
#' @param response_body The response body from the AlphaGenome API
#' @return A list with 'values' (numeric matrix) and 'metadata' (data.frame)
#' @importFrom reticulate py_to_r
#' @export
#'
#' @examples
#' \dontrun{
#' response <- alphagenome_query(access_token = "YOUR_API_KEY", genomic_region = "chr1:1000000-1001000")
#' data <- alphagenome_get_contact_maps(response)
#' }
alphagenome_get_contact_maps <- function(response_body) {

  # EXTRACT THE CONTACT MAP DATA
  track_data <- response_body$contact_maps

  if (is.null(track_data)) return(NULL)

  list(
    values   = reticulate::py_to_r(track_data$values),
    metadata = reticulate::py_to_r(track_data$metadata)
  )

}
