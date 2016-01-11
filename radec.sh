## script to extract RA/DEC from all MIDI headers
outfile=radec.txt

for night in `find . -type d -name "20*"`; do
	for f in `ls $night/MIDI.*.txt`; do
		ra=`grep "RA      =" $f | awk '{print $3}'`
		dec=`grep "DEC     =" $f | awk '{print $3}'`
		echo "$ra $dec" >> $outfile
	done
done