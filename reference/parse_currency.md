# Parse Currency Strings to Numeric

Converts messy currency strings commonly found in financial data into
clean numeric values. Handles currency symbols, commas, spaces, and
accounting-style negative numbers written in parentheses.

## Usage

``` r
parse_currency(x, na_on_fail = TRUE)
```

## Arguments

- x:

  A character vector of currency strings to convert. Examples of
  supported formats: `"$1,234.56"`, `"€500"`, `"(1,200)"`, `"-$300.00"`,
  `"1 000.50"`.

- na_on_fail:

  Logical. If `TRUE` (default), values that cannot be parsed will be
  returned as `NA` with a warning. If `FALSE`, the function will stop
  with an error on unparseable input.

## Value

A numeric vector of the same length as `x`, with currency formatting
removed. Parentheses-style negatives like `"(500)"` are correctly
converted to `-500`.

## Examples

``` r
parse_currency(c("$1,234.56", "EUR500", "(1,200)", "-$300.00"))
#> [1]  1234.56   500.00 -1200.00  -300.00
```
