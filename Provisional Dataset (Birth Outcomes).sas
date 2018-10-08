**********************************************************************************************
PURPOSE: The purpose of this is to extract, QC, and build a provisional birth outcomes dataset

INPUT: Need to have DB3 downloaded (Raw Data - No SAS Pathway Mapper) into the work library

**********************************************************************************************
;
/*Required Libraries*/
libname THOMAS 'C:\Users\tchavez\Documents\My SAS Files\DB2'; 

/*Required Cleaning Scripts*/
%include 'R:\MADRES_DATA\SAS Code\Data_Corrections\Window Corrections.sas'; 
%include 'R:\MADRES_DATA\SAS Code\Non-Responders Flag.sas'; 
%include 'R:\MADRES_DATA\SAS Code\Cleaning LMP, IDs & DOB.sas'; 

******************************************
STEP 1: Extracting our data from DB2 & DB3
******************************************
;
data db3; set redcap.db3;
run;


DATA BIRTH; 
	SET DB3 (KEEP = REDCAP_EVENT_NAME FAMILY_ID mdx_trg mdx_dt_dlvry -- mdxapgar_5min mdx_nicu mdx_dlv_disdt);
	WHERE REDCAP_EVENT_NAME = 'mom_arm_1'; DROP REDCAP_EVENT_NAME;
RUN;

DATA _7_14; 
	SET THOMAS.DB2 (KEEP = FAMILY_ID redcap_event_name b01_baby_dob 
 							b01_baby_gender b01_pounds b01_ounces b01_length
							b01_born_place b01_other_hosp b01_other b01_delivered
							b01_icu b01_why_icu___: b01_icu_other b01_weight_grams
							birth_dob birth_gender birth_place birth_place_other_hospital
							birth_place_other);
	WHERE REDCAP_EVENT_NAME = 'baby_7to14_days_arm_1';
	DROP REDCAP_EVENT_NAME;
RUN;


DATA _SCREEN; 
	SET THOMAS.DB2 (KEEP =REDCAP_EVENT_NAME FAMILY_ID mom_lmp MOM_SITE ID ID_BABY non_responder non_participant cohort);
	WHERE REDCAP_EVENT_NAME = 'mom_screening_arm_1';
	DROP REDCAP_EVENT_NAME;
RUN;

***************************************************
STEP 3: Sorting and merging our DB3 subset datasets
***************************************************
;
proc sort data=birth;
by family_id;
run;
proc sort data=_7_14;
by family_id;
run;
proc sort data=_SCREEN;
by family_id;
run;
data birth_outcomes;
merge birth _7_14 _SCREEN;
by family_id;
run;

DATA BIRTH_1; 
	SET DB3 (KEEP = FAMILY_ID redcap_event_name mdxdate_1_us mdxedd_1 mdxga_date1 mdxu_ga_day_1 mdxbpd mdxcrl);
	WHERE REDCAP_EVENT_NAME = 'mom_arm_1'; DROP REDCAP_EVENT_NAME;
RUN;
DATA BIRTH_2; 
	SET DB3 (KEEP = FAMILY_ID redcap_event_name mdxdate_2_us mdxedd_2 mdxga_date2 mdxu_ga_day_2 mdxbpd2 mdxcrl2);
	WHERE REDCAP_EVENT_NAME = 'mom_arm_1'; DROP REDCAP_EVENT_NAME;
	RENAME mdxdate_2_us = mdxdate_1_us mdxedd_2 = mdxedd_1 mdxga_date2 = mdxga_date1
			mdxu_ga_day_2 = mdxu_ga_day_1 mdxbpd2 = mdxbpd mdxcrl2 = mdxcrl;
RUN;
DATA BIRTH_3; 
	SET DB3 (KEEP = FAMILY_ID redcap_event_name mdxdate_3_us mdxedd_3 mdxga_date3 mdxu_ga_day_3 mdxbpd3 mdxcrl3);
	WHERE REDCAP_EVENT_NAME = 'mom_arm_1'; DROP REDCAP_EVENT_NAME;
	RENAME mdxdate_3_us = mdxdate_1_us mdxedd_3 = mdxedd_1 mdxga_date3 = mdxga_date1
			mdxu_ga_day_3 = mdxu_ga_day_1 mdxbpd3 = mdxbpd mdxcrl3 = mdxcrl;
RUN;
DATA BIRTH_4; 
	SET DB3 (KEEP = FAMILY_ID redcap_event_name mdxdate_4_us mdxedd_4 mdxga_date4 mdxu_ga_day_4 mdxbpd4 mdxcrl4);
	WHERE REDCAP_EVENT_NAME = 'mom_arm_1'; DROP REDCAP_EVENT_NAME;
	RENAME mdxdate_4_us = mdxdate_1_us mdxedd_4 = mdxedd_1 mdxga_date4 = mdxga_date1
			mdxu_ga_day_4 = mdxu_ga_day_1 mdxbpd4 = mdxbpd mdxcrl4 = mdxcrl;
RUN;
DATA BIRTH_5; 
	SET DB3 (KEEP = FAMILY_ID redcap_event_name mdxdate_5_us mdxedd_5 mdxga_date5 mdxu_ga_day_5 mdxbpd5 mdxcrl5);
WHERE REDCAP_EVENT_NAME = 'mom_arm_1'; DROP REDCAP_EVENT_NAME;
	RENAME mdxdate_5_us = mdxdate_1_us mdxedd_5 = mdxedd_1 mdxga_date5 = mdxga_date1
			mdxu_ga_day_5 = mdxu_ga_day_1 mdxbpd5 = mdxbpd mdxcrl5 = mdxcrl;
RUN;
DATA BIRTH_6; 
	SET DB3 (KEEP = FAMILY_ID redcap_event_name mdxdate_6_us mdxedd_6 mdxga_date6 mdxu_ga_day_6 mdxbpd6 mdxcrl6);
	WHERE REDCAP_EVENT_NAME = 'mom_arm_1'; DROP REDCAP_EVENT_NAME;
	RENAME mdxdate_6_us = mdxdate_1_us mdxedd_6 = mdxedd_1 mdxga_date6 = mdxga_date1
			mdxu_ga_day_6 = mdxu_ga_day_1 mdxbpd6 = mdxbpd mdxcrl6 = mdxcrl;
RUN;
DATA BIRTH_7; 
	SET DB3 (KEEP = FAMILY_ID redcap_event_name mdxdate_7_us mdxedd_7 mdxga_date7 mdxu_ga_day_7 mdxbpd7 mdxcrl7);
	WHERE REDCAP_EVENT_NAME = 'mom_arm_1'; DROP REDCAP_EVENT_NAME;
	RENAME mdxdate_7_us = mdxdate_1_us mdxedd_7 = mdxedd_1 mdxga_date7 = mdxga_date1
			mdxu_ga_day_7 = mdxu_ga_day_1 mdxbpd7 = mdxbpd;
	mdxcrl = input (mdxcrl7, best32.); /*no data exists under crl - imported as character. need to convert to numeric*/
	format mdxcrl best32.;
	drop mdxcrl7;
