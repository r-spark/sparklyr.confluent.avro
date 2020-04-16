#' @import sparklyr
#' @export
sparklyudf_register <- function(sc, schemaRegistryUrl) {
  sparklyr::invoke_static(sc, "sparklyudf.Main", "create_deserializer", spark_session(sc), schemaRegistryUrl)
}
