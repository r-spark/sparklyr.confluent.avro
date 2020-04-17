package sparklyudf

import org.apache.spark.sql.avro.SchemaConverters
import io.confluent.kafka.schemaregistry.client.{CachedSchemaRegistryClient, SchemaRegistryClient}
import io.confluent.kafka.serializers.AbstractKafkaAvroDeserializer
import org.apache.avro.Schema
import org.apache.avro.generic.GenericRecord
import org.apache.spark.sql.SparkSession

object Main {
  class AvroDeserializer extends AbstractKafkaAvroDeserializer {
    def this(client: SchemaRegistryClient) {
      this()
      this.schemaRegistry = client
    }

    override def deserialize(bytes: Array[Byte]): String = {
      val genericRecord = super.deserialize(bytes).asInstanceOf[GenericRecord]
      genericRecord.toString
    }
  }
  
  def register_deserialize(spark: SparkSession, schemaRegistryUrl: String) = {
    val schemaRegistryClient = new CachedSchemaRegistryClient(schemaRegistryUrl, 128)
    val kafkaAvroDeserializer = new AvroDeserializer(schemaRegistryClient)
	object DeserializerWrapper {
	  val client=schemaRegistryClient
      val deserializer = kafkaAvroDeserializer
	  def getSchema(topic: String) {
	    val avroSchema = schemaRegistryClient.getLatestSchemaMetadata(topic + "-value").getSchema
        SchemaConverters.toSqlType(new Schema.Parser().parse(avroSchema))
	  }
    }
	spark.udf.register("deserialize", (bytes: Array[Byte]) => {
      DeserializerWrapper.deserializer.deserialize(bytes)
	  }
    )
  }
  
  def register_getSchema(spark: SparkSession, schemaRegistryUrl: String) = {
   val schemaRegistryClient = new CachedSchemaRegistryClient(schemaRegistryUrl, 128)
    val kafkaAvroDeserializer = new AvroDeserializer(schemaRegistryClient)
	object DeserializerWrapper {
	  val client=schemaRegistryClient
      val deserializer = kafkaAvroDeserializer
	  def getSchema(topic: String) {
	    val avroSchema = schemaRegistryClient.getLatestSchemaMetadata(topic + "-value").getSchema
        SchemaConverters.toSqlType(new Schema.Parser().parse(avroSchema))
	  }
    }
	spark.udf.register("getSchema", DeserializerWrapper.getSchema(_))
  }
  
}
