sparklyr extension package to support deserializing Confluent Schema Registry avro encoded messages.

You can find a Vagrant/docker-compose playground to test it over here: 

https://github.com/HikaGenji/sparklyr.confluent.avro.playground

Some sample usage:

```
library(sparklyr.confluent.avro)
library(sparklyr)
library(dplyr)

config <- spark_config()
config$sparklyr.shell.packages <- "io.confluent:kafka-avro-serializer:5.4.1,io.confluent:kafka-schema-registry:5.4.1,org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.5,org.apache.spark:spark-avro_2.11:2.4.5,za.co.absa:abris_2.11:3.1.1"
config$sparklyr.shell.repositories <- "http://packages.confluent.io/maven/"

sc <- spark_connect(master = "local", spark_home = "spark", config=config)

stream_read_kafka_avro(sc, "parameter", startingOffsets="earliest") %>%
stream_write_memory("p")

# sql style 'eager' returns an R dataframe
query <- 'select value.timestamp, value.side, value.id from p'
res   <- DBI::dbGetQuery(sc, statement =query)

# dbplyr style 'lazy' returns a spark dataframe stream
query %>%
dbplyr::sql() %>%
tbl(sc, .) %>%
group_by(id) %>%
summarise(n=count()) 

# read avro data, unstruct and push to avro data (stream_write_avro wraps columns into a struct automatically)
stream_read_kafka_avro(sc, "parameter", startingOffsets="earliest") %>%
invoke("select", "value.timestamp", list("value.id", "value.side")) %>%
stream_write_kafka_avro(sc, topic="output", dataFrame=.)

# read avro data and push to memory
stream_read_kafka_avro(sc, "output", startingOffsets="earliest") %>%
invoke("select", "value.timestamp", list("value.id", "value.side")) %>%
sdf_register() %>%
mutate(side=2*side) %>%
group_by(id) %>%
summarise(n=count()) %>%
stream_write_memory("q")

# sql style 'eager' returns an R dataframe
query <- 'select value.timestamp, value.side, value.id from q'
res   <- DBI::dbGetQuery(sc, statement =query)

# query from memory
'select value.timestamp as timestamp, value.side as side, value.id as id from q' %>%
dbplyr::sql() %>%
tbl(sc, .) %>%
stream_write_memory("u")
````
