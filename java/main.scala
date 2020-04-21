package sparklyudf

import java.util.Properties

import org.apache.spark.sql.functions.col
import org.apache.spark.sql.{DataFrame, Dataset, Row}
import za.co.absa.abris.examples.utils.ExamplesUtils._
import org.apache.spark.sql.SparkSession
import za.co.absa.abris.avro.functions.from_confluent_avro

object Reader {
  
  def stream(topic: String, master: String = "local[*]", startingOffsets: String = "latest", kafkaUrl: String = "broker:9092",
             schemaRegistryUrl: String = "http://schema-registry:8081", logLevel: String = "ERROR", jobName: String = "sample") = {
    val properties = new Properties()
	properties.setProperty("job.name", jobName)
	properties.setProperty("job.master", master)
	properties.setProperty("key.schema.id", "latest")
	properties.setProperty("value.schema.id", "latest")
	properties.setProperty("value.schema.naming.strategy", "topic.name")
	properties.setProperty("schema.name", "native_complete")
	properties.setProperty("schema.registry.topic", topic)
	properties.setProperty("option.subscribe", topic)
	properties.setProperty("schema.namespace", "all-types.test")
	properties.setProperty("key.schema.id", "latest")
	properties.setProperty("log.level", logLevel)
	properties.setProperty("schema.registry.url", schemaRegistryUrl)
	val spark = getSparkSession(properties, "job.name", "job.master", "log.level")
	val schemaRegistryConfig = properties.getSchemaRegistryConfigurations("option.subscribe")
    val stream = spark.readStream.format("kafka").option("startingOffsets", startingOffsets).option("kafka.bootstrap.servers", kafkaUrl).addOptions(properties)
    stream.load().select(from_confluent_avro(col("value"), schemaRegistryConfig) as 'data)
  }
}