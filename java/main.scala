package sparklyudf

import com.hortonworks.spark.registry.util._
import org.apache.spark.sql.Column

object Main {
  val schemaRegistryUrl = "http://schema-registry:8081"
  import spark.implicits._
  val config = Map[String, Object]("schema.registry.url" -> schemaRegistryUrl)
  implicit val srConfig: SchemaRegistryConfig = SchemaRegistryConfig(config)
  
  def register_deserialize(spark: SparkSession, schemaRegistryUrl: String) = {
	spark.udf.register("deserialize", (data: Column, topic: String) => {
      from_sr(bytes, topic)
	  }
    )
  }
  
}
