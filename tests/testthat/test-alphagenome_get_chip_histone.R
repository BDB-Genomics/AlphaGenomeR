library(AlphaGenomeR)
library(testthat)

test_that("alphagenome_get_chip_histone extracts chip_histone data from response", {

  mock_response <- list(
    chip_histone = list(
      values    = matrix(rnorm(100), nrow = 10),
      metadata  = data.frame(name = "test_chip_histone", strand = "+")
    )
  )

  result <- alphagenome_get_chip_histone(mock_response)

  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_true("chip_histone" %in% names(mock_response))
  expect_true(all(c("values", "metadata") %in% names(result)))
  expect_true(length(result$values) > 0)
  expect_true(is.matrix(result$values))
  expect_type(result$values, "double")
  expect_true(is.data.frame(result$metadata))
  expect_true(nrow(result$metadata) > 0)
  expect_true(all(c("name", "strand") %in% colnames(result$metadata)))

})
