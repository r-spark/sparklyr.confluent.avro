#' @import sparklyr
#' @export
stream_read_kafka_avro <- function (sc, kafka.bootstrap.servers, schema.registry.topic, schema.registry.url, startingOffsets="latest", 
                                    key.schema.naming.strategy="record.name", key.schema.id="latest",
                                    value.schema.naming.strategy="topic.name", value.schema.id="latest", name = NULL, ...) {
 if(is.null(name)) {
    name <- schema.registry.topic
  }
  registryConfig <- new.env()
  registryConfig$schema.registry.topic <- schema.registry.topic
  registryConfig$schema.registry.url <- schema.registry.url
  registryConfig$key.schema.naming.strategy <- key.schema.naming.strategy
  registryConfig$value.schema.id <- key.schema.id
  registryConfig$value.schema.naming.strategy <- value.schema.naming.strategy
  registryConfig$value.schema.id <- value.schema.id
  stream_read_kafka(sc, options=list(kafka.bootstrap.servers = kafka.bootstrap.servers, subscribe = registryConfig$schema.registry.topic, startingOffsets=startingOffsets)) %>%
  spark_dataframe() %>%
  invoke("select", list(
                        invoke(invoke_static(sc, "za.co.absa.abris.avro.functions", "from_confluent_avro", invoke_static(sc, "org.apache.spark.sql.functions", "col", "key"), registryConfig), "as", "key"),
                        invoke(invoke_static(sc, "za.co.absa.abris.avro.functions", "from_confluent_avro", invoke_static(sc, "org.apache.spark.sql.functions", "col", "value"), registryConfig), "as", "value"))) %>%
  invoke("select", list("key", "value.*"))%>%
  invoke("createOrReplaceTempView", name)
  tbl(sc, name)
}

#' @import sparklyr
#' @export
#' one column needs to be named key
stream_write_kafka_avro <- function (x, kafka.bootstrap.servers, schema.registry.topic, schema.registry.url, 
    mode = c("append", "complete", "update"), trigger = stream_trigger_interval(), 
    checkpoint = file.path("checkpoints", random_string("")),
	key.schema.naming.strategy="record.name",
	value.schema.naming.strategy="topic.name", schema.name="record", schema.namespace="namespace", 
    options = list(), ...) {
  registryConfig <- new.env()
  registryConfig$schema.registry.topic <- schema.registry.topic
  registryConfig$schema.registry.url <- schema.registry.url
  registryConfig$key.schema.naming.strategy <- key.schema.naming.strategy
  registryConfig$value.schema.naming.strategy <- value.schema.naming.strategy
  registryConfig$schema.name <- schema.name
  registryConfig$schema.namespace <- schema.namespace
  x %>%
  spark_dataframe() %>%
  invoke("select", list(invoke(invoke_static(sc, "org.apache.spark.sql.functions", "struct", head(invoke(., "columns"), 1)[[1]], tail(invoke(., "columns"), -1)), "as", "value"))) %>%
  invoke("select", list(
                        invoke(invoke_static(sc, "za.co.absa.abris.avro.functions", "to_confluent_avro", invoke_static(sc, "org.apache.spark.sql.functions", "col", "key"), registryConfig), "as", "key"),
                        invoke(invoke_static(sc, "za.co.absa.abris.avro.functions", "to_confluent_avro", invoke_static(sc, "org.apache.spark.sql.functions", "col", "value"), registryConfig), "as", "value")
					    )
		) %>% 
  stream_write_kafka(options=list(kafka.bootstrap.servers = kafka.bootstrap.servers, topic = schema.registry.topic), mode=mode, trigger=trigger, checkpoint=checkpoint) 
}