\name{stream_read_kafka_avro}
\alias{stream_read_kafka_avro}
\title{read kafka avro topic}
\usage{
stream_read_kafka_avro(sc, kafka.bootstrap.servers=kafkaUrl, schema.registry.topic="parameter", startingOffsets="earliest", schema.registry.url=schemaRegistryUrl)
}
\arguments{
  \item{sc}{spark context}
  \item{kafka.bootstrap.servers}{kafka brokers url}
  \item{schema.registry.topic,}{A character, topic name}
  \item{schemaRegistryUrl}{confluent schema registry url}  
  \item{startingOffsets}{"earliest" or "latest"}
  \item{key.schema.naming.strategy}{key schema naming strategy}
  \item{value.schema.naming.strategy}{value schema naming strategy}
  \item{key.schema.id}{key schema id}
  \item{value.schema.id}{value schema id}
  \item{name}{view name if any}
  
}
\value{
returns a spark stream
}
\description{
decode avro encoded kafka topic stream
}