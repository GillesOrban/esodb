#!/bin/bash
##
## call with five arguments, e.g.
## sh get_hdrs_INS.sh "SINFO" "sinfoni" 2012 11 05 ## this would download all non-existing headers from the given date for SINFONI
## or
## sh get_hdrs_INS.sh "SHOOT" "xshooter" 2008 11 13 ## from the beginning of the XSHOOTER age
## sh get_hdrs_INS.sh "MIDI" "midi" 2004 04 07 ## from the beginning of the MIDI age (last obst: 2015-03-05)

INS=$1
ins_form=$2

year=$3
month=$4
day=$5

if [ ! $# -eq 5 ]; then
	echo "Number of parameters must be 5."
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
	## query ESO archive
	if [ ! -e $htmlfile ]; then
		stime="$year $month $day"
		etime="$year2 $month2 $day2"
		echo $stime $etime
		wget --post-data "stime=$stime&etime=$etime&max_rows_returned=100000" http://archive.eso.org/wdb/wdb/eso/${ins_form}/query -O $htmlfile
		echo "Queried ESO archive server for observations between $stime and $etime. Stored HTML file $htmlfile."
		if [ ! -s $htmlfile ]; then
			echo "Download of HTML file $htmlfile failed."
			exit 1
		fi
	fi
	##
	## get DPIDs
	while read LINE
	do
		DPID=`echo $LINE | grep "DpId=" | awk -F 'DpId=' {'print $2'} | awk -F '"' {'print $1'}`
		if [ -z $DPID ]; then continue; fi
		DPID_mac=`echo $DPID | sed 's/:/-/g'`
		dir_hdr_day="$dir_hdr/${year}-${month}-${day}"
		if [ ! -d $dir_hdr_day ]; then mkdir $dir_hdr_day; fi
		ifile="$dir_hdr_day/$DPID_mac.txt"
		##
		## check if header file exists, if not, download from ESO server
		if [ ! -f $ifile ]; then
			url="http://archive.eso.org/hdr?DpId=$DPID"
			echo "Downloading $ifile"
			result=`wget -qO $ifile $url`
			echo "Downloaded and saved " $ifile
		fi
		##
		## make sure file name in header (ARCFILE) is what it should be
		f_this="${DPID}.fits"
		arcfile=`grep 'ARCFILE' $ifile | awk -F "'" '{print $2}'`
		if [ ! "$f_this" == "$arcfile" ]; then
			echo "$f_this does not equal ${arcfile}!" >&2
			continue
		fi
		echo $DPID >> $DPID_all_file
	done < $htmlfile
		
	if [ $year -eq $year_today ] && [ $month -eq $month_today ] && [ $day -eq $day_today ]; then break; fi
	
	year=$year2
	month=$month2
	day=$day2
done