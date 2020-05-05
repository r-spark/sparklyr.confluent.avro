colExpr <- function(sc, expr) {
  invoke_static(sc$src$con, "org.apache.spark.sql.functions", "expr", expr)
}

groupBy <- function(sc, cols) {
  invoke(spark_dataframe(sc), "groupBy", cols)
}

window <- function(sc, timecol, interval, every) {
  colExpr(sc, str_interp("window(${timecol}, '${interval}', '${every}')"))
}

col <- function(sc, colname) {
  colExpr(sc, colname)
}

count <- function(sc) {
  invoke(sc, "count")
}

agg <- function(sc, expr) {
  s <- lapply(expr, function(e) invoke_static(sc$connection, "org.apache.spark.sql.functions", "expr", e))
  invoke(sc, "agg", s[[1]], s[-1])
}