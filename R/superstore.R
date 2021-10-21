# Tableau Data from 
# http://www.tableau.com/sites/default/files/training/global_superstore.zip
library("readxl")
library("DBI")
library("dplyr")
library("here")
source(here("R", "factory_method.R"))

set.seed(123)

fname <- here("data", "Global Superstore.xls")
df <- read_xls(fname) 

create_active_ids <- function(.data) {
  n <- nrow(.data)
  nums <- sample(1:(n * 4))
  ids <- sample(nums, n) %% 2
  .data$Active <- ids
  return(.data)
}

location_df <- df %>%
  select(Market, Region, Country, State, City, `Postal Code`) %>%
  distinct() 
location_df$`Location ID` <- as.character(1:nrow(location_df))
location_df <- create_active_ids(location_df) %>%
  as.data.frame()

product_df <- df %>%
  select(`Product Name`, Category, `Sub-Category`) %>%
  distinct() 
product_df$`Product ID` <- as.character(1:nrow(product_df))
product_df <- create_active_ids(product_df) %>%
  as.data.frame()

cnr <- ConnectorFactory("sqlexpress")
con <- dbConnect(cnr)
dbWriteTable(con, "tbl_location", unique(location_df), overwrite = TRUE)
dbWriteTable(con, "tbl_product", unique(product_df), overwrite = TRUE)
dbDisconnect(con)
