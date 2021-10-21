library("DBI")
library("odbc")
library("here")

setClass(
  "OdbcConnector", 
  contains = "DBIConnector", 
  slots = c(
    .drv = "OdbcDriver", 
    .conn_args = "list"
  ),
  prototype = list(
    .drv = odbc::odbc(), 
  )
)

setClass(
  "SQLiteConnector", 
  contains = "DBIConnector", 
  slots = c(
    .drv = "SQLiteDriver", 
    .conn_args = "list"
  ), 
  prototype = list(
    .drv = RSQLite::SQLite()
  )
)

LiveSQLExpressConnector <- function(use_test = TRUE) {
  .conn_args <- list(
    Driver = "SQL Server", 
    Database = "master",  
    Trusted_Connection = TRUE
  )
  .conn_args$Server <- if (isFALSE(use_test)) {
    "localhost\\SQLEXPRESS_LIVE", 
  } else {
    "localhost\\SQLEXPRESS_TEST"
  }
  methods::new("OdbcConnector", .conn_args = .conn_args)
}

SQLiteConnector <- function(...) {
  methods::new("SQLiteConnector", ...)
}

SQLServerExpress <- function(use_test = TRUE) {
  cnr <- SQLServerConnector()
  cnr@.conn_args$Server <- if (isFALSE(use_test)) {
    "localhost\\sqlexpress_live"
  } else {
    "localhost\\sqlexpress_test"
  }
  return(cnr)
}

SQLiteExample <- function(use_test = TRUE) {
  cnr <- SQLiteConnector()
  cnr@.conn_args$dbname <- if (isFALSE(use_test)) {
    here("Data", "sqliteexample_Live.db")
  } else {
    here("Data", "SQLiteExample_Test.db")
  }
  return(cnr)
}

ConnectorFactory <- function(id, ..., use_test = TRUE) {
  obj <- valid_connector_objs[[id]]
  cnr <- obj(...)
  return(cnr)
}