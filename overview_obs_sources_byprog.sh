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
#dbfile="/afs/mpe.mpg.de/irdata/spiffi/data/database/obs.db"
dir_db="$OBSDBDIR"
dbfile="$OBSDB"

sourceslist="$dir_db/scripts/targets.txt"

#sourceslist="/tmp/sql_out_sources.txt"
#if [ -e $sourceslist ]; then rm $sourceslist; fi
#sqlite3 $dbfile "select name, ra, dec, z from sources where z<0.025;" >> $sourceslist
#if [ ! -e $sourceslist ]; then echo "could not create source file"; fi

while read LINE; do
	object=`echo $LINE | awk -F "|" '{print $1}'`
	ra=`echo $LINE | awk -F "|" '{print $2}'`
	dec=`echo $LINE | awk -F "|" '{print $3}'`
#	redshift=`echo $LINE | awk -F "|" '{print $4}'`
	##
	## get unique list of programmes with observations of this object; search box: 10 arcsec (sufficient to catch all AGNs)
	searchboxhalflength=5
	ra1=$(echo "scale=5;$ra-$searchboxhalflength/3600"|bc)
	ra2=$(echo "scale=5;$ra+$searchboxhalflength/3600"|bc)
	dec1=$(echo "scale=5;$dec-$searchboxhalflength/3600"|bc)
	dec2=$(echo "scale=5;$dec+$searchboxhalflength/3600"|bc)
	
#	echo $object
	progs=$(sqlite3 $dbfile "select distinct prog.prog from prog inner join obs on substr(obs.prog,1,10)=prog.prog where obs.dprtype LIKE '%OBJECT%' and obs.ra between $ra1 and $ra2 and obs.dec between $dec1 and $dec2;")
	
	grat="K H+K"
	#grat="J H K H+K"
	opti="0.025 0.1 0.25"
	
	for iprog in $progs; do
#		echo $iprog
		for igrat in $grat; do
#			echo $igrat
			for iopti in $opti; do
#				echo $iopti
				query="select dateobs, round(sum(dit * ndit)/3600.,2) 'ToT [h]', object, picoi from obs inner join prog on substr(obs.prog,1,10) = prog.prog where obs.grat1='$igrat' and obs.opti1=$iopti and obs.dprtype LIKE '%OBJECT%' and obs.ra between $ra1 and $ra2 and obs.dec between $dec1 and $dec2 and substr(obs.prog,1,10) = '$iprog' and obs.fwhm_start < 1.1;"
				result=$(sqlite3 $dbfile "$query")
				dateobs=$(echo $result | awk -F "|" '{print $1}')
				ToT=$(echo $result | awk -F "|" '{print $2}')
				hdr_obj=$(echo $result | awk -F "|" '{print $3}')
				picoi=$(echo $result | awk -F "|" '{print $4}')
				if [ -z "$dateobs" ] || [ -z "$ToT" ] ; then continue; fi
				ToT_min=0.25
				if [[ `echo "$ToT < $ToT_min" | bc` -eq 1 ]]; then continue; fi
				query_badseeing="select dateobs, round(sum(dit * ndit)/3600.,2) 'ToT [h]', object, picoi from obs inner join prog on substr(obs.prog,1,10) = prog.prog where obs.grat1='$igrat' and obs.opti1=$iopti and obs.dprtype LIKE '%OBJECT%' and obs.ra between $ra1 and $ra2 and obs.dec between $dec1 and $dec2 and substr(obs.prog,1,10) = '$iprog' and obs.fwhm_start >= 1.1;"
				result_badseeing=$(sqlite3 $dbfile "$query_badseeing")
				ToT_badseeing=$(echo $result_badseeing | awk -F "|" '{print $2}')

#				printf '%-20s %-20s %10s %10s %5s %-3s %-5s %-6s %-6s %-10s %-50s\n' "$object" "$hdr_obj" "$ra" "$dec" "$redshift" "$igrat" "$iopti" "$ToT" "$ToT_badseeing" "$iprog" "$picoi"
				echo "$object,$hdr_obj,$ra,$dec,$redshift,$igrat,$iopti,$ToT,$ToT_badseeing,$iprog,$picoi"
#				echo $result
			done
		done
	done
done < $sourceslist
