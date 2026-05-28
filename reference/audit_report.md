# Generate a Data Quality Audit Report

Scans a data frame and returns a summary of data quality issues commonly
found in financial datasets. For each column, the report includes the
number of missing values, duplicates, and for numeric columns, the
number of outliers detected using the IQR method.

## Usage

``` r
audit_report(df, outlier_method = "iqr", threshold = NULL)
```

## Arguments

- df:

  A data frame to audit.

- outlier_method:

  A single character string specifying the outlier detection method to
  use. Either `"iqr"` (default) or `"zscore"`. Passed to
  [`flag_outliers()`](https://adc-405-s26.github.io/finclean/reference/flag_outliers.md).

- threshold:

  A single numeric value controlling outlier sensitivity. For `"iqr"`,
  this is the IQR multiplier (default `1.5`). For `"zscore"`, this is
  the z-score cutoff (default `3`).

## Value

A data frame with one row per column in `df` and the following columns:

- column:

  The column name.

- type:

  The data type of the column.

- n_missing:

  Number of `NA` values.

- pct_missing:

  Percentage of values that are `NA`.

- n_duplicates:

  Number of duplicate values in the column.

- n_outliers:

  Number of outliers detected. `NA` for non-numeric columns.

## Examples

``` r
df <- data.frame(
  revenue = c(100, 200, 150, 10000, NA, 130),
  category = c("A", "A", "B", "B", "C", "C"),
  expenses = c(50, 80, 70, 60, 90, 50)
)
audit_report(df)
#>     column      type n_missing pct_missing n_duplicates n_outliers
#> 1  revenue   numeric         1        16.7            0          1
#> 2 category character         0         0.0            6         NA
#> 3 expenses   numeric         0         0.0            2          0
audit_report(df, outlier_method = "zscore", threshold = 2)
#>     column      type n_missing pct_missing n_duplicates n_outliers
#> 1  revenue   numeric         1        16.7            0          0
#> 2 category character         0         0.0            6         NA
#> 3 expenses   numeric         0         0.0            2          0
```
