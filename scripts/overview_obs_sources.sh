#!/bin/bash
##
##
## PURPOSE
##    Construct a list of total time on target under good seeing for all local AGNs
##
## REQUIREMENTS
##    - local installation of SQLite3 command line tool
##    - local copy of obs.db or connection to MPE AFS server
##
## OUTPUT
##    formatted list of observations (one line per target and ESO programme) on stdout
##
## CAVEATS
##    seeing is taken from header, which is instantaneous seeing as measured by DIMM, not 
##       averaged over the duration of the OB.
##    if fwhm_start is empty, this observation is currently not included in result
##
## TESTED ON
##    Mac OS X 10.7.5
##
## WRITTEN BY
##    Leonard Burtscher, burtscher@mpe.mpg.de, 2012-11-14
##
##
dbfile="$OBSDB"

sourceslist="$OBSDBDIR/scripts/targets.txt"

while read LINE; do
	object=`echo $LINE | awk -F "|" '{print $1}'`
	ra=`echo $LINE | awk -F "|" '{print $2}'`
	dec=`echo $LINE | awk -F "|" '{print $3}'`

	##
	## searchboxhalflength
	##    only with values = 30 will all P93 SINFO BAT proposal targets be found
	##    result does not change by increasing searchboxhalflength to 90 arcsec
	##
	searchboxhalflength=30 ## arcsec
	seeing_max=1.5 ## arcsec
	ToT_min=0.25 ## hours

	##
	## get unique list of programmes with observations of this object; search box: 10 arcsec (sufficient to catch all AGNs)
	ra1=$(echo "scale=5;$ra-$searchboxhalflength/3600"|bc)
	ra2=$(echo "scale=5;$ra+$searchboxhalflength/3600"|bc)
	dec1=$(echo "scale=5;$dec-$searchboxhalflength/3600"|bc)
	dec2=$(echo "scale=5;$dec+$searchboxhalflength/3600"|bc)
	
	grat="H K H+K"
	opti="0.025 0.1 0.25"
#	echo $object
#	echo $ra $ra1 $ra2
#	echo $dec $dec1 $dec2

	for igrat in $grat; do
#		echo $igrat
		for iopti in $opti; do
#		echo $iopti
			query="select dateobs, round(sum(dit*ndit)/3600.,2) as 'ToT [h]', object from obs where grat1='$igrat' and opti1=$iopti and dprtype LIKE '%OBJECT%' and ra between $ra1 and $ra2 and dec between $dec1 and $dec2 and fwhm_start < $seeing_max;"
#			echo $query
			result=$(sqlite3 $dbfile "$query")
			dateobs=$(echo $result | awk -F "|" '{print $1}')
			ToT=$(echo $result | awk -F "|" '{print $2}')
			hdr_obj=$(echo $result | awk -F "|" '{print $3}')
			if [ -z "$dateobs" ] || [ -z "$ToT" ] ; then continue; fi
			if [[ `echo "$ToT < $ToT_min" | bc` -eq 1 ]]; then continue; fi
			echo "$object,$hdr_obj,$ra,$dec,$igrat,$iopti,$ToT"
		done
	done
	exit
done < $sourceslist
