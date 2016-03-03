createdb nyc-taxi-data


psql nyc-taxi-data -f create_taxi_table.sql

shp2pgsql -s 2263:4326 data/nyct2010.shp | psql -d nyc-taxi-data

psql nyc-taxi-data -c "CREATE INDEX index__on_geom ON nyct2010 USING gist (geom);"
psql nyc-taxi-data -c "CREATE INDEX index_on_ntacode ON nyct2010 (ntacode);"
psql nyc-taxi-data -c "VACUUM ANALYZE nyct2010;"
