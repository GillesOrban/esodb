###
### CAVEAT: At the moment we record only DET DIT which is the NIR arm DIT!
###


# list header files, produce text file with relevant header information
dbfile="$OBSDB"
dpidfile="$OBSDBLOCAL/data/DPID/SHOOT.txt"
sqlfile="$OBSDBLOCAL/data/SHOOT/SQL/insert.sql"
HDRdir="$OBSDBLOCAL/data/SHOOT/HDR"
counter=0
while read DPID; do
	DPID_mac=`echo $DPID | sed 's/:/-/g'`
	nightdir=`echo $DPID | awk -F "." '{print $2}' | awk -F "T" '{print $1}'`
	HDRfile=$HDRdir/${nightdir}/${DPID_mac}.txt
	if [ ! -e $HDRfile ]; then echo "$HDRfile does not exist."; fi
	fields=""
	values=""
	ra=`less $HDRfile | grep 'RA      =' | awk -F " " '{print $3}'`
	dec=`less $HDRfile | grep 'DEC     =' | awk -F " " '{print $3}'`
	dprtype=`less $HDRfile | grep 'HIERARCH ESO DPR TYPE' | awk -F "'" '{print $2}'`
	dprtech=`less $HDRfile | grep 'HIERARCH ESO DPR TECH' | awk -F "'" '{print $2}'`
	dit=`less $HDRfile | grep 'HIERARCH ESO DET DIT = ' | awk -F " " '{print $6}'`
	ndit=`less $HDRfile | grep 'HIERARCH ESO DET NDIT = ' | awk -F " " '{print $6}'`
	prog=`less $HDRfile | grep 'HIERARCH ESO OBS PROG ID = ' | awk -F "'" '{print $2}'`
	object=`less $HDRfile | grep 'OBJECT  =' | awk -F "'" '{print $2}'`
	airm_start=`less $HDRfile | grep 'AIRM START' | awk -F " " '{print $7}'`
	dateobs=`less $HDRfile | grep DATE-OBS | awk -F "'" '{print $2}'`
	night=`whichnight_date.sh $dateobs`
	lst=`less $HDRfile | grep "LST     =" | awk -F " " '{print $3}'`
	arcfile=`less $HDRfile | grep "ARCFILE" | awk -F "'" '{print $2}'`
	fwhm_start=`less $HDRfile | grep 'AMBI FWHM START = ' | awk -F " " '{print $8}'`
	fwhm_end=`less $HDRfile | grep 'AMBI FWHM END' | awk -F " " '{print $8}'`
	ob_name=`less $HDRfile | grep 'HIERARCH ESO OBS NAME' | awk -F "'" '{print $2}'`
	opti2_name=`less $HDRfile | grep 'HIERARCH ESO INS OPTI2 NAME' | awk -F "'" '{print $2}'`
	opti3_name=`less $HDRfile | grep 'HIERARCH ESO INS OPTI3 NAME' | awk -F "'" '{print $2}'`
	opti4_name=`less $HDRfile | grep 'HIERARCH ESO INS OPTI4 NAME' | awk -F "'" '{print $2}'`
	opti5_name=`less $HDRfile | grep 'HIERARCH ESO INS OPTI5 NAME' | awk -F "'" '{print $2}'`
	arm=`less $HDRfile | grep 'HIERARCH ESO SEQ ARM' | awk -F "'" '{print $2}'`
	clock=`less $HDRfile | grep 'HIERARCH ESO DET READ CLOCK' | awk -F "'" '{print $2}'`
	posang=`less $HDRfile | grep 'HIERARCH ESO ADA POSANG' | awk -F " " '{print $6}'`
	parang_start=`less $HDRfile | grep 'HIERARCH ESO TEL PARANG START' | awk -F " " '{print $7}'`
	parang_end=`less $HDRfile | grep 'HIERARCH ESO TEL PARANG END' | awk -F " " '{print $7}'`

	night=`whichnight_date.sh $dateobs`

	
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
	if [ ! -z "$dprtech" ]; then
		fields+=dprtech,
		values+=\'$dprtech\',
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
	if [ ! -z "$arcfile" ]; then
		fields+=arcfile,
		values+=\'$arcfile\',
	fi
	if [ ! -z "$fwhm_start" ]; then
		fields+=fwhm_start,
		values+=$fwhm_start,
	fi
	if [ ! -z "$fwhm_end" ]; then
		fields+=fwhm_end,
		values+=$fwhm_end,
	fi
	if [ ! -z "$ob_name" ]; then
		fields+=ob_name,
		values+=\'$ob_name\',
	fi
	if [ ! -z "$opti2_name" ]; then
		fields+=opti2_name,
		values+=\'$opti2_name\',
	fi
	if [ ! -z "$opti3_name" ]; then
		fields+=opti3_name,
		values+=\'$opti3_name\',
	fi
	if [ ! -z "$opti4_name" ]; then
		fields+=opti4_name,
		values+=\'$opti4_name\',
	fi
	if [ ! -z "$opti5_name" ]; then
		fields+=opti5_name,
		values+=\'$opti5_name\',
	fi
	if [ ! -z "$arm" ]; then
		fields+=arm,
		values+=\'$arm\',
	fi
	if [ ! -z "$clock" ]; then
		fields+=clock,
		values+=\'$clock\',
	fi
	if [ ! -z "$posang" ]; then
		fields+=posang,
		values+=$posang,
	fi
	if [ ! -z "$parang_start" ]; then
		fields+=parang_start,
		values+=$parang_start,
	fi
	if [ ! -z "$parang_end" ]; then
		fields+=parang_end,
		values+=$parang_end,
	fi
	
	#
	# remove last comma from end of both strings
	fields="${fields%?}"
	values="${values%?}"
		
	echo "insert into shoot($fields) values ($values)"\; >> $sqlfile
	if [[ `expr $counter % 500` -eq 0 ]]; then echo "Done with file No. $counter ($HDRfile)."; fi
	counter=$((counter+1))
done < $dpidfile