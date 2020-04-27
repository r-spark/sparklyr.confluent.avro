#' @import sparklyr
#' @export
stream_read_kafka_avro <- function(sc, topic, master= "local[*]", startingOffsets="latest", kafkaUrl= "broker:9092",
             schemaRegistryUrl= "http://schema-registry:8081", logLevel= "ERROR", jobName="sample") {
  invoke_static(sc, "sparklyr.confluent.avro.Bridge", "stream_read", topic, master, startingOffsets, kafkaUrl, schemaRegistryUrl, logLevel, jobName)
}

stream_write_kafka_avro <- function(sc, topic, dataFrame, kafkaUrl= "broker:9092", schemaRegistryUrl="http://schema-registry:8081",
                   valueSchemaNamingStrategy= "topic.name", avroRecordName="RecordName",
				   avroRecordNamespace= "RecordNamespace") {
  invoke_static(sc, "sparklyr.confluent.avro.Bridge", "stream_write", topic, dataFrame, kafkaUrl, schemaRegistryUrl, valueSchemaNamingStrategy, avroRecordName,avroRecordNamespace)
}
