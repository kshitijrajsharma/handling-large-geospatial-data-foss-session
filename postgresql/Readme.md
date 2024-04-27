## Lets download some data 

https://download.geofabrik.de/asia/india.html 

Downloaded openstreetmap data of india worth of 1.4 GB compressed format 


## Install 

- Install postgresql and osm2ogsql ( to load OSM data to postgresql ) 
- Lets insert data to postgresql 

We used [raw-data-api backend](https://github.com/hotosm/raw-data-api/blob/develop/backend/raw_backend) for this , You can use [osm2pgsql](https://osm2pgsql.org/examples/export/) directly

![alt text](./images/insert.png)

it took approx and hour on my laptop ( i5 , intel processor , 32 gb ram )

## Power of indexes

We have 9 GB worth of data in our database now , We build GIST index on the geom and clustered them physically

Lets find all the buildings in new delhi 

```sql
select count(*) from ways_poly wp 
where st_intersects(geom,(select geom from relations where osm_id=1942586))
```

This can go from very simple to very complex query , Yet Postgresql will be able to handle them all 


## Test on Planet Data 

TBD 


## Load same data in Duckdb 

WIP




## PostgreSQL and DuckDB

We absolutely love PostgreSQL and DuckDB. Both have their unique abilities. DuckDB now allows us to directly insert data from PostgreSQL. Due to this, we can benefit from both PostgreSQL and DuckDB at the same time.

### How I used PostgreSQL and DuckDB?

We have loaded the whole planet data into the PostgreSQL database. We don't have indexes on tags as we are focused on the spatial extraction only.

Now we have PostgreSQL with the whole planet data and indexes on top of them, and we did clustering based on the geometry indexes. Now, in order to perform country exports, let's say we want to create different datasets for each country, which is:

- Populated Places
- Education Facilities
- Health Facilities
- Points of Interest
- Airports
- Sea Ports
- Buildings
- Roads
- Railways
- Financial Services
- Waterways

Each category also requires multiple GIS formats, including KML, GeoJSON, and Shapefile.

PostgreSQL was doing a fine job for a single category but lacked filters as we only have an index on the geometry column, but we also want to filter our data based on attributes like buildings, roads, etc.

Now, since DuckDB excels at columnar data and filtering, we wanted to test out that theory, hence we did:

PostgreSQL >>>> bounding box of the country >>> get all the OSM features in the area >>> transfer to DuckDB >>> Now shoot all the filters like `WHERE building = 'yes' AND amenities = 'x'` in multiple categories. We also used DuckDB spatial export to export them into multiple formats.

### Performance Comparison:

I am aware it might not make much sense to do performance comparision just based on the single indexes in postgresql . Numbers would be different if I build index on tags for sure but I wanted solution out of the box without created overhead in postgresql database. I have only listed what i have tried so far 

**Using PostgreSQL** : Postgresql with planet data and index on geometry column : clustered ( AWS Rds)
India All exports with a single file format: Timed out (Killed the process after 12 hours)

**Using DuckDB** : No indexes and new database was created on the disk ( AWS ec2 instance)
India all exports all file formats (SHP, GeoJSON, and KML): Total 4 hours

Since DuckDB can run on disk, we don't require any network transaction, and we can use parallel processing to extract different categories based on the device it is running on. It allowed our main PostgreSQL server to be free from multiple concurrent requests as PostgreSQL will be freed after transferring data to DuckDB.

We haven't used any indexes on DuckDB at all! Further exploration is needed to see how much DuckDB can benefit from indexes.


## Reference 

- [Performance exploration of different GIS file formats and DuckDB by Chris Homes] https://cloudnativegeo.org/blog/2023/08/performance-explorations-of-geoparquet-and-duckdb/ 

- Related Code for [Postgresql with duckdb](https://github.com/hotosm/raw-data-api/blob/b2f2a1b532aed52eb917185890b4761771652c91/src/query_builder/builder.py#L883)