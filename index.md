# finclean

> A toolkit for auditing, cleaning, and visualizing messy financial
> datasets in R.

## Overview

`finclean` is an R package designed to help analysts and data scientists
clean and diagnose the messy, inconsistent data commonly found in
real-world financial datasets. It provides a set of simple but powerful
functions for parsing currency strings, standardizing fiscal year
formats, normalizing account names, detecting outliers, auditing data
quality, and visualizing anomalies — all in one place.

## Installation

You can install `finclean` directly from GitHub:

``` r
devtools::install_github("ADC-405-S26/finclean")
```

## Functions

| Function | Description |
|----|----|
| [`parse_currency()`](https://adc-405-s26.github.io/finclean/reference/parse_currency.md) | Converts messy currency strings like `"$1,234.56"` or `"(1,200)"` to numeric |
| [`standardize_fiscal_year()`](https://adc-405-s26.github.io/finclean/reference/standardize_fiscal_year.md) | Normalizes fiscal year formats like `"FY23"`, `"Q1 2023"`, `"2023-Q1"` into a consistent output |
| [`normalize_accounts()`](https://adc-405-s26.github.io/finclean/reference/normalize_accounts.md) | Standardizes inconsistent account name variations like `"Rev."`, `"REVENUE"` to `"Revenue"` |
| [`flag_outliers()`](https://adc-405-s26.github.io/finclean/reference/flag_outliers.md) | Flags suspicious values in a numeric column using IQR or z-score method |
| [`audit_report()`](https://adc-405-s26.github.io/finclean/reference/audit_report.md) | Scans a data frame and returns a summary of missing values, duplicates, and outliers |
| [`plot_outliers()`](https://adc-405-s26.github.io/finclean/reference/plot_outliers.md) | Generates a bar chart highlighting outlier values in red |

## Example Usage

``` r
library(finclean)

# Load the built-in sample dataset
data(finclean_sample)
```

**Parse messy currency strings**

``` r
parse_currency(c("$1,234.56", "EUR500", "(1,200)", "-$300.00"))
#> [1]  1234.56   500.00 -1200.00  -300.00
```

**Standardize fiscal year formats**

``` r
standardize_fiscal_year(c("FY23", "Q1 2023", "2023-Q2", "Q1FY23"))
#> [1] "FY2023"    "FY2023-Q1" "FY2023-Q2" "FY2023-Q1"
```

**Normalize account name variations**

``` r
normalize_accounts(c("Rev.", "REVENUE", "Expenses", "EXP", "Net Inc."))
#> [1] "Revenue"  "Revenue"  "Expenses" "Expenses" "Net Income"
```

**Flag outliers using IQR method**

``` r
flag_outliers(c(100, 200, 150, 10000, 130, 170))
#>   value is_outlier
#> 1   100      FALSE
#> 2   200      FALSE
#> 3   150      FALSE
#> 4 10000       TRUE
#> 5   130      FALSE
#> 6   170      FALSE
```

**Generate a full data quality audit report**

``` r
audit_report(finclean_sample)
#>     column      type n_missing pct_missing n_duplicates n_outliers
#> 1   period character         0           0            0         NA
#> 2  account character         0           0            0         NA
#> 3   amount character         0           0            0         NA
#> 4  revenue   numeric         1          10            0          1
#> 5 expenses   numeric         0           0            2          1
```

**Visualize outliers in a column**

``` r
plot_outliers(finclean_sample, column = "revenue")
```

## Dataset

`finclean` includes a built-in sample dataset `finclean_sample`
containing common data quality issues found in real-world financial
data, including inconsistent fiscal year formats, account name
variations, messy currency strings, outliers, and missing values.

| period  | account  | amount     | revenue | expenses |
|---------|----------|------------|---------|----------|
| FY23    | Rev.     | \$1,234.56 | 100     | 50       |
| Q1 2023 | REVENUE  | EUR500     | 200     | 80       |
| 2023-Q2 | Expenses | (1,200)    | 150     | 200      |
| Q1FY23  | EXP      | -\$300.00  | 10000   | 60       |
| FY2023  | Net Inc. | \$98,000   | 130     | 90       |
| Q3-2023 | COGS     | \$1,500    | 170     | 50       |

## Dependencies

- [`checkmate`](https://cran.r-project.org/package=checkmate) — input
  validation
- [`ggplot2`](https://ggplot2.tidyverse.org/) — visualization
- [`rlang`](https://rlang.r-lib.org/) — tidy evaluation utilities

## License

MIT © 2025
