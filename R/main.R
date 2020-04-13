#' @import sparklyr
#' @export
sparkavroudf_hello <- function(sc) {
  sparklyr::invoke_static(sc, "sparkavroudf.Main", "hello")
}
