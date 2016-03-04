CREATE TABLE temp_points AS
SELECT
    id,
    ST_SetSRID(ST_MakePoint(pickup_longitude, pickup_latitude), 4326) as pickup,
    ST_SetSRID(ST_MakePoint(dropoff_longitude, dropoff_latitude), 4326) as dropoff
FROM yellow_taxi_tripdata;

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
(cab_type_id, vendor_id, pickup_datetime, dropoff_datetime, passenger_count, trip_distance, pickup_longitude, pickup_latitude, rate_code_id, store_and_fwd_flag, dropoff_longitude, dropoff_latitude, payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount, pickup, dropoff, pickup_nyct2010_gid, dropoff_nyct2010_gid)
SELECT
  cab_types.id,
  vendor_id,
  pickup_datetime::timestamp,
  dropoff_datetime::timestamp,
  passenger_count::integer,
  trip_distance::numeric,
  CASE WHEN pickup_longitude != 0 THEN pickup_longitude END,
  CASE WHEN pickup_latitude != 0 THEN pickup_latitude END,
  rate_code_id::integer,
  store_and_fwd_flag,
  CASE WHEN dropoff_longitude != 0 THEN dropoff_longitude END,
  CASE WHEN dropoff_latitude != 0 THEN dropoff_latitude END,
  payment_type,
  fare_amount::numeric,
  extra::numeric,
  mta_tax::numeric,
  tip_amount::numeric,
  tolls_amount::numeric,
  improvement_surcharge::numeric,
  total_amount::numeric,
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
  yellow_taxi_tripdata
   INNER JOIN cab_types ON cab_types.type = 'yellow'
   LEFT JOIN temp_pickups ON yellow_taxi_tripdata.id = temp_pickups.id
   LEFT JOIN temp_dropoffs ON yellow_taxi_tripdata.id = temp_dropoffs.id;

TRUNCATE TABLE yellow_taxi_tripdata;
DROP TABLE temp_points;
DROP TABLE temp_pickups;
DROP TABLE temp_dropoffs;
