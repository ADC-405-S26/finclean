test_that("normalize_accounts handles basic revenue variations", {
  result <- normalize_accounts(c("Rev.", "REVENUE", "revenue", "sales"))
  expect_equal(result, c("Revenue", "Revenue", "Revenue", "Revenue"))
})

test_that("normalize_accounts handles COGS and net income variations", {
  result <- normalize_accounts(c("COGS", "cost of goods sold", "Net Inc.", "net income"))
  expect_equal(result, c("COGS", "COGS", "Net Income", "Net Income"))
})

test_that("normalize_accounts returns NA with warning for unmatched values when na_on_fail = TRUE", {
  expect_warning(
    result <- normalize_accounts(c("Revenue", "unknown_account")),
    "Could not match"
  )
  expect_true(is.na(result[2]))
})

test_that("normalize_accounts returns value unchanged when na_on_fail = FALSE", {
  result <- normalize_accounts(c("Revenue", "unknown_account"), na_on_fail = FALSE)
  expect_equal(result[2], "unknown_account")
})

test_that("normalize_accounts accepts and uses a custom map", {
  my_map <- c("Sales" = "^(sales|revenue|rev)$")
  result <- normalize_accounts(c("rev", "Sales", "revenue"), custom_map = my_map)
  expect_equal(result, c("Sales", "Sales", "Sales"))
})

test_that("normalize_accounts rejects non-character input", {
  expect_error(normalize_accounts(c(1, 2, 3)))
})