RUN;
DATA BIRTH_8; 
	SET DB3 (KEEP = FAMILY_ID redcap_event_name mdxdate_8_us mdxedd_8 mdxga_date8 mdxu_ga_day_8 mdxbpd8 mdxcrl8);
	WHERE REDCAP_EVENT_NAME = 'mom_arm_1'; DROP REDCAP_EVENT_NAME;
	RENAME mdxdate_8_us = mdxdate_1_us mdxedd_8 = mdxedd_1 mdxga_date8 = mdxga_date1
			mdxu_ga_day_8 = mdxu_ga_day_1 mdxbpd8 = mdxbpd;
	mdxcrl = input (mdxcrl8, best32.);
	format mdxcrl best32.;
	drop mdxcrl8;
RUN;
DATA BIRTH_9; 
	SET DB3 (KEEP = FAMILY_ID redcap_event_name mdxdate_9_us mdxedd_9 mdxga_date9 mdxu_ga_day_9 					mdxbpd_9 mdxcrl9);
	WHERE REDCAP_EVENT_NAME = 'mom_arm_1'; DROP REDCAP_EVENT_NAME;
	RENAME mdxdate_9_us = mdxdate_1_us mdxedd_9 = mdxedd_1 mdxga_date9 = mdxga_date1
			mdxu_ga_day_9 = mdxu_ga_day_1 mdxbpd_9 = mdxbpd ;
mdxcrl = input (mdxcrl9, best32.);
format mdxcrl best32.;
drop mdxcrl9;
RUN;
DATA THOMAS.DB3_merge;
SET BIRTH_1 BIRTH_2 BIRTH_3 BIRTH_4 BIRTH_5 BIRTH_6 BIRTH_7 BIRTH_8 BIRTH_9;
BY FAMILY_ID;
RUN;

/*creating our GA values*/
proc sort data = thomas.DB3_merge out = db3_sort;
by family_id ;
run;

proc transpose data=db3_sort out=wide1 (drop = _name_) prefix=US;
    by family_id;
	VAR mdxdate_1_us;
run;
proc transpose data=db3_sort out=wide2 (drop = _name_) prefix=GA_WK;
    by family_id ;
    var mdxga_date1;
run;
proc transpose data=db3_sort out=wide2_2 (drop = _name_) prefix=GA_DAY;
    by family_id ;
    var mdxu_ga_day_1;
run;
proc transpose data=db3_sort out=wide3 (drop = _name_) prefix=CRL;
    by family_id ;
    var mdxcrl;
run;

proc transpose data=db3_sort out=wide4 (drop = _name_) prefix=EDD;
    by family_id ;
    var mdxedd_1;
run;

proc transpose data=db3_sort out=wide5 (drop = _name_) prefix=BPD;
    by family_id ;
    var mdxbpd;
run;

 DATA final_1;
 MERGE wide1(IN=In1) wide2(IN=In2);
 BY family_id;
 IF (In1=1 OR In2=1) then output final_1;
 RUN;
 DATA final_2;
 MERGE final_1(IN=In1) wide3(IN=In2);
 BY family_id;
 IF (In1=1 OR In2=1) then output final_2;
 RUN;
 DATA final_3;
 MERGE final_2(IN=In1) wide4(IN=In2);
 BY family_id;
 IF (In1=1 OR In2=1) then output final_3;
 RUN;
 DATA final_4;
 MERGE final_3(IN=In1) WIDE5(IN=In2);
 BY family_id;
 IF (In1=1 OR In2=1) then output final_4;
 RUN;
  DATA final_5;
 MERGE final_4(IN=In1) wide2_2(IN=In2);
 BY family_id;
 IF (In1=1 OR In2=1) then output final_5;
 RUN;
 DATA birth_outcomes1;
 MERGE final_5(IN=In1) birth_outcomes(IN=In2);
 BY family_id;
 IF (In1=1 OR In2=1) then output birth_outcomes1;
 RUN;
data birth_outcomes1; set birth_outcomes1; /*converting our two GA variables (weeks.days) = (days)*/
ga1 = ((GA_WK1 * 7) + GA_DAY1) / 7;
ga2 = ((GA_WK2 * 7) + GA_DAY2) / 7;
ga3 = ((GA_WK3 * 7) + GA_DAY3) / 7;
ga4 = ((GA_WK4 * 7) + GA_DAY4) / 7;
ga5 = ((GA_WK5 * 7) + GA_DAY5) / 7;
ga6 = ((GA_WK6 * 7) + GA_DAY6) / 7;
ga7 = ((GA_WK7 * 7) + GA_DAY7) / 7;
ga8 = ((GA_WK8 * 7) + GA_DAY8) / 7;
ga9 = ((GA_WK9 * 7) + GA_DAY9) / 7;
DROP GA_WK1 - GA_WK9 GA_DAY1 - GA_DAY9;
run;

/*
title 'PROC CONTENTS OF OUR DB2/DB3 MERGE';
proc contents varnum;
run; title;
*/
********************
STEP 3: Creating GAs
********************
;
data birth_outcomes1; set birth_outcomes1; 
ft = 280; /*need to create a full term variable (280 days old)*/
/*BUILDING WEIGHTS*/
_7_14_temp_weight = (b01_pounds * 16) + b01_ounces;
_7_14_temp_weight2 = _7_14_temp_weight * 28.3495;
IF mdx_bw > 0 THEN WEIGHT_EMR = 1;
IF mdx_bw_sr > 0 THEN WEIGHT_SR = 2;
IF _7_14_temp_weight2 > 0 THEN WEIGHT_714 = 3;

/*BUILDING LENGTH*/
_7_14_temp_LENGTH = b01_length * 2.54;
mdxlength_T = INPUT(mdxlength, best32.);
IF mdxlength_T > 0 THEN LENGTH_EMR = 1;
IF _7_14_temp_LENGTH > 0 THEN LENGTH_714 = 2;

/*CLEANING HC*/
mdxheadcircum_T = INPUT(mdxheadcircum, best32.);
IF mdxheadcircum_T > 0 THEN HC_EMR = 1;

/*CLEANING GENDER -------- MAD 296, 133, 50 have two different genders*/
IF mdx_gndr > . THEN gender_EMR = 1;
IF birth_gender > . THEN gender_birth = 2;
IF b01_baby_gender > . THEN gender_714 = 3;

/*CLEANING DOB ------ MAD 186, 205, 143, 31, 230, 115, 156, 224, 204, 45, 81, 287 are inconsistet
						Why are there so many babies born at 0000?? */
db3_time = substr(mdx_dt_dlvry, 11, 8) /*EXTRACTING ONLY THE LAST 8 CHARACTERS OF 'mdx_dt_dlvry' BEGNINNING FROM POSITION 11*/;
db3_date = substr(mdx_dt_dlvry, 1, 10) /*EXTRACTING THE FIRST 10 CHARACTERS OF 'mdx_dt_dlvry' BEGNINNING FROM POSITION 1*/;
date_fix_DC = input (mdx_dlv_disdt, anydtdtm21.);
format date_fix_DC DATETIME. ;
date_fix_ADMISSION = input (mdx_dt_dlvry, anydtdtm21.);
format date_fix_ADMISSION DATETIME. ;
date_fix_date = input (db3_date, YYMMDD10.);
format date_fix_date YYMMDD10. ;
date_fix_time = input (db3_time, anydtdtm21.);
format date_fix_time TIME6. ;
IF date_fix_date > 0 THEN DATE_EMR = 1;
IF birth_dob > 0 THEN DATE_birth = 2;
IF b01_baby_dob > 0 THEN DATE_714 = 3;
/*BUILDING DELIVERY TYPE*/

