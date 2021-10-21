library("randomNames")
library("data.table")

state_dt <- data.table(state_name = state.name, state_abb = state.abb)

create_names_df <- function(col) {
  n <- sample(1000L:5000L, 1L)
  .names <- randomNames(n = n)
}
vendor_names <- randomNames::randomNames(n = )
customer_names <- randomNames::randomNames(n = sample(1000L:5000L, 1L))
employee_names <- randomNames::randomNames(n = sample(1000L:5000L, 1L))