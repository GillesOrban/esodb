README for SQLite3 database obs.db

== Change log ==
2016-01-11  added description for new tables
2014-01-23  added columns ob_name, offset_ra, offset_dec to table obs; updated to include all obs until 2014-01-19
2012-12-21	added table cal with JHK magnitudes, spectral types, coordinates, proper motions and names of some STD stars observed with SINFONI (via SIMBAD)
2012-11-15	compressed database (SQL 'VACUUM' command), same content, smaller size
2012-11-14	first upload to MPE-AFS



== Description of the database tables and fields ==

Table sinfo (428242 entries as of 11 Jan 2016)
	ra				RA						[deg]
	dec				DEC						[deg]
	dprtype			DPR TYPE				e.g. 'OBJECT', 'SKY', 'FLAT,LAMP' etc.
	grat1			INS GRAT1 NAME			'K', 'H+K', 'H', 'J' or empty
	opti1			INS OPTI1 NAME			0.025, 0.1, 0.25 or empty
	dit				DET DIT					[seconds]
	ndit			DET NDIT
	prog			OBS PROG ID
	object			OBJECT
	airm_start		AIRM START
	dateobs			DATE-OBS
	night			(day of night begin)
	lst				LST
	ao_tiptilt		AOS RTC LOOP TIPTILT
	ao_horder		AOS RTC LOOP HORDER
	ao_lgs			AOS RTC LOOP LGS
	arcfile			ARCFILE
	lamps									Combined string of INS1 LAMP1 ST-INS1 LAMP6 ST
	fwhm_start		AMBI FWHM START			DIMM seeing at start of OB
	fwhm_end		AMBI FWHM END			DIMM seeing at end of OB
	ob_name         OBS NAME                OB name given by observer
	offset_ra       SEQ CUMOFFSETA          offset in RA w.r.t. original pointing
	offset_dec      SEQ CUMOFFSETD          offset in DEC w.r.t. original pointing
	
Table shoot (911193 entries), simiar to sinfo, but for X-SHOOTER observations

Table midi (428014 entries), simiar to sinfo, but for MIDI observations

Table prog (1727 entries)
	prog									ESO programme ID
	picoi									programme PI/CoI
	title									title of programme

Table sources (126 entries) with all local AGNs observed with SINFONI:
	name									primary SIMBAD name of target
	ra										SIMBAD ICRS J2000 co-ordinate
	dec										SIMBAD ICRS J2000 co-ordinate
	z										from SIMBAD

Table std (394 entries) with information about STD stars observed with SINFONI:
	ra
	dec
	name									primary SIMBAD name of target
	Jmag									from SIMBAD (2MASS)
	Hmag									from SIMBAD (2MASS)
	Kmag									from SIMBAD (2MASS)
	SpType									simplified spectral type, from SIMBAD
	pm_ra									proper motion (mas/yr)
	pm_dec									proper motion (mas/yr)
	SpType_orig								original spectral type, from SIMBAD

Table dimm (2341727 entries) with information about observing conditions


For more details on the table please see the schema of the database.



== Caveats and notes ==

- Some dprtypes are stored with spaces, see below for instructions how to search for dprtype
- dprtype is sometimes wrong, e.g. STD observations are sometimes stored as OBJECT. You 
should therefore not rely on dprtype alone, but better on a combination of dprtype and 
ra,dec to identify an observation of the target in question.
- The object name given in the OBJECT field should be treated with caution. This is the 
object name given by the observer; the name could be from a different catalogue, misspelt or wrong


== Some basic syntax examples ==
Open the database:
	sqlite3 $OBSDB

Get information about the database scheme:
	.schema

Get most recent entry of table obs:
	select dateobs from obs order by dateobs desc limit 1;

Get list of unique co-ordinates
	select distinct ra, dec from obs;

To search for a specific dprtype (e.g. 'OBJECT' files), use the SQL LIKE comparison (or trim the string before comparison) since some dprtypes are stored with blanks, e.g. to get the number of all object files in the database, do:
	select count(*) from obs where dprtype like "%OBJECT%";

Get total time spent on observing the galactic center region with good seeing:
	select round(sum(dit*ndit)/3600,2) from obs where ra between 266.367 and 266.467 and dec between -29.058 and -28.958 and dprtype like "%OBJECT%" and fwhm_start < 1.0;

Get co-ordinates for K band observations in 0.025" sampling with active AO and limit query to first 30 results:
	select ra,dec from obs where ra between 266.367 and 266.467 and dec between -29.058 and -28.958 and dprtype like "%OBJECT%" and fwhm_start < 1.0 and grat1='K' and opti1=0.025 and ao_horder=1 limit 30;