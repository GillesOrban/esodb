#!/bin/bash
##
## get DIMM measurements, extract relevant information and print SQL insert string
##

year_start=2014
month_start=07
day_start=17

year=$year_start
month=$month_start
day=$day_start

year_now=`date "+%Y"`
month_now=`date "+%m"`
day_now=`date "+%d"`

year_now=2015
month_now=03
day_now=09


tmpfile="/tmp/DIMMtmp.txt"
sqlfile="$OBSDBLOCAL/data/DIMM/insert_dimm.sql"

while true
do
	dimmfile=$OBSDBLOCAL/data/DIMM/${year}-${month}-${day}.txt
	
	if [[ ! -f $dimmfile ]]; then
		night1=`date -v${year}y -v${month}m -v${day}d "+%Y-%m-%d"`
		night2=`date -v${year}y -v${month}m -v${day}d -v+1d "+%Y-%m-%d"`
		curl -s --data "night=&stime=$night1&starttime=12&etime=$night2&endtime=12&tab_interval=on&interval=&tab_ra=on&ra=&tab_dec=on&dec=&tab_fwhm=on&fwhm=&tab_airmass=on&airmass=&tab_rfl=on&rfl=&tab_tau=on&tau=&tab_tet=on&tet=&order=-start_date&export=tab&max_rows_returned=100000000" http://archive.eso.org/wdb/wdb/eso/ambient_paranal/query > $tmpfile
		cat $tmpfile | grep \"METEO\" | awk -F "<td>" '{ print $2 $3 $4 $5 $6 $7 $8 $9}' | awk -F "</td>" '{print $1 " " $3 " " $4 " " $5 " " $6 " " $7 " " $8 " " $9}' > $dimmfile
		echo "Downloaded and parsed DIMM measurements for $night1 and saved to $dimmfile"
	fi

	iyear=`date -v${year}y -v${month}m -v${day}d -v+1d "+%Y"`
	imonth=`date -v${year}y -v${month}m -v${day}d -v+1d "+%m"`
	iday=`date -v${year}y -v${month}m -v${day}d -v+1d "+%d"`
	
	year=$iyear
	month=$imonth
	day=$iday
	
	##
	## some files are empty; ignore them
	if [ ! -s $dimmfile ]; then continue; fi
	
	sh $OBSDBDIR/scripts/parse_dimm.sh $dimmfile >> $sqlfile	
	
	if [ $year -eq $year_now ] && [ $month -eq $month_now ] && [ $day -eq $day_now ]; then break; fi
done