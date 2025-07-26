# README
Patrick Cherry
2025-07-26

## sql-db mini package

SQL databases for practicing

### Set Up

In R, run:

    source("R/0_initalize_env_and_first_db.R")

### Practicing

``` r
source("R/1_load_first_duckdb.R")
```

    Loading required package: duckdb

    Loading required package: DBI

    Loading required package: fs

``` r
con <- dbConnect(duckdb(),
                 dbdir = fs::path("nycflights13-duckdb", "nycflights13.duckdb"),
                 read_only = FALSE)
```

## Run you query

``` r
test_query <- "SELECT * FROM airlines LIMIT 10"

dbGetQuery(con, test_query)
```

       carrier                        name
    1       9E           Endeavor Air Inc.
    2       AA      American Airlines Inc.
    3       AS        Alaska Airlines Inc.
    4       B6             JetBlue Airways
    5       DL        Delta Air Lines Inc.
    6       EV    ExpressJet Airlines Inc.
    7       F9      Frontier Airlines Inc.
    8       FL AirTran Airways Corporation
    9       HA      Hawaiian Airlines Inc.
    10      MQ                   Envoy Air
