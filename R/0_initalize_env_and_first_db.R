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
attach_install("nycflights13")

# load duckdb connection
fs::dir_create(fs::path("nycflights13-duckdb"))
con <- dbConnect(duckdb(),
                 dbdir = fs::path("nycflights13-duckdb", "nycflights13.duckdb"),
                 read_only = FALSE)

# connect duckdb to nycflights13
# duckdb_register(con, "airlines", nycflights13::airlines)
# duckdb_register(con, "airports", nycflights13::)
# duckdb_register(con, "flights", nycflights13::)
# duckdb_register(con, "planes", nycflights13::)
# duckdb_register(con, "weather", nycflights13::weather)

# connect duckdb to nycflights13
dbWriteTable(con, "airlines", nycflights13::airlines)
dbWriteTable(con, "airports", nycflights13::airports)
dbWriteTable(con, "flights", nycflights13::flights)
dbWriteTable(con, "planes", nycflights13::planes)
dbWriteTable(con, "weather", nycflights13::weather)

# close and clean up
duckdb::dbDisconnect(con)

