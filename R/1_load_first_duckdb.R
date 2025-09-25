# make a install if not present, and then load function
attach_install <- function(...){
  if(suppressWarnings(!require(...))){
    # special install for duckdb https://duckdb.org/docs/stable/clients/r.html#warning-when-installing-on-macos
    if(... == "duckdb"){install.packages("duckdb", repos = c("https://duckdb.r-universe.dev", "https://cloud.r-project.org"))}else{
      install.packages(...)
      }
  };
  
  library(...)
}

# install / load packages
#attach_install("dplyr")
attach_install("duckdb")
attach_install("DBI")
attach_install("fs")

# load duckdb connection
con <- dbConnect(duckdb(),
                 dbdir = fs::path("nycflights13-duckdb", "nycflights13.duckdb"),
                 read_only = FALSE)

# run first test query
test_query <- "SELECT * FROM airlines LIMIT 10"

# Run the following on your own:
dbGetQuery(con, test_query)
dbGetQuery(con,
           "SELECT * FROM pg_tables")
dbGetQuery(con, "FROM flights LIMIT 10")
dbGetQuery(con,
           "SELECT carrier, MEAN(dep_delay) AS mean_dep_delay, COUNT(*) AS N_flights FROM flights
           GROUP BY carrier
           WHERE mean_dep_delay < 50
           ORDER BY N_flights DESC")
dbGetQuery(con,
           "SELECT year, month, COUNT(*) AS N_flights FROM flights
           GROUP BY year, month")
dbGetQuery(con,
           "SELECT distance, year, month, day,
           SUM(distance) AS cumu_distance
           OVER ( ORDER BY year, month, day )
           FROM flights")

# Find the time stamp (ts) of the 7th something above 4 hours for each airline
dbGetQuery(con,
           "SELECT carrier, concat_ws(' ', year, month, day, dep_time) AS ts FROM (
              SELECT *, row_number() OVER (PARTITION BY carrier ORDER BY year, month, day, dep_time) AS nth_flight FROM flights
              WHERE air_time >= 240
           )
           WHERE nth_flight == 7")


