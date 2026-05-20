test_that("audit_report returns a data frame with correct columns", {
  df <- data.frame(
    revenue  = c(100, 200, 150, 10000, NA, 130),
    category = c("A", "A", "B", "B", "C", "C")
  )
  result <- audit_report(df)
  expect_s3_class(result, "data.frame")
  expect_named(result, c("column", "type", "n_missing", "pct_missing", "n_duplicates", "n_outliers"))
})

test_that("audit_report has one row per column in input data frame", {
  df <- data.frame(
    revenue  = c(100, 200, 150),
    expenses = c(50, 80, 70),
    category = c("A", "B", "C")
  )
  result <- audit_report(df)
  expect_equal(nrow(result), ncol(df))
})

test_that("audit_report correctly counts missing values", {
  df <- data.frame(revenue = c(100, NA, 150, NA, 130))
  result <- audit_report(df)
  expect_equal(result$n_missing[1], 2)
  expect_equal(result$pct_missing[1], 40)
})

test_that("audit_report correctly counts outliers for numeric columns", {
  df <- data.frame(revenue = c(100, 200, 150, 10000, 130, 170))
  result <- audit_report(df)
  expect_equal(result$n_outliers[1], 1)
})

test_that("audit_report returns NA for n_outliers on non-numeric columns", {
  df <- data.frame(category = c("A", "A", "B", "B", "C"))
  result <- audit_report(df)
  expect_true(is.na(result$n_outliers[1]))
})

test_that("audit_report works with zscore method", {
  df <- data.frame(revenue = c(100, 200, 150, 10000, 130, 170))
  result <- audit_report(df, outlier_method = "zscore", threshold = 2)
  expect_s3_class(result, "data.frame")
})

test_that("audit_report rejects non-data-frame input", {
  expect_error(audit_report(c(100, 200, 300)))
})
