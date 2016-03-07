file1="data/econFile.csv"
file2="data/highSchool.csv"
file3="data/population_modified.csv"

schema="(ntacode,level1,level2,level3,level4,level5,level6,level7,level8,level9,level10)"

echo "`date`: beginning load for ${file1}"
sed $'s/\r$//' $file1 | sed '/^$/d' | psql nyc-taxi-data -c "COPY demographic ${schema} FROM stdin CSV HEADER;"
echo "`date`: finished raw load for ${file1}"

schema2="(latitude,longitude,total_students)"

echo "`date`: beginning load for ${file2}"
sed $'s/\r$//' $file2 | sed '/^$/d' | psql nyc-taxi-data -c "COPY highschool_data ${schema2} FROM stdin CSV HEADER;"
echo "`date`: finished raw load for ${file2}"

schema3="(boroname,ct2010,population)"

echo "`date`: beginning load for ${file3}"
sed $'s/\r$//' $file3 | sed '/^$/d' | psql nyc-taxi-data -c "COPY population ${schema3} FROM stdin CSV HEADER;"
echo "`date`: finished raw load for ${file3}"



psql nyc-taxi-data -f import_census.sql