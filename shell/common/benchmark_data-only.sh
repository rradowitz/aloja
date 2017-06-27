# TPC-H benchmark from Todor Ivanov https://github.com/t-ivanov/D2F-Bench/
# Benchmark to test Spark installation and configurations

source_file "$ALOJA_REPO_PATH/shell/common/common_TPC-H.sh"


benchmark_suite_config() {
  initialize_hadoop_vars
  prepare_hadoop_config "$NET" "$DISK" "$BENCH_SUITE"
  start_hadoop

  initialize_spark_vars
  prepare_spark_config
}

benchmark_suite_run() {
  
  echo "===============================================================================================================================================" 
  echo "Datagen MR start" 
  echo "TPCH_HDFS_DIR:	$TPCH_HDFS_DIR" 
  echo "SF:		$TPCH_SCALE_FACTOR"
  echo "Local SF:	$TPCH_USE_LOCAL_FACTOR"  
  echo "DB-Name:	$TPCH_DB_NAME"
  echo "FileFormat:	$BENCH_FILE_FORMAT"
  echo "===============================================================================================================================================" 

  tpc-h_datagen_only

 
}


