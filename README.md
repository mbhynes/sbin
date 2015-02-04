Shell scripts to interface ganglia with Apache Spark on our cluster.

All definitions are in file: spark_vars, which is sourced for global definitions.

The main script is called: spark_run, which is an interface script to spark-submit, that clocks the start and stop time for the Spark experiments.

rrdcsv is just a dumping script that converts the Round Robin Database (RRD) from ganglia that is in xml format into a usual text format. There's probably a very good tool to do this, but I just used sed.

ssearch is a convenient function to search the spark source code, because Scala doc is awful and browsing github for hours is painful.