if b01_delivered = 1 then new_delivery = 1;
else if b01_delivered = 2 then new_delivery = 1;
else if b01_delivered = 3 then new_delivery = 2;
else if b01_delivered = 4 then new_delivery = 3;
IF mdxty_deliv > 0 THEN DELIV_EMR = 1;
IF b01_delivered > 0 THEN DELIV_714 = 2;
/*BUILDING LOS*/
LOS=intck('DTDAY', date_fix_ADMISSION, date_fix_DC);
   put LOS=;
/*BUILDING NICU ADMISSIONS*/
if b01_icu = 2 then b01_icu = 1;
IF b01_icu > . THEN ICU_BIRTH = 2;
IF mdx_nicu > . THEN ICU_EMR = 1;
ga_4 = ((mdx_gad_wks * 7) + mdx_gad_days) / 7;
IF ga_4 > 0 THEN GA_4_SOURCE = 4;
run;
proc sql;
create table birth_outcomes2 as 
select 	CASE WHEN date_fix_date ne . then date_fix_date
				when date_fix_date = . and birth_dob ne . then birth_dob
				when date_fix_date = . and birth_dob = . and b01_baby_dob ne . then b01_baby_dob
				end as DOB_Baby2 format = YYMMDD10. label = 'Baby''s Date of Birth',*
from birth_outcomes1 ; quit ;
data birth_outcomes2; set birth_outcomes2;
edd_lmp = 280 + mom_lmp; 
format edd_lmp YYMMDD10.;
distance = intck('DTDAY', edd_lmp, mom_lmp);
distance_lmp_edd = abs (edd_lmp - dob_baby2);
run;

data birth_outcomes2; set birth_outcomes2;
if ga1 > 0 and ga1 < 14 and crl1 ne . then ga_1_1 = 1;
if ga2 > 0 and ga2 < 14 and crl2 ne . then ga_1_2 = 1;
if ga3 > 0 and ga3 < 14 and crl3 ne . then ga_1_3 = 1;
if ga4 > 0 and ga4 < 14 and crl4 ne . then ga_1_4 = 1;
if ga5 > 0 and ga5 < 14 and crl5 ne . then ga_1_5 = 1;
if ga6 > 0 and ga6 < 14 and crl6 ne . then ga_1_6 = 1;
if ga7 > 0 and ga7 < 14 and crl7 ne . then ga_1_7 = 1;
if ga8 > 0 and ga8 < 14 and crl8 ne . then ga_1_8 = 1;
if ga9 > 0 and ga9 < 14 and crl9 ne . then ga_1_9 = 1;

if ga1 >= 14 and bpd1 ne . then  ga_2_1 = 1;
if ga2 >= 14 and bpd2 ne . then  ga_2_2 = 1;
if ga3 >= 14 and bpd3 ne . then  ga_2_3 = 1;
if ga4 >= 14 and bpd4 ne . then  ga_2_4 = 1;
if ga5 >= 14 and bpd5 ne . then  ga_2_5 = 1;
if ga6 >= 14 and bpd6 ne . then  ga_2_6 = 1;
if ga7 >= 14 and bpd7 ne . then  ga_2_7 = 1;
if ga8 >= 14 and bpd8 ne . then  ga_2_8 = 1;
if ga9 >= 14 and bpd9 ne . then  ga_2_9 = 1;

if ga1 >=28 and distance_lmp_edd < 14 then ga_5_1 = 1;
if ga2 >=28 and distance_lmp_edd < 14 then ga_5_2 = 1;
if ga3 >=28 and distance_lmp_edd < 14 then ga_5_3 = 1;
if ga4 >=28 and distance_lmp_edd < 14 then ga_5_4 = 1;
if ga5 >=28 and distance_lmp_edd < 14 then ga_5_5 = 1;
if ga6 >=28 and distance_lmp_edd < 14 then ga_5_6 = 1;
if ga7 >=28 and distance_lmp_edd < 14 then ga_5_7 = 1;
if ga8 >=28 and distance_lmp_edd < 14 then ga_5_8 = 1;
if ga9 >=28 and distance_lmp_edd < 14 then ga_5_9 = 1;
run;
proc sql;
select family_id, ga1, ga2, crl1, crl2, ga_1_1, ga_1_2, edd1, edd2, ga_first
from birth_outcomes2
where family_id = 423
; quit ;



data birth_outcomes2; set birth_outcomes2;

if ga_1_1 = 1 and edd1 > 0 then ga_first = edd1;
ELSE IF ga_1_2 = 1 and edd2 > 0 THEN ga_first = edd2;
ELSE IF ga_1_3 = 1 and edd3 > 0 THEN ga_first = edd3;
ELSE IF ga_1_4 = 1 and edd4 > 0 THEN ga_first = edd4;
ELSE IF ga_1_5 = 1 and edd5 > 0 THEN ga_first = edd5;
ELSE IF ga_1_6 = 1 and edd6 > 0 THEN ga_first = edd6;
ELSE IF ga_1_7 = 1 and edd7 > 0 THEN ga_first = edd7;
ELSE IF ga_1_8 = 1 and edd8 > 0 THEN ga_first = edd8;
ELSE IF ga_1_9 = 1 and edd9 > 0 THEN ga_first = edd9;

if ga_2_1 = 1 and edd1 > 0 then ga_second = edd1;
ELSE IF ga_2_2 = 1 and edd2 > 0 THEN ga_second = edd2;
ELSE IF ga_2_3 = 1 and edd3 > 0 THEN ga_second = edd3;
ELSE IF ga_2_4 = 1 and edd4 > 0 THEN ga_second = edd4;
ELSE IF ga_2_5 = 1 and edd5 > 0 THEN ga_second = edd5;
ELSE IF ga_2_6 = 1 and edd6 > 0 THEN ga_second = edd6;
ELSE IF ga_2_7 = 1 and edd7 > 0 THEN ga_second = edd7;
ELSE IF ga_2_8 = 1 and edd8 > 0 THEN ga_second = edd8;
ELSE IF ga_2_9 = 1 and edd9 > 0 THEN ga_second = edd9;

if ga_5_1 = 1 and edd1 > 0 then ga_five = edd1;
ELSE IF ga_5_2 = 1 and edd2 > 0 THEN ga_five = edd2;
ELSE IF ga_5_3 = 1 and edd3 > 0 THEN ga_five = edd3;
ELSE IF ga_5_4 = 1 and edd4 > 0 THEN ga_five = edd4;
ELSE IF ga_5_5 = 1 and edd5 > 0 THEN ga_five = edd5;
ELSE IF ga_5_6 = 1 and edd6 > 0 THEN ga_five = edd6;
ELSE IF ga_5_7 = 1 and edd7 > 0 THEN ga_five = edd7;
ELSE IF ga_5_8 = 1 and edd8 > 0 THEN ga_five = edd8;
ELSE IF ga_5_9 = 1 and edd9 > 0 THEN ga_five = edd9;


IF ga_first > 0 THEN GA_1_SOURCE = 1;
ga_1 = (FT -(ga_first -  DOB_Baby2)) / 7;

