#' @import sparklyr
#' @export
stream_read_kafka_avro <- function(sc, topic) {
  sparklyr::invoke_static(sc, "sparklyudf.avro.Reader", "stream", topic)
}
