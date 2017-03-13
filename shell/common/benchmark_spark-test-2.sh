# Benchmark to test Hive installation and configurations
source_file "$ALOJA_REPO_PATH/shell/common/common_TPC-H.sh"
SPARK_VERSION="spark-2.0.2" #use full folder name


source_file "$ALOJA_REPO_PATH/shell/common/common_spark.sh"
set_spark_requires

[ ! "$BENCH_LIST" ] && BENCH_LIST="SparkPi"
execute_hadoop_new "$bench_name" "fs -mkdir -p /tmp/{output,$native_spark_folder}"



# Implement only the different functionality

benchmark_suite_config() {
  initialize_hadoop_vars
  prepare_hadoop_config "$NET" "$DISK" "$BENCH_SUITE"
  start_hadoop

  initialize_spark_vars
  prepare_spark_config
}

benchmark_suite_cleanup() {
  clean_hadoop
}

benchmark_spark-version() {
  local bench_name="${FUNCNAME[0]##*benchmark_}"
  logger "INFO: Running $bench_name"

  execute_spark "$bench_name" "--version" "time"
}

benchmark_SparkPi() {
  tpc-h_datagen_only
  echo "======================================================SparkPi=========================================================="
  #local bench_name="${FUNCNAME[0]##*benchmark_}"
  #logger "INFO: Running $bench_name"

  #local pi_size="100" # Defaults 100 pis if not overidden
  #[ "$BENCH_EXTRA_CONFIG" ] && pi_size="$BENCH_EXTRA_CONFIG"

  #if [ "$(get_spark_major_version)" == "2" ]; then
  #  execute_spark "$bench_name" "--class org.apache.spark.examples.SparkPi $SPARK_HOME/examples/jars/spark-examples*.jar $pi_size" "time"
  #else
  #  execute_spark "$bench_name" "--class org.apache.spark.examples.SparkPi $SPARK_HOME/lib/spark-examples*.jar $pi_size" "time"
  #fi
  logger "Running TPCH on native Spark"
  execute_spark "$bench_name" "--class main.scala.TpchQuery /vagrant/blobs/aplic2/tarballs/spark-tpc-h-queries_2.11-1.0.jar 4" "time"
}
