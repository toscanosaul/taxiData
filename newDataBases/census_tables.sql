
CREATE TABLE highschool_data(
	id serial primary key,
	latitude numeric,
	longitude numeric,
	total_students numeric
);

CREATE TABLE population(
	id serial primary key,
	boroname varchar,
	ct2010 varchar,
	population numeric
);

CREATE TABLE demographic(
	id serial primary key,
	ntacode varchar,
	level1 numeric,
	level2 numeric,
	level3 numeric,
	level4 numeric,
	level5 numeric,
	level6 numeric,
	level7 numeric,
	level8 numeric,
	level9 numeric,
	level10 numeric
);

CREATE TABLE demographics(
    id serial primary key,
    ngid numeric,
	level1 numeric,
	level2 numeric,
	level3 numeric,
	level4 numeric,
	level5 numeric,
	level6 numeric,
	level7 numeric,
	level8 numeric,
	level9 numeric,
	level10 numeric,
    population numeric, 
	total_students numeric
);
