Manual update instructions
(14. Juli 2014)

== update table obs ==
1. find out start date (sql: select dateobs from obs order by dateobs desc limit 1 offset 45;)
2. get_hdrs_INS with start date
3. hdr2sqlite_SINFO (reads $OBSDBLOCAL/data/DPID/SINFO.txt)
4. insert into database: sqlite3 $OBSDB < $OBSDBLOCAL/data/SINFO/SQL/insert.sql
5. check if insert was successful: in sql: select dateobs from obs order by dateobs desc limit 1 offset 45;
6. cleanup:
	rm $OBSDBLOCAL/data/SINFO/SQL/insert.sql
	cat $OBSDBLOCAL/data/DPID/SINFO.txt >> $OBSDBLOCAL/data/DPID/SINFO_all.txt
	rm $OBSDBLOCAL/data/DPID/SINFO.txt
7. call get_proginfo.sh with no parameters (it will update the DB automatically)

--> this is now implemented in the script update_obsdb.sh (2015 June 01) which can be run without further parameters, once the initial run has finished successfully.


== update table dimm ==
1. find out start date (sql ...) and update start in get_dimm.sh
1b. update date_now as well in get_dimm.sh
2. run get_dimm.sh
3. insert into database: sqlite3 $OBSDB < $OBSDBLOCAL/data/DIMM/insert_dimm.sql
4. check if insert was successful: in sql: select dateobs from dimm order by dateobs desc limit 1;
5. cleanup:
	rm $OBSDBLOCAL/data/DIMM/insert_dimm.sql
	tar czf "raw data" and remove raw data (*.txt)
===
