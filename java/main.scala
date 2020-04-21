package sparklyudf

import java.util.Properties

import org.apache.spark.sql.functions.col
import org.apache.spark.sql.{DataFrame, Dataset, Row}
import za.co.absa.abris.examples.utils.ExamplesUtils._
import org.apache.spark.sql.SparkSession
import za.co.absa.abris.avro.functions.from_confluent_avro

object Reader {
  val PARAM_JOB_MASTER = "job.master"
  val PARAM_JOB_NAME = "job.name"
  val PARAM_LOG_LEVEL = "log.level"
  val kafkaUrl = "broker:9092"
  val schemaRegistryUrl="http://schema-registry:8081"
  
  def stream(topic: String) = {
    val properties = new Properties()
	properties.setProperty("job.name", "SampleJob")
	properties.setProperty("job.master", "local[*]")
	properties.setProperty("key.schema.id", "latest")
	properties.setProperty("value.schema.id", "latest")
	properties.setProperty("value.schema.naming.strategy", "topic.name")
	properties.setProperty("schema.name", "native_complete")
	properties.setProperty("schema.registry.topic", topic)
	properties.setProperty("option.subscribe", topic)
	properties.setProperty("schema.namespace", "all-types.test")
	properties.setProperty("key.schema.id", "latest")
	properties.setProperty("log.level", "ERROR")
	properties.setProperty("schema.registry.url", schemaRegistryUrl)
	val spark = getSparkSession(properties, PARAM_JOB_NAME, PARAM_JOB_MASTER, PARAM_LOG_LEVEL)
	val schemaRegistryConfig = properties.getSchemaRegistryConfigurations("option.subscribe")
    val stream = spark.readStream.format("kafka").option("startingOffsets", "earliest").option("kafka.bootstrap.servers", kafkaUrl).addOptions(properties)
    stream.load().select(from_confluent_avro(col("value"), schemaRegistryConfig) as 'data)
  }
}