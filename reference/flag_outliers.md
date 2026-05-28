# Flag Outliers in a Numeric Column

Identifies and flags suspicious values in a numeric vector using either
the IQR (interquartile range) method or the z-score method. Returns a
data frame with the original values and a logical column indicating
whether each value is an outlier.

## Usage

``` r
flag_outliers(x, method = "iqr", threshold = NULL)
```

## Arguments

- x:

  A numeric vector to check for outliers.

- method:

  A single character string specifying the detection method. Either
  `"iqr"` (default) or `"zscore"`.

- threshold:

  A single numeric value controlling outlier sensitivity. For `"iqr"`,
  this is the multiplier applied to the IQR (default `1.5`). For
  `"zscore"`, this is the z-score cutoff (default `3`).

## Value

A data frame with two columns:

- value:

  The original numeric values from `x`.

- is_outlier:

  Logical. `TRUE` if the value is flagged as an outlier.

## Examples

``` r
flag_outliers(c(100, 200, 150, 10000, 130, 170))
#>   value is_outlier
#> 1   100      FALSE
#> 2   200      FALSE
#> 3   150      FALSE
#> 4 10000       TRUE
#> 5   130      FALSE
#> 6   170      FALSE
flag_outliers(c(100, 200, 150, 10000, 130, 170), method = "zscore")
#>   value is_outlier
#> 1   100      FALSE
#> 2   200      FALSE
#> 3   150      FALSE
#> 4 10000      FALSE
#> 5   130      FALSE
#> 6   170      FALSE
flag_outliers(c(100, 200, 150, 10000, 130, 170), method = "iqr", threshold = 3)
#>   value is_outlier
#> 1   100      FALSE
#> 2   200      FALSE
#> 3   150      FALSE
#> 4 10000       TRUE
#> 5   130      FALSE
#> 6   170      FALSE
```
