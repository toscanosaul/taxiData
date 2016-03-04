year_regex="tripdata_([0-9]{4})"

green_schema_pre_2015="(vendor_id,pickup_datetime,dropoff_datetime,store_and_fwd_flag,rate_code_id,pickup_longitude,pickup_latitude,dropoff_longitude,dropoff_latitude,passenger_count,trip_distance,fare_amount,extra,mta_tax,tip_amount,tolls_amount,ehail_fee,total_amount,payment_type,trip_type,empty,empty2)"

green_schema_2015="(vendor_id,pickup_datetime,dropoff_datetime,store_and_fwd_flag,rate_code_id,pickup_longitude,pickup_latitude,dropoff_longitude,dropoff_latitude,passenger_count,trip_distance,fare_amount,extra,mta_tax,tip_amount,tolls_amount,ehail_fee,improvement_surcharge,total_amount,payment_type,trip_type)"

yellow_schema_pre_2015="(vendor_id,pickup_datetime,dropoff_datetime,passenger_count,trip_distance,pickup_longitude,pickup_latitude,rate_code_id,store_and_fwd_flag,dropoff_longitude,dropoff_latitude,payment_type,fare_amount,extra,mta_tax,tip_amount,tolls_amount,total_amount)"

yellow_schema_2015="(vendor_id,pickup_datetime,dropoff_datetime,passenger_count,trip_distance,pickup_longitude,pickup_latitude,rate_code_id,store_and_fwd_flag,dropoff_longitude,dropoff_latitude,payment_type,fare_amount,extra,mta_tax,tip_amount,tolls_amount,improvement_surcharge,total_amount)"



for filename in data/green*.csv; do
    [[ $filename =~ $year_regex ]]

    if [ ${BASH_REMATCH[1]} == 2015 ]
    then
    schema=$green_schema_2015
    else
    schema=$green_schema_pre_2015
    fi

    echo "`date`: beginning load for ${filename}"
    sed $'s/\r$//' $filename | sed '/^$/d' | psql nyc-taxi-data -c "COPY green_taxi_tripdata ${schema} FROM stdin CSV HEADER;"
    echo "`date`: finished raw load for ${filename}"
    psql nyc-taxi-data -f taxisGreen.sql
    echo "`date`: loaded trips for ${filename}"
done;

for filename in data/yellow*.csv; do
    [[ $filename =~ $year_regex ]]

    if [ ${BASH_REMATCH[1]} == 2015 ]
    then
    schema=$yellow_schema_2015
    else
    schema=$yellow_schema_pre_2015
    fi

    echo "`date`: beginning load for ${filename}"
    sed $'s/\r$//' $filename | sed '/^$/d' | psql nyc-taxi-data -c "COPY yellow_taxi_tripdata ${schema} FROM stdin CSV HEADER;"
    echo "`date`: finished raw load for ${filename}"
    psql nyc-taxi-data -f taxisYellow.sql
    echo "`date`: loaded trips for ${filename}"
done;

