test_that("standardize_fiscal_year handles FY short and long formats", {
  result <- standardize_fiscal_year(c("FY23", "FY2023"))
  expect_equal(result, c("FY2023", "FY2023"))
})

test_that("standardize_fiscal_year handles plain 4-digit year", {
  result <- standardize_fiscal_year(c("2023", "2024"))
  expect_equal(result, c("FY2023", "FY2024"))
})

test_that("standardize_fiscal_year handles Q1 2023 and 2023-Q1 formats", {
  result <- standardize_fiscal_year(c("Q1 2023", "2023-Q1"))
  expect_equal(result, c("FY2023-Q1", "FY2023-Q1"))
})

test_that("standardize_fiscal_year handles Q1-2023 and Q1FY23 formats", {
  result <- standardize_fiscal_year(c("Q1-2023", "Q1FY23"))
  expect_equal(result, c("FY2023-Q1", "FY2023-Q1"))
})

test_that("standardize_fiscal_year returns NA with warning for unrecognized input", {
  expect_warning(
    result <- standardize_fiscal_year(c("FY2023", "bad_input")),
    "Could not standardize"
  )
  expect_true(is.na(result[2]))
})

test_that("standardize_fiscal_year respects custom prefix", {
  result <- standardize_fiscal_year(c("2023", "FY23"), prefix = "AF")
  expect_equal(result, c("AF2023", "AF2023"))
})

test_that("standardize_fiscal_year rejects non-character input", {
  expect_error(standardize_fiscal_year(c(2023, 2024)))
})
