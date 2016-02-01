sqlfile="$HOME/obsdb/sql_insert/insert_sources.sql"
	while read LINE; do
		sourcename=`echo $LINE | awk -F "|" '{print $1}'`
		ra=`echo $LINE | awk -F "|" '{print $3}'`
		dec=`echo $LINE | awk -F "|" '{print $4}'`
		z=`echo $LINE | awk -F "|" '{print $5}'`
		
		fields="name,ra,dec,z"
		values=\'$sourcename\',$ra,$dec,$z
		
		echo "insert into sources($fields) values ($values)"\; >> $sqlfile
#		echo "insert into sources($fields) values ($values)"\;
	done < $1
