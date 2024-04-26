## Lets verify the latest release of overture data 

https://github.com/OvertureMaps/data

We used following : 

s3://overturemaps-us-west-2/release/2024-04-16-beta.0/
  |-- theme=admins/
  |-- theme=base/
  |-- theme=buildings/
  |-- theme=divisions/
  |-- theme=places/
  |-- theme=transportation/


## Installation 

- Install [duckdb](https://duckdb.org/docs/installation/index) 
- Install [gpq](https://github.com/planetlabs/gpq#installation) to convert parquet to geoparquet 