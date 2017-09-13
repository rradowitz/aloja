# TPC-H benchmark from Todor Ivanov https://github.com/t-ivanov/D2F-Bench/
# Benchmark to test Spark installation and configurations
SPARK_HIVE="spark_hive-2.1.1"

source_file "$ALOJA_REPO_PATH/shell/common/common_TPC-H.sh"

source_file "$ALOJA_REPO_PATH/shell/common/common_spark.sh"
set_spark_requires

#BENCH_LIST="$(seq -f "tpch_query%g" -s " " 21 22)"
#BENCH_LIST="tpch_query22"
#BENCH_LIST="tpch_query2_2 tpch_query2_4 tpch_query2_8 tpch_query2_9 tpch_query2_11 tpch_query2_15 tpch_query2_16 tpch_query2_17 tpch_query2_18 tpch_query2_19 tpch_query2_20 tpch_query2_21 tpch_query2_22"
#BENCH_LIST="tpch_query11 tpch_query15 tpch_query17 tpch_query18 tpch_query21 tpch_query22"
BENCH_LIST="tpch_query2_2 tpch_query2_4 tpch_query2_8 tpch_query2_9 tpch_query2_11 tpch_query2_15 tpch_query2_16 tpch_query2_17 tpch_query2_18 tpch_query2_19 tpch_query2_20"
#BENCH_LIST="tpch_query2_21"

benchmark_suite_run() {
  logger "INFO: Running $BENCH_SUITE"

  tpc-h_datagen

  execute_hadoop_new "$bench_name" "fs -mkdir -p /user/enventLog"

  BENCH_CURRENT_NUM_RUN="1" #reset the global counter
   
  if [ ! -d "$SPARK_CONF_DIR" ]; then
    SPARK_CONF_DIR="$(get_spark_conf_dir)" 
    #local_prepare_config
    initialize_spark_vars
    prepare_spark_config
  fi	

  # Iterate at least one time
  while true; do
    [ "$BENCH_NUM_RUNS" ] && logger "INFO: Starting iteration $BENCH_CURRENT_NUM_RUN of $BENCH_NUM_RUNS"

    for query in $BENCH_LIST ; do
      logger "INFO: RUNNING $query of $BENCH_NUM_RUNS runs"
      execute_query_spark "$query"
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
execute_query_spark() {
  local query="$1"
  execute_spark-sql "$query" "-e \"USE $TPCH_DB_NAME; \$(< $D2F_local_dir/tpch/queries/$query.sql)\"" "time"
}

local_prepare_config() {
  # Spark needs the hive-site.xml to access metastore
  # common-spark.sh seems not to work properly
  $DSH "mkdir $SPARK_CONF_DIR"
  $DSH "cp $(get_local_bench_path)/hive_conf/hive-site.xml $SPARK_CONF_DIR/" 
}
