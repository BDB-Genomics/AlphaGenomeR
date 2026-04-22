library(AlphaGenomeR)
library(testthat)

test_that("Alphagenome query returns a list", {

  mock_response <- list(
    atac = list(
      values   = matrix(rnorm(100), nrow = 10),
      metadata = data.frame(name = "test_atac", strand = "+")
    )
  )

  # Mock reticulate functions
  local_mocked_bindings(
    import = function(...) list(
      create = function(...) list(
        predict_interval = function(...) mock_response
      ),
      Interval = function(...) "mock_interval"
    ),
    py_module_available = function(...) TRUE,
    py_to_r = function(x) x,
    .package = "reticulate"
  )

  result <- alphagenome_query(
    access_token = "fake_api_key",
    genomic_region = "chr1:1000-2000"
  )

  expect_true(length(result) > 0)
  expect_type(result, "list")
  expect_true("atac" %in% names(result))

})
