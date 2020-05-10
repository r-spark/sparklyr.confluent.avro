\name{stream_read_kafka_avro}
\alias{stream_read_kafka_avro}
\title{read kafka avro topic}
\usage{
stream_read_kafka_avro(sc, "topic.name", startingOffsets="earliest") 
}
\arguments{
  \item{sc}{spark context}
  \item{kafka.bootstrap.servers}{kafka brokers url}
  \item{schema.registry.topic,}{A character, topic name}
  \item{schemaRegistryUrl}{confluent schema registry url}  
  \item{startingOffsets}{"earliest" or "latest"}
  
  \item{value.schema.naming.strategy}{schema naming strategy}
 
  \item{value.schema.id}{schema id}
  \item{name}{view name if any}
  
}
\value{
returns a spark stream
}
\description{
decode avro encoded kafka topic stream
}