IF ga_second > 0 THEN GA_2_SOURCE = 2;
ga_2 = (FT -(ga_second -  DOB_Baby2)) / 7;

IF ga_five > 0 THEN GA_5_SOURCE = 5;
ga_5 = (FT -(ga_five -  DOB_Baby2)) / 7;

ga_6 = (DOB_Baby2 - MOM_LMP)/7;
IF GA_6 > 0 THEN GA_6_SOURCE = 6;
run;
/*
data tester (keep = family_id ga_1: ga_first edd:); set birth_outcomes2;
run;
*/
data birth_outcomes2; set birth_outcomes2;
if ga_1 > 50 then ga_1 = .;
if ga_2 > 50 then ga_2 = .;
if ga_6 < 0 then ga_6 = .;
run;





data birth_outcomes2; set birth_outcomes2;
length born_site $60.;
/*birth information form*/
if birth_place = 1 then born_site = 'LAC+USC County Hospital';
if birth_place = 2 then born_site = 'California Hospital Medical Center';
if birth_place_other_hospital = 'Good Samaritan' then born_site = 'Good Samaritan Hospital';
if birth_place_other_hospital = 'Good Samaritan Hospital' then born_site = 'Good Samaritan Hospital';
if birth_place_other_hospital = 'Good samaritan' then born_site = 'Good Samaritan Hospital';
if birth_place_other = 'Good Samaritan' then born_site = 'Good Samaritan Hospital';
if birth_place_other = 'Good Samaritan Hospital' then born_site = 'Good Samaritan Hospital';
if birth_place_other_hospital = 'Dignity Health' then born_site = 'Dignity Health';
if birth_place_other_hospital = 'El Camino Hospital Mountain View' then born_site = 'El Camino Hospital Mountain View';
if birth_place_other_hospital = 'Glendale Memorial Hospital' then born_site = 'Glendale Memorial Hospital';
if birth_place_other_hospital = 'Huntington Hospital' then born_site = 'Huntington Memorial Hospital';
if birth_place_other_hospital = 'John Stroger Hospital' then born_site = 'John Stroger Hospital';
if birth_place_other_hospital = 'Kaiser Los Angeles' then born_site = 'Kaiser Permanente Los Angeles';
if birth_place_other_hospital = 'Little Company of Mary in Torrance' then born_site = 'Little Company of Mary';
if birth_place_other_hospital = 'Providence St. Joseph' then born_site = 'Providence St. Joseph';
if birth_place_other_hospital = 'St. Francis Medical Center in Lynwood' then born_site = 'St. Francis Medical Center';
if birth_place_other_hospital = 'White Memorial' then born_site = 'White Memorial';
if birth_place_other_hospital = 'Pomona Valley Hospital' then born_site = 'Pomona Valley Hospital';
if birth_place_other_hospital = 'Monterey Park Hospital' then born_site = 'Monterey Park Hospital';
if birth_place_other_hospital = 'Hollywood Presbyterian Hospital' then born_site = 'Hollywood Presbyterian Medical Center';
if birth_place_other_hospital = 'Sharp Chula Vista' then born_site = 'Sharp Chula Vista Medical Center';
if birth_place_other_hospital = 'Torrance Memorial Hospital' then born_site = 'Torrance Memorial Hospital';

if birth_place_other = 'Arrowhead Regional Medical Center' then born_site = 'Arrowhead Regional Medical Center';
if birth_place_other = 'Cedars Sinai' then born_site = 'Cedars-Sinai Medical Center';
if birth_place_other = 'Cedars-Sinai' then born_site = 'Cedars-Sinai Medical Center';
if birth_place_other = 'Graceful Birthing Center' then born_site = 'Graceful Birthing Center';
if birth_place_other = 'Huntington Memorial' then born_site = 'Huntington Memorial Hospital';
if birth_place_other = 'Queens Care Health Center' then born_site = 'Queens Care Health Center';
if birth_place_other = 'San Bernardino Hospital, Dignity Health Community Hospital' then born_site = 'San Bernardino Hospital, Dignity Health Community Hospital';
if birth_place_other = 'St. Francis' then born_site = 'St. Francis';
if birth_place_other = 'home birth' then born_site = 'Home Birth';
if birth_place_other = 'Torrance Memorial Hospital' then born_site = 'Torrance Memorial Hospital';
if birth_place_other = 'Torrance Memorial Hospital' then born_site = 'Torrance Memorial Hospital';
if b01_other_hosp = 'Clinique Breteche in France' then born_site = 'Clinique Breteche';

/*7-14 day form*/
if b01_born_place = 1 then born_site = 'LAC+USC County Hospital';
if b01_born_place = 2 then born_site = 'California Hospital Medical Center';
if b01_other_hosp = 'Dignity Health' then born_site = 'Dignity Health';
if b01_other_hosp = 'El Camino Hospital Mountain View' then born_site = 'El Camino Hospital Mountain View';
if b01_other_hosp = 'Good Samaritan' then born_site = 'Good Samaritan Hospital';
if b01_other_hosp = 'Good Samaritan Hospital' then born_site = 'Good Samaritan Hospital';
if b01_other_hosp = 'Huntington Hospital' then born_site = 'Huntington Memorial Hospital';
if b01_other_hosp = 'Huntington Memorial' then born_site = 'Huntington Memorial Hospital';
if b01_other_hosp = 'Kaiser Permanente Downey' then born_site = 'Kaiser Permanente Downey';
if b01_other_hosp = 'La Palma Hospital' then born_site = 'La Palma Hospital';
if b01_other_hosp = 'Little Company of Mary' then born_site = 'Little Company of Mary';
if b01_other_hosp = 'Providence St. Joseph' then born_site = 'Providence St. Joseph';
if b01_other_hosp = 'San Bernardino Hospital, Dignity Health Community Hospital' then born_site = 'San Bernardino Hospital, Dignity Health Community Hospital';
if b01_other_hosp = 'St. Francis' then born_site = 'St. Francis';
if b01_other_hosp = 'White Memorial' then born_site = 'White Memorial';
if b01_other_hosp = 'Highline Medical Center' then born_site = 'Highline Medical Center';

if b01_other = 'Antelope Valley Hospital' then born_site = 'Antelope Valley Hospital';
if b01_other = 'Arrowhead Regional Medical Center' then born_site = 'Arrowhead Regional Medical Center';
if b01_other = 'Cedars Sinai' then born_site = 'Cedars-Sinai Medical Center';
if b01_other = 'Cedars-Sinai' then born_site = 'Cedars-Sinai Medical Center';
if b01_other = 'Graceful Birthing Center' then born_site = 'Graceful Birthing Center';
if b01_other = 'hollywood presbyterian' then born_site = 'Hollywood Presbyterian Medical Center';
run;

/* need to always check to make sure there are no "others" to code
proc sql;
select family_id, birth_place, birth_place_other_hospital,
		birth_place_other, b01_born_place, b01_other_hosp,
		b01_other, born_site
from birth_outcomes2
; quit ;
*/


