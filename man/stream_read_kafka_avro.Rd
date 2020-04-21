\name{stream_read_kafka_avro}
\alias{stream_read_kafka_avro}
\title{read kafka avro topic}
\usage{
stream_read_kafka_avro(sc, "topic.name", startingOffsets="earliest") 
}
\arguments{
  \item{sc}{spark context}

  \item{topic}{A character, topic name}
  
  \item{master} spark master url
  
  \item{startingOffsets} "earliest" or "latest"
  
  \item{kafkaUrl} kafka broker url
  
  \item{schemaRegistryUrl} confluent schema registry url
  
  \item{logLevel} a character, the desired log level
  
  \item{jobName} a character, the spark job name
  
}
\value{
returns a spark stream with decoded avro messages as struct
}
\description{
decode avro encoded kafka topic stream
}