## post-processing / parsing TReCS files after downloading index files...

url_base="http://archive.gemini.edu"

for f in `find $OBSDBLOCAL/data/TReCS/html -type f -name *.html`; do
	##
	## first remove archive query results for nights without TReCS observations
	if [[ `grep "<H2>Your search returned no results</H2>" $f | wc -l` -eq 1 ]]; then
		rm $f
		echo "Removed file $f -- no recorded TReCS observations in that night."
		continue
	fi
	echo "Now parsing $f"
	##
	## fetch line numbers where individual observation blocks start
	night=$(echo $f | awk -F "/" '{print $8}' | awk -F "." '{print $1}' | sed -e 's/_/-/g')
	night_dir=${OBSDBLOCAL}/data/TReCS/HDR/${night}
	if [ ! -d $night_dir ]; then mkdir $night_dir; fi

	hdrs=$(grep "fullheader" $f | awk -F "\"" '{print $2}')

	for h in $hdrs; do
		url="${url_base}${h}"
		hdr_id=$(echo $h | awk -F "/" '{print $3}')
		hdrfile=${night_dir}/${hdr_id}.txt
		if [ ! -e $hdrfile ]; then wget $url -O $hdrfile; fi
	done
done