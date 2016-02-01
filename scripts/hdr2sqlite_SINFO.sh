## ACHTUNG
## catch: opti1 is sometimes a string
##

# list header files, produce text file with relevant header information
dpidfile="$OBSDBLOCAL/data/DPID/SINFO.txt"
sqlfile="$OBSDBLOCAL/data/SINFO/SQL/insert.sql"

counter=0
while read DPID; do
	DPID_mac=`echo $DPID | sed 's/:/-/g'`
	nightdir=`echo $DPID | awk -F "." '{print $2}' | awk -F "T" '{print $1}'`
	HDRfile=$OBSDBLOCAL/data/SINFO/HDR/${nightdir}/${DPID_mac}.txt
	if [ ! -e $HDRfile ]; then echo "$HDRfile does not exist."; fi

	fields=""
	values=""
	ra=`less $HDRfile | grep 'RA      =' | awk -F " " '{print $3}'`
	dec=`less $HDRfile | grep 'DEC     =' | awk -F " " '{print $3}'`
	dprtype=`less $HDRfile | grep 'HIERARCH ESO DPR TYPE' | awk -F "'" '{print $2}'`
	grat1=`less $HDRfile | grep 'HIERARCH ESO INS GRAT1 NAME' | awk -F "'" '{print $2}'`
	opti1=`less $HDRfile | grep 'HIERARCH ESO INS OPTI1 NAME' | awk -F "'" '{print $2}'`
	dit=`less $HDRfile | grep 'HIERARCH ESO DET DIT = ' | awk -F " " '{print $6}'`
	ndit=`less $HDRfile | grep 'HIERARCH ESO DET NDIT = ' | awk -F " " '{print $6}'`
	prog=`less $HDRfile | grep 'HIERARCH ESO OBS PROG ID = ' | awk -F "'" '{print $2}'`
	object=`less $HDRfile | grep 'OBJECT  =' | awk -F "'" '{print $2}'`
	airm_start=`less $HDRfile | grep 'AIRM START' | awk -F " " '{print $7}'`
	dateobs=`less $HDRfile | grep DATE-OBS | awk -F "'" '{print $2}'`
	night=`whichnight_date.sh $dateobs`
	lst=`less $HDRfile | grep "LST     =" | awk -F " " '{print $3}'`
	ao_tiptilt=`less $HDRfile | grep "AOS RTC LOOP TIPTILT" | awk -F " " '{print $8}'`
	ao_horder=`less $HDRfile | grep "AOS RTC LOOP HORDER" | awk -F " " '{print $8}'`
	ao_lgs=`less $HDRfile | grep "AOS RTC LOOP LGS" | awk -F " " '{print $8}'`
	arcfile=`less $HDRfile | grep "ARCFILE" | awk -F "'" '{print $2}'`
	lamp1=`less $HDRfile | grep "INS1 LAMP1 ST" | awk -F " " '{print $7}'`
	lamp2=`less $HDRfile | grep "INS1 LAMP2 ST" | awk -F " " '{print $7}'`
	lamp3=`less $HDRfile | grep "INS1 LAMP3 ST" | awk -F " " '{print $7}'`
	lamp4=`less $HDRfile | grep "INS1 LAMP4 ST" | awk -F " " '{print $7}'`
	lamp5=`less $HDRfile | grep "INS1 LAMP5 ST" | awk -F " " '{print $7}'`
	lamp6=`less $HDRfile | grep "INS1 LAMP6 ST" | awk -F " " '{print $7}'`
	lamps=$lamp1$lamp2$lamp3$lamp4$lamp5$lamp6
	fwhm_start=`less $HDRfile | grep 'AMBI FWHM START = ' | awk -F " " '{print $8}'`
	fwhm_end=`less $HDRfile | grep 'AMBI FWHM END' | awk -F " " '{print $8}'`
	ob_name=`less $HDRfile | grep 'HIERARCH ESO OBS NAME' | awk -F "'" '{print $2}'`
	offset_ra=`less $HDRfile | grep 'HIERARCH ESO SEQ CUMOFFSETA' | awk -F " " '{print $6}'`
	offset_dec=`less $HDRfile | grep 'HIERARCH ESO SEQ CUMOFFSETD' | awk -F " " '{print $6}'`
	
	if [ ! -z "$ra" ]; then
		fields+=ra,
		values+=$ra,
	fi
	if [ ! -z "$dec" ]; then
		fields+=dec,
		values+=$dec,
	fi
	if [ ! -z "$dprtype" ]; then
		fields+=dprtype,
		values+=\'$dprtype\',
	fi
	if [ ! -z "$grat1" ]; then
		fields+=grat1,
		values+=\'$grat1\',
	fi
	if [ ! -z "$opti1" ]; then
		## sometimes this field is "pupil", which we want to change to a numerical value
		if ! ( [[ "$opti1" == "0.025" ]] || [[ "$opti1" == "0.1" ]] || [[ "$opti1" == "0.25" ]] ); then
			echo "opti1 value of $opti1 changed to 0."
			opti1=0
		fi
		fields+=opti1,
		values+=$opti1,
	fi
	if [ ! -z "$dit" ]; then
		fields+=dit,
		values+=$dit,
	fi
	if [ ! -z "$ndit" ]; then
		fields+=ndit,
		values+=$ndit,
	fi
	if [ ! -z "$prog" ]; then
		fields+=prog,
		values+=\'$prog\',
	fi
	if [ ! -z "$object" ]; then
		fields+=object,
		values+=\'$object\',
	fi
	if [ ! -z "$airm_start" ]; then
		fields+=airm_start,
		values+=$airm_start,
	fi
	if [ ! -z "$dateobs" ]; then
		fields+=dateobs,
		values+=\'$dateobs\',
	fi
	if [ ! -z "$night" ]; then
		fields+=night,
		values+=\'$night\',
	fi
	if [ ! -z "$lst" ]; then
		fields+=lst,
		values+=$lst,
	fi
	if [ ! -z "$ao_tiptilt" ]; then
		fields+=ao_tiptilt,
		values+=\'$ao_tiptilt\',
	fi
	if [ ! -z "$ao_horder" ]; then
		fields+=ao_horder,
		values+=\'$ao_horder\',
	fi
	if [ ! -z "$ao_lgs" ]; then
		fields+=ao_lgs,
		values+=\'$ao_lgs\',
	fi
	if [ ! -z "$arcfile" ]; then
		fields+=arcfile,
		values+=\'$arcfile\',
	fi
	if [ ! -z "$lamps" ]; then
		fields+=lamps,
		values+=\'$lamps\',
	fi
	if [ ! -z "$fwhm_start" ] && [ ! "$fwhm_start" = "-1.00" ]; then
		fields+=fwhm_start,
		values+=\'$fwhm_start\',
	fi
	if [ ! -z "$fwhm_end" ] && [ ! "$fwhm_end" = "-1.00" ]; then
		fields+=fwhm_end,
		values+=\'$fwhm_end\',
	fi
	if [ ! -z "$ob_name" ]; then
		fields+=ob_name,
		values+=\'$ob_name\',
	fi
	if [ ! -z "$offset_ra" ]; then
		fields+=offset_ra,
		values+=$offset_ra,
	fi
	if [ ! -z "$offset_dec" ]; then
		fields+=offset_dec,
		values+=$offset_dec,
	fi
	#
	# remove last comma from end of both strings
	fields="${fields%?}"
	values="${values%?}"
		
	echo "insert into sinfo($fields) values ($values)"\; >> $sqlfile
	if [[ `expr $counter % 500` -eq 0 ]]; then echo "Done with file No. $counter ($HDRfile)."; fi
	counter=$((counter+1))
done < $dpidfile