## Process overture data

This repo has scripts that downloads overture map data , clips it for your area of interest , converts it to geoparquet and finally create vector tiles so that it can be visualized in maps.


## Release and Source 

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

## Usage 

```bash
bash ./extract-overture-data.sh [country_geojson] [release_version] [theme] [output_path]
```
- `country_geojson`: (Optional) Path to the country boundary GeoJSON file. If not provided, all data will be extracted without filtering.
- `release_version`: (Optional) The current release version. Default is `"2024-04-16-beta.0"`.
- `theme`: (Optional) The specific theme to extract and convert. If not provided or set to `"all"`, data for all themes will be extracted and converted. Supported themes are: `admins`, `transportation`, `buildings`, and `places`.
- `output_path`: (Optional) The output path for the GeoParquet and PMTiles files. Default is the current directory (`.`).

## Bash Example

- Extract and convert data for the `admins` theme without filtering:

```bash
bash ./extract-overture-data.sh "" "2024-04-16-beta.0" "admins"
```

- Notebook example

I have provided how we can use duckdb to run spatial queries over the downloaded parquet files in this [notebook](./overture_duckdb.ipynb) 


## Output

The script will generate the following files in the specified `output_path`:

- `<theme>.parquet`: [Geo]Parquet file containing the extracted data for the specified theme.
- `<theme>.pmtiles`: PMTiles file converted from the GeoParquet file, suitable for rendering and visualization.

Note that if you extract data for all themes, separate GeoParquet and PMTiles files will be generated for each theme.