/*
birth_place birth_place_other_hospital birth_place_other
1	LAC+USC County Hospital
2	California Hospital Medical Center
3	Other Hospital
4	Other
5	Unknown

b01_born_place  b01_other_hosp b01_other
1	LAC+USC County Hospital 
2	California Hospital Medical Center
3	Other Hospital 
4	Other



proc sql;
select *
from birth_outcomes2
where family_id = 299
; quit ;


proc means data = birth_outcomes2;
var ga_1 ga_2 ga_4 ga_5 ga_6;
run;


/*QC*/


%include 'R:\MADRES_DATA\Datasets\Formats & Labels\BIRTH.sas'; 


PROC SQL;
CREATE TABLE THOMAS.BIRTH_OUTCOMES AS
SELECT 	FAMILY_ID,
		ID label = 'MADRES ID',
		ID_BABY label = 'MADRES ID for Baby',mom_lmp,
		COHORT FORMAT = cohort_. LABEL = '< 20-week vs late entry flag',
		non_responder format = nonresponder_. label = 'Responder vs Non-Responder flag',
		MOM_SITE FORMAT = mom_site_. label = 'Mother'' Recruitment Site',
		/*Birth Outcomes*/
		DOB_BABY2 as DOB_Baby format = YYMMDD10. label = 'Baby''s Date of Birth',

		date_fix_time as DOB_time format = TIME6. label = 'Baby''s Time of Birth',

		born_site as baby_site label = 'Baby''s Birth Location',

		CASE WHEN DATE_EMR ne . then DATE_EMR
				when DATE_EMR = . and DATE_birth ne . then DATE_birth
				when DATE_EMR = . and DATE_birth = . and DATE_714 ne . then DATE_714
				end as DOB_Baby_s format = dobcounter_. label = 'Baby''s DOB Source',

		CASE WHEN mdxty_deliv ne . then mdxty_deliv 
				when mdxty_deliv = . and new_delivery ne . then new_delivery
				end as delivery format = delivery_. label = 'Delivery Method',

		CASE WHEN DELIV_EMR ne . then DELIV_EMR 
				when DELIV_EMR = . and DELIV_714 ne . then DELIV_714
				end as delivery_s format = deliverycounter_. label = 'Delivery Method Source',

		CASE WHEN mdx_bw ne . then mdx_bw
				when mdx_bw = . and mdx_bw_sr ne . then mdx_bw_sr
				when mdx_bw = . and mdx_bw_sr = . and _7_14_temp_weight2 ne . then _7_14_temp_weight2
				end as birthweight label = 'Birthweight in grams (Use Counter Variable)',

		CASE WHEN WEIGHT_EMR ne . then WEIGHT_EMR
				when WEIGHT_EMR = . and WEIGHT_SR ne . then WEIGHT_SR
				when WEIGHT_EMR = . and WEIGHT_SR = . and WEIGHT_714 ne . then WEIGHT_714
				end as birthweight_s format =bw_. label = 'Birthweight Source',

		CASE WHEN mdxlength_T ne . then mdxlength_T
				when mdxlength_T = . and _7_14_temp_LENGTH ne . then _7_14_temp_LENGTH
				end as length label = 'Baby''s Length at Birth in cm',

		CASE WHEN LENGTH_EMR ne . then LENGTH_EMR
				when LENGTH_EMR = . and LENGTH_714 ne . then LENGTH_714
				end as length_s format = length_. label = 'Baby''s Length Source',

		mdxheadcircum_T AS head_circumference label = 'Baby''s Head Circumference at Birth (cm)',

		HC_EMR as head_circumference_s format = hc_. label = 'Baby''s Head Circumference Source',

		CASE 	WHEN ga_1 ne . then ga_1
				when ga_1 = . and ga_2 ne . then ga_2
				when ga_1 = . and ga_2 = . and ga_4 ne . then ga_4
				when ga_1 = . and ga_2 = . and ga_4 = . and ga_5  ne . then ga_5
				when ga_1 = . and ga_2 = . and ga_4 = . and ga_5  = . and ga_6 ne . then ga_6
				end as GA label = 'Baby''s Gestational Age (GA) at Birth)',

		CASE 	WHEN GA_1_SOURCE ne . then GA_1_SOURCE
				when GA_1_SOURCE = . and ga_2_source ne . then ga_2_source
				when GA_1_SOURCE = . and ga_2_source = . and ga_4_source ne . then ga_4_source
				when GA_1_SOURCE = . and ga_2_source = . and ga_4_source = . and ga_5_source ne . then ga_5_source
				when GA_1_SOURCE = . and ga_2_source = . and ga_4_source = . and ga_5_source = . and ga_6_source ne . then ga_6_source
				end as GA_S format = gasource_. label = 'Baby''s Gestational Age (GA) Source)',
		
		CASE WHEN mdx_gndr ne . then mdx_gndr
				when mdx_gndr = . and birth_gender ne . then birth_gender
				when mdx_gndr = . and birth_gender = . and b01_baby_gender ne . then b01_baby_gender
				end as gender format = gender_. label = 'Baby''s Gender',

		CASE WHEN gender_EMR ne . then gender_EMR
				when gender_EMR = . and gender_birth ne . then gender_birth
				when gender_EMR = . and gender_birth = . and gender_714 ne . then gender_714
				end as gender_s format = gendercounter_. label = 'Baby''s Gender Source',

		mdxapgar_1 as apgars_1 label = 'Apgar Score at 1 Minute (Obtained from EMR)',

		mdxapgar_5min as apgars_5 label = 'Apgar Score at 5 Minute (Obtained from EMR)',
		
		date_fix_DC as discharge_date label = 'Date and Time of Hospital Discharge',

		los label = 'Hospital Length of Stay (LOS) [Discharge Date - Birth Date]',

		CASE WHEN mdx_nicu ne . then mdx_nicu
				when mdx_nicu = . and b01_icu ne . then b01_icu
				end as NICU_yn format = yn_. label = 'Was the NICU present at delivery?',

		CASE WHEN ICU_EMR ne . then ICU_EMR
				when ICU_EMR = . and ICU_BIRTH ne . then ICU_BIRTH
				end as NICU_yn_s format = NICUcounter_. label = 'NICU Admission Source',
		
		non_participant
FROM BIRTH_OUTCOMES2
; QUIT ;



