library("glue")
library("httr")
library("jsonlite")
library("data.table")
library("anytime")

to_clip <- function(.data) {
  write.table(.data, "clipboard-99999", sep = "\t", row.names = F)
}

get_api_key <- function() {
  user_profile <- Sys.getenv("USERPROFILE")
  path_to_key <- file.path(user_profile, "Documents", "Creds", "eia_api_key.txt")
  file_size <- file.info(path_to_key)$size
  api_key <- readChar(path_to_key, file_size)
  return(api_key)
}


api_key <- get_api_key
api_url <- "http://api.eia.gov/series/?api_key={api_key}&series_id=PET.MCRFP{state_abb}1.M"

format_eia_url <- function(state_abb) {
  glue(api_url, api_key = api_key, state_abb = state_abb)
}

get_eia_response <- function(state_abb) {
  url <- format_eia_url(state_abb)
  res <- GET(url)
  return(res)
}

response_to_json <- function(res) {
  json <- fromJSON(rawToChar(res$content))
  return(json)
}

json_to_data <- function(json) {
  .data <- json$series$data
  return(.data)
}

rename_columns <- function(DT) {
  old <- names(DT)
  .new <- c("date", "barrel")
  setnames(DT, old = old, new = .new)
}

all_cols_to_char <- function(DT) {
  for (j in names(DT)) 
    set(DT, j = j, value = as.character(DT[[j]]))
}

convert_date_col <- function(DT) {
  DT[, date := anydate(date)]
}

format_data <- function(.data) {
  setDT(.data)
  rename_columns(.data)
  all_cols_to_char(.data)
  convert_date_col(.data)
}

run <- function(state_abb) {
  res <- get_eia_response(state_abb)
  json <- response_to_json(res)
  .data <- json_to_data(json)
  DT <- format_data(.data)
  return(DT)
}

state_abb_to_name <- function(state_abb) {
  state_name <- toupper(state.name[which(state.abb == state_abb)])
  return(state_name)
}

state_abbs <- c("TX", "ND", "SD", "CO", "MT", "NE", "NM", "WY", "PA", "WV", "OH", "NY", "LA", "OK", "AR")
results <- sapply(state_abbs, run, USE.NAMES = TRUE, simplify = F)
DT <- rbindlist(results, use.names = TRUE, idcol = "state_abb")
DT[, state := state_abb_to_name(state_abb), by = .(state_abb)]
DT[, year := year(date)]
setcolorder(DT, c('state_abb', 'state', 'year', 'date', 'barrel'))
write.table(DT, "clipboard-99999", row.names = F, sep = "\t")
