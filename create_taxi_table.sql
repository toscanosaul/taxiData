CREATE EXTENSION postgis;

CREATE TABLE green_taxi_tripdata(
    id serial primary key,
    vendor_id varchar,
    pickup_datetime varchar,
    dropoff_datetime varchar,
    store_and_fwd_flag varchar,
    rate_code_id varchar,
    pickup_longitude numeric,
    pickup_latitude numeric,
    dropoff_longitude numeric,
    dropoff_latitude numeric,
    passenger_count varchar,
    trip_distance varchar,
    fare_amount varchar,
    extra varchar,
    mta_tax varchar,
    tip_amount varchar,
    tolls_amount varchar,
    ehail_fee varchar,
    improvement_surcharge varchar,
    total_amount varchar,
    payment_type varchar,
    trip_type varchar,
    empty1 varchar,
    empty2 varchar
);

CREATE TABLE yellow_taxi_tripdata(
    id serial primary key,
    vendor_id varchar,
    pickup_datetime varchar,
    dropoff_datetime varchar,
    passenger_count varchar,
    trip_distance varchar,
    pickup_longitude numeric,
    pickup_latitude numeric,
    rate_code_id varchar,
    store_and_fwd_flag varchar,
    dropoff_longitude numeric,
    dropoff_latitude numeric,
    payment_type varchar,
    fare_amount varchar,
    extra varchar,
    mta_tax varchar,
    tip_amount varchar,
    tolls_amount varchar,
    improvement_surcharge varchar,
    total_amount varchar
);

CREATE TABLE cab_types (
      id serial primary key,
      type varchar
);

INSERT INTO cab_types (type) SELECT 'yellow';
INSERT INTO cab_types (type) SELECT 'green';

CREATE TABLE trips(
    id serial primary key,
    cab_type_id integer,
    vendor_id varchar,
    pickup_datetime timestamp without time zone,
    dropoff_datetime timestamp without time zone,
    store_and_fwd_flag char(1),
    rate_code_id integer,
    pickup_longitude numeric,
    pickup_latitude numeric,
    dropoff_longitude numeric,
    dropoff_latitude numeric,
    passenger_count integer,
    trip_distance numeric,
    fare_amount numeric,
    extra numeric,
    mta_tax numeric,
    tip_amount numeric,
    tolls_amount numeric,
    ehail_fee numeric,
    improvement_surcharge numeric,
    total_amount numeric,
    payment_type varchar,
    trip_type integer,
    pickup_nyct2010_gid integer,
    dropoff_nyct2010_gid integer
);

SELECT AddGeometryColumn('trips', 'pickup', 4326, 'POINT', 2);
SELECT AddGeometryColumn('trips', 'dropoff', 4326, 'POINT', 2);

