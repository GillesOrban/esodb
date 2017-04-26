##
## probably more efficient way to add one header keyword to database (compared to running everything again)
##
## IMPORTANT: don't forget to add whatever field I am adding here also to the main script (hdr2sqlite_VISIR.sh)!
##

# list header files, produce text file with relevant header information
dpidfile="$OBSDBLOCAL/data/DPID/VISIR_some.txt"
sqlfile="$OBSDBLOCAL/data/VISIR/SQL/insert.sql"

counter=0
while read DPID; do
	DPID_mac=`echo $DPID | sed 's/:/-/g'`
	nightdir=`echo $DPID | awk -F "." '{print $2}' | awk -F "T" '{print $1}'`
	HDRfile=$OBSDBLOCAL/data/VISIR/HDR/${nightdir}/${DPID_mac}.txt
	if [ ! -e $HDRfile ]; then echo "$HDRfile does not exist."; fi

	dateobs=`less $HDRfile | grep -m 1 DATE-OBS | awk -F "'" '{print $2}'`

	##
	## NEW FIELD
	m1temp=`less $HDRfile | grep -m 1 'HIERARCH ESO TEL TH M1 TEMP = ' | awk -F " " '{print $8}'`
	##
	##

	if [ ! -z "$m1temp" ]; then
		echo "update visir set m1temp=$m1temp where dateobs=\"$dateobs\";" >> $sqlfile
	fi
		
	if [[ `expr $counter % 500` -eq 0 ]]; then echo "Done with file No. $counter ($HDRfile)."; fi
	counter=$((counter+1))
done < $dpidfile