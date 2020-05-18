\name{stream_write_kafka_avro}
\alias{stream_write_kafka_avro}
\title{write kafka avro topic}
\usage{
stream_write_kafka_avro(kafka.bootstrap.servers=kafkaUrl, schema.registry.topic="output", schema.registry.url=schemaRegistryUrl) 

}
\arguments{
  \item{x}{spark stream}

  \item{kafka.bootstrap.servers}{kafka brokers url}
  \item{schema.registry.topic,}{A character, topic name}
  \item{schemaRegistryUrl}{confluent schema registry url}  
  
  \item{mode}{Specifies how data is written to a streaming sink. Valid values are
\code{"append"}, \code{"complete"} or \code{"update"}.}

\item{trigger}{The trigger for the stream query, defaults to micro-batches runnnig
every 5 seconds. See \code{\link{stream_trigger_interval}} and
\code{\link{stream_trigger_continuous}}.}

\item{checkpoint}{The location where the system will write all the checkpoint
information to guarantee end-to-end fault-tolerance.}

  \item{key.schema.naming.strategy}{key schema naming strategy}
      \item{value.schema.naming.strategy}{value schema naming strategy}
	  \item{schema.namespace}{schema namespace}
	  \item{key cols}{columns part of the key}
  
}
\value{
 nothing
}
\description{
encode avro
}