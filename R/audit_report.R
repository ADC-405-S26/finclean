#' Generate a Data Quality Audit Report
#'
#' Scans a data frame and returns a summary of data quality issues commonly
#' found in financial datasets. For each column, the report includes the number
#' of missing values, duplicates, and for numeric columns, the number of
#' outliers detected using the IQR method.
#'
#' @param df A data frame to audit. Must have at least one column.
#' @param outlier_method A single character string specifying the outlier
#'   detection method to use. Either \code{"iqr"} (default) or \code{"zscore"}.
#'   Passed to \code{flag_outliers()}.
#' @param threshold A single numeric value controlling outlier sensitivity.
#'   For \code{"iqr"}, this is the IQR multiplier (default \code{1.5}).
#'   For \code{"zscore"}, this is the z-score cutoff (default \code{3}).
#'
#' @return A data frame with one row per column in \code{df} and the following
#'   columns:
#'   \describe{
#'     \item{column}{The column name.}
#'     \item{type}{The data type of the column.}
#'     \item{n_missing}{Number of \code{NA} values.}
#'     \item{pct_missing}{Percentage of values that are \code{NA}.}
#'     \item{n_duplicates}{Number of values that appear more than once,
#'       counted as pairs. For example, if \code{"A"} appears twice, that
#'       counts as 1 duplicate pair.}
#'     \item{n_outliers}{Number of outliers detected. \code{NA} for
#'       non-numeric columns.}
#'   }
#' @export
#'
#' @examples
#' df <- data.frame(
#'   revenue = c(100, 200, 150, 10000, NA, 130),
#'   category = c("A", "A", "B", "B", "C", "C"),
#'   expenses = c(50, 80, 70, 60, 90, 50)
#' )
#' audit_report(df)
#' audit_report(df, outlier_method = "zscore", threshold = 2)
audit_report <- function(df, outlier_method = "iqr", threshold = NULL) {
  checkmate::assert_data_frame(df)
  checkmate::assert_choice(outlier_method, c("iqr", "zscore"))
  if (!is.null(threshold)) checkmate::assert_number(threshold)

  if (ncol(df) == 0 || nrow(df) == 0) {
    message("The provided data frame is empty. No audit to report.")
    return(
      data.frame(
        column       = character(),
        type         = character(),
        n_missing    = integer(),
        pct_missing  = numeric(),
        n_duplicates = integer(),
        n_outliers   = integer(),
        stringsAsFactors = FALSE
      )
    )
  }

  n_rows <- nrow(df)

  report <- lapply(names(df), function(col) {
    x <- df[[col]]

    n_missing    <- sum(is.na(x))
    pct_missing  <- round((n_missing / n_rows) * 100, 1)

    n_duplicates <- sum(duplicated(x), na.rm = TRUE)

    n_outliers <- if (is.numeric(x)) {
      flagged <- flag_outliers(x, method = outlier_method, threshold = threshold)
      sum(flagged$is_outlier, na.rm = TRUE)
    } else {
      NA_integer_
    }

    data.frame(
      column       = col,
      type         = class(x)[1],
      n_missing    = n_missing,
      pct_missing  = pct_missing,
      n_duplicates = n_duplicates,
      n_outliers   = n_outliers,
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, report)
}
