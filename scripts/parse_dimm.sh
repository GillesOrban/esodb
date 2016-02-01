while read LINE; do
	date_d=`echo $LINE | awk -F " " '{print $1}'`
	date_t=`echo $LINE | awk -F " " '{print $2}'`
	[[ ! "$date_d" =~ ^(19|20)[0-9][0-9]-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$ ]] && continue
	[[ ! "$date_t" =~ ^(0|1|2)[0-9]:[0-5][0-9]:[0-5][0-9]$ ]] && continue
	dateobs=${date_d}T${date_t}
	ra=`echo $LINE | awk -F " " '{print $3}'`
	dec=`echo $LINE | awk -F " " '{print $4}'`
	[[ ! "$ra" =~ ^[0-9]*\.?[0-9]+$ ]] && continue
	[[ ! "$dec" =~ ^[-+]?[0-9]*\.?[0-9]+$ ]] && continue
	seeing=`echo $LINE | awk -F " " '{print $5}'`
	[[ ! "$seeing" =~ ^[0-9]*\.?[0-9]+$ ]] && continue
	airmass=`echo $LINE | awk -F " " '{print $6}'`
	[[ ! "$airmass" =~ ^(1|2|3)\.?[0-9]+$ ]] && continue
	
	fields="dateobs,ra,dec,seeing,airmass,"
	values=\'$dateobs\',$ra,$dec,$seeing,$airmass,
	
	flux_rms=`echo $LINE | awk -F " " '{print $7}'`
	if [[ "$flux_rms" =~ ^0\.?[0-9]+$ ]];
		then
		fields+=flux_rms,
		values+=$flux_rms,
	fi
	tau0=`echo $LINE | awk -F " " '{print $8}'`
	if [[ "$tau0" =~ ^[0-9]\.?[0-9]+$ ]];
		then
		fields+=tau0,
		values+=$tau0,
	fi
	theta0=`echo $LINE | awk -F " " '{print $9}'`
	if [[ "$theta0" =~ ^[0-9]\.?[0-9]+$ ]];
		then
		fields+=theta0,
		values+=$theta0,
	fi

	# remove last comma from end of both strings
	fields="${fields%?}"
	values="${values%?}"

	echo "insert into dimm($fields) values ($values)"\;
done < $1
