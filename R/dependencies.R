spark_dependencies <- function(spark_version, scala_version, ...) {
  sparklyr::spark_dependency(
    jars = c(
      system.file(
        "java/sparklyudf-2.4-5_2.11.jar",
        package = "sparklyudf"
      ), 
	  system.file(
        "java/spark-schema-registry-0.1-SNAPSHOT-jar-with-dependencies.jar",
        package = "sparklyudf"
      ),
	  
	  system.file(
        "java/spark-sql-kafka-0-10_2.11-2.4.5.jar",
        package = "sparklyudf"
      )
    )
  )
}

#' @import sparklyr
.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
