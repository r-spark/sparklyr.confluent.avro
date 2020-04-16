#' @import sparklyr
#' @export
sparklyudf_register <- function(sc, schemaRegistryUrl) {
  sparklyr::invoke_static(sc, "sparklyudf.Main", "deserialize", spark_session(sc), schemaRegistryUrl)
  sparklyr::invoke_static(sc, "sparklyudf.Main", "getSchema", spark_session(sc), schemaRegistryUrl)
}
