## script to add single header key to database (relatively fast)
## need to first alter table definition in SQLite table!

sqlfile="sqlfile.txt"

for night in `find 20* -type d`; do
	echo $night
#	sleep 1
	for f in `find $night -type f`; do
#		echo $f
#		sleep 1
		date_obs=$(grep "DATE-OBS" $f | awk -F "'" '{print $2}')
#		echo $date_obs
#		sleep 1
		obs_id=$(grep "ESO OBS ID" $f | awk '{print $6}')
#		echo $obs_id
#		sleep 1
		sql="update shoot set obs_id=\"$obs_id\" where dateobs=\"$date_obs\";"
		echo $sql >> $sqlfile
#		echo $sql
#		sleep 1
	done
done