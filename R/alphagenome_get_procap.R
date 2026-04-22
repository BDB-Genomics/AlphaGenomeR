#' Extract PROCAP data from the AlphaGenome API response
#'
#' @param response_body The response body from the AlphaGenome API
#' @return A list with 'values' (numeric matrix) and 'metadata' (data.frame)
#' @export
alphagenome_get_procap <- function(response_body) {

  # EXTRACT THE PROCAP DATA
  track_data <- reticulate::py_get_attr(response_body, "procap")
  
  if (inherits(track_data, "python.builtin.NoneType")) return(NULL)

  return(list(
    values   = reticulate::py_to_r(reticulate::py_get_attr(track_data, "values")),
    metadata = reticulate::py_to_r(reticulate::py_get_attr(track_data, "metadata"))
  ))

}
