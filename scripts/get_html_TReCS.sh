#!/bin/bash
##
## for querying the Gemini science archive
##
## TReCS observations started 2003-09-12


INS="TReCS"

year=$1
month=$2
day=$3

if [ ! $# -eq 3 ]; then
	echo "Number of parameters must be 3 (year, month, day of start of query)."
	exit
fi

##
## check if required directories exist, or create them
dir_data="$OBSDBLOCAL/data"
DPID_all_file="$dir_data/DPID/${INS}.txt"
dir_INS="$dir_data/$INS"
dir_html="$dir_INS/html"
dir_hdr="$dir_INS/HDR"
if [ ! -d $dir_INS ]; then mkdir $dir_INS; fi
if [ ! -d $dir_html ]; then mkdir $dir_html; fi
if [ ! -d $dir_hdr ]; then mkdir $dir_hdr; fi
if [ ! -e $DPID_all_file ]; then touch $DPID_all_file; fi
month=`date -v${year}y -v${month}m -v${day}d "+%m"` # for a clean leading '0' for the month.

year_today=`date "+%Y"`
month_today=`date "+%m"`
day_today=`date "+%d"`

while true; do
	htmlfile="$dir_html/${year}_${month}_${day}.html"
	echo $htmlfile
	##
	## calculate next date
	year2=`date -v${year}y -v${month}m -v${day}d -v+1d "+%Y"`
	month2=`date -v${year}y -v${month}m -v${day}d -v+1d "+%m"`
	day2=`date -v${year}y -v${month}m -v${day}d -v+1d "+%d"`
	##
	## query archive
	if [ ! -e $htmlfile ]; then
		stime="${year}${month}${day}"
		etime="$year2 $month2 $day2"
		echo $stime $etime
		url="https://archive.gemini.edu/searchform/cols=CTOWFDErdLQ/notengineering/TReCS/${stime}/NotFail"
		wget $url -O $htmlfile
		echo "Queried archive server for observations on $stime. Stored HTML file $htmlfile."
		if [ ! -s $htmlfile ]; then
			echo "Download of HTML file $htmlfile failed."
			exit 1
		fi
	fi
	if [ $year -eq $year_today ] && [ $month -eq $month_today ] && [ $day -eq $day_today ]; then break; fi
	
	year=$year2
	month=$month2
	day=$day2
done