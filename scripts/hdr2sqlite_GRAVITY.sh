##
## SQLite table schema
# CREATE TABLE gravity(ra real, dec real, dateobs date PRIMARY KEY, night char, lst real, dprtype varchar, dprcatg varchar, dit_sci real, ndit_sci real, dit_ft real, station1 varchar, station2 varchar, station3 varchar, station4 varchar, tel1 varchar, tel2 varchar, tel3 varchar, tel4 varchar, prog varchar, target varchar, ob_name varchar, object varchar, airm_start real, arcfile varchar, fwhm_start real, fwhm_end real);

# list header files, produce text file with relevant header information
dpidfile="$OBSDBLOCAL/data/DPID/GRAVITY.txt"
sqlfile="$OBSDBLOCAL/data/GRAVITY/SQL/insert.sql"

counter=0
while read DPID; do
	DPID_mac=`echo $DPID | sed 's/:/-/g'`
	nightdir=`echo $DPID | awk -F "." '{print $2}' | awk -F "T" '{print $1}'`
	HDRfile=$OBSDBLOCAL/data/GRAVITY/HDR/${nightdir}/${DPID_mac}.txt
	if [ ! -e $HDRfile ]; then echo "$HDRfile does not exist."; fi

	fields=""
	values=""
	ra=`less $HDRfile | grep 'RA      =' | awk -F " " '{print $3}'`
	dec=`less $HDRfile | grep 'DEC     =' | awk -F " " '{print $3}'`
	dateobs=`less $HDRfile | grep DATE-OBS | head -n 1 | awk -F "'" '{print $2}'`
	night=`whichnight_date.sh $dateobs`
	lst=`less $HDRfile | grep "LST     =" | awk -F " " '{print $3}'`

	dprtype=`less $HDRfile | grep 'HIERARCH ESO DPR TYPE' | awk -F "'" '{print $2}'`
	dprcatg=`less $HDRfile | grep 'HIERARCH ESO DPR CATG' | awk -F "'" '{print $2}'`
	dit_sci=`less $HDRfile | grep 'HIERARCH ESO DET2 SEQ1 DIT = ' | awk -F " " '{print $7}'`
	ndit_sci=`less $HDRfile | grep 'HIERARCH ESO DET2 SEQ1 NDIT = ' | awk -F " " '{print $7}'`
	dit_ft=`less $HDRfile | grep 'HIERARCH ESO DET3 SEQ1 DIT = ' | awk -F " " '{print $7}'`
	station1=`less $HDRfile | grep 'HIERARCH ESO ISS CONF STATION1' | awk -F "'" '{print $2}'`
	station2=`less $HDRfile | grep 'HIERARCH ESO ISS CONF STATION2' | awk -F "'" '{print $2}'`
	station3=`less $HDRfile | grep 'HIERARCH ESO ISS CONF STATION3' | awk -F "'" '{print $2}'`
	station4=`less $HDRfile | grep 'HIERARCH ESO ISS CONF STATION4' | awk -F "'" '{print $2}'`
	tel1=`less $HDRfile | grep 'HIERARCH ESO ISS CONF T1NAME' | awk -F "'" '{print $2}'`
	tel2=`less $HDRfile | grep 'HIERARCH ESO ISS CONF T2NAME' | awk -F "'" '{print $2}'`
	tel3=`less $HDRfile | grep 'HIERARCH ESO ISS CONF T3NAME' | awk -F "'" '{print $2}'`
	tel4=`less $HDRfile | grep 'HIERARCH ESO ISS CONF T4NAME' | awk -F "'" '{print $2}'`
	prog=`less $HDRfile | grep 'HIERARCH ESO OBS PROG ID = ' | awk -F "'" '{print $2}'`
	target=`less $HDRfile | grep 'HIERARCH ESO OBS TARG NAME = ' | awk -F "'" '{print $2}'`
	ob_name=`less $HDRfile | grep 'HIERARCH ESO OBS NAME' | awk -F "'" '{print $2}'`
	object=`less $HDRfile | grep 'OBJECT  =' | awk -F "'" '{print $2}'`
	airm_start=`less $HDRfile | grep 'HIERARCH ESO ISS AIRM START = ' | awk -F " " '{print $7}'`
	arcfile=`less $HDRfile | grep "ARCFILE" | awk -F "'" '{print $2}'`
	fwhm_start=`less $HDRfile | grep 'HIERARCH ESO ISS AMBI FWHM START = ' | awk -F " " '{print $8}'`
	fwhm_end=`less $HDRfile | grep 'HIERARCH ESO ISS AMBI FWHM END' | awk -F " " '{print $8}'`

	if [ ! -z "$ra" ]; then
		fields+=ra,
		values+=$ra,
	fi
	if [ ! -z "$dec" ]; then
		fields+=dec,
		values+=$dec,
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
	if [ ! -z "$dprtype" ]; then
		fields+=dprtype,
		values+=\'$dprtype\',
	fi
	if [ ! -z "$dprcatg" ]; then
		fields+=dprcatg,
		values+=\'$dprcatg\',
	fi
	if [ ! -z "$dit_sci" ]; then
		fields+=dit_sci,
		values+=$dit_sci,
	fi
	if [ ! -z "$ndit_sci" ]; then
		fields+=ndit_sci,
		values+=$ndit_sci,
	fi
	if [ ! -z "$dit_ft" ]; then
		fields+=dit_ft,
		values+=$dit_ft,
	fi
	if [ ! -z "$station1" ]; then
		fields+=station1,
		values+=\'$station1\',
	fi
	if [ ! -z "$station2" ]; then
		fields+=station2,
		values+=\'$station2\',
	fi
	if [ ! -z "$station3" ]; then
		fields+=station3,
		values+=\'$station3\',
	fi
	if [ ! -z "$station4" ]; then
		fields+=station4,
		values+=\'$station4\',
	fi
	if [ ! -z "$tel1" ]; then
		fields+=tel1,
		values+=\'$tel1\',
	fi
	if [ ! -z "$tel2" ]; then
		fields+=tel2,
		values+=\'$tel2\',
	fi
	if [ ! -z "$tel3" ]; then
		fields+=tel3,
		values+=\'$tel3\',
	fi
	if [ ! -z "$tel4" ]; then
		fields+=tel4,
		values+=\'$tel4\',
	fi
	if [ ! -z "$prog" ]; then
		fields+=prog,
		values+=\'$prog\',
	fi
	if [ ! -z "$target" ]; then
		fields+=target,
		values+=\'$target\',
	fi
	if [ ! -z "$ob_name" ]; then
		fields+=ob_name,
		values+=\'$ob_name\',
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
	#
	# remove last comma from end of both strings
	fields="${fields%?}"
	values="${values%?}"
		
	echo "insert into gravity($fields) values ($values)"\; >> $sqlfile
	if [[ `expr $counter % 500` -eq 0 ]]; then echo "Done with file No. $counter ($HDRfile)."; fi
	counter=$((counter+1))
done < $dpidfile