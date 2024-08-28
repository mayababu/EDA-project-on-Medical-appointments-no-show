/*creating library*/
libname Maya "C:\DSA\FDAS\PROJECT\Maya";

/*importing csv file*/
proc import datafile="C:\DSA\FDAS\PROJECT\Maya\Medical Appointment No shows.csv"
dbms=csv
out=Maya.SAS_Project;
run;

/*Checking the data to get the details of the variables in the dataset.*/
proc contents data=Maya.SAS_Project varnum;
run;

/*Check descriptive statistics of the numerical variables in the data.*/
proc means dat=Maya.SAS_Project;
run;

Proc means data=Maya.SAS_Project MAXDEC =2   NMISS p1 p5 var CV Q1 MEDIAN Q3 p95 p99 stderr;
run;

proc means data=Maya.SAS_Project nmiss;
run;

/*making the table more comparable*/

data Maya.EDA (drop=patientid appointmentid);
set Maya.SAS_Project (rename=(Hipertension=Hypertension));
drop scheduledday appointmentday;
Schld_date = datepart(scheduledday);
Apt_date = datepart(Appointmentday);
format schld_date apt_date date9.;
day_diff = (apt_date - schld_date);
run;

proc print data=Maya.EDA (obs=10);
run;
title;

/**********************Univariate analysis*******************/
/*Univariate analysis of numeric variables*/

/*summarisation of variable age*/

proc univariate data=Maya.EDA;
var age;
run;

/*visualisation of variable age*/
proc sgplot data=Maya.EDA;
title "Age Distribution";
histogram Age;
density Age;
run;

/*summarisation of variable day difference*/
title;
proc univariate data=Maya.EDA;
var day_diff;
run;

/*visualisation of variable day difference*/
proc sgplot data=Maya.EDA;
histogram day_diff;
run;

/*univariate analysis of categorical variables*/

/*summarisation*/
proc freq data=Maya.EDA;
table gender scholarship hypertension diabetes alcoholism handcap SMS_received No_show;
run;

/*visualisation of Gender*/
proc gchart data=Maya.EDA;
pie gender;
title "Gender";
run;
quit;

/*visualisation of Scholarship*/
PROC SGPLOT DATA= Maya.EDA;
VBAR Scholarship;
title "Scholarship";
RUN;
QUIT;

/*visualisation of Hypertension*/
PROC SGPLOT DATA= Maya.EDA;
VBAR Hypertension;
title "Hypertension";
RUN;
QUIT;

/*visualisation of Diabetes*/
PROC SGPLOT DATA= Maya.EDA;
VBAR Diabetes;
title "Diabetes";
RUN;
QUIT;

/*visualisation of Alcoholism*/
PROC SGPLOT DATA= Maya.EDA;
VBAR Alcoholism;
title "Alcoholism";
RUN;
QUIT;

/*visualisation of Handcap*/
PROC SGPLOT DATA= Maya.EDA;
VBAR Handcap;
title "Handicap";
RUN;
QUIT;

/*visualisation of SMS_received*/
proc gchart data=Maya.EDA;
pie SMS_received;
title "SMS Received";
run;
quit;

/*visualisation of No_show*/
PROC SGPLOT DATA= Maya.EDA;
VBAR No_Show;
title "No_Show";
RUN;
QUIT;


/***************Bivariate Analysis**************/
/*finding out the percentage of no show*/

proc freq data=Maya.EDA;
tables No_show/ nocum plots=freqplot(type=bar scale=percent);
run;

/*Categorical Vs categorical variables*/
/*gender vs no show*/

/*summarisation*/
/*chi square test*/
 proc freq data=Maya.EDA;
 tables No_show*gender / chisq norow nocol nopct;
 run;

/*visualisation*/

Title "Vertical Stacked Barchart : Gender By No_show";
proc SGPLOT data= Maya.EDA;
HBAR No_show/Group=Gender;
run;
quit;

title;

/*Scholarship Vs No show*/
/*summarisation*/
proc freq data=Maya.EDA;
tables No_show*Scholarship;
run;

/*Visualisation*/
proc SGPLOT data = Maya.EDA;
vbar scholarship /group = No_show groupdisplay = cluster;
title 'Scholarship Vs No_show';
run;
quit;

/*Hypertension Vs No_show*/
/*summarisation*/
proc freq data=Maya.EDA;
tables No_show*Hypertension /chisq;
run;

/*Visualisation*/
proc SGPLOT data = Maya.EDA;
vbar Hypertension /group = No_show groupdisplay = cluster;
title 'Hypertension Vs No_show';
run;
quit;

/*SMS Received Vs No_show*/
/*summarisation*/
proc freq data=Maya.EDA;
tables No_show*SMS_received /chisq;
run;

/*Visualisation*/
proc SGPLOT data = Maya.EDA;
vbar SMS_Received /group = No_show groupdisplay = cluster;
title 'SMS_Received Vs No_show';
run;
quit;

/*Neighbourgood Vs No_show*/
/*Summarisation*/
proc freq data=Maya.EDA;
tables No_show*neighbourhood / chisq;
run;

/*visualisation*/
proc sgplot data=Maya.EDA;
vbar Neighbourhood / group = No_show groupdisplay= cluster;
title 'Neighbourhood Vs No_show';
run;
quit; 

/*Alcoholism Vs No show*/
/*Summarisation*/
proc freq data=Maya.EDA;
tables No_show*alcoholism;
run;

/*visualisation*/
proc sgplot data=Maya.EDA;
vbar alcoholism / group=No_show groupdisplay=cluster;
title 'Alcoholism Vs No_show';
run;

/*Bivariate Analysis of continuous and categorical variables*/
/*Age Vs No show*/
/*summarisation*/

proc freq data=Maya.EDA;
tables No_show*Age;
run;

/*visualisation*/
proc sgplot data=Maya.EDA;
hbox Age/ group=No_show groupdisplay=cluster;
title'Age Vs No show';
run;

/*day difference vs no show*/

data Maya.day;
set Maya.EDA;
length day_diff2 $ 16;
if day_diff <= 0 then day_diff2 = "Same Day";
else if day_diff <= 4 then day_diff2 = "Few Days";
else if day_diff > 4 and day_diff <= 15 then day_diff2 = "More than4";
else day_diff2 = "More than15";
run; 

/*summarisation*/

proc freq data=Maya.day;
tables No_show*day_diff2/nocum;
run;

/*visualisation*/
title;
proc SGPLOT data = Maya.EDA;
vbox day_diff /group = No_show;
title 'day_diff Vs No_show';
run;
quit;

/*t test*/
ods graphics on;
title 'Day difference Vs No show';
proc ttest data = Maya.EDA;
class No_show;
var day_diff;
run;
ods graphics off;


