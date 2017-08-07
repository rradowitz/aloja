# TPC-H benchmark from Todor Ivanov https://github.com/t-ivanov/D2F-Bench/
# Benchmark to test Spark installation and configurations
#SPARK_VERSION=$SPARK2_VERSION
SPARK_VERSION="spark-2.1.1"
SPARK_HIVE="spark_hive-2.1.1"

# Parameter native type text, orc, orc-sql; default: DS
[ ! "$NATIVE_FORMAT" ] && NATIVE_FORMAT="text"

# Parameter native api in combination with orc or orc-sql: possible values DF or DS; default: DS
[ ! "$NATIVE_API" ] && NATIVE_API="DS" 

source_file "$ALOJA_REPO_PATH/shell/common/common_TPC-H.sh"
source_file "$ALOJA_REPO_PATH/shell/common/common_spark.sh"
set_spark_requires
#initialize_spark_vars
#prepare_spark_config

# Setting bench list - queries 1 to 22
BENCH_LIST="$(seq 22)"

# Set Bench name
BENCH_NAME="TPCH-on-Native_Spark"
NATIVE_SPARK_FOLDER_NAME="native_spark-master"

# Required bench files download mirror
BENCH_REQUIRED_FILES["$NATIVE_SPARK_FOLDER_NAME"]="https://github.com/rradowitz/native_spark/archive/master.zip"

# Local
NATIVE_SPARK_LOCAL_DIR="$(get_local_apps_path)/$NATIVE_SPARK_FOLDER_NAME"

# Set scaleFactor for data input dir
SCALE_FACTOR=$TPCH_SCALE_FACTOR
if [ "$TPCH_USE_LOCAL_FACTOR" > 0 ] ; then
  SCALE_FACTOR=$TPCH_USE_LOCAL_FACTOR
fi

if [[ "$NATIVE_FORMAT" == "text" ]]; then
  NATIVE_INPUT_DIR="/tmp/tpch-generate/$SCALE_FACTOR"
  logger "INFO: Setting INPUT_DIR to $NATIVE_INPUT_DIR"
elif [[ "$NATIVE_FORMAT" == "orc" ]]; then
  NATIVE_INPUT_DIR="/apps/hive/warehouse/tpch_orc_${SCALE_FACTOR}.db"
  logger "INFO: Setting INPUT_DIR to $NATIVE_INPUT_DIR"
else
  logger "WARN: NO INPUT_DIR SET"
fi  

# Set output base dir; a subdirectory for each BENCH_CURRENT_NUM_RUN is created
# Info: do not miss last "/"
NATIVE_OUTPUT_DIR="/native_spark/output/"
# Set the output format that; possible values json, csv; default: json
NATIVE_OUT_FORMAT="json" 
# Set if print out; possible values 0 (off) or 1 (on); default: 1
NATIVE_PRINT="1"

benchmark_suite_run() {
  if [[ "$NATIVE_FORMAT" == "text" ]]; then
    logger "INFO: Running $BENCH_SUITE on Text"
  elif [[ "$NATIVE_FORMAT" == "orc" ]]; then
    logger "INFO: Running $BENCH_SUITE on ORC"
  else 
    logger "WARN: NATIVE_FORMAT not choosen for $BENCH_SUITE"
  fi 
  
  tpc-h_datagen

  BENCH_CURRENT_NUM_RUN="1" #reset the global counter

  # Iterate at least one time
  while true; do
    [ "$BENCH_NUM_RUNS" ] && logger "INFO: Starting iteration $BENCH_CURRENT_NUM_RUN of $BENCH_NUM_RUNS"

    for query in $BENCH_LIST ; do
      logger "INFO: RUNNING Query $query -- current run: $BENCH_CURRENT_NUM_RUN"
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
# TODO: inputdir, outputdir, outputformat, println << true false / 0 1
# jar is expecting 7 args [scaleFactor, BenchNum, query, inputdir, outputdir, outputformat, screenprint]
# scaleFactor for data input_dir
# BenchNum for data output_dir
# query for TPCH query
# inputdir for the data input
# outputdir for data output
# format of output [json, csv]
execute_tpchquery_spark() {
  local query="$1"

  if [[ "$NATIVE_FORMAT" == "text" ]]; then
    if [[ "$NATIVE_API" == "DS" ]]; then
      execute_spark "tpch_query_$query" "--class main.scala.TpchQuery $NATIVE_SPARK_LOCAL_DIR/spark-tpc-h-queries_2.11-1.0-TXT-SC-DS.jar $SCALE_FACTOR $BENCH_CURRENT_NUM_RUN $query" "time" 
    elif [[ "$NATIVE_API" == "DF" ]]; then
      execute_spark "tpch_query_$query" "--class main.scala.TpchQuery $NATIVE_SPARK_LOCAL_DIR/spark-tpc-h-queries_2.11-1.0-TXT-SC-DF.jar $SCALE_FACTOR $BENCH_CURRENT_NUM_RUN $query" "time"
    elif [[ "$NATIVE_API" == "DS-spse" ]]; then
      execute_spark "tpch_query_$query" "--class main.scala.TpchQuery $NATIVE_SPARK_LOCAL_DIR/spark-tpc-h-queries_2.11-1.0-TXT-spSe-DS.jar $SCALE_FACTOR $BENCH_CURRENT_NUM_RUN $query" "time" 
    elif [[ "$NATIVE_API" == "DF-spse" ]]; then
      execute_spark "tpch_query_$query" "--class main.scala.TpchQuery $NATIVE_SPARK_LOCAL_DIR/spark-tpc-h-queries_2.11-1.0-TXT-spSe-DF.jar $SCALE_FACTOR $BENCH_CURRENT_NUM_RUN $query" "time"
    else
      logger "WARN: NO API choosen for $BENCH_SUITE" 
    fi 
  elif [[ "$NATIVE_FORMAT" == "orc" ]]; then
    if [[ "$NATIVE_API" == "DS" ]]; then
      execute_spark "tpch_query_$query" "--class main.scala.TpchQuery $NATIVE_SPARK_LOCAL_DIR/spark-tpc-h-queries_2.11-1.0-ORC-DS.jar $SCALE_FACTOR $BENCH_CURRENT_NUM_RUN $query" "time"
    elif [[ "$NATIVE_API" == "DF" ]]; then
      execute_spark "tpch_query_$query" "--class main.scala.TpchQuery $NATIVE_SPARK_LOCAL_DIR/spark-tpc-h-queries_2.11-1.0-ORC-DF.jar $SCALE_FACTOR $BENCH_CURRENT_NUM_RUN $query" "time"
    elif [[ "$NATIVE_API" == "DS-sql" ]]; then
      execute_spark "tpch_query_$query" "--class main.scala.TpchQuery $NATIVE_SPARK_LOCAL_DIR/spark-tpc-h-queries_2.11-1.0-ORC-SQL-DS.jar $SCALE_FACTOR $BENCH_CURRENT_NUM_RUN $query" "time"
    elif [[ "$NATIVE_API" == "DF-sql" ]]; then
      execute_spark "tpch_query_$query" "--class main.scala.TpchQuery $NATIVE_SPARK_LOCAL_DIR/spark-tpc-h-queries_2.11-1.0-ORC-SQL-DF.jar $SCALE_FACTOR $BENCH_CURRENT_NUM_RUN $query" "time"
    else 
      logger "WARN: NO API choosen for $BENCH_SUITE"
    fi    
  fi
}

benchmark_suite_cleanup() {
  clean_hadoop
}
