# Standardize Fiscal Year Strings

Converts a variety of fiscal year and quarter string formats commonly
found in financial data into a single consistent format. The default
output format is `"FY2023"` for annual periods and `"FY2023-Q1"` for
quarterly periods.

## Usage

``` r
standardize_fiscal_year(x, prefix = "FY")
```

## Arguments

- x:

  A character vector of fiscal year strings to standardize. Supported
  input formats include: `"FY23"`, `"FY2023"`, `"2023"`, `"Q1 2023"`,
  `"2023-Q1"`, `"Q1-2023"`, `"Q1FY23"`.

- prefix:

  A single character string to use as the fiscal year prefix. Defaults
  to `"FY"`.

## Value

A character vector of the same length as `x` with all fiscal year
strings converted to a consistent format. Unrecognized formats are
returned as `NA` with a warning.

## Examples

``` r
standardize_fiscal_year(c("FY23", "FY2023", "2023"))
#> [1] "FY2023" "FY2023" "FY2023"
standardize_fiscal_year(c("Q1 2023", "2023-Q1", "Q1-2023", "Q1FY23"))
#> [1] "FY2023-Q1" "FY2023-Q1" "FY2023-Q1" "FY2023-Q1"
```
