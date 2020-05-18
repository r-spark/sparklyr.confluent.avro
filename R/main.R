#' @import sparklyr
#' @export
stream_read_kafka_avro <- function (sc, kafka.bootstrap.servers, schema.registry.topic, schema.registry.url, startingOffsets="latest", 
                                    key.schema.id="latest", key.schema.naming.strategy="topic.name",
                                    value.schema.naming.strategy="topic.name", value.schema.id="latest", 
									name = NULL, ...) {
 if(is.null(name)) {
    name <- schema.registry.topic
  }
  keyRegistryConfig <- new.env()
  keyRegistryConfig$schema.registry.topic <- schema.registry.topic
  keyRegistryConfig$schema.registry.url <- schema.registry.url
  keyRegistryConfig$key.schema.naming.strategy <- key.schema.naming.strategy
  keyRegistryConfig$key.schema.id <- key.schema.id
  valueRegistryConfig <- new.env()
  valueRegistryConfig$schema.registry.topic <- schema.registry.topic
  valueRegistryConfig$schema.registry.url <- schema.registry.url
  valueRegistryConfig$value.schema.naming.strategy <- value.schema.naming.strategy
  valueRegistryConfig$value.schema.id <- value.schema.id
 
  t <- stream_read_kafka(sc, options=list(kafka.bootstrap.servers = kafka.bootstrap.servers, subscribe = valueRegistryConfig$schema.registry.topic, startingOffsets=startingOffsets)) %>%
       spark_dataframe() %>%
       invoke("select", list(
                        invoke(invoke_static(sc, "za.co.absa.abris.avro.functions", "from_confluent_avro", invoke_static(sc, "org.apache.spark.sql.functions", "col", "key"), keyRegistryConfig), "as", "key"),
                        invoke(invoke_static(sc, "za.co.absa.abris.avro.functions", "from_confluent_avro", invoke_static(sc, "org.apache.spark.sql.functions", "col", "value"), valueRegistryConfig), "as", "value")))
  keyCol   <- t %>% invoke("select", "key.*", list()) %>% invoke("columns") %>% unlist
  valueCol <- t %>% invoke("select", "value.*", list()) %>% invoke("columns") %>% unlist 
  
  if(all(keyCol %in% valueCol)) {
    t %>% invoke("select", "value.*", list()) %>%
    invoke("createOrReplaceTempView", name)
  } else {
    t %>% invoke("select", "value.*", list(paste0("key.", keyCol))) %>%
    invoke("createOrReplaceTempView", name)
  }
  tbl(sc, name)
}

#' @import sparklyr
#' @export
#' one column needs to be named key
stream_write_kafka_avro <- function (x, kafka.bootstrap.servers, schema.registry.topic, schema.registry.url, 
    mode = c("append", "complete", "update"), trigger = stream_trigger_interval(), 
    checkpoint = file.path("checkpoints", random_string("")), key.schema.naming.strategy="topic.name",
	value.schema.naming.strategy="topic.name", schema.namespace="namespace", keyCols="key",
    options = list(), ...) {
  keyRegistryConfig <- new.env()
  keyRegistryConfig$schema.registry.topic <- schema.registry.topic
  keyRegistryConfig$schema.registry.url <- schema.registry.url
  keyRegistryConfig$key.schema.naming.strategy <- key.schema.naming.strategy
  keyRegistryConfig$schema.name <- "key"
  keyRegistryConfig$schema.namespace <- schema.namespace
  valueRegistryConfig <- new.env()
  valueRegistryConfig$schema.registry.topic <- schema.registry.topic
  valueRegistryConfig$schema.registry.url <- schema.registry.url
  valueRegistryConfig$schema.name <- "value"
  valueRegistryConfig$value.schema.naming.strategy <- value.schema.naming.strategy
  valueRegistryConfig$schema.namespace <- schema.namespace
  x %>%
  spark_dataframe() %>%
  invoke("select", list(invoke(invoke_static(sc, "org.apache.spark.sql.functions", "struct", head(keyCols, 1), as.list(tail(keyCols, -1))), "as", "key"),
                        invoke(invoke_static(sc, "org.apache.spark.sql.functions", "struct", head(invoke(., "columns"), 1)[[1]], tail(invoke(., "columns"), -1)), "as", "value"))) %>%
  invoke("select", list(
                        invoke(invoke_static(sc, "za.co.absa.abris.avro.functions", "to_confluent_avro", invoke_static(sc, "org.apache.spark.sql.functions", "col", "key"), keyRegistryConfig), "as", "key"),
                        invoke(invoke_static(sc, "za.co.absa.abris.avro.functions", "to_confluent_avro", invoke_static(sc, "org.apache.spark.sql.functions", "col", "value"), valueRegistryConfig), "as", "value")
					    )
		) %>% 
  stream_write_kafka(options=list(kafka.bootstrap.servers = kafka.bootstrap.servers, topic = schema.registry.topic), mode=mode, trigger=trigger, checkpoint=checkpoint) 
}