package sparklyudf

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
  
  def create_deserializer(spark: SparkSession, kafkaUrl: String, schemaRegistryUrl: String) = {
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
	spark.udf.register("deserialize", (bytes: Array[Byte]) =>
      DeserializerWrapper.deserializer.deserialize(bytes)
    )
	spark.udf.register("getAvroSchema", (topic: String) =>
      DeserializerWrapper.getSchema(topic)
    )
	
  }
  
}
