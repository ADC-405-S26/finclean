# Normalize Account Name Variations

Standardizes inconsistent account name strings commonly found in
financial data into a single consistent label. For example, variations
like `"Rev."`, `"REVENUE"`, and `"revenue"` are all mapped to
`"Revenue"`. Users can also supply their own custom mapping.

## Usage

``` r
normalize_accounts(x, custom_map = NULL, na_on_fail = TRUE)
```

## Arguments

- x:

  A character vector of account name strings to normalize.

- custom_map:

  A named character vector where names are the desired standardized
  labels and values are regex patterns to match against. If `NULL`
  (default), a built-in mapping of common financial account names is
  used.

- na_on_fail:

  Logical. If `TRUE` (default), unmatched values are returned as `NA`
  with a warning. If `FALSE`, unmatched values are returned as-is
  unchanged.

## Value

A character vector of the same length as `x` with account name
variations replaced by their standardized labels. Unmatched values are
returned as `NA` or unchanged depending on `na_on_fail`.

## Examples

``` r
normalize_accounts(c("Rev.", "REVENUE", "revenue", "Expenses", "EXP"))
#> [1] "Revenue"  "Revenue"  "Revenue"  "Expenses" "Expenses"
normalize_accounts(c("COGS", "cost of goods", "Net Inc.", "NET INCOME"))
#> [1] "COGS"       "COGS"       "Net Income" "Net Income"
```
