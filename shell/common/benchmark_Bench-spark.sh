# TPC-H benchmark from Todor Ivanov https://github.com/t-ivanov/D2F-Bench/
# Benchmark to test Spark installation and configurations

source_file "$ALOJA_REPO_PATH/shell/common/common_TPC-H.sh"

SPARK_VERSION="spark-2.0.2" #use full folder name

source_file "$ALOJA_REPO_PATH/shell/common/common_spark.sh"
set_spark_requires

#Override BENCH_LIST from common_TPCH.sh
#BENCH_LIST="$(seq 22)"
BENCH_LIST="4"


benchmark_suite_run() {
  logger "INFO: Running $BENCH_SUITE"
  

  bench_name="Native_Spark-TPCH"
  native_spark_folder="nativeSpark"
  nativeSparkJarPath="/vagrant/blobs/aplic2/tarballs"
  hdfsfolder="/tmp/$native_spark_folder"  
  
  #Create Output folder
  execute_hadoop_new "$bench_name" "fs -mkdir -p /tmp/{output,$native_spark_folder}"
  execute_hadoop_new "$bench_name" "fs -copyFromLocal /vagrant/blobs/aplic2/tarballs/spark-tpc-h-queries_2.11-1.0.jar /tmp/$native_spark_folder"
  
  tpc-h_datagen_only

  BENCH_CURRENT_NUM_RUN="1" #reset the global counter

  # Iterate at least one time
  while true; do
    [ "$BENCH_NUM_RUNS" ] && logger "INFO: Starting iteration $BENCH_CURRENT_NUM_RUN of $BENCH_NUM_RUNS"

    for query in $BENCH_LIST ; do
      logger "INFO: RUNNING Query $query of $BENCH_NUM_RUNS runs"
      execute_tpchquery_spark "$query"
    done

    # Check if requested to iterate multiple times
    if [ ! "$BENCH_NUM_RUNS" ] || [[ "$BENCH_CURRENT_NUM_RUN" -ge "$BENCH_NUM_RUNS" ]] ; then
      break
    else
      BENCH_CURRENT_NUM_RUN="$((BENCH_CURRENT_NUM_RUN + 1))"
    fi
  done

  logger "INFO: DONE executing $BENCH_SUITE"
}

# $1 query number
execute_tpchquery_spark() {
  local query="$1"
  #execute_spark "$bench_name" "--class \"main.scala.TpchQuery\" --master local $nativeSparkJarPath/spark-tpc-h-queries_2.11-1.0.jar $query" "time"
  execute_spark "$bench_name" "--class \"main.scala.TpchQuery\" --executor-memory 500mb --master yarn $nativeSparkJarPath/spark-tpc-h-queries_2.11-1.0.jar $query" "time"
  #execute_spark "$bench_name" "--class \"main.scala.TpchQuery\" --driver-memory 1g --executor-memory 1g --executor-cores 1 --master yarn /tmp/$native_TPCH_folder/spark-tpc-h-queries_2.11-1.0.jar 4" "time"
}
