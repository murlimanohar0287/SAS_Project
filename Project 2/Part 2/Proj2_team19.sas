
libname proj2 '/folders/myfolders/project2_1';

%Let categorical=House_Style 
Overall_Qual 
Overall_Cond 
Heating_QC 
Central_Air 
Bedroom_AbvGr 
Fireplaces 
Mo_Sold 
Full_Bathroom 
Half_Bathroom 
Total_Bathroom 
Season_Sold 
Garage_Type_2 
Foundation_2 
Masonry_Veneer 
Lot_Shape_2 
House_Style2 
Overall_Qual2 
Overall_Cond2 
Bonus;

%Let interval=Lot_Area 
Gr_Liv_Area 
Garage_Area 
SalePrice 
Basement_Area 
Deck_Porch_Area 
Age_Sold 
Log_Price;



/* Part 2 – Prob 1: 
Q 1: Does the significance level for entry into and staying in the model 
 	 have any impact when you use options other than SL
A 1: No, other than SL none of the options have any impact of 
	 ignificance level for entry into and staying in the model 
	 
Q 2: Which variables stay in the model for each 5 options
A 2: Below are the variables those stay in all the 5 models:
	 Gr_Liv_Area
	 Basement_Area
	 Deck_Porch_Area
	 Age_Sold
	 Log_Price

Q 3: Which selection methods and criteria would you recommend
A 3: All the methods have same r-square value and Root MSE. 
	 So, I would suggest to go with any model all will be effective.
*/
ods graphics on;

%Let interval1=Lot_Area 
Gr_Liv_Area 
Garage_Area
Basement_Area 
Deck_Porch_Area 
Age_Sold 
Log_Price;

%macro macro_glm(method);
 proc glmselect data=proj2.team19 plots=all; 
    model SalePrice=&interval1/ 
    SELECTION=STEPWISE DETAILS=steps SELECT=&method SLENTRY=0.05 SLSTAY=0.05;    
    title "Macro execution with Stepwise Selection and method &method";
 run;
 quit;
%mend macro_glm;

%macro_glm(SL);
%macro_glm(AIC);
%macro_glm(BIC);
%macro_glm(AICC);
%macro_glm(SBC);

ods graphics off;

/* Part 2 – Prob 2: We will use same macro "interval1" in this question too.
	I would suggest to go with R-Square as it is expalaining 95.82% of variation 
	with just 4 variable selection:
	
	Number in   R-Square	Adjusted R-Square	C(p)	Variables in Model
	Model	
	4	         0.9585	         0.9582	       10.6189	Gr_Liv_Area Basement_Area Age_Sold Log_Price
*/

proc reg data=proj2.team19;
 model SalePrice=&interval1/selection=rsquare adjrsq cp;
run;



/* Part 2 – Prob 3:

	There is a bonus associsted with greater basment area. 
	So chances of bonus are much more when you have house basement are greater than 1200 square feet
*/

ods graphics on;

proc freq data=proj2.team19;
 tables Bonus Fireplaces Lot_Shape_2 Bonus*Fireplaces Bonus*Lot_Shape_2;
run;

proc univariate data=proj2.team19;
 histogram Basement_Area;
 class Bonus;
 var Basement_Area;
run;

ods graphics off;

/* Part 2 – Prob 4: The following
code generates plots and descriptive 
statistics for continuous variables */


/* Part 2 – Prob 5: The following
code generates plots and descriptive 
statistics for continuous variables */


/* Part 2 – Prob 6: The following
code generates plots and descriptive 
statistics for continuous variables */
