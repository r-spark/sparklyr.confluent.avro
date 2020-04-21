#' @import sparklyr
#' @export
stream_read_kafka_avro <- function(sc, topic, master= "local[*]", startingOffsets="latest", kafkaUrl= "broker:9092",
             schemaRegistryUrl= "http://schema-registry:8081", logLevel= "ERROR", jobName="sample") {
  invoke_static(sc, "sparklyr_confluent_avro.Reader", "stream", topic, master, startingOffsets, kafkaUrl, schemaRegistryUrl, logLevel, jobName)
}
