library("DBI")
library("odbc")

setClass(
  "OdbcConnector", 
  contains =  "DBIConnector", 
  slots = c(
    .drv = "OdbcDriver", 
    .conn_args = "list"
  ), 
  prototype = list(
    .drv = odbc::odbc()
  )
)

setClass(
  "SQLExpressConnector", 
  contains = "OdbcConnector", 
  prototype = list(
    .conn_args = list(
      Driver = "SQL Server", 
      Server = "localhost\\sqlexpress", 
      Database = "master", 
      Trusted_Connection = TRUE
    )
  )
)

setClass(
  "SQLiteConnector", 
  contains = "DBIConnector", 
  slots = c(
    .drv = "SQLiteDriver"
  ), 
  prototype = list(
    .drv = RSQLite::SQLite(), 
    .conn_args = list(dbname = here("data", "sqlite.db"))
  )
)

SQLExpressConnector <- function(...) {
  methods::new("SQLExpressConnector")
}

SQLiteConnector <- function(...) {
  methods::new("SQLiteConnector")
}

.connector_factories <- list(
  "sqlexpress"  = SQLExpressConnector, 
  "sqlite" = SQLiteConnector
)

ConnectorFactory <- function(id, ...) {
  obj <- .connector_factories[[id]]
  cnr <- obj(...)
  return(cnr)
}