# TPC-H benchmark from Todor Ivanov https://github.com/t-ivanov/D2F-Bench/
# Benchmark to test Spark installation and configurations

source_file "$ALOJA_REPO_PATH/shell/common/common_TPC-H.sh"

source_file "$ALOJA_REPO_PATH/shell/common/common_spark.sh"
set_spark_requires


benchmark_suite_run() {
  #logger "INFO: Running $BENCH_SUITE"
  bench_name="Native TPCH"
  native_TPCH_folder="nativeTPCH"

  mkdir /tmp/$native_TPCH_folder
  cp /vagrant/blobs/aplic2/tarballs/spark-tpc-h-queries_2.11-1.0.jar /tmp/nativeTPCH/

  tpc-h_datagen

  execute_hadoop_new "$bench_name" "fs -mkdir -p /tmp/{output,$native_TPCH_folder}"

  #execute_hadoop_new "$bench_name" "fs -copyFromLocal /vagrant/blobs/aplic2/tarballs/spark-tpc-h-queries_2.11-1.0.jar /tmp/$native_TPCH_folder"
  
  execute_hadoop_new "$bench_name" "fs -mkdir -p /tmp/tpch-generate/1/{customer,lineitem,nation,orders,part,partsupp,region,supplier}"
  execute_hadoop_new "$bench_name" "fs -copyFromLocal /vagrant/blobs/aplic2/tarballs/indir/customer.tbl /tmp/tpch-generate/1/customer"
  execute_hadoop_new "$bench_name" "fs -copyFromLocal /vagrant/blobs/aplic2/tarballs/indir/lineitem.tbl /tmp/tpch-generate/1/lineitem"
  execute_hadoop_new "$bench_name" "fs -copyFromLocal /vagrant/blobs/aplic2/tarballs/indir/nation.tbl /tmp/tpch-generate/1/nation"
  execute_hadoop_new "$bench_name" "fs -copyFromLocal /vagrant/blobs/aplic2/tarballs/indir/orders.tbl /tmp/tpch-generate/1/orders"
  execute_hadoop_new "$bench_name" "fs -copyFromLocal /vagrant/blobs/aplic2/tarballs/indir/part.tbl /tmp/tpch-generate/1/part"
  execute_hadoop_new "$bench_name" "fs -copyFromLocal /vagrant/blobs/aplic2/tarballs/indir/partsupp.tbl /tmp/tpch-generate/1/partsupp"
  execute_hadoop_new "$bench_name" "fs -copyFromLocal /vagrant/blobs/aplic2/tarballs/indir/region.tbl /tmp/tpch-generate/1/region"
  execute_hadoop_new "$bench_name" "fs -copyFromLocal /vagrant/blobs/aplic2/tarballs/indir/supplier.tbl /tmp/tpch-generate/1/supplier"
  

  echo "Variables"
  echo "$native_TPCH_folder"
   
  echo "Native Spark"
  logger "INFO: Running $bench_name"
  execute_spark "$bench_name" "--class \"main.scala.TpchQuery\" --master local /tmp/$native_TPCH_folder/spark-tpc-h-queries_2.11-1.0.jar 1" "time"

  #BENCH_CURRENT_NUM_RUN="1" #reset the global counter

  # Iterate at least one time
  #while true; do
  #  [ "$BENCH_NUM_RUNS" ] && logger "INFO: Startivi ng iteration $BENCH_CURRENT_NUM_RUN of $BENCH_NUM_RUNS"

  #  for query in $BENCH_LIST ; do
  #    logger "INFO: RUNNING $query of $BENCH_NUM_RUNS runs"
  #    execute_query_spark "$query"
  #  done

    # Check if requested to iterate multiple times
  #  if [ ! "$BENCH_NUM_RUNS" ] || [[ "$BENCH_CURRENT_NUM_RUN" -ge "$BENCH_NUM_RUNS" ]] ; then
  #    break
  #  else
  #    BENCH_CURRENT_NUM_RUN="$((BENCH_CURRENT_NUM_RUN + 1))"
  #  fi
  #done

  #logger "INFO: DONE executing $BENCH_SUITE"
}

# $1 query number
#execute_query_spark() {
  #local query="$1"
  #execute_spark-sql "$query" "-e \"USE $TPCH_DB_NAME; \$(< $D2F_local_dir/tpch/queries/$query.sql)\"" "time"
#}