*Fenton's cutoff weights and time (DO NOT DELETE OR MANIPULATE);
DATA lms;
input Weeks	Days	time1	ten	ninety	sex1;
datalines;
22	3.5	22.500	424	609	0
22	4	22.571	427	614	0
22	5	22.714	432	624	0
22	6	22.857	438	635	0
23	0	23.000	443	646	0
23	1	23.143	449	657	0
23	2	23.286	455	668	0
23	3	23.429	461	681	0
23	4	23.571	467	694	0
23	5	23.714	474	708	0
23	6	23.857	480	722	0
24	0	24.000	487	738	0
24	1	24.143	494	754	0
24	2	24.286	501	770	0
24	3	24.429	508	787	0
24	4	24.571	515	804	0
24	5	24.714	522	822	0
24	6	24.857	530	840	0
25	0	25.000	537	858	0
25	1	25.143	544	876	0
25	2	25.286	551	895	0
25	3	25.429	559	914	0
25	4	25.571	566	933	0
25	5	25.714	574	953	0
25	6	25.857	581	972	0
26	0	26.000	589	992	0
26	1	26.143	596	1012	0
26	2	26.286	604	1033	0
26	3	26.429	612	1053	0
26	4	26.571	620	1074	0
26	5	26.714	628	1095	0
26	6	26.857	637	1117	0
27	0	27.000	645	1138	0
27	1	27.143	654	1160	0
27	2	27.286	663	1183	0
27	3	27.429	673	1205	0
27	4	27.571	682	1228	0
27	5	27.714	692	1252	0
27	6	27.857	702	1276	0
28	0	28.000	713	1300	0
28	1	28.143	723	1324	0
28	2	28.286	734	1349	0
28	3	28.429	746	1374	0
28	4	28.571	758	1400	0
28	5	28.714	770	1426	0
28	6	28.857	783	1453	0
29	0	29.000	796	1480	0
29	1	29.143	810	1507	0
29	2	29.286	824	1535	0
29	3	29.429	839	1564	0
29	4	29.571	854	1592	0
29	5	29.714	870	1622	0
29	6	29.857	887	1652	0
30	0	30.000	904	1682	0
30	1	30.143	921	1713	0
30	2	30.286	940	1744	0
30	3	30.429	959	1775	0
30	4	30.571	978	1808	0
30	5	30.714	998	1840	0
30	6	30.857	1019	1873	0
31	0	31.000	1041	1907	0
31	1	31.143	1063	1941	0
31	2	31.286	1086	1975	0
31	3	31.429	1109	2010	0
31	4	31.571	1133	2044	0
31	5	31.714	1158	2080	0
31	6	31.857	1183	2115	0
32	0	32.000	1209	2151	0
32	1	32.143	1235	2187	0
32	2	32.286	1262	2223	0
32	3	32.429	1289	2260	0
32	4	32.571	1317	2297	0
32	5	32.714	1345	2334	0
32	6	32.857	1374	2371	0
33	0	33.000	1403	2408	0
33	1	33.143	1432	2445	0
33	2	33.286	1462	2482	0
33	3	33.429	1492	2520	0
33	4	33.571	1523	2557	0
33	5	33.714	1554	2595	0
33	6	33.857	1585	2633	0
34	0	34.000	1616	2671	0
34	1	34.143	1648	2708	0
34	2	34.286	1680	2746	0
34	3	34.429	1712	2784	0
34	4	34.571	1744	2822	0
34	5	34.714	1776	2860	0
34	6	34.857	1809	2898	0
35	0	35.000	1841	2936	0
35	1	35.143	1874	2974	0
35	2	35.286	1907	3011	0
35	3	35.429	1939	3049	0
35	4	35.571	1972	3088	0
35	5	35.714	2004	3126	0
35	6	35.857	2036	3164	0
36	0	36.000	2069	3201	0
36	1	36.143	2101	3239	0
36	2	36.286	2132	3277	0
36	3	36.429	2164	3314	0
36	4	36.571	2195	3352	0
36	5	36.714	2226	3389	0
36	6	36.857	2257	3425	0
37	0	37.000	2288	3461	0
37	1	37.143	2317	3497	0
37	2	37.286	2347	3533	0
37	3	37.429	2376	3567	0
37	4	37.571	2405	3602	0
37	5	37.714	2433	3635	0
37	6	37.857	2460	3668	0
38	0	38.000	2487	3700	0
38	1	38.143	2513	3732	0
38	2	38.286	2539	3763	0
38	3	38.429	2565	3794	0
38	4	38.571	2590	3824	0
38	5	38.714	2614	3854	0
38	6	38.857	2638	3883	0
39	0	39.000	2662	3912	0
39	1	39.143	2685	3940	0
39	2	39.286	2708	3968	0
39	3	39.429	2731	3996	0
39	4	39.571	2754	4024	0
39	5	39.714	2777	4052	0
39	6	39.857	2799	4080	0
40	0	40.000	2822	4109	0
40	1	40.143	2845	4137	0
40	2	40.286	2867	4165	0
40	3	40.429	2890	4194	0
40	4	40.571	2913	4223	0
40	5	40.714	2937	4252	0
40	6	40.857	2960	4282	0
41	0	41.000	2984	4312	0
41	1	41.143	3007	4342	0
41	2	41.286	3031	4373	0
41	3	41.429	3055	4403	0
41	4	41.571	3080	4434	0
41	5	41.714	3104	4466	0
41	6	41.857	3129	4497	0
42	0	42.000	3153	4529	0
42	1	42.143	3178	4561	0
42	2	42.286	3203	4593	0
42	3	42.429	3228	4625	0
42	4	42.571	3253	4658	0
42	5	42.714	3278	4690	0
42	6	42.857	3303	4723	0
43	0	43.000	3329	4756	0
43	1	43.143	3354	4789	0
43	2	43.286	3380	4822	0
43	3	43.429	3405	4855	0
43	4	43.571	3431	4889	0
43	5	43.714	3456	4922	0
43	6	43.857	3482	4956	0
44	0	44.000	3508	4989	0
44	1	44.143	3533	5022	0
44	2	44.286	3559	5056	0
44	3	44.429	3585	5089	0
44	4	44.571	3611	5123	0
44	5	44.714	3636	5156	0
44	6	44.857	3662	5190	0
45	0	45.000	3688	5223	0
45	1	45.143	3713	5256	0
45	2	45.286	3739	5290	0
45	3	45.429	3764	5323	0
45	4	45.571	3790	5356	0
45	5	45.714	3815	5389	0
45	6	45.857	3841	5421	0
46	0	46.000	3866	5454	0
46	1	46.143	3891	5487	0
46	2	46.286	3917	5519	0
46	3	46.429	3942	5551	0
46	4	46.571	3967	5583	0
46	5	46.714	3992	5616	0
46	6	46.857	4017	5647	0
47	0	47.000	4042	5679	0
47	1	47.143	4067	5711	0
47	2	47.286	4091	5743	0
47	3	47.429	4116	5774	0
47	4	47.571	4141	5805	0
47	5	47.714	4165	5836	0
47	6	47.857	4190	5867	0
48	0	48.000	4214	5898	0
48	1	48.143	4238	5929	0
48	2	48.286	4263	5960	0
48	3	48.429	4287	5990	0
48	4	48.571	4311	6021	0
48	5	48.714	4335	6051	0
48	6	48.857	4359	6081	0
49	0	49.000	4383	6111	0
49	1	49.143	4407	6140	0
49	2	49.286	4430	6170	0
49	3	49.429	4453	6199	0
49	4	49.571	4477	6228	0
49	5	49.714	4500	6256	0
49	6	49.857	4522	6284	0
50	0	50.000	4545	6313	0
22	3.5	22.500	442	629	1
22	4	22.571	446	636	1
22	5	22.714	453	651	1
22	6	22.857	460	665	1
23	0	23.000	466	680	1
23	1	23.143	473	694	1
23	2	23.286	480	709	1
23	3	23.429	488	724	1
23	4	23.571	495	740	1
23	5	23.714	502	755	1
23	6	23.857	509	771	1
24	0	24.000	517	788	1
24	1	24.143	525	804	1
24	2	24.286	532	821	1
24	3	24.429	540	838	1
24	4	24.571	548	855	1
24	5	24.714	556	873	1
24	6	24.857	564	891	1
25	0	25.000	572	909	1
25	1	25.143	580	927	1
25	2	25.286	588	945	1
25	3	25.429	596	964	1
25	4	25.571	605	983	1
25	5	25.714	613	1003	1
25	6	25.857	622	1022	1
26	0	26.000	631	1042	1
26	1	26.143	640	1062	1
26	2	26.286	649	1082	1
26	3	26.429	658	1103	1
26	4	26.571	668	1124	1
26	5	26.714	677	1145	1
26	6	26.857	687	1167	1
27	0	27.000	697	1189	1
27	1	27.143	707	1211	1
27	2	27.286	718	1234	1
27	3	27.429	729	1257	1
27	4	27.571	740	1281	1
27	5	27.714	751	1305	1
27	6	27.857	763	1329	1
28	0	28.000	775	1354	1
28	1	28.143	787	1379	1
28	2	28.286	800	1404	1
28	3	28.429	813	1430	1
28	4	28.571	826	1456	1
28	5	28.714	840	1483	1
28	6	28.857	854	1511	1
29	0	29.000	869	1538	1
29	1	29.143	884	1567	1
29	2	29.286	900	1595	1
29	3	29.429	916	1624	1
29	4	29.571	933	1654	1
29	5	29.714	950	1684	1
29	6	29.857	968	1715	1
30	0	30.000	987	1746	1
30	1	30.143	1006	1778	1
30	2	30.286	1025	1810	1
30	3	30.429	1045	1843	1
30	4	30.571	1066	1877	1
30	5	30.714	1088	1910	1
30	6	30.857	1110	1945	1
31	0	31.000	1133	1980	1
31	1	31.143	1156	2015	1
31	2	31.286	1180	2051	1
31	3	31.429	1205	2087	1
31	4	31.571	1230	2124	1
31	5	31.714	1256	2161	1
31	6	31.857	1282	2198	1
32	0	32.000	1309	2235	1
32	1	32.143	1336	2273	1
32	2	32.286	1364	2311	1
32	3	32.429	1392	2349	1
32	4	32.571	1421	2387	1
32	5	32.714	1450	2426	1
32	6	32.857	1479	2464	1
33	0	33.000	1509	2503	1
33	1	33.143	1539	2542	1
33	2	33.286	1570	2580	1
33	3	33.429	1600	2619	1
33	4	33.571	1631	2658	1
33	5	33.714	1663	2696	1
33	6	33.857	1694	2735	1
34	0	34.000	1726	2774	1
34	1	34.143	1758	2812	1
34	2	34.286	1790	2850	1
34	3	34.429	1822	2888	1
34	4	34.571	1854	2926	1
34	5	34.714	1887	2964	1
34	6	34.857	1919	3002	1
35	0	35.000	1952	3039	1
35	1	35.143	1984	3076	1
35	2	35.286	2016	3113	1
35	3	35.429	2048	3150	1
35	4	35.571	2081	3186	1
35	5	35.714	2113	3222	1
35	6	35.857	2144	3258	1
36	0	36.000	2176	3293	1
36	1	36.143	2208	3328	1
36	2	36.286	2239	3363	1
36	3	36.429	2270	3397	1
36	4	36.571	2301	3431	1
36	5	36.714	2331	3464	1
36	6	36.857	2361	3497	1
37	0	37.000	2391	3530	1
37	1	37.143	2421	3562	1
37	2	37.286	2451	3594	1
37	3	37.429	2480	3626	1
37	4	37.571	2509	3658	1
37	5	37.714	2538	3689	1
37	6	37.857	2567	3720	1
38	0	38.000	2596	3752	1
38	1	38.143	2624	3783	1
38	2	38.286	2653	3814	1
38	3	38.429	2681	3845	1
38	4	38.571	2709	3876	1
38	5	38.714	2737	3907	1
38	6	38.857	2766	3938	1
39	0	39.000	2794	3969	1
39	1	39.143	2822	4001	1
39	2	39.286	2850	4032	1
39	3	39.429	2877	4064	1
39	4	39.571	2905	4096	1
39	5	39.714	2933	4129	1
39	6	39.857	2961	4161	1
40	0	40.000	2989	4194	1
40	1	40.143	3018	4228	1
40	2	40.286	3046	4261	1
40	3	40.429	3074	4296	1
40	4	40.571	3102	4330	1
40	5	40.714	3131	4365	1
40	6	40.857	3159	4401	1
41	0	41.000	3188	4437	1
41	1	41.143	3217	4473	1
41	2	41.286	3246	4510	1
41	3	41.429	3275	4547	1
41	4	41.571	3303	4585	1
41	5	41.714	3332	4623	1
41	6	41.857	3362	4661	1
42	0	42.000	3391	4700	1
42	1	42.143	3420	4738	1
42	2	42.286	3449	4777	1
42	3	42.429	3478	4817	1
42	4	42.571	3508	4856	1
42	5	42.714	3537	4896	1
42	6	42.857	3566	4936	1
43	0	43.000	3596	4976	1
43	1	43.143	3625	5016	1
43	2	43.286	3654	5057	1
43	3	43.429	3684	5097	1
43	4	43.571	3713	5138	1
43	5	43.714	3743	5178	1
43	6	43.857	3772	5219	1
44	0	44.000	3801	5259	1
44	1	44.143	3831	5300	1
44	2	44.286	3860	5340	1
44	3	44.429	3890	5381	1
44	4	44.571	3919	5421	1
44	5	44.714	3948	5461	1
44	6	44.857	3978	5501	1
45	0	45.000	4007	5541	1
45	1	45.143	4037	5581	1
45	2	45.286	4066	5620	1
45	3	45.429	4095	5659	1
45	4	45.571	4125	5698	1
45	5	45.714	4154	5736	1
45	6	45.857	4184	5774	1
46	0	46.000	4213	5812	1
46	1	46.143	4242	5850	1
46	2	46.286	4271	5887	1
46	3	46.429	4301	5924	1
46	4	46.571	4330	5961	1
46	5	46.714	4359	5998	1
46	6	46.857	4388	6034	1
47	0	47.000	4417	6070	1
47	1	47.143	4446	6106	1
47	2	47.286	4475	6141	1
47	3	47.429	4503	6177	1
47	4	47.571	4532	6212	1
47	5	47.714	4560	6247	1
47	6	47.857	4589	6281	1
48	0	48.000	4617	6316	1
48	1	48.143	4645	6350	1
48	2	48.286	4673	6385	1
48	3	48.429	4700	6419	1
48	4	48.571	4728	6453	1
48	5	48.714	4755	6487	1
48	6	48.857	4782	6521	1
49	0	49.000	4809	6554	1
49	1	49.143	4836	6588	1
49	2	49.286	4862	6621	1
49	3	49.429	4889	6655	1
49	4	49.571	4914	6688	1
49	5	49.714	4940	6722	1
49	6	49.857	4965	6755	1
50	0	50.000	4991	6789	1
;
run;

