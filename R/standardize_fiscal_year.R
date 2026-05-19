#'Standardize Fiscal Year Strings
#' Converts a variety of fiscal year and quarter string formats commonly found
#' in financial data into a single consistent format. The default output format
#' is \code{"FY2023"} for annual periods and \code{"FY2023-Q1"} for quarterly periods.
#' @param x A character vector of fiscal year strings to standardize.
#'   Supported input formats include: \code{"FY23"}, \code{"FY2023"},
#'   \code{"2023"}, \code{"Q1 2023"}, \code{"2023-Q1"}, \code{"Q1-2023"},
#'   \code{"Q1FY23"}.
#' @param prefix A single character string to use as the fiscal year prefix.
#'   Defaults to \code{"FY"}.
#'
#' @returns A character vector of the same length as \code{x} with all fiscal
#'   year strings converted to a consistent format. Unrecognized formats are
#'   returned as \code{NA} with a warning.
#' @export
#'
#' @examples
#' standardize_fiscal_year(c("FY23", "FY2023", "2023"))
#' standardize_fiscal_year(c("Q1 2023", "2023-Q1", "Q1-2023", "Q1FY23"))
standardize_fiscal_year <- function(x, prefix = "FY") {
  checkmate::assert_character(x)
  checkmate::assert_string(prefix)

  result <- rep(NA_character_, length(x))

  for (i in seq_along(x)) {
    val <- trimws(x[i])

    if (grepl("^FY\\d{2,4}$", val, ignore.case = TRUE)) {
      year <- sub("^FY(\\d{2,4})$", "\\1", val, ignore.case = TRUE)
      year <- expand_year(year)
      result[i] <- paste0(prefix, year)

    } else if (grepl("^\\d{4}$", val)) {
      result[i] <- paste0(prefix, val)

    } else if (grepl("^Q[1-4][\\s-]\\d{4}$", val, perl = TRUE)) {
      parts <- strsplit(val, "[\\s-]", perl = TRUE)[[1]]
      result[i] <- paste0(prefix, parts[2], "-", parts[1])

    } else if (grepl("^\\d{4}[\\s-]Q[1-4]$", val, perl = TRUE)) {
      parts <- strsplit(val, "[\\s-]", perl = TRUE)[[1]]
      result[i] <- paste0(prefix, parts[1], "-", parts[2])

    } else if (grepl("^Q[1-4]FY\\d{2,4}$", val, ignore.case = TRUE)) {
      quarter <- substr(val, 1, 2)
      year <- sub("^Q[1-4]FY(\\d{2,4})$", "\\1", val, ignore.case = TRUE)
      year <- expand_year(year)
      result[i] <- paste0(prefix, year, "-", toupper(quarter))

    } else {
      result[i] <- NA_character_
    }
  }

  failed <- is.na(result) & !is.na(x)
  if (any(failed)) {
    warning(paste("Could not standardize the following values:",
                  paste(x[failed], collapse = ", ")))
  }

  result
}

expand_year <- function(year) {
  if (nchar(year) == 2) {
    year <- paste0(ifelse(as.integer(year) <= 50, "20", "19"), year)
  }
  year
}
