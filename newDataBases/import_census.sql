CREATE TABLE tmp_points AS
SELECT
	id,
	ST_SetSRID(ST_MakePoint(longitude, latitude), 4326) as school,
	total_students
FROM highschool_data;

CREATE TABLE tmp_school AS
SELECT t.id,t.total_students, n.gid
FROM tmp_points t, nyct2010 n
WHERE ST_Within(t.school,n.geom);

CREATE TABLE schools AS
SELECT gid, SUM(total_students) as Total_students
FROM tmp_school
GROUP BY gid;

CREATE TABLE tmp_population AS
SELECT n.gid, n.ntacode,t.population 
FROM nyct2010 n, population t;

CREATE TABLE tmp_population AS
SELECT t.id,n.gid
FROM population t, nyct2010 n
WHERE t.ct2010=n.ct2010;

CREATE TABLE tmp_ocurrences AS
SELECT ntacode, COUNT(*)
FROM nyct2010
GROUP BY ntacode;

CREATE TABLE tmp_demographic AS
SELECT t.id,t.level1/n.count as level1,t.level2/n.count as level2,t.level3/n.count as level3,t.level4/n.count as level4,t.level5/n.count as level5,t.level6/n.count as level6,t.level7/n.count as level7,t.level8/n.count as level8,t.level9/n.count as level9,t.level10/n.count as level10,n.ntacode
FROM demographic t, tmp_ocurrences n
WHERE n.ntacode=t.ntacode;

INSERT INTO demographics
(ct2010,level1,level2,level3,level4,level5,level6,level7,level8,level9,level10,population,total_students)
SELECT
    tmp_population.gid,
    population::integer,
    schools .Total_students::integer,
    tmp_demographic.level1:: integer,
    tmp_demographic.level2:: integer,
    tmp_demographic.level3:: integer,
    tmp_demographic.level4:: integer,
    tmp_demographic.level5:: integer,
    tmp_demographic.level6:: integer,
    tmp_demographic.level7:: integer,
    tmp_demographic.level8 :: integer,
    tmp_demographic.level9:: integer,
    tmp_demographic.level10:: integer
FROM
    tmp_population
	LEFT JOIN schools ON schools.gid=tmp_population.gid
	LEFT JOIN tmp_demographic ON  tmp_demographic.ntacode=tmp_population.ntacode;

DROP TABLE tmp_points;
DROP TABLE tmp_school;
DROP TABLE schools;
DROP TABLE tmp_population;
DROP TABLE tmp_ocurrences;
DROP TABLE tmp_demographic;
DROP TABLE tmp_population;
    
