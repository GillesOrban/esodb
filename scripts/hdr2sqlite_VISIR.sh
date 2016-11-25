# SQL table definition
# 
# CREATE TABLE visir(ra real, dec real, dateobs date PRIMARY KEY, night char, lst real, arcfile varchar, alt real, az real, dprtype varchar, dprtech varchar, dprcatg varchar, filt1 varchar, grat1 varchar, dit real, ndit int, exptime real, chop_ncycles int, prog varchar, object varchar, ob_name varchar, chopnod_dir varchar, nodpos varchar, chop_freq real, parang_start real, parang_end real, chop_posang real, chop_throw real, ada_start real, ada_end real, ada_posang real, fwhm_start real, fwhm_end real, irsky_temp real, iwv_start real, press_start real, rhum real, temp real, winddir real, windspeed real);
##
## CHANGE LOG
##
## 2016-11-23   Added several more parameters related to ADA and AMBI, sorted keywords by category (TEL,DET,DPR,...)
## 2016-11-14   Added several parameters related to the rotation of the instrument
##


# list header files, produce text file with relevant header information
dpidfile="$OBSDBLOCAL/data/DPID/VISIR.txt"
sqlfile="$OBSDBLOCAL/data/VISIR/SQL/insert.sql"

counter=0
while read DPID; do
	DPID_mac=`echo $DPID | sed 's/:/-/g'`
	nightdir=`echo $DPID | awk -F "." '{print $2}' | awk -F "T" '{print $1}'`
	HDRfile=$OBSDBLOCAL/data/VISIR/HDR/${nightdir}/${DPID_mac}.txt
	if [ ! -e $HDRfile ]; then echo "$HDRfile does not exist."; fi

	fields=""
	values=""
	##
	## generic keywords
	ra=`less $HDRfile | grep 'RA      =' | awk -F " " '{print $3}'`
	dec=`less $HDRfile | grep 'DEC     =' | awk -F " " '{print $3}'`
	dateobs=`less $HDRfile | grep DATE-OBS | awk -F "'" '{print $2}'`
	night=`whichnight_date.sh $dateobs`	
	year=`echo $night | awk -F "-" '{print $1}'`

	lst=`less $HDRfile | grep "LST     =" | awk -F " " '{print $3}'`
	arcfile=`less $HDRfile | grep "ARCFILE" | awk -F "'" '{print $2}'`
	alt=`less $HDRfile | grep 'HIERARCH ESO TEL ALT' | awk -F " " '{print $6}'`
	az=`less $HDRfile | grep 'HIERARCH ESO TEL AZ' | awk -F " " '{print $6}'`
	##
	## DPR keywords
	dprtype=`less $HDRfile | grep 'HIERARCH ESO DPR TYPE' | awk -F "'" '{print $2}'`
	dprtech=`less $HDRfile | grep 'HIERARCH ESO DPR TECH' | awk -F "'" '{print $2}'`
	dprcatg=`less $HDRfile | grep 'HIERARCH ESO DPR CATG' | awk -F "'" '{print $2}'`

	##
	## INS keywords
	filt1=`less $HDRfile | grep 'HIERARCH ESO INS FILT1 NAME' | awk -F "'" '{print $2}'`
	grat1=`less $HDRfile | grep 'HIERARCH ESO INS GRAT1 NAME' | awk -F "'" '{print $2}'`

	##
	## DET keywords
	##
	## VISIR was offline for upgrade all of 2014 (and before and after)
	if [ $year -lt "2014" ]; then
		## old visir
		dit=`less $HDRfile | grep 'HIERARCH ESO DET DIT = ' | awk -F " " '{print $6}'`
	else
		## new visir (since 2015??)
		dit=`less $HDRfile | grep 'HIERARCH ESO DET SEQ1 DIT = ' | awk -F " " '{print $7}'`
	fi
	ndit=`less $HDRfile | grep 'HIERARCH ESO DET NDIT = ' | awk -F " " '{print $6}'`
	exptime=`less $HDRfile | grep 'HIERARCH ESO DET SEQ1 EXPTIME = ' | awk '{print $7}'`
	chop_ncycles=`less $HDRfile | grep 'HIERARCH ESO DET CHOP NCYCLES = ' | awk '{print $7}'`

	##
	## OBS and SEQ keywords
	prog=`less $HDRfile | grep 'HIERARCH ESO OBS PROG ID = ' | awk -F "'" '{print $2}'`
	object=`less $HDRfile | grep 'OBJECT  =' | awk -F "'" '{print $2}'`
	ob_name=`less $HDRfile | grep 'HIERARCH ESO OBS NAME' | awk -F "'" '{print $2}'`
	chopnod_dir=`less $HDRfile | grep 'HIERARCH ESO SEQ CHOPNOD DIR = ' | awk -F "'" '{print $2}'`
	nodpos=`less $HDRfile | grep 'HIERARCH ESO SEQ NODPOS = ' | awk -F "'" '{print $2}'`

	##
	## TEL keywords
	chop_freq=`less $HDRfile | grep 'HIERARCH ESO TEL CHOP FREQ' | awk -F " " '{print $7}'`
	parang_start=`less $HDRfile | grep 'HIERARCH ESO TEL PARANG START' | awk -F " " '{print $7}'`
	parang_end=`less $HDRfile | grep 'HIERARCH ESO TEL PARANG END' | awk -F " " '{print $7}'`
	chop_posang=`less $HDRfile | grep 'HIERARCH ESO TEL CHOP POSANG' | awk -F " " '{print $7}'`
	chop_throw=`less $HDRfile | grep 'HIERARCH ESO TEL CHOP THROW' | awk -F " " '{print $7}'`
	
	##
	## ADA keywords (Adapter-Rotator)	
	ada_start=`less $HDRfile | grep 'HIERARCH ESO ADA ABSROT START' | awk -F " " '{print $7}'`
	ada_end=`less $HDRfile | grep 'HIERARCH ESO ADA ABSROT END' | awk -F " " '{print $7}'`
	ada_posang=`less $HDRfile | grep 'HIERARCH ESO ADA POSANG END' | awk -F " " '{print $7}'`
	
	##
	## AMBI keywords
	fwhm_start=`less $HDRfile | grep 'HIERARCH ESO TEL AMBI FWHM START = ' | awk -F " " '{print $8}'`
	fwhm_end=`less $HDRfile | grep 'HIERARCH ESO TEL AMBI FWHM END' | awk -F " " '{print $8}'`
	irsky_temp=`less $HDRfile | grep 'HIERARCH ESO TEL AMBI IRSKY TEMP = ' | awk -F " " '{print $8}'`
	iwv_start=`less $HDRfile | grep 'HIERARCH ESO TEL AMBI IWV START = ' | awk -F " " '{print $8}'`
	press_start=`less $HDRfile | grep 'HIERARCH ESO TEL AMBI PRES START = ' | awk -F " " '{print $8}'`
	rhum=`less $HDRfile | grep 'HIERARCH ESO TEL AMBI RHUM = ' | awk -F " " '{print $7}'`
	temp=`less $HDRfile | grep 'HIERARCH ESO TEL AMBI TEMP = ' | awk -F " " '{print $7}'`
	winddir=`less $HDRfile | grep 'HIERARCH ESO TEL AMBI WINDDIR = ' | awk -F " " '{print $7}'`
	windspeed=`less $HDRfile | grep 'HIERARCH ESO TEL AMBI WINDSP = ' | awk -F " " '{print $7}'`

	
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
	if [ ! -z "$arcfile" ]; then
		fields+=arcfile,
		values+=\'$arcfile\',
	fi
	if [ ! -z "$alt" ]; then
		fields+=alt,
		values+=$alt,
	fi
	if [ ! -z "$az" ]; then
		fields+=az,
		values+=$az,
	fi
	if [ ! -z "$dprtype" ]; then
		fields+=dprtype,
		values+=\'$dprtype\',
	fi
	if [ ! -z "$dprtech" ]; then
		fields+=dprtech,
		values+=\'$dprtech\',
	fi
	if [ ! -z "$dprcatg" ]; then
		fields+=dprcatg,
		values+=\'$dprcatg\',
	fi
	if [ ! -z "$filt1" ]; then
		fields+=filt1,
		values+=\'$filt1\',
	fi
	if [ ! -z "$grat1" ]; then
		fields+=grat1,
		values+=\'$grat1\',
	fi
	if [ ! -z "$dit" ]; then
		fields+=dit,
		values+=$dit,
	fi
	if [ ! -z "$ndit" ]; then
		fields+=ndit,
		values+=$ndit,
	fi
	if [ ! -z "$exptime" ]; then
		fields+=exptime,
		values+=$exptime,
	fi
	if [ ! -z "$chop_ncycles" ]; then
		fields+=chop_ncycles,
		values+=$chop_ncycles,
	fi
	if [ ! -z "$prog" ]; then
		fields+=prog,
		values+=\'$prog\',
	fi
	if [ ! -z "$object" ]; then
		fields+=object,
		values+=\'$object\',
	fi
	if [ ! -z "$ob_name" ]; then
		fields+=ob_name,
		values+=\'$ob_name\',
	fi
	if [ ! -z "$chopnod_dir" ]; then
		fields+=chopnod_dir,
		values+=\'$chopnod_dir\',
	fi
	if [ ! -z "$nodpos" ]; then
		fields+=nodpos,
		values+=\'$nodpos\',
	fi
	if [ ! -z "$chop_freq" ]; then
		fields+=chop_freq,
		values+=$chop_freq,
	fi
	if [ ! -z "$parang_start" ]; then
		fields+=parang_start,
		values+=$parang_start,
	fi
	if [ ! -z "$parang_end" ]; then
		fields+=parang_end,
		values+=$parang_end,
	fi
	if [ ! -z "$chop_posang" ]; then
		fields+=chop_posang,
		values+=$chop_posang,
	fi
	if [ ! -z "$chop_throw" ]; then
		fields+=chop_throw,
		values+=$chop_throw,
	fi
	if [ ! -z "$ada_start" ]; then
		fields+=ada_start,
		values+=$ada_start,
	fi
	if [ ! -z "$ada_end" ]; then
		fields+=ada_end,
		values+=$ada_end,
	fi
	if [ ! -z "$ada_posang" ]; then
		fields+=ada_posang,
		values+=$ada_posang,
	fi
	if [ ! -z "$fwhm_start" ] && [ ! "$fwhm_start" = "-1.00" ]; then
		fields+=fwhm_start,
		values+=$fwhm_start,
	fi
	if [ ! -z "$fwhm_end" ] && [ ! "$fwhm_end" = "-1.00" ]; then
		fields+=fwhm_end,
		values+=$fwhm_end,
	fi
	if [ ! -z "$irsky_temp" ]; then
		fields+=irsky_temp,
		values+=$irsky_temp,
	fi
	if [ ! -z "$iwv_start" ]; then
		fields+=iwv_start,
		values+=$iwv_start,
	fi
	if [ ! -z "$press_start" ]; then
		fields+=press_start,
		values+=$press_start,
	fi
	if [ ! -z "$rhum" ]; then
		fields+=rhum,
		values+=$rhum,
	fi
	if [ ! -z "$temp" ]; then
		fields+=temp,
		values+=$temp,
	fi
	if [ ! -z "$winddir" ]; then
		fields+=winddir,
		values+=$winddir,
	fi
	if [ ! -z "$windspeed" ]; then
		fields+=windspeed,
		values+=$windspeed,
	fi
	#
	# remove last comma from end of both strings
	fields="${fields%?}"
	values="${values%?}"
		
	echo "insert into visir($fields) values ($values)"\; >> $sqlfile
	if [[ `expr $counter % 500` -eq 0 ]]; then echo "Done with file No. $counter ($HDRfile)."; fi
	counter=$((counter+1))
done < $dpidfile