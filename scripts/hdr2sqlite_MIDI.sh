## ACHTUNG
## catch: opti1 is sometimes a string
##

# list header files, produce text file with relevant header information
dpidfile="$OBSDBLOCAL/data/DPID/MIDI.txt"
sqlfile="$OBSDBLOCAL/data/MIDI/SQL/insert.sql"

counter=0
while read DPID; do
	DPID_mac=`echo $DPID | sed 's/:/-/g'`
	nightdir=`echo $DPID | awk -F "." '{print $2}' | awk -F "T" '{print $1}'`
	HDRfile=$OBSDBLOCAL/data/MIDI/HDR/${nightdir}/${DPID_mac}.txt
	if [ ! -e $HDRfile ]; then echo "$HDRfile does not exist."; fi

	fields=""
	values=""
	ra=`less $HDRfile | grep 'RA      =' | awk -F " " '{print $3}'`
	dec=`less $HDRfile | grep 'DEC     =' | awk -F " " '{print $3}'`
	dprtype=`less $HDRfile | grep 'HIERARCH ESO DPR TYPE' | awk -F "'" '{print $2}'`
	dprcatg=`less $HDRfile | grep 'HIERARCH ESO DPR CATG' | awk -F "'" '{print $2}'`
	shut_name=`less $HDRfile | grep 'HIERARCH ESO INS SHUT NAME' | awk -F "'" '{print $2}'`
	beamcombiner=`less $HDRfile | grep 'HIERARCH ESO INS OPT1 NAME' | awk -F "'" '{print $2}'`
	filt_name=`less $HDRfile | grep 'HIERARCH ESO INS FILT NAME' | awk -F "'" '{print $2}'`
	gris_name=`less $HDRfile | grep 'HIERARCH ESO INS GRIS NAME' | awk -F "'" '{print $2}'`
	nrts_mode=`less $HDRfile | grep 'HIERARCH ESO DET NRTS MODE' | awk -F "'" '{print $2}'`
	chopfrq=`less $HDRfile | grep 'HIERARCH ESO ISS CHOP FREQ' | awk -F " " '{print $7}'`
	tel=`less $HDRfile | grep 'TELESCOP' | head -n 1 | awk -F "'" '{print $2}'`
	prog=`less $HDRfile | grep 'HIERARCH ESO OBS PROG ID = ' | awk -F "'" '{print $2}'`
	dateobs=`less $HDRfile | grep DATE-OBS | head -n 1 | awk -F "'" '{print $2}'`
	night=`whichnight_date.sh $dateobs`
	lst=`less $HDRfile | grep "LST     =" | awk -F " " '{print $3}'`
	dit=`less $HDRfile | grep 'HIERARCH ESO DET DIT = ' | awk -F " " '{print $6}'`
	ndit=`less $HDRfile | grep 'HIERARCH ESO DET NDIT = ' | awk -F " " '{print $6}'`
	object=`less $HDRfile | grep 'OBJECT  =' | awk -F "'" '{print $2}'`
	airm_start=`less $HDRfile | grep 'AIRM START' | awk -F " " '{print $7}'`
	arcfile=`less $HDRfile | grep "ARCFILE" | awk -F "'" '{print $2}'`
	fwhm_start=`less $HDRfile | grep 'AMBI FWHM START = ' | awk -F " " '{print $8}'`
	fwhm_end=`less $HDRfile | grep 'AMBI FWHM END' | awk -F " " '{print $8}'`
	ob_name=`less $HDRfile | grep 'HIERARCH ESO OBS NAME' | awk -F "'" '{print $2}'`
	bl_start=`less $HDRfile | grep 'HIERARCH ESO ISS PBL12 START' | awk -F " " '{print $7}'`
	pa_start=`less $HDRfile | grep 'HIERARCH ESO ISS PARANG START' | awk -F " " '{print $7}'`

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
	if [ ! -z "$dprcatg" ]; then
		fields+=dprcatg,
		values+=\'$dprcatg\',
	fi
	if [ ! -z "$shut_name" ]; then
		fields+=shut_name,
		values+=\'$shut_name\',
	fi
	if [ ! -z "$beamcombiner" ]; then
		fields+=beamcombiner,
		values+=\'$beamcombiner\',
	fi
	if [ ! -z "$filt_name" ]; then
		fields+=filt_name,
		values+=\'$filt_name\',
	fi
	if [ ! -z "$gris_name" ]; then
		fields+=gris_name,
		values+=\'$gris_name\',
	fi
	if [ ! -z "$nrts_mode" ]; then
		fields+=nrts_mode,
		values+=\'$nrts_mode\',
	fi
	if [ ! -z "$chopfrq" ]; then
		fields+=chopfrq,
		values+=$chopfrq,
	fi
	if [ ! -z "$tel" ]; then
		fields+=tel,
		values+=\'$tel\',
	fi
	if [ ! -z "$prog" ]; then
		fields+=prog,
		values+=\'$prog\',
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
	if [ ! -z "$dit" ]; then
		fields+=dit,
		values+=$dit,
	fi
	if [ ! -z "$ndit" ]; then
		fields+=ndit,
		values+=$ndit,
	fi
	if [ ! -z "$object" ]; then
		fields+=object,
		values+=\'$object\',
	fi
	if [ ! -z "$airm_start" ]; then
		fields+=airm_start,
		values+=$airm_start,
	fi
	if [ ! -z "$arcfile" ]; then
		fields+=arcfile,
		values+=\'$arcfile\',
	fi
	if [ ! -z "$fwhm_start" ] && [ ! "$fwhm_start" = "-1.00" ]; then
		fields+=fwhm_start,
		values+=$fwhm_start,
	fi
	if [ ! -z "$fwhm_end" ] && [ ! "$fwhm_end" = "-1.00" ]; then
		fields+=fwhm_end,
		values+=$fwhm_end,
	fi
	if [ ! -z "$ob_name" ]; then
		fields+=ob_name,
		values+=\'$ob_name\',
	fi
	if [ ! -z "$bl_start" ]; then
		fields+=bl_start,
		values+=$bl_start,
	fi
	if [ ! -z "$pa_start" ]; then
		fields+=pa_start,
		values+=$pa_start,
	fi
	#
	# remove last comma from end of both strings
	fields="${fields%?}"
	values="${values%?}"
		
	echo "insert into midi($fields) values ($values)"\; >> $sqlfile
	if [[ `expr $counter % 500` -eq 0 ]]; then echo "Done with file No. $counter ($HDRfile)."; fi
	counter=$((counter+1))
done < $dpidfile