*Creating the first table to separate the sex variables;
proc sql; 
create table data1 as 
select *
from thomas.birth_outcomes, lms 
where birth_outcomes.gender = lms.sex1;
quit;
*doesn't include those less than 22.5;
*Only takes the relevant lines where the time from fentons dataset match the time from your dataset;
data data1; set data1;
tmp = round(ga,0.001);
if tmp = time1 then output;
run;

proc sql;
select family_id, gender, ga, birthweight, ga_fenton
from thomas.birth_outcomes;quit;

*creates the categories;
*if weight is <10% and <90% then small;
*if weight is >10% and <90% then normal;
*if weight is >10% and >90% then large;
data data1 (keep = family_id ga_fenton); set data1;
length ga_FENTON $40.;
if birthweight lt ten and birthweight lt ninety then ga_fenton = 'SGA (Small for Gestational Age)';
if birthweight gt ten and birthweight lt ninety then ga_fenton = 'AGA (Appropriate for Gestational Age)';
if birthweight gt ten and birthweight gt ninety then ga_fenton = 'LGA (Large for Gestational Age)';
run;
proc sort data=data1;
by family_id;
run;
proc sort data=thomas.birth_outcomes;
by family_id;
run;
data thomas.birth_outcomes;
merge data1 thomas.birth_outcomes;
by family_id;
run;

