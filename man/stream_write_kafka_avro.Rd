\name{stream_write_kafka_avro}
\alias{stream_write_kafka_avro}
\title{write kafka avro topic}
\usage{
stream_write_kafka_avro(sc, "topic.name", x) 
}
\arguments{
  \item{sc}{spark context}

  \item{topic}{A character, topic name}
  
  \item{x}{spark dataframe}
  
}
\value{
 nothing
}
\description{
encode avro
}