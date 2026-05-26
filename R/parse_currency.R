#' Parse Currency Strings to Numeric
#'
#' Converts messy currency strings commonly found in financial data into clean
#' numeric values. Handles currency symbols, commas, spaces, and accounting-style
#' negative numbers written in parentheses.

#' @param x A character vector of currency strings to convert.
#'   Examples of supported formats: \code{"$1,234.56"}, \code{"€500"},
#'   \code{"(1,200)"}, \code{"-$300.00"}, \code{"1 000.50"}.
#' @param na_on_fail Logical. If \code{TRUE} (default), values that cannot be
#'   parsed will be returned as \code{NA} with a warning. If \code{FALSE}, the
#'   function will stop with an error on unparseable input.
#'
#' @returns A numeric vector of the same length as \code{x}, with currency
#'   formatting removed. Parentheses-style negatives like \code{"(500)"} are
#'   correctly converted to \code{-500}.
#' @export
#'
#' @examples
#' parse_currency(c("$1,234.56", "EUR500", "(1,200)", "-$300.00"))
parse_currency <- function(x, na_on_fail = TRUE) {
  checkmate::assert_character(x)
  checkmate::assert_logical(na_on_fail, len = 1)

  is_negative <- grepl("^\\(.*\\)$", trimws(x))
  cleaned <- gsub("[$\u20ac\u00a3\u00a5,\\(\\)\\s]", "", x, perl = TRUE)
  cleaned <- gsub("[A-Za-z]", "", cleaned, perl = TRUE)
  result <- suppressWarnings(as.numeric(cleaned))
  result <- ifelse(is_negative, -abs(result), result)

  failed <- is.na(result) & !is.na(x)
  if (any(failed)) {
    msg <- paste("Could not parse the following values:",
                 paste(x[failed], collapse = ", "))
    if (na_on_fail) warning(msg) else stop(msg)
  }

  result
}
