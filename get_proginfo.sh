#!/bin/bash
##
## get programme info HTML file, extract relevant information and update SQL DB
##
## HISTORY
##    2015-06-01   Now using generic ESO query form (not SINFONI-specific one)
##                    in order to find programmes involving all instruments
##    2015-04-24   Now automatically searches all programmes for which 
##                    observations are in DB, but that do not have a description;
##                    then queries ESO DB for these programmes and inserts info
##                    into DB
##    2012-11-12   created
##
## CAVEATS
##    - sometimes prog numbers have no leading 0, this causes some uniqueness warnings
##

##
## set file and directory names
progdir=$OBSDBLOCAL/data/prog
htmldir=$progdir/html

obsprogs=$progdir/obsprogs.txt
obsprogs_uniq=$progdir/obsprogs_uniq.txt
dbprogs=$progdir/dbprogs.txt
newprogs=$progdir/newprogs.txt
sqlfile=$progdir/sql/insert_progs.sql
##
## select progs from all instrument tables, strip run ID and leading zeros before sort and uniq
sqlite3 $OBSDB 'select prog from sinfo;' >> $obsprogs
sqlite3 $OBSDB 'select prog from shoot;' >> $obsprogs
sqlite3 $OBSDB 'select prog from midi;' >> $obsprogs
if [ -e $obsprogs_uniq ]; then rm $obsprogs_uniq; fi
cat $obsprogs | awk -F "(" '{print $1}' | sed 's/^0//' | sort | uniq > $obsprogs_uniq
##
## select all progs from prog table, strip leading zeros before sort and uniq and build diff file
sqlite3 $OBSDB 'select prog from prog;' | sed 's/^0//' | sort | uniq > $dbprogs
if [ -e $newprogs ]; then rm $newprogs; fi
diff $obsprogs_uniq $dbprogs | egrep ["<"">"] | awk '{print $2}' > $newprogs

if [ -e $sqlfile ]; then rm $sqlfile; fi

while read prog; do
	htmlfile="$htmldir/${prog}.html"
	##
	## query ESO archive
	if [ ! -e $htmlfile ]; then
		wget http://archive.eso.org/wdb/wdb/eso/sched_rep_arc/query?progid=${prog} -O $htmlfile
		echo "Queried ESO archive server for programme $prog. Stored HTML file $htmlfile."
	fi
	if [ ! -e $htmlfile ]; then echo "Could not download $htmlfile."; else
		picoi=`cat $htmlfile | grep "PI/CoI"`
		picoi=${picoi:24}
		picoi=`echo $picoi | sed 's/'"'"'//g'`
		title=`cat $htmlfile | grep "Proposal Title"`
		title=${title:24}
		title=`echo $title | sed 's/'"'"'//g'`
		
		fields=""
		values=""

		fields+=prog,
		values+=\'$prog\',

		if [ ! -z "$picoi" ]; then
		fields+=picoi,
		values+=\'$picoi\',
		fi

		if [ ! -z "$title" ]; then
		fields+=title,
		values+=\'$title\',
		fi

		#
		# remove last comma from end of both strings
		fields="${fields%?}"
		values="${values%?}"
		echo "insert into prog($fields) values ($values)"\; >> $sqlfile
	fi
done < $newprogs

sqlite3 $OBSDB < $sqlfile
nprog=`wc -l $sqlfile`
echo "Inserted $nprog new programmes into OBSDB."

##
## cleanup
rm $obsprogs
rm $obsprogs_uniq
rm $dbprogs
rm $newprogs
rm $sqlfile
rm $htmldir/*.html