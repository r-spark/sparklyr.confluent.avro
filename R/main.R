#' @import sparklyr
#' @export
sparklyudf_register <- function(sc) {
  sparklyr::invoke_static(sc, "sparklyudf.Main", "create_deserializer", spark_session(sc))
  sparklyr::invoke_static(sc, "sparklyudf.Main", "getAvroSchema", spark_session(sc))
}
