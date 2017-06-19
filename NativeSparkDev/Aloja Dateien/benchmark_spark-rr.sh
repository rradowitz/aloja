# Benchmark to test Spark installation and configurations
source_file "$ALOJA_REPO_PATH/shell/common/common_spark.sh"
set_spark_requires
initialize_spark_vars


#BENCH_REQUIRED_FILES["tpch-hive"]="$ALOJA_PUBLIC_HTTP/aplic2/tarballs/tpch-hive.tar.gz"
[ ! "$BENCH_LIST" ] && BENCH_LIST="test-rr"

# Implement only the different functionality


benchmark_suite_run() {

  logger "INFO: Running $BENCH_SUITE"
  for bench in $BENCH_LIST ; do

    # Test Spark
    function_call "benchmark_$bench"

    # Bench Run
    #function_call "benchmark_$bench"
    # Validate (eg. teravalidate)
    #function_call "benchmark_validate_$bench"
    # Clean-up HDFS space (in case necessary)
    #clean_HDFS "$bench_name" "$BENCH_SUITE"

  done

  logger "INFO: DONE executing $BENCH_SUITE"
}

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


benchmark_test-rr(){

  local bench_name="${FUNCNAME[0]##*benchmark_}"
  logger "INFO: Running $bench_name"
  #start_spark
  #$DSH "$SPARK_HOME/bin/spark-shell.sh start"
  #$DSH "$SPARK_HOME/bin/spark-shell start"
  #$DSH "$SPARK_HOME/bin/spark-sql.sh start"
  #$DSH "$SPARK_HOME/bin/spark-sql start"
  #$DSH "$SPARK_HOME/bin/spark-shell.cmd start"

  #local show_databases="use sys;"
  #local local_file_path="$(create_local_file "$bench_name.sql" "$show_databases")"
  #execute_spark "$bench_name" "--version" "time"
  #execute_spark-sql "$bench_name" "-e \"Create Table if not exists cust (id int, name string);\"" "time"
  execute_spark "$bench_name" "-e \"Create Table if not exists cust (id int, name string);\"" "time" "spark-sql"
  execute_spark "$bench_name" "-e \"insert into cust values (1,'HP');\"" "time" "spark-sql"
  execute_spark "$bench_name" "-e \"insert into cust values (2,'Dokbukki');\"" "time" "spark-sql"

  execute_spark "$bench_name" "-e Create Table if not exists cust (id int, name string);" "time" "spark-sql"
  execute_spark "$bench_name" "-e insert into cust values (1,'HP');" "time" "spark-sql"
  execute_spark "$bench_name" "-e insert into cust values (2,'Dokbukki');" "time" "spark-sql"
  #execute_spark "$bench_name" "--version" "time"
  #execute_spark "$bench_name" "" "time" "spark-sql"
  #execute_spark "$bench_name" "" "time" "spark-shell"
  
  #execute_spark "$bench_name" "-e 'show databases;'" "time" "spark-sql"
  #echo "show tables:"
  #execute_spark-sql "$bench_name" "-e \"show tables;\"" "time"
  #echo "tables showed"
  #execute_spark-sql() "$bench_name" "Create Table if not exists cust (id int, name string);" "time"
  #execute_spark-sql() "$bench_name" "insert into cust values (1,'HP');" "time"
  #execute_spark-sql() "$bench_name" "insert into cust values (2,'Dokbukki');" "time"
  #execute_spark-sql() "$bench_name" "Select * from cust;" "time"

  #echo "test sql from spark-shell"
  #execute_spark "$bench_name" "import org.apache.spark.sql.hive.orc._" "time" "spark-shell"
  #execute_spark "$bench_name" "import org.apache.spark.sql._ " "time" "time" "spark-shell"
  #execute_spark "$bench_name" "val hiveContext = new org.apache.spark.sql.hive.HiveContext(sc)" "time" "time" "spark-shell"
  #execute_spark "$bench_name" "hiveContext.sql(\"CREATE TABLE IF NOT EXISTS employee2(id INT, name STRING, age INT)\")" "time" "time" "spark-shell"
  #execute_spark "$bench_name" "hiveContext.sql(\"Select * from employee\").show()" "time" "time" "spark-shell"
  #echo "test Done"
}
