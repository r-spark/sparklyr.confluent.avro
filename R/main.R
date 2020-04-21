#' @import sparklyr
#' @export
stream_read_kafka_avro <- function(sc, topic, master= "local[*]", startingOffsets="latest", kafkaUrl= "broker:9092",
             schemaRegistryUrl= "http://schema-registry:8081", logLevel= "ERROR", jobName=String = "sample") {
  invoke_static(sc, "sparklyudf.Reader", "stream", topic, master, startingOffsets, kafkaUrl, schemaRegistryUrl, logLevel, jobName)
}
