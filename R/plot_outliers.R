#' Plot Outliers in a Numeric Column
#' Generates a ggplot2 boxplot for a numeric column from a data frame,
#' highlighting flagged outlier points in red. Outliers are detected using
#' \code{flag_outliers()} and overlaid on the plot for easy visual identification.
#' @param df A data frame containing the column to plot.
#' @param column A single character string specifying the name of the numeric
#'   column in \code{df} to visualize.
#' @param method A single character string specifying the outlier detection
#'   method. Either \code{"iqr"} (default) or \code{"zscore"}.
#' @param threshold A single numeric value controlling outlier sensitivity.
#'   For \code{"iqr"}, this is the IQR multiplier (default \code{1.5}).
#'   For \code{"zscore"}, this is the z-score cutoff (default \code{3}).
#' @param title A single character string for the plot title. Defaults to
#'   \code{"Outlier Detection: <column>"}.
#'
#' @returns A \code{ggplot2} object displaying a boxplot of the specified column
#'   with outlier points highlighted in red.
#' @export
#' @importFrom ggplot2 ggplot aes geom_boxplot geom_point scale_color_manual labs theme_minimal theme element_text position_jitter
#' @importFrom rlang .data
#' @examples
#' df <- data.frame(revenue = c(100, 200, 150, 10000, 130, 170, 160, 140))
#' plot_outliers(df, column = "revenue")
#' plot_outliers(df, column = "revenue", method = "zscore", threshold = 2)

plot_outliers <- function(df, column, method = "iqr", threshold = NULL, title = NULL) {
  checkmate::assert_data_frame(df)
  checkmate::assert_string(column)
  checkmate::assert_choice(method, c("iqr", "zscore"))
  if (!is.null(threshold)) checkmate::assert_number(threshold)
  if (!is.null(title)) checkmate::assert_string(title)

  if (!column %in% names(df)) {
    stop(paste0("Column '", column, "' not found in the data frame."))
  }

  if (!is.numeric(df[[column]])) {
    stop(paste0("Column '", column, "' must be numeric."))
  }

  flagged <- flag_outliers(df[[column]], method = method, threshold = threshold)
  plot_df <- data.frame(
    value      = flagged$value,
    is_outlier = flagged$is_outlier,
    x_axis     = column
  )

  plot_title <- if (!is.null(title)) title else paste("Outlier Detection:", column)

  ggplot2::ggplot(plot_df, ggplot2::aes(x = .data$x_axis, y = .data$value)) +
    ggplot2::geom_boxplot(outlier.shape = NA, fill = "grey92", color = "grey40") +
    ggplot2::geom_point(
      ggplot2::aes(color = .data$is_outlier),
      position = ggplot2::position_jitter(width = 0.05, seed = 1),
      size = 2.5,
      alpha = 0.8
    ) +
    ggplot2::scale_color_manual(
      values = c("FALSE" = "steelblue", "TRUE" = "red"),
      labels = c("FALSE" = "Normal", "TRUE" = "Outlier"),
      name   = NULL
    ) +
    ggplot2::labs(
      title = plot_title,
      x     = NULL,
      y     = column
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title   = ggplot2::element_text(face = "bold", size = 13),
      axis.text.x  = ggplot2::element_text(size = 11)
    )
}
