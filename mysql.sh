#! /usr/bin/env bash

#create a database in mysql called smart
bin/mysql --defaults-file=my.cnf -e "create database smart"

#create table day and hour
bin/mysql --defaults-file=my.cnf -D smart -e "create table day (instant int, dteday date, season int,	yr int, mnth int, holiday int, weekday int, workingday int, weathersit int, temp float, atemp float, hum float, windspeed float, casual int, registered int, cnt int);"
bin/mysql --defaults-file=my.cnf -D smart -e "create table hour (instant int, dteday date, season int, yr int, mnth int, hr int, holiday int, weekday int, workingday int, weathersit int, temp float, atemp float, hum float, windspeed float, casual int, registered int, cnt int);"

bin/mysql --defaults-file=my.cnf -D smart -e "load data local infile 'day.csv' into table day fields terminated by ',' lines terminated by '\n' IGNORE 1 LINES;"
bin/mysql --defaults-file=my.cnf -D smart -e "load data local infile 'hour.csv' into table hour fields terminated by ',' lines terminated by '\n' IGNORE 1 LINES;"


#the output directory of export csv files
outputDir=$HOME/research/smart

#average the following features and export to output csv files
for feature in mnth yr season holiday weekday workingday weathersit
do
output=$outputDir/$feature.csv
echo $output
if [ -e $output ]; then
	rm $output
fi
bin/mysql --defaults-file=my.cnf -D smart -e "select '$feature','casual', 'registered','cnt' union  select $feature, avg(casual), avg(registered), avg(cnt) from day group by $feature into outfile '$output' fields terminated by ',';"
done

output=$outputDir/hr.csv
bin/mysql --defaults-file=my.cnf -D smart -e "select hr,avg(casual),avg(registered),avg(cnt) from hour group by hr into outfile '$output' fields terminated by ',';"

output=$outputDir/hr_workingday.csv
bin/mysql --defaults-file=my.cnf -D smart -e "select hr,avg(casual),avg(registered),avg(cnt) from hour where workingday =1 group by hr into outfile '$output' fields terminated by ',';"

output=$outputDir/hr_nonworkingday.csv
bin/mysql --defaults-file=my.cnf -D smart -e "select hr,avg(casual),avg(registered),avg(cnt) from hour where workingday =0 group by hr into outfile '$output' fields terminated by ',';"