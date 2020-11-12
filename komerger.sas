%macro one (a = , b = );
proc import 
datafile= "/folders/myfolders/ko/&a"
out= Work.&b
dbms=csv replace;
guessingrows= max;
run;
%mend one;

%one (a = HZNP-KRY-202_AE.csv, b = AE );
%one (a = HZNP-KRY-202_CM.csv, b = CM );
%one (a = HZNP-KRY-202_MH.csv, b = MH );


data CM1;
retain Subject Domain CMTERM CMINDC CMSTDT_RAW CMONGO CMENDT_RAW CMDOSU CMDOSE CMFREQ CMROUTE;
set work.CM;
Indication = '';
Administered_Dose_at_Each_Intake = .;
Reason_for_Medication = '';
Dose_Unit = '';
Frequency = '';
Domain = 'CM';
Route_of_Administration = '';
keep Subject Domain CMTERM CMINDC CMSTDT_RAW CMONGO CMENDT_RAW CMDOSU CMDOSE CMFREQ CMROUTE;
rename Subject = Patient_ID;
rename CMTERM  = Term;
rename CMINDC = Indication;
rename CMSTDT_RAW = Start_Date;
rename CMONGO = Continuing;
rename CMENDT_RAW = End_Date;
rename CMDOSU = Dose_Unit;
rename CMDOSE = Administered_Dose_at_Each_Intake;
rename CMFREQ = Frequency;
rename CMROUTE = Route_of_Administration;
run;

data AE1;
retain Subject Domain AETERM AESTDT_RAW AESTTM AEONGO AEENDT_RAW AEENTM AEOUT AEACN AEGRADE AEREL AESER;
set work.AE;
Indication = '';
Administered_Dose_at_Each_Intake = .;
Reason_for_Medication = '';
Dose_Unit = '';
Frequency = '';
Domain = 'AE';
Route_of_Administration = '';
keep Subject Domain AETERM AESTDT_RAW AESTTM AEONGO AEENDT_RAW AEENTM AEOUT AEACN AEGRADE AEREL AESER;
set work.AE;
format AETERM best12. ;
rename Subject = Patient_ID;
rename AETERM = Term;
rename AESTDT_RAW = Start_Date;
rename AESTTM = Start_Time;
rename AEONGO = Continuing;
rename AEENDT_RAW = End_Date;
rename AEENTM = End_Time;
rename AEOUT = Outcome;
rename AEACN = AE_Action_Taken;
rename AEGRADE = Grade;
rename AEREL = Relation_to_Study_Treat;
rename AESER = Serious;
run;

data MH1;
retain Subject Domain MHTERM MHSTDT_RAW MHONGO MHENDT_RAW MHCTC;
set work.MH;
Indication = '';
Administered_Dose_at_Each_Intake = .;
Dose_Unit = '';
Frequency = '';
Reason_for_Medication = '';
Route_of_Administration = '';
Domain = 'MH';
keep Subject Domain MHTERM MHSTDT_RAW MHONGO MHENDT_RAW MHCTC;
set work.MH;
format CMROUTE best12. ;
rename Subject = Patient_ID;
rename MHTERM = Term;
rename MHSTDT_RAW = Start_Date;
rename MHONGO = Continuing;
rename MHENDT_RAW = End_Date;
rename MHCTC = Grade;
run;

data COMPLETE;
merge work.AE1 work.CM1 work.MH1;
by Domain;

proc sort data=work.complete out=work._comp_;
by Patient_ID;

proc export 
  data=work._COMP_
  dbms=xlsx 
  outfile="/folders/myfolders/ko/HZNP-KRY-202_AE_CM_MH.xlsx" 
  replace;
run;