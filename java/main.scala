package sparklyudf

import com.hortonworks.spark.registry.util._
import org.apache.spark.sql.Column
import org.apache.spark.sql.SparkSession

object Main {
  val schemaRegistryUrl = "http://schema-registry:8081"
  val config = Map[String, Object]("schema.registry.url" -> schemaRegistryUrl)
  implicit val srConfig: SchemaRegistryConfig = SchemaRegistryConfig(config)
  
  def register_deserialize(spark: SparkSession, schemaRegistryUrl: String) = {
    import spark.implicits._
	spark.udf.register("deserialize", (data: Column, topic: String) => {
      from_sr(data, topic)
	  }
    )
  }
  
}
