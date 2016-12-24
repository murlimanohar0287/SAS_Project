
/* Read data csv and load it into sas dataset*/
proc import 
	out=projfact
	datafile="/folders/myfolders/project1_data_16.csv" 
	dbms= csv replace;
	getnames=yes;
	datarow=2;
run;


/* Analyse contents for the data set: all are quantitative values so no need to drop any variable*/
proc contents data=projfact;
	title 'content analyzation for the dataset';
run;


/* Examine if we have a correlated variables in the dataset*/
proc corr data=projfact;
	title 'initial varables correlation matrix';
run;


/* We need standardization in the dataset values as lot many values are weighed differently */
proc standard data=projfact out=Stdprojfact(drop= PALLFNF_Index PNFUEL_Index PFANDB_Index) mean=0 std=1;
	title 'Standardisation of the dataset';
run;


/* Analyze data set after standardisation */
proc means data=Stdprojfact;
	title 'Summary Statistics for the standardised dataset';
run;


/* Factor analysis without any rotation to get the top factors*/
proc factor data=Stdprojfact scree reorder;
	title 'Initial Factor analysis without any rotation';
run;


/* Using Varimax rotation without Prior SMC*/
proc factor data=Stdprojfact rotate=varimax nfactors=4 scree reorder out=scoreVar;
	title 'Factor analysis using varimax with 4 best factors';
run;


/* Using Varimax rotation with Prior SMC*/
proc factor data=Stdprojfact rotate=varimax nfactors=4 plot scree reorder;
	title 'Factor analysis using varimax with 4 best factors with prior smc';
	priors smc;
run;


/* Using Promax rotation without Prior SMC*/
proc factor data=Stdprojfact rotate=promax nfactors=4 scree reorder out=scorePro;
	title 'Factor analysis using promax with 4 best factors';
run;


/* Using Promax rotation with Prior SMC*/
proc factor data=Stdprojfact rotate=promax nfactors=4 scree reorder;
	title 'Factor analysis using promax with 4 best factors with prior smc';
	*priors smc;
run;



/* Correlation analysis for factors "Promax rotation without Prior SMC" */
%let varlist1=PALLFNF_Index 
PNFUEL_Index 
PFANDB_Index 
PCOFFOTM_USD 
PCOFFROB_USD 
PCOTTIND_USD
PFISH_USD
PLEAD_USD
PLOGSK_USD
PMAIZMT_USD
PNGASEU_USD
PNGASJP_USD
PSMEA_USD
PSUNO_USD
PURAN_USD
PWHEAMT_USD;

%let varlist2=PLOGORE_USD PCOCO_USD ;

%let varlist3=PLAMB_USD PNGASUS_USD;

%let varlist21=PLAMB_USD PNGASUS_USD;

%let varlist31=PLOGORE_USD;

%let varlist11=PALLFNF_Index 
PNFUEL_Index 
PFANDB_Index 
PCOFFOTM_USD 
PCOFFROB_USD 
PCOTTIND_USD
PFISH_USD
PLEAD_USD
PLOGSK_USD
PMAIZMT_USD
PNGASEU_USD
PNGASJP_USD
PSMEA_USD
PSUNO_USD
PURAN_USD
PWHEAMT_USD
PCOCO_USD;

DATA SCOREPRO1;
   SET scorePro;
   FACT1 = MEAN(OF &varlist1);

   FACT2 = mean(of &varlist2);
   
   FACT3= mean(of &varlist3);
   
RUN;

PROC CORR DATA=SCOREPRO1 ; *NOSIMPLE;
   TITLE "Correlating Factor Scores to Simple Scoring Promax rotation without Prior SMC";
   VAR FACTOR1 FACTOR2 FACTOR3;
   WITH FACT1 FACT2 FACT3;
RUN;



/* Correlation analysis for factors "Varimax rotation without using priors" */

DATA SCOREVAR1;
   SET scoreVar;
   FACT11 = MEAN(OF &varlist11);

   FACT21 = mean(of &varlist21);
   
   FACT31= mean(of &varlist31);
   
RUN;

PROC CORR DATA=SCOREVAR1 ; *NOSIMPLE;
   TITLE "Correlating Factor Scores to Simple Scoring Varimax rotation without Prior SMC";
   VAR FACTOR1 FACTOR2 FACTOR3;
   WITH FACT11 FACT21 FACT31;
RUN;






