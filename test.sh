yellow_schema_pre_2015="(vendor_id,pickup_datetime,dropoff_datetime,passenger_count,trip_distance,pickup_longitude,pickup_latitude,rate_code_id,store_and_fwd_flag,dropoff_longitude,dropoff_latitude,payment_type,fare_amount,extra,mta_tax,tip_amount,tolls_amount,total_amount)"

['vendor_name', 'Trip_Pickup_DateTime', 'Trip_Dropoff_DateTime', 'Passenger_Count', 'Trip_Distance', 'Start_Lon', 'Start_Lat', 'Rate_Code', 'store_and_forward', 'End_Lon', 'End_Lat', 'Payment_Type', 'Fare_Amt', 'surcharge', 'mta_tax', 'Tip_Amt', 'Tolls_Amt', 'Total_Amt']

schema=$yellow_schema_pre_2015

filename="/Volumes/mio/taxi_data/taxiData/data/yellow_tripdata_2009-01.csv"

echo "`date`: beginning load for ${filename}"
sed $'s/\r$//' $filename | sed '/^$/d' | psql nyc-taxi-data -c "COPY yellow_taxi_tripdata ${schema} FROM stdin CSV HEADER;"
echo "`date`: finished raw load for ${filename}"
psql nyc-taxi-data -f taxisYellow.sql
echo "`date`: loaded trips for ${filename}"
