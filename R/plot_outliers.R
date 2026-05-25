#' Plot Outliers in a Numeric Column
#'
#' Generates a ggplot2 bar chart for a numeric column from a data frame,
#' highlighting flagged outlier bars in red. Outliers are detected using
#' \code{flag_outliers()} and colored differently for easy visual identification.
#'
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
#' @return A \code{ggplot2} object displaying a bar chart of the specified
#'   column with outlier bars highlighted in red and normal bars in steelblue.
#'
#' @examples
#' df <- data.frame(revenue = c(100, 200, 150, 10000, 130, 170, 160, 140))
#' plot_outliers(df, column = "revenue")
#' plot_outliers(df, column = "revenue", method = "zscore", threshold = 2)
#'
#' @importFrom ggplot2 ggplot aes geom_bar scale_fill_manual labs theme_minimal theme element_text
#' @importFrom rlang .data
#' @export
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
    index      = seq_along(flagged$value),
    value      = flagged$value,
    is_outlier = ifelse(flagged$is_outlier, "Outlier", "Normal")
  )

  plot_title <- if (!is.null(title)) title else paste("Outlier Detection:", column)

  ggplot2::ggplot(
    plot_df,
    ggplot2::aes(x = .data$index, y = .data$value, fill = .data$is_outlier)
  ) +
    ggplot2::geom_bar(stat = "identity") +
    ggplot2::scale_fill_manual(
      values = c("Normal" = "steelblue", "Outlier" = "red"),
      name   = NULL
    ) +
    ggplot2::labs(
      title = plot_title,
      x     = "Observation Index",
      y     = column
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title  = ggplot2::element_text(face = "bold", size = 13),
      axis.text.x = ggplot2::element_text(size = 11)
    )
}
