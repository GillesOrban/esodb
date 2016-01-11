esodb

== Purpose ==
esodb is a set of scripts that allow you to download the relevant header information for all observations of selected ESO instruments. The downloaded headers are parsed and stored in a SQLite database for further use. Such a database can be useful for various archive studies, e.g. finding all objects ever observed with an instrument. We did such a study in 2015 and looked for local AGNs observed with SINFONI. About half of the data in the archive, despite many years old, had never been published. In our summary paper (Burtscher et al. 2015, http://adsabs.harvard.edu/abs/2015A%26A...578A..47B) we collected data for 51 AGNs.

== Setup ==
The setup should be relatively straight forward.

(1) set up directory structure and according environment variables
$OBSDBDIR -- path to these scripts and the database
$OBSDB -- path to the database
$OBSDBLOCAL -- path to a directory holding all the raw data files, can be identical to OBSDBDIR

for a bash shell you could use these lines of code:
export OBSDBDIR="$HOME/OBSDB"
export OBSDB="$OBSDBDIR/obs.db"
export OBSDBLOCAL="$HOME/OBSDB-Local"

(2) create an empty SQLite database with this structure:
CREATE TABLE prog(prog varchar PRIMARY KEY,picoi varchar,title varchar);
CREATE TABLE std(ra real, dec real, name varchar, Jmag real, Hmag real, Kmag real, SpType varchar, pm_ra real, pm_dec real, SpType_orig varchar);
CREATE TABLE "sinfo"(ra real, dec real, dprtype varchar, grat1 varchar, opti1 real, dit real, ndit int, prog varchar, object varchar, airm_start real, dateobs date PRIMARY KEY, night char, lst real, ao_tiptilt char, ao_horder char, ao_lgs char, arcfile varchar, lamps char, fwhm_start real, fwhm_end real, ob_name varchar, offset_ra real, offset_dec real);
CREATE TABLE sources(id varchar PRIMARY KEY, name varchar, ra real, dec real, z real);
CREATE TABLE dimm(dateobs date PRIMARY KEY,ra real,dec real,seeing real, airmass real,flux_rms real,tau0 real,theta0 real);
CREATE TABLE shoot(ra real, dec real, dprtype varchar, dprtech varchar, dit real, ndit int, prog varchar, object varchar, airm_start real, dateobs date PRIMARY KEY, night char, lst real, arcfile varchar, fwhm_start real, fwhm_end real, ob_name varchar, opti2_name varchar, opti3_name varchar, opti4_name varchar, opti5_name varchar, arm varchar, clock varchar, posang real, parang_start real, parang_end real, obs_id varchar);
CREATE TABLE midi(ra real, dec real, dprtype varchar, dprcatg varchar, shut_name varchar, beamcombiner varchar, filt_name varchar, gris_name varchar, nrts_mode varchar, chopfrq real, tel varchar, prog varchar, dateobs date PRIMARY KEY, night char, lst real, dit real, ndit int, object varchar, airm_start real, arcfile varchar, fwhm_start real, fwhm_end real, ob_name varchar, bl_start real, pa_start real);

(3) Run init_obsdb.sh


== Updating the database ==
Run update_obsdb.sh


== More documentation in ==
README.db.txt -- description of the database structure and some basic instructions on how to use it
README.update-db.txt -- description of the update process.


== Contact ==
Written and maintained by Leonard Burtscher, burtscher@mpe.mpg.de, please cite Burtscher et al. 2015, http://adsabs.harvard.edu/abs/2015A%26A...578A..47B, should you find these scripts useful for your own research.
