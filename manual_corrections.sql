--
-- manual corrections to obs.db for entries with wrong header information
--
update obs set dprtype="STD" where dateobs="2004-10-02T04:25:00.2999";
update obs set dprtype="SKY,STD" where dateobs="2004-10-02T04:27:52.4367";
update obs set dprtype='SKY,STD' where arcfile='SINFO.2009-08-30T05:45:30.808.fits';
update obs set dprtype='SKY,STD' where arcfile='SINFO.2009-08-30T06:55:11.293.fits';
update obs set dprtype='SKY,STD' where arcfile='SINFO.2009-08-30T07:58:23.628.fits';
update obs set dprtype='SKY,STD' where arcfile='SINFO.2009-08-30T09:01:51.509.fits';
update obs set dprtype='SKY,STD' where arcfile='SINFO.2009-08-30T09:54:35.715.fits';
update obs set dprtype='STD' where dateobs='2004-07-15T02:03:37.4423';

update obs set dprtype='SKY,STD' where dateobs='2009-08-31T06:49:49.2827';
update obs set dprtype='SKY,STD' where dateobs='2009-08-31T08:02:05.4090';
update obs set dprtype='SKY,STD' where dateobs='2009-08-31T09:14:15.6600';
update obs set dprtype='SKY,STD' where dateobs='2009-08-31T10:01:56.6210';
