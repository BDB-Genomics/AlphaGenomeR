library(AlphaGenomeR)
library(testthat)

test_that("alphagenome_get_contact_maps extracts contact_maps data from response", {

  mock_response <- list(
    contact_maps = list(
      values    = matrix(rnorm(100), nrow = 10),
      metadata  = data.frame(name = "test_contact_maps", strand = "+")
    )
  )

  result <- alphagenome_get_contact_maps(mock_response)

  expect_type(result, "list")
  expect_true(length(result) > 0)
  expect_true("contact_maps" %in% names(mock_response))
  expect_true(all(c("values", "metadata") %in% names(result)))
  expect_true(length(result$values) > 0)
  expect_true(is.matrix(result$values))
  expect_type(result$values, "double")
  expect_true(is.data.frame(result$metadata))
  expect_true(nrow(result$metadata) > 0)
  expect_true(all(c("name", "strand") %in% colnames(result$metadata)))

})
