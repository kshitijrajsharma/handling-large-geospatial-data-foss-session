## Process overture data

This repo has scripts that downloads overture map data , clips it for your area of interest , converts it to geoparquet and finally create vector tiles so that it can be visualized in maps.


## Lets verify the latest release of overture data 

https://github.com/OvertureMaps/data


```
s3://overturemaps-us-west-2/release/2024-04-16-beta.0/
  |-- theme=admins/
  |-- theme=base/
  |-- theme=buildings/
  |-- theme=divisions/
  |-- theme=places/
  |-- theme=transportation/
```

## Installation 

- Install [duckdb](https://duckdb.org/docs/installation/index) 
- Install [gpq](https://github.com/planetlabs/gpq#installation) to convert parquet to geoparquet 
- Install [gdal](https://gdal.org/programs/ogr2ogr.html) to convert geoparquet to tiles

## Get your boundary geojson that you want data for 

Get it in geojson fromat , we downloaded boundary from osm

## Run & Extract 

```bash 
bash ./extract-overture-data.sh nepal.geojson 
```

## Analysis example 

I have provided how we can use duckdb to run spatial queries over the downloaded parquet files in this [notebook](./overture_duckdb.ipynb) 


