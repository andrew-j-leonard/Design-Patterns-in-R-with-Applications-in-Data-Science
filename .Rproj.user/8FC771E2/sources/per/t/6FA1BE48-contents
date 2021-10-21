library("dbplyr")

setClass(
  "Query", 
  slots = c(
    cnr = "OdbcConnector", 
    tbl_name = "character", 
    .data = "list"
  ), 
  prototype = list(
    cnr = ConnectorFactory("sqlexpress")
  )
)

setClass(
  "Location", 
  contains = "Query", 
  prototype = list(
    tbl_name = "tbl_location"
  )
)

setClass(
  "Product", 
  contains = "Query", 
  prototype = list( 
    tbl_name = "tbl_product"
  )
)

setGeneric("reset", function(x) standardGeneric("reset"))
setMethod("get", "Query", function(x) {
  cnr <- x@cnr
  con <- dbConnect(cnr)
  x@.data <- tbl(con, x@tbl_name)
  dbDisconnect(con)
})

setClass(
  "QueryBuilder", 
  slots = c(
    active = "integer"
  ), 
  prototype = list(
    active = c(0L, 1L)
  )
)

setClass(
  "LocationBuilder", 
  contains = "QueryBuilder", 
  slots = c(
    market = "character"
  ), 
  prototype = list(
    market = c("US", "APAC", "EU", "Africa", "EMEA", "LATAM", "Canada")
  )
)

setClass(
  "ProductBuilder", 
  contains = "QueryBuilder", 
  slots = c(
    category = "character"
  ), 
  prototype = list(
    category = c("Technology", "Furniture", "Office Supplies")
  )
)


