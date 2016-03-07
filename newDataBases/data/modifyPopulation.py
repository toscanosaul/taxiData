import csv

file1="Population.csv"
file2="population_modified.csv"

with open(file1,"rb") as f:
    re=csv.reader(f)
    
    with open(file2,"wb") as f2:
        re2=csv.writer(f2)
        for row in re:
            re2.writerow([row[0],row[4],row[5]])
