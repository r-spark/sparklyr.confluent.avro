#' @import sparklyr
#' @export
stream_read_kafka_avro <- function(sc, topic) {
  invoke_static(sc, "sparklyudf.Reader", "stream", topic)
}
