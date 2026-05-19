test_that("parse_currency handles basic currency symbols", {
  result <- parse_currency(c("$1,234.56", "€500", "£300"))
  expect_equal(result, c(1234.56, 500, 300))
})

test_that("parse_currency converts parentheses to negative numbers", {
  result <- parse_currency(c("(1,200)", "(75.00)"))
  expect_equal(result, c(-1200, -75))
})

test_that("parse_currency handles explicit negative signs", {
  result <- parse_currency(c("-$300.00", "-500"))
  expect_equal(result, c(-300, -500))
})

test_that("parse_currency returns NA with warning on bad input when na_on_fail = TRUE", {
  expect_warning(
    result <- parse_currency(c("$100", "bad_value", "$200")),
    "Could not parse"
  )
  expect_true(is.na(result[2]))
})

test_that("parse_currency stops with error on bad input when na_on_fail = FALSE", {
  expect_error(
    parse_currency(c("$100", "bad_value"), na_on_fail = FALSE),
    "Could not parse"
  )
})

test_that("parse_currency rejects non-character input", {
  expect_error(parse_currency(c(100, 200)))
})
