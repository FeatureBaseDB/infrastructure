#!/bin/bash

source /etc/profile

function pibench
{
pi bench query --hosts=$PILOSA_HOSTS --index=taxi --iterations=20 --query="Count(Intersect(Union(Row(pickup_year=2012), Row(pickup_year=2013)), Row(pickup_month=3)))"
pi bench query --hosts=$PILOSA_HOSTS --index=taxi --iterations=20 --query="TopN(dist_miles)"
pi bench query --hosts=$PILOSA_HOSTS --index=taxi --iterations=20 --query="TopN(dist_miles, Row(pickup_year=2011))"
pi bench query --hosts=$PILOSA_HOSTS --index=taxi --iterations=20 --query="Count(Intersect(Row(cab_type=1),Union(Row(pickup_month=1),Row(pickup_month=2),Row(pickup_month=11),Row(pickup_month=12)),Union(Row(pickup_day=4),Row(pickup_day=5),Row(pickup_day=6)),Union(Row(dist_miles=0),Row(dist_miles=1),Row(dist_miles=2),Row(dist_miles=3),Row(dist_miles=4),Row(dist_miles=5),Row(dist_miles=6),Row(dist_miles=7),Row(dist_miles=8),Row(dist_miles=9),Row(dist_miles=10),Row(dist_miles=11),Row(dist_miles=12),Row(dist_miles=13),Row(dist_miles=14),Row(dist_miles=15),Row(dist_miles=16),Row(dist_miles=17),Row(dist_miles=18),Row(dist_miles=19),Row(dist_miles=20))))"
pi bench query --hosts=$PILOSA_HOSTS --index=taxi --iterations=20 --query="GroupBy(Rows(field=cab_type), Rows(field=pickup_year), Rows(field=pickup_month))"
# do the 4 standard taxi queries using GroupBy
# 1. ride count by cab type
pi bench query --hosts=$PILOSA_HOSTS --query="TopN(cab_type)" --index=taxi --iterations=20
# 2. average(total_amount) by passenger_count
# difficult to do in a single query. need to TopN passenger count and then Average total amount for each
# 3. GroupBy year and passenger count
pi bench query --hosts=$PILOSA_HOSTS --index=taxi --iterations=20 --query="GroupBy(Rows(field=cab_type), Rows(field=pickup_year), Rows(field=passenger_count))"
# 4. Group By year, passegner count dist_miles
pi bench query --hosts=$PILOSA_HOSTS --index=taxi --iterations=20 --query="GroupBy(Rows(field=pickup_year), Rows(field=passenger_count), Rows(field=dist_miles))"
} 

pibench

