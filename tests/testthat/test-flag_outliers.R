test_that("flag_outliers returns a data frame with correct columns", {
  result <- flag_outliers(c(100, 200, 150, 10000, 130, 170))
  expect_s3_class(result, "data.frame")
  expect_named(result, c("value", "is_outlier"))
})

test_that("flag_outliers correctly flags outliers using IQR method", {
  result <- flag_outliers(c(100, 200, 150, 10000, 130, 170))
  expect_true(result$is_outlier[4])
  expect_false(result$is_outlier[1])
})

test_that("flag_outliers correctly flags outliers using zscore method", {
  result <- flag_outliers(c(10, 11, 12, 10, 11, 1000), method = "zscore", threshold = 2)
  expect_true(result$is_outlier[6])
  expect_false(result$is_outlier[1])
})
test_that("flag_outliers respects custom threshold", {
  result <- flag_outliers(c(100, 105, 98, 102, 99, 101), threshold = 100)
  expect_false(any(result$is_outlier, na.rm = TRUE))
})

test_that("flag_outliers handles NA values without error", {
  result <- flag_outliers(c(100, NA, 150, 10000, 130))
  expect_true(is.na(result$is_outlier[2]))
})

test_that("flag_outliers rejects non-numeric input", {
  expect_error(flag_outliers(c("100", "200", "10000")))
})

test_that("flag_outliers rejects invalid method", {
  expect_error(flag_outliers(c(100, 200, 300), method = "median"))
})
