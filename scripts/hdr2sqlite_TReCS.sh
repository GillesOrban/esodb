## SQLite table definition
##
# CREATE TABLE trecs(
# 	ra real,
# 	dec real,
# 	dateobs date PRIMARY KEY,
# 	object varchar,
# 	lambda real,
# 	filter varchar,
# 	grating varchar,
# 	objtime real
# 	);

sqlfile="$OBSDBLOCAL/data/TReCS/SQL/insert.sql"

counter=0
for night in `find $OBSDBLOCAL/data/TReCS/HDR -name "20*"`; do
	for HDRfile in `ls $night/*.txt`; do
		fields=""
		values=""
		ra=`less $HDRfile | grep 'RA      =' | awk -F " " '{print $3}'`
		dec=`less $HDRfile | grep 'DEC     =' | awk -F " " '{print $3}'`
		day=`less $HDRfile | grep 'DATE    =' | awk -F " " '{print $3}' | awk -F "'" '{print $2}'`
		ut=`less $HDRfile | grep 'UT      =' | awk -F " " '{print $3}' | awk -F "'" '{print $2}'`
		dateobs="${day}T${ut}"
		lambda=`less $HDRfile | grep 'WAVELENG=' | awk -F " " '{print $2}'`
		object=`less $HDRfile | grep 'OBJECT  =' | awk -F "'" '{print $2}'`
		filter=`less $HDRfile | grep 'FILTER1 =' | awk -F "'" '{print $2}'`
		grating=`less $HDRfile | grep 'GRATING =' | awk -F "'" '{print $2}'`
		objtime=`less $HDRfile | grep 'OBJTIME =' | awk -F " " '{print $3}'`
		
#		echo "ra: $ra"
#		echo "dec: $dec"
#		echo "day: $day"
#		echo "ut: $ut"
#		echo "dateobs: $dateobs"
#		echo "lambda: $lambda"
#		echo "object: $object"
#		echo "filter: $filter"
#		echo "grating: $grating"
#		echo "objtime: $objtime"
#		continue
	
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
		if [ ! -z "$lambda" ]; then
			fields+=lambda,
			values+=\'$lambda\',
		fi
		if [ ! -z "$object" ]; then
			fields+=object,
			values+=\'$object\',
		fi
		if [ ! -z "$filter" ]; then
			fields+=filter,
			values+=\'$filter\',
		fi
		if [ ! -z "$grating" ]; then
			fields+=grating,
			values+=\'$grating\',
		fi
		if [ ! -z "$objtime" ]; then
			fields+=objtime,
			values+=$objtime,
		fi
		#
		# remove last comma from end of both strings
		fields="${fields%?}"
		values="${values%?}"
		
		echo "insert into trecs($fields) values ($values)"\; >> $sqlfile
		if [[ `expr $counter % 500` -eq 0 ]]; then echo "Done with file No. $counter ($HDRfile)."; fi
		counter=$((counter+1))
	done
done
