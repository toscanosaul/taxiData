CREATE TABLE temp_points AS
SELECT
    id,
    ST_SetSRID(ST_MakePoint(pickup_longitude, pickup_latitude), 4326) as pickup,
    ST_SetSRID(ST_MakePoint(dropoff_longitude, dropoff_latitude), 4326) as dropoff
FROM green_taxi_tripdata;

CREATE INDEX idx_points_pickup ON temp_points USING gist (pickup);
CREATE INDEX idx_points_dropoff ON temp_points USING gist (dropoff);

CREATE TABLE temp_pickups AS
SELECT t.id, n.gid
FROM temp_points t, nyct2010 n
WHERE ST_Within(t.pickup,n.geom);

CREATE TABLE temp_dropoffs AS
SELECT t.id, n.gid
FROM temp_points t, nyct2010 n
WHERE ST_Within(t.dropoff, n.geom);

INSERT INTO trips
(cab_type_id, vendor_id, pickup_datetime, dropoff_datetime, store_and_fwd_flag, rate_code_id, pickup_longitude, pickup_latitude, dropoff_longitude, dropoff_latitude, passenger_count, trip_distance, fare_amount, extra, mta_tax, tip_amount, tolls_amount, ehail_fee, improvement_surcharge, total_amount, payment_type, trip_type, pickup, dropoff, pickup_nyct2010_gid, dropoff_nyct2010_gid)
SELECT
  cab_types.id,
  vendor_id,
  pickup_datetime::timestamp,
  dropoff_datetime::timestamp,
  store_and_fwd_flag,
  rate_code_id::integer,
  CASE WHEN pickup_longitude != 0 THEN pickup_longitude END,
  CASE WHEN pickup_latitude != 0 THEN pickup_latitude END,
  CASE WHEN dropoff_longitude != 0 THEN dropoff_longitude END,
  CASE WHEN dropoff_latitude != 0 THEN dropoff_latitude END,
  passenger_count::integer,
  trip_distance::numeric,
  fare_amount::numeric,
  extra::numeric,
  mta_tax::numeric,
  tip_amount::numeric,
  tolls_amount::numeric,
  ehail_fee::numeric,
  improvement_surcharge::numeric,
  total_amount::numeric,
  payment_type,
  trip_type::integer,
  CASE
   WHEN pickup_longitude != 0 AND pickup_latitude != 0
   THEN ST_SetSRID(ST_MakePoint(pickup_longitude, pickup_latitude), 4326)
  END,
  CASE
   WHEN dropoff_longitude != 0 AND dropoff_latitude != 0
   THEN ST_SetSRID(ST_MakePoint(dropoff_longitude, dropoff_latitude), 4326)
  END,
  temp_pickups.gid,
  temp_dropoffs.gid
FROM
  green_taxi_tripdata
   INNER JOIN cab_types ON cab_types.type = 'green'
   LEFT JOIN temp_pickups ON green_taxi_tripdata.id = temp_pickups.id
   LEFT JOIN temp_dropoffs ON green_taxi_tripdata.id = temp_dropoffs.id;

TRUNCATE TABLE green_taxi_tripdata;
DROP TABLE temp_points;
DROP TABLE temp_pickups;
DROP TABLE temp_dropoffs;
