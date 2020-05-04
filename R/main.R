#' @import sparklyr
#' @export
stream_read_kafka_avro <- function(sc, topic, master= "local[*]", startingOffsets="latest", kafkaUrl,
             schemaRegistryUrl, logLevel= "ERROR", jobName="sample", name=NULL) {
  if(is.null(name)) {
    name <- topic
  }
  invoke_static(sc, "sparklyr.confluent.avro.Bridge", "stream_read", topic, master, startingOffsets, kafkaUrl, schemaRegistryUrl, logLevel, jobName) %>%
  invoke("select", "value.*", list()) %>% 
  invoke("createOrReplaceTempView", name)
  tbl(sc, name)
}

stream_write_kafka_avro <- function(sc, topic, dataFrame, kafkaUrl, schemaRegistryUrl,
                   valueSchemaNamingStrategy= "topic.name", avroRecordName="RecordName",
				   avroRecordNamespace= "RecordNamespace", checkPointLocation="a") {
  dataFrame %>%
  invoke_static(sc, "sparklyr.confluent.avro.Bridge", "stream_write", topic, dataFrame=., kafkaUrl, schemaRegistryUrl, valueSchemaNamingStrategy, avroRecordName,avroRecordNamespace, checkPointLocation)
}
