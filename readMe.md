sparklyr extension package to support deserializing Confluent Schema Registry avro encoded messages.

You can find a Vagrant/docker-compose playground to test it over here: 

https://github.com/HikaGenji/sparklyr.confluent.avro.playground

Some sample usage:

```
library(sparklyr.confluent.avro)
library(sparklyr)
library(dplyr)

config <- spark_config()
kafkaUrl <- "broker:9092"
schemaRegistryUrl <- "http://schema-registry:8081"
sc <- spark_connect(master = "spark://spark-master:7077", spark_home = "spark", config=config)

stream_read_kafka_avro(sc, kafka.bootstrap.servers=kafkaUrl, schema.registry.topic="parameter", startingOffsets="earliest", schema.registry.url=schemaRegistryUrl) %>%
mutate(qty=side ^ 2) %>%
stream_write_kafka_avro(kafka.bootstrap.servers=kafkaUrl, schema.registry.topic="output", schema.registry.url=schemaRegistryUrl) 

stream_read_kafka_avro(sc, kafka.bootstrap.servers=kafkaUrl, schema.registry.topic="output", startingOffsets="earliest", schema.registry.url=schemaRegistryUrl) 

# sql style 'eager' returns an R dataframe
query <- 'select * from output'
res   <- DBI::dbGetQuery(sc, statement =query)

# dbplyr style 'lazy' returns a spark dataframe stream
query %>%
dbplyr::sql() %>%
tbl(sc, .) %>%
group_by(id) %>%
summarise(n=count())


t <- tbl(sc, "output") %>%
groupBy(c(window(., "timestamp", "10 seconds", "5 seconds"), col(., "id"))) %>%
agg(count(side*side))

tbl(sc, "output") %>%
groupBy(c(window(., "timestamp", "10 seconds", "5 seconds"), col(., "id"))) %>%
agg(avg(side), avg(id))
````
