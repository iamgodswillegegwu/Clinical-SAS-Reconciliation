%macro one (a = , b = );
proc import 
datafile= "/folders/myfolders/joe/&a"
out= Work.&b
dbms=csv replace;
guessingrows= max;
run;
%mend one;

%one (a = ACP-2566-004_AE.csv, b = AE );
%one (a = ACP-2566-004_CM.csv, b = CM );
%one (a = ACP-2566-004_MH.csv, b = MH );

data CM1;
retain Subject Domain CMTRT CMINDC CMSTDAT CMONGO CMENDAT CMDOSU CMDOSE CMDOSFR CMROUTE;
set work.CM;
Indication = '';
Administered_Dose_at_Each_Intake = .;
Reason_for_Medication = '';
Dose_Unit = '';
Frequency = '';
Domain = 'CM';
Route_of_Administration = '';
keep Subject Domain CMTRT CMINDC CMSTDAT CMONGO CMENDAT CMDOSU CMDOSE CMDOSFR CMROUTE;
rename Subject = Patient_ID;
rename CMTRT  = Term;
rename CMINDC = Indication;
rename CMSTDAT = Start_Date;
rename CMONGO = Continuing;
rename CMENDAT = End_Date;
rename CMDOSU = Dose_Unit;
rename CMDOSE = Administered_Dose_at_Each_Intake;
rename CMDOSFR = Frequency;
rename CMROUTE = Route_of_Administration;
run;

data AE1;
retain Subject Domain AETERM AESTDAT AEONG AEENDAT AEFREQ AEOUT AEACN AETHER AEREL AESER;
set work.AE;
Indication = '';
Administered_Dose_at_Each_Intake = .;
Reason_for_Medication = '';
Dose_Unit = '';
Frequency = '';
Domain = 'AE';
Route_of_Administration = '';
keep Subject Domain AETERM AESTDAT AEONG AEENDAT AEFREQ AEOUT AEACN AETHER AEREL AESER;
set work.AE;
format AETERM best12. ;
rename Subject = Patient_ID;
rename AETERM = Term;
rename AESTDAT = Start_Date;
rename AEONG = Continuing;
rename AEENDAT = End_Date;
rename AEFREQ = Frequency;
rename AEOUT = Outcome;
rename AEACN = AE_Action_Taken;
rename AETHER = Con_Add_Medication_Given;
rename AEREL = Relation_to_Study_Treat;
rename AESER = Serious;
run;

data MH1;
retain Subject Domain MHTERM MHBOD MHSTDAT MHONGO MHENDAT;
set work.MH;
Indication = '';
Administered_Dose_at_Each_Intake = .;
Dose_Unit = '';
Frequency = '';
Reason_for_Medication = '';
Route_of_Administration = '';
Domain = 'MH';
keep Subject Domain MHTERM MHBOD MHSTDAT MHONGO MHENDAT;
set work.MH;
format CMROUTE best12. ;
rename Subject = Patient_ID;
rename MHTERM = Term;
rename MHBOD = Body_System;
rename MHSTDAT = Start_Date;
rename MHONGO = Continuing;
rename MHENDAT = End_Date;
run;

data COMPLETE;
merge work.AE1 work.CM1 work.MH1;
by Domain;

proc sort data=work.complete out=work._comp_;
by Patient_ID;

proc export 
  data=work.COMPLETE
  dbms=xlsx 
  outfile="/folders/myfolders/joe/ACP-2566-004_AE_CM_MH_.xlsx" 
  replace;
run;