proc format;
value ga_cat_ 	1 = 'Extremely Preterm (GA: < 28 weeks)'
				2 = 'Very Preterm (GA: 28 - 31 6/7 days)'
				3 = 'Moderate to Late Preterm (GA: 32 - 36 6/7 days)'
				4 = 'Early Term (37 - 38 6/7 days)'
				5 = 'Full Term (39 - 40 6/7 days)'
				6 = 'Late Term (41 - 41 6/7 days)'
				7 = 'Post Term (>42 weeks)';
run;

DATA THOMAS.BIRTH_OUTCOMES (drop = non_participant); set THOMAS.BIRTH_OUTCOMES;
if non_participant = 1 then delete;
if DOB_Baby = . then delete;
label ga_who = 'WHO Preterm Sub Categories';
format ga_who ga_cat_.;
if not missing (ga) then do;
if ga >= 42 then ga_who = 7;
else if ga >= 41 then ga_who = 6;
else if ga >= 39 then ga_who = 5;
else if ga >= 37 then ga_who = 4;
else if ga >= 32 then ga_who = 3;
else if ga >= 28 then ga_who = 2;
else if ga >= 1 then ga_who = 1;
end;
run;
data thomas.birth_outcomes; set thomas.birth_outcomes;
if family_id = 40 then delete;





proc sql;
select family_id
from thomas.birth_outcomes
; quit ;


/*QC-Univariate Analysis*/
proc contents data = thomas.birth_outcomes varnum;
run;
PROC FREQ DATA = thomas.birth_outcomes;
TABLES _character_;
RUN;
PROC FREQ DATA = thomas.birth_outcomes;
TABLES _numeric_;
RUN;
PROC FREQ DATA = thomas.birth_outcomes;
TABLES cohort * mom_site;
RUN;

PROC FREQ DATA = thomas.birth_outcomes;
TABLES NON_RESPONDER;
RUN;
PROC FREQ DATA = thomas.birth_outcomes;
TABLES mom_site;
RUN;
proc tabulate data=thomas.birth_outcomes;
var DOB_Baby;
table DOB_Baby,
n nmiss (min max)*f=mmddyy10.;
run;
proc tabulate data=thomas.birth_outcomes;
var DOB_time;
table DOB_time,
n nmiss (min max)*f=TIME.;
run;
PROC sort DATA=THOMAS.BIRTH_OUTCOMES;
by delivery_s;
run;
PROC freq DATA=THOMAS.BIRTH_OUTCOMES;
tables delivery;
RUN;

proc sgplot data = thomas.birth_outcomes;
reg x = birthweight y = ga /  clm cli ;

where birthweight < 6000 and ga < 45;
run;

reg x = birthweight y = ga /  clm cli ;
scatter x = birthweight y = ga / group = ga_fenton;
loess x = birthweight y = ga /  group = ga_fenton;

PROC MEANS DATA=THOMAS.BIRTH_OUTCOMES;
CLASS birthweight_s;
VAR birthweight;
RUN;

proc sort data = thomas.birth_outcomes;
by cohort;
run;
proc sgplot data = thomas.birth_outcomes;
scatter x = length y = ga;
reg x = length y = ga;
where length < 100 and length > 25;
run;



PROC MEANS DATA=THOMAS.BIRTH_OUTCOMES;
CLASS length_s;
VAR length;
RUN;
PROC MEANS DATA=THOMAS.BIRTH_OUTCOMES;

/*There are only 5 observations. Data must come from PEDS DB*/
CLASS head_circumference_s;
VAR head_circumference;
RUN;
PROC MEANS DATA=THOMAS.BIRTH_OUTCOMES;
CLASS ga_s;
VAR ga;
RUN;
PROC FREQ DATA=THOMAS.BIRTH_OUTCOMES;
TABLES ga_cat * ga_fenton;
RUN;
PROC FREQ DATA=THOMAS.BIRTH_OUTCOMES;
TABLES ga_FENTON;
RUN;
PROC sort DATA=THOMAS.BIRTH_OUTCOMES;
by gender_s;
run;
PROC freq DATA=THOMAS.BIRTH_OUTCOMES;
tables gender;
RUN;
proc sort data=thomas.birth_outcomes;
by mom_site;
run;
PROC MEANS DATA=THOMAS.BIRTH_OUTCOMES N mean MEDIAN Q1 Q3 MIN MAX;
by mom_site;
VAR apgars_1 apgars_5;
RUN;
proc tabulate data=thomas.birth_outcomes;
var discharge_date;
table discharge_date,
n nmiss (min max)*f=DATETIME. ;
run;
PROC MEANS DATA=THOMAS.BIRTH_OUTCOMES;
VAR los;
RUN;
PROC sort DATA=THOMAS.BIRTH_OUTCOMES;
by NICU_yn_source;
run;
PROC FREQ DATA=THOMAS.BIRTH_OUTCOMES;
TABLES NICU_yn;
RUN;
proc sql;
select family_id, gender, ga, birthweight
from thomas.birth_outcomes
; quit ;
proc sql;
select family_id, GA, BIRTHWEIGHT
from THOMAS.BIRTH_OUTCOMES
where ga_fenton = 'SGA'
; quit ;


proc sql;
create table THOMAS.BIRTH_OUTCOMES_1Oct2018 as
select ID,ID_Baby,family_id,cohort,non_responder,
		mom_site,DOB_Baby,DOB_time,DOB_Baby_s,baby_site,
		delivery,delivery_s,birthweight,birthweight_s,length,
		length_s,head_circumference,head_circumference_s,GA,GA_s,
		ga_FENTON label = 'Fenton 2013 GA Category',ga_who,gender,gender_s,apgars_1,
		apgars_5,discharge_date,LOS,NICU_yn,NICU_yn_s
from THOMAS.BIRTH_OUTCOMES
; quit ;


*created a proc compare;
libname datasets "R:\MADRES_DATA\Datasets";
proc sort data = thomas.birth_outcomes_4Sept2018;
by family_id;
run;
proc sort data = thomas.BIRTH_OUTCOMES;
by family_id;
run;
title '';
footnote '';
proc compare base = thomas.birth_outcomes_4Sept2018 compare = thomas.BIRTH_OUTCOMES out=result outnoequal outbase outcomp outdif;
id family_id;
run;

proc print data=result noobs;
	by family_id;
   id family_id;
   title 'The Output Data Set RESULT';
run;


