#' @import sparklyr
#' @export
sparklyudf_register <- function(sc, schemaRegistryUrl) {
  list(deserialize=sparklyr::invoke_static(sc, "sparklyudf.Main", "register_deserialize", spark_session(sc), schemaRegistryUrl),
  getSchema=sparklyr::invoke_static(sc, "sparklyudf.Main", "register_getSchema", spark_session(sc), schemaRegistryUrl))
}
