package main.scala

import org.apache.spark.SparkContext
import org.apache.spark.SparkConf
import java.io.BufferedWriter
import java.io.File
import java.io.FileWriter
import java.time.LocalDateTime.now
import org.apache.spark.sql._
import scala.collection.mutable.ListBuffer

/**
 * Parent class for TPC-H queries.
 *
 * Main Class for Execution of TPC-H Queries
 *
 * Original Author: Savvas Savvides <savvas@purdue.edu>
 * Modified by Raphael Radowitz
 */
abstract class TpchQuery {

  // get the name of the class excluding dollar signs and package
  private def escapeClassName(className: String): String = {
    className.split("\\.").last.replaceAll("\\$", "")
  }

  def getName(): String = escapeClassName(this.getClass.getName)

  /**
   *  implemented in children classes and hold the actual query
   */
  def execute(sc: SparkContext, tpchSchemaProvider: TpchSchemaProvider): DataFrame
}

object TpchQuery {

  def outputDF(df: DataFrame, outputDir: String, className: String, outputformat: String, sprint: Int): Unit = {

    if (sprint == 1)
      df.collect().foreach(println)	
     
    if (outputformat != "off")
      if (outputDir != null || outputDir != "")
        if (outputformat == "orc" || outputformat == "json" || outputformat == "csv" || outputformat == "parquet")
      	  df.write.mode("overwrite").format(outputformat).option("header", "true").save(outputDir + "/" + className + ".out")
  }

  def executeQueries(sc: SparkContext, schemaProvider: TpchSchemaProvider, scaleFactor: Int, benchNum: Int ,queryNum: Int, outputdir: String, outputformat: String, sprint: Int): Unit = {

    val OUTPUT_DIR: String =  outputdir + outputformat + "/" + benchNum.toString

    var fromNum = 1
    var toNum = 22
    if (queryNum != 0) {
      fromNum = queryNum;
      toNum = queryNum;
    }

    for (queryNo <- fromNum to toNum) {
    
      val query = Class.forName(f"main.scala.Q${queryNo}%02d").newInstance.asInstanceOf[TpchQuery]

      outputDF(query.execute(sc, schemaProvider), OUTPUT_DIR, query.getName(), outputformat, sprint)      

    }
  }

  def main(args: Array[String]): Unit = {

    var scaleFactor = 0
    var benchNum = 0
    var queryNum = 0
    var inputdir = "" 
    var outputdir = ""
    var outputformat = ""
    var sprint = 1
    var nFormat = ""
    var nAPI = ""
    if (args.length > 0)
      scaleFactor = args(0).toInt
      benchNum = args(1).toInt
      queryNum = args(2).toInt
      inputdir = args(3).toString 
      outputdir = args(4).toString
      outputformat = args(5).toString
      sprint = args(6).toInt
      nFormat = args(7).toString
      nAPI = args(8).toString
   
    val conf = new SparkConf().setAppName("TPCH on native Spark")
    val sc = new SparkContext(conf)

    // read from hdfs    
    val INPUT_DIR: String = inputdir

    val schemaProvider = new TpchSchemaProvider(sc, INPUT_DIR)
    
    // Start execution of TPC-H queries
    executeQueries(sc, schemaProvider, scaleFactor, benchNum, queryNum, outputdir, outputformat, sprint)

  }
}
