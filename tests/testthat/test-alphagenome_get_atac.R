library(AlphaGenomeR)
library(testthat)

test_that("alphagenome_get_atac extracts atac data from response", {

  mock_response <- list(
    atac = list(
      values    = matrix(rnorm(100), nrow = 10),
      metadata  = data.frame(name = "test_atac", strand = "+")
    )
  )

  result <- alphagenome_get_atac(mock_response)

  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_true("atac" %in% names(mock_response))
  expect_true(all(c("values", "metadata") %in% names(result)))
  expect_true(length(result$values) > 0)
  expect_true(is.matrix(result$values))
  expect_type(result$values, "double")
  expect_true(is.data.frame(result$metadata))
  expect_true(nrow(result$metadata) > 0)
  expect_true(all(c("name", "strand") %in% colnames(result$metadata)))

})
