library(testthat)

test_that("alphagenome_query validates missing access_token", {
  skip_on_cran()
  skip_if_offline()
  
  expect_error(
    alphagenome_query(
      access_token = "",
      genomic_region = "chr17:42560601-43609177",
      requested_outputs = "RNA_SEQ"
    ),
    "access_token"
  )
})

test_that("alphagenome_query validates genomic_region format", {
  skip_on_cran()
  
  expect_error(
    alphagenome_query(
      access_token = "dummy",
      genomic_region = "not_a_region",
      requested_outputs = "RNA_SEQ"
    ),
    "genomic_region"
  )
})

test_that("alphagenome_query validates start < end", {
  skip_on_cran()
  
  expect_error(
    alphagenome_query(
      access_token = "dummy",
      genomic_region = "chr17:50000000-40000000",
      requested_outputs = "RNA_SEQ"
    ),
    "start.*end|end.*start"
  )
})

test_that("alphagenome_query validates region length <= 1 Mb", {
  skip_on_cran()
  
  expect_error(
    alphagenome_query(
      access_token = "dummy",
      genomic_region = "chr17:1-2000000",
      requested_outputs = "RNA_SEQ"
    ),
    "1 Mb|1000000|too large"
  )
})

test_that("alphagenome_query validates requested_outputs", {
  skip_on_cran()
  
  expect_error(
    alphagenome_query(
      access_token = "dummy",
      genomic_region = "chr17:42560601-43609177",
      requested_outputs = "INVALID_TYPE"
    ),
    "requested_outputs"
  )
})

test_that("alphagenome_query fails gracefully when Python module unavailable", {
  skip_on_cran()
  
  # Mock reticulate::py_module_available to return FALSE
  local_mocked_bindings(
    py_module_available = function(...) FALSE,
    .package = "reticulate"
  )
  
  expect_error(
    alphagenome_query(
      access_token = "dummy",
      genomic_region = "chr17:42560601-43609177",
      requested_outputs = "RNA_SEQ"
    ),
    "alphagenome.*Python|Python.*alphagenome|not available"
  )
})
