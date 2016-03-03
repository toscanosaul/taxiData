green_schema_pre_2015="(vendor_id,pickup_datetime,dropoff_datetime,store_and_fwd_flag,rate_code_id,pickup_longitude,pickup_latitude,dropoff_longitude,dropoff_latitude,passenger_count,trip_distance,fare_amount,extra,mta_tax,tip_amount,tolls_amount,ehail_fee,total_amount,payment_type,trip_type,empty1,empty2)"

schema=$green_schema_pre_2015

filename="data/green_tripdata_2014-06.csv"

echo "`date`: beginning load for ${filename}"
sed $'s/\r$//' $filename | sed '/^$/d' | psql nyc-taxi-data -c "COPY green_taxi_tripdata ${schema} FROM stdin CSV HEADER;"
echo "`date`: finished raw load for ${filename}"
psql nyc-taxi-data -f taxisGreen.sql
echo "`date`: loaded trips for ${filename}"
