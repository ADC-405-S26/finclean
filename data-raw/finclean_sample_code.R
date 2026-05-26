## code to prepare `finclean_sample_code` dataset goes here
finclean_sample <- data.frame(
  period = c(
    "FY23", "Q1 2023", "2023-Q2", "Q1FY23", "FY2023",
    "Q3-2023", "2024", "FY24", "Q2 2024", "Q4FY24"
  ),
  account = c(
    "Rev.", "REVENUE", "Expenses", "EXP", "Net Inc.",
    "COGS", "cost of goods", "assets", "CASH", "Equity"
  ),
  amount = c(
    "$1,234.56", "EUR500", "(1,200)", "-$300.00", "$98,000",
    "$1,500", "$2,000", "$99,999,999", "(750.00)", "$3,200"
  ),
  revenue = c(
    100, 200, 150, 10000, 130,
    170, 160, 140, NA, 120
  ),
  expenses = c(
    50, 80, 200, 60, 90,
    50, 75, 65, 85, 55
  ),
  stringsAsFactors = FALSE
)

usethis::use_data(finclean_sample, overwrite = TRUE)

