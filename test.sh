COUNTRY_GEOJSON=${1:-"nepal.geojson"} # Default country code is NP (Nepal)
RELEASE_VERSION=${2:-"2024-04-16-beta.0"} # Current release version
OUTPUT_PATH=${3:-"."}
duckdb -c """
    INSTALL spatial;
    LOAD spatial;
    COPY (
        SELECT a.*
        FROM read_parquet('s3://overturemaps-us-west-2/release/$RELEASE_VERSION/theme=admins/type=*//*', hive_partitioning=1) AS a
    )
    TO 'test.parquet' (FORMAT 'parquet');
"""