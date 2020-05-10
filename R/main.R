#' @import sparklyr
#' @export
stream_read_kafka_avro <- function (sc, kafka.bootstrap.servers, schema.registry.topic, startingOffsets, 
                                    schema.registry.url, value.schema.naming.strategy, value.schema.id, name = NULL, ...) {
 if(is.null(name)) {
    name <- topic
  }
  registryConfig <- new.env()
  registryConfig$schema.registry.topic <- schema.registry.topic
  registryConfig$schema.registry.url <- schema.registry.url
  registryConfig$value.schema.naming.strategy <- value.schema.naming.strategy
  registryConfig$value.schema.id <- value.schema.id
  stream_read_kafka(sc, options=list(kafka.bootstrap.servers = kafka.bootstrap.servers, subscribe = schema.registry.topic, startingOffsets=startingOffsets)) %>%
  spark_dataframe() %>%
  invoke("select", list(invoke(invoke_static(sc, "za.co.absa.abris.avro.functions", "from_confluent_avro", invoke_static(sc, "org.apache.spark.sql.functions", "col", "value"), registryConfig), "as", "value"))) %>%
  invoke("select", "value.*", list())%>%
  invoke("createOrReplaceTempView", name)
  tbl(sc, name)
}

#' @import sparklyr
#' @export
stream_write_kafka_avro <- function (x, mode = c("append", "complete", "update"), trigger = stream_trigger_interval(), 
    checkpoint = file.path("checkpoints", random_string("")), kafka.bootstrap.servers, schema.registry.topic, schema.registry.url, 
	value.schema.naming.strategy, schema.name, schema.namespace,
    options = list(), ...) {
  registryConfig <- new.env()
  registryConfig$schema.registry.topic <- schema.registry.topic
  registryConfig$schema.registry.url <- schema.registry.url
  registryConfig$value.schema.naming.strategy <- value.schema.naming.strategy
  registryConfig$schema.name <- schema.name
  registryConfig$schema.namespace <- schema.namespace
  x %>%
  spark_dataframe() %>%
  invoke("select", list(invoke(invoke_static(sc, "org.apache.spark.sql.functions", "struct", head(invoke(., "columns"), 1)[[1]], tail(invoke(., "columns"), -1)), "as", "value"))) %>%
  invoke("select", list(invoke(invoke_static(sc, "za.co.absa.abris.avro.functions", "to_confluent_avro", invoke_static(sc, "org.apache.spark.sql.functions", "col", "value"), writeRegistryConfig), "as", "value"))) %>% 
  stream_write_kafka(options=list(kafka.bootstrap.servers = kafka.bootstrap.servers, topic = schema.registry.topic)) 
}