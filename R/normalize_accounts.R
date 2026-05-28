#' Normalize Account Name Variations
#'
#' Standardizes inconsistent account name strings commonly found in financial
#' data into a single consistent label. For example, variations like
#' \code{"Rev."}, \code{"REVENUE"}, and \code{"revenue"} are all mapped to
#' \code{"Revenue"}. Users can also supply their own custom mapping.
#'
#'
#' @param x A character vector of account name strings to normalize.
#' @param custom_map A named character vector where names are the desired
#'   standardized labels and values are regex patterns to match against.
#'   If \code{NULL} (default), a built-in mapping of common financial account
#'   names is used. Note: providing a \code{custom_map} completely replaces
#'   the default mapping, built-in account names will no longer be recognized
#'   unless explicitly included in your custom map.
#' @param na_on_fail Logical. If \code{TRUE} (default), unmatched values are
#'   returned as \code{NA} with a warning. If \code{FALSE}, unmatched values
#'   are returned as-is unchanged.
#'
#' @returns A character vector of the same length as \code{x} with account name
#'   variations replaced by their standardized labels. Unmatched values are
#'   returned as \code{NA} or unchanged depending on \code{na_on_fail}.
#' @export
#'
#' @examples
#' normalize_accounts(c("Rev.", "REVENUE", "revenue", "Expenses", "EXP"))
#' normalize_accounts(c("COGS", "cost of goods", "Net Inc.", "NET INCOME"))
normalize_accounts <- function(x, custom_map = NULL, na_on_fail = TRUE) {
  checkmate::assert_character(x)
  checkmate::assert_logical(na_on_fail, len = 1)
  if (!is.null(custom_map)) {
    checkmate::assert_character(custom_map)
    checkmate::assert_named(custom_map)
  }


  default_map <- c(
    "Revenue"      = "^(rev\\.?|revenue|revenues|sales|net sales)$",
    "Expenses"     = "^(exp\\.?|expense|expenses|operating expenses|opex)$",
    "Net Income"   = "^(net inc\\.?|net income|net earnings|profit|net profit)$",
    "COGS"         = "^(cogs|cost of goods|cost of goods sold|cost of sales)$",
    "Gross Profit" = "^(gross profit|gross margin|gross inc\\.?)$",
    "Assets"       = "^(assets|total assets|asset)$",
    "Liabilities"  = "^(liabilities|total liabilities|liability)$",
    "Equity"       = "^(equity|shareholders equity|stockholders equity|owners equity)$",
    "Cash"         = "^(cash|cash and equivalents|cash & equivalents)$",
    "EBITDA"       = "^(ebitda|earnings before interest|ebit)$"
  )

  mapping <- if (!is.null(custom_map)) custom_map else default_map

  result <- rep(NA_character_, length(x))

  for (i in seq_along(x)) {
    val <- trimws(x[i])
    matched <- FALSE

    for (label in names(mapping)) {
      if (grepl(mapping[label], val, ignore.case = TRUE, perl = TRUE)) {
        result[i] <- label
        matched <- TRUE
        break
      }
    }

    if (!matched) {
      result[i] <- if (na_on_fail) NA_character_ else val
    }
  }

  failed <- is.na(result) & !is.na(x) & na_on_fail
  if (any(failed)) {
    warning(paste("Could not match the following account names:",
                  paste(x[failed], collapse = ", ")))
  }

  result
}
