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
# dbGetQuery(con, test_query)
