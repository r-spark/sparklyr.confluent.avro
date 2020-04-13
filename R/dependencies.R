spark_dependencies <- function(spark_version, scala_version, ...) {
  sparklyr::spark_dependency(
    jars = c(
      system.file(
        sprintf("java/sparkavroudf-%s-%s.jar", spark_version, scala_version),
        package = "sparkavroudf"
      )
    ),
    packages = c(
      "org.apache.spark:spark-avro_2.12:2.4.5"
    )
  )
}

#' @import sparklyr
.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
