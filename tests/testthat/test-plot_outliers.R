test_that("plot_outliers returns a ggplot object", {
  df <- data.frame(revenue = c(100, 200, 150, 10000, 130, 170))
  result <- plot_outliers(df, column = "revenue")
  expect_s3_class(result, "ggplot")
})

test_that("plot_outliers works with zscore method and custom threshold", {
  df <- data.frame(revenue = c(100, 200, 150, 10000, 130, 170))
  result <- plot_outliers(df, column = "revenue", method = "zscore", threshold = 2)
  expect_s3_class(result, "ggplot")
})

test_that("plot_outliers works with a custom title", {
  df <- data.frame(revenue = c(100, 200, 150, 10000, 130, 170))
  result <- plot_outliers(df, column = "revenue", title = "My Custom Title")
  expect_equal(result$labels$title, "My Custom Title")
})

test_that("plot_outliers stops when column does not exist", {
  df <- data.frame(revenue = c(100, 200, 150))
  expect_error(
    plot_outliers(df, column = "nonexistent"),
    "not found in the data frame"
  )
})

test_that("plot_outliers stops when column is not numeric", {
  df <- data.frame(category = c("A", "B", "C"))
  expect_error(
    plot_outliers(df, column = "category"),
    "must be numeric"
  )
})

test_that("plot_outliers rejects non-data-frame input", {
  expect_error(plot_outliers(c(100, 200, 300), column = "revenue"))
})

test_that("plot_outliers rejects invalid method", {
  df <- data.frame(revenue = c(100, 200, 150))
  expect_error(plot_outliers(df, column = "revenue", method = "median"))
})
