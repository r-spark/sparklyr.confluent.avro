spark_dependencies <- function(spark_version, scala_version, ...) {
  sparklyr::spark_dependency(
    jars = c(
      system.file(
        sprintf("java/sparklyudf-%s-%s.jar", spark_version, scala_version),
        package = "sparklyudf"
      )
    ),
    packages = c("org.apache.spark:spark-avro_2.11:2.4.5", "org.apache.avro:avro:1.9.2", 
	            "kafka-schema-registry-5.4.1.kafka-avro-serializer:5.4.1", "io.confluent:kafka-schema-registry-client:5.4.1",
				"io.confluent:kafka-schema-registry:5.4.1", "org.apache.kafka:kafka-clients:5.4.1-ce")
  )
}

#' @import sparklyr
.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
