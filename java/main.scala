package sparkavroudf

object AvroUtils {
  def fromAvro(dataset: org.apache.spark.sql.DataFrame, column: org.apache.spark.sql.Column, schema: String) = {
    dataset.select(org.apache.spark.sql.avro.from_avro(column, schema))
  }
  
  def toAvro(dataset: org.apache.spark.sql.DataFrame, column: org.apache.spark.sql.Column) = {
    dataset.select(org.apache.spark.sql.avro.to_avro(column))
  }
}
