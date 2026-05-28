# Sample Messy Financial Dataset

A small dataset containing common data quality issues found in
real-world financial data. Includes inconsistent fiscal year formats,
account name variations, messy currency strings, numeric values with
outliers, and missing values. Designed to demonstrate all functions in
the `finclean` package.

## Usage

``` r
finclean_sample
```

## Format

A data frame with 10 rows and 5 columns:

- period:

  Character. Fiscal year/quarter strings in various formats e.g.
  `"FY23"`, `"Q1 2023"`, `"2023-Q2"`.

- account:

  Character. Account name strings with inconsistent capitalization and
  abbreviations e.g. `"Rev."`, `"REVENUE"`.

- amount:

  Character. Currency strings in various messy formats e.g.
  `"$1,234.56"`, `"(1,200)"`, `"-$300.00"`.

- revenue:

  Numeric. Revenue values including an extreme outlier and a missing
  value.

- expenses:

  Numeric. Expense values with no missing entries.

## Examples

``` r
data(finclean_sample)
head(finclean_sample)
#>    period  account    amount revenue expenses
#> 1    FY23     Rev. $1,234.56     100       50
#> 2 Q1 2023  REVENUE      €500     200       80
#> 3 2023-Q2 Expenses   (1,200)     150      200
#> 4  Q1FY23      EXP  -$300.00   10000       60
#> 5  FY2023 Net Inc.   $98,000     130       90
#> 6 Q3-2023     COGS    $1,500     170       50

# Parse the messy currency column
parse_currency(finclean_sample$amount)
#>  [1]     1234.56      500.00    -1200.00     -300.00    98000.00     1500.00
#>  [7]     2000.00 99999999.00     -750.00     3200.00

# Standardize the fiscal year column
standardize_fiscal_year(finclean_sample$period)
#>  [1] "FY2023"    "FY2023-Q1" "FY2023-Q2" "FY2023-Q1" "FY2023"    "FY2023-Q3"
#>  [7] "FY2024"    "FY2024"    "FY2024-Q2" "FY2024-Q4"

# Normalize the account name column
normalize_accounts(finclean_sample$account)
#>  [1] "Revenue"    "Revenue"    "Expenses"   "Expenses"   "Net Income"
#>  [6] "COGS"       "COGS"       "Assets"     "Cash"       "Equity"    

# Flag outliers in the revenue column
flag_outliers(finclean_sample$revenue)
#>    value is_outlier
#> 1    100      FALSE
#> 2    200      FALSE
#> 3    150      FALSE
#> 4  10000       TRUE
#> 5    130      FALSE
#> 6    170      FALSE
#> 7    160      FALSE
#> 8    140      FALSE
#> 9     NA         NA
#> 10   120      FALSE

# Run a full audit on the dataset
audit_report(finclean_sample)
#>     column      type n_missing pct_missing n_duplicates n_outliers
#> 1   period character         0           0            0         NA
#> 2  account character         0           0            0         NA
#> 3   amount character         0           0            0         NA
#> 4  revenue   numeric         1          10            0          1
#> 5 expenses   numeric         0           0            2          1
```
