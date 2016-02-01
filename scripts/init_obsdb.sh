##
## initialize the obs db for a given instrument, currently only SINFONI and XSHOOTER are supported, but other VLT-software compliant instruments can be trivially added.
##
## Table dimm has to be updated manually, see instructions in README.update-db.txt
##
function update_ins {

	INS=$1
	echo $INS

	if [[ $INS == "SINFO" ]]; then
		table="sinfo"
		instrument="sinfoni"
		hdr2sql_script=$OBSDBDIR/scripts/hdr2sqlite_SINFO.sh
		sqlfile=$OBSDBLOCAL/data/SINFO/SQL/insert.sql
		htmlfiles=$OBSDBLOCAL/data/SINFO/html/*.html
		dpid_tmp=$OBSDBLOCAL/data/DPID/SINFO.txt
		dpid_all=$OBSDBLOCAL/data/DPID/SINFO_all.txt
		last_date="2004-07-01"
	elif [[ $INS == "SHOOT" ]]; then
		table="shoot"
		instrument="xshooter"
		hdr2sql_script=$OBSDBDIR/scripts/hdr2sqlite_SHOOT.sh
		sqlfile=$OBSDBLOCAL/data/SHOOT/SQL/insert.sql
		htmlfiles=$OBSDBLOCAL/data/SHOOT/html/*.html
		dpid_tmp=$OBSDBLOCAL/data/DPID/SHOOT.txt
		dpid_all=$OBSDBLOCAL/data/DPID/SHOOT_all.txt
		last_date="2008-11-01"
	fi

	YY_start=`echo $last_date | awk -F "-" '{print $1}'`
	MM_start=`echo $last_date | awk -F "-" '{print $2}'`
	DD_start=`echo $last_date | awk -F "-" '{print $3}'`
	##
	## download headers
	command="$OBSDBDIR/scripts/get_hdrs_INS.sh $INS $instrument $YY_start $MM_start $DD_start"
	sh $command
	if [ ! $? == 0 ]; then
		echo "Error encountered with download script. Exiting"
		exit
	fi
	##
	## convert headers to SQL insert statements and insert into DB
	sh $hdr2sql_script
	sqlite3 $OBSDB < $sqlfile
	##
	## cleanup
	echo "Now deleting temporary files..."
	rm $sqlfile
	rm $htmlfiles
	cat $dpid_tmp >> $dpid_all
	rm $dpid_tmp
}

echo "Updating OBSDB with SINFONI observations..."
update_ins "SINFO"

echo "Updating OBSDB with X-SHOOTER observations..."
update_ins "SHOOT"
##
## update info about programmes
echo "Updating information about observing programmes..."
sh $OBSDBDIR/scripts/get_proginfo.sh
