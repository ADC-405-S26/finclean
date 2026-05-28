#' Flag Outliers in a Numeric Column
#'
#' Identifies and flags suspicious values in a numeric vector using either the
#' IQR (interquartile range) method or the z-score method. Returns a data frame
#' with the original values and a logical column indicating whether each value
#' is an outlier.
#'
#' @param x A numeric vector to check for outliers.
#' @param method A single character string specifying the detection method.
#'   Either \code{"iqr"} (default) or \code{"zscore"}.
#' @param threshold A single numeric value controlling outlier sensitivity.
#'   Must be greater than zero. For \code{"iqr"}, this is the multiplier
#'   applied to the IQR (default \code{1.5}). For \code{"zscore"}, this is
#'   the z-score cutoff (default \code{3}).
#'
#' @return A data frame with two columns:
#'   \describe{
#'     \item{value}{The original numeric values from \code{x}.}
#'     \item{is_outlier}{Logical. \code{TRUE} if the value is flagged as an
#'       outlier. Returns \code{FALSE} for all values if all non-missing values
#'       are identical.}
#'   }
#'
#' @examples
#' flag_outliers(c(100, 200, 150, 10000, 130, 170))
#' flag_outliers(c(100, 200, 150, 10000, 130, 170), method = "zscore")
#' flag_outliers(c(100, 200, 150, 10000, 130, 170), method = "iqr", threshold = 3)
#'
#' @export
flag_outliers <- function(x, method = "iqr", threshold = NULL) {
  checkmate::assert_numeric(x)
  checkmate::assert_choice(method, c("iqr", "zscore"))

  if (!is.null(threshold)) {
    checkmate::assert_number(threshold)
    if (threshold <= 0) {
      stop("threshold must be a positive number greater than zero.")
    }
  }

  if (is.null(threshold)) {
    threshold <- if (method == "iqr") 1.5 else 3
  }

  is_outlier <- if (method == "iqr") {
    q1  <- stats::quantile(x, 0.25, na.rm = TRUE)
    q3  <- stats::quantile(x, 0.75, na.rm = TRUE)
    iqr <- q3 - q1
    x < (q1 - threshold * iqr) | x > (q3 + threshold * iqr)
  } else {
    sd_val <- stats::sd(x, na.rm = TRUE)

    if (!is.na(sd_val) && sd_val == 0) {
      return(data.frame(value = x, is_outlier = rep(FALSE, length(x))))
    }

    z_scores <- (x - mean(x, na.rm = TRUE)) / sd_val
    abs(z_scores) > threshold
  }

  is_outlier[is.na(x)] <- NA

  data.frame(value = x, is_outlier = is_outlier)
}
