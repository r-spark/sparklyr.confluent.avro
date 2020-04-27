package sparklyr.confluent.avro

import java.util.Properties

import org.apache.spark.sql.functions.col
import org.apache.spark.sql.{DataFrame, Dataset, Row}
import za.co.absa.abris.examples.utils.ExamplesUtils._
import org.apache.spark.sql.SparkSession
import za.co.absa.abris.avro.functions.from_confluent_avro
import za.co.absa.abris.avro.functions.to_confluent_avro
import org.apache.spark.sql.functions.struct

object Bridge {
  
  def stream_read(topic: String, master: String = "local[*]", startingOffsets: String = "latest", kafkaUrl: String = "broker:9092",
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
    stream.load().select(from_confluent_avro(col("value"), schemaRegistryConfig) as 'value)
  }
  
  def stream_write(topic: String, dataFrame: Dataset[Row], kafkaUrl: String = "broker:9092", schemaRegistryUrl: String = "http://schema-registry:8081",                
                   valueSchemaNamingStrategy: String = "topic.name", avroRecordName: String = "RecordName",
				   avroRecordNamespace: String = "RecordNamespace") = {
    val registryConfig = Map(
      "schema.registry.topic" -> topic,
      "schema.registry.url" -> schemaRegistryUrl,
      "value.schema.naming.strategy" -> valueSchemaNamingStrategy,
      "schema.name" -> avroRecordName,
      "schema.namespace"-> avroRecordNamespace
      )
	val allColumns = struct(dataFrame.columns.head, dataFrame.columns.tail: _*)
    dataFrame.select(to_confluent_avro(allColumns, registryConfig) as 'value).writeStream.format("kafka").option("kafka.bootstrap.servers", kafkaUrl).option("topic", topic).option("checkpointLocation", "a").start()
  }
}

// val x = bridge.stream_read("parameter")
// Bridge.stream_write("parameter_3", x, "value", avroRecordName="record", avroRecordNamespace="indicator")
// Bridge.stream_read("parameter_3")