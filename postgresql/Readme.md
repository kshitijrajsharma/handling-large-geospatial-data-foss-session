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