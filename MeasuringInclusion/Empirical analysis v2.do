*Financial inclusion measures
*VERSION
*v1: GK
*v2: GK
**Prepared for revised paper
**New working directory
**Park and Mercado (2015) data are saved as FII.dta
**Arora (2010) data are saves as FAI.dta
**DATA_FOR_MERGE.dta refers to Park and Mercado (2015) data for comparision
**Problem with country strings
**Excel file String matching.xlsx - string matching using vlookup function
**Count variable stored in Code.dta
**Corrected mistake in predicted scores - see line 307 to 309

*Change directory
*GK in home office
cd "C:\Users\User\Documents\Gerhard\NEW\Resubmission\DATA\"


*******************************************************************************************
*Park and Mercado (2015)<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
*******************************************************************************************
*Import data from the World Devlopment Indicators databse
global var "ATM BOR COM DEP DOM"
	foreach y of global var {
		insheet using `y'.csv, clear
		*Make country identifier
		encode countrycode, gen(code)
		sort code time
		save `y'.dta, replace
	}

*Merge datasets
use ATM.dta, clear	
sort code time

global var "BOR COM DEP DOM"
	foreach y of global var {
		sort code time
		merge code time using `y'.dta
		drop _merge
		}

rename countryname name
rename time year
order name countrycode code year

*Labels for variables
label var atm "Automated teller machines (ATMs) (per 100,000 adults) [FB.ATM.TOTL.P5]"
label var bor "Borrowers from commercial banks (per 1,000 adults) [FB.CBK.BRWR.P3]" 
label var com "Commercial bank branches (per 100,000 adults) [FB.CBK.BRCH.P5]"
label var dep "Depositors with commercial banks (per 1,000 adults) [FB.CBK.DPTR.P3]" 
label var dom "Domestic credit provided by financial sector (% of GDP) [FS.AST.DOMS.GD.ZS]" 

*Replicate Park and Mercado (2015) 
*Except: no country averages as we want to explore time trends

*STEP 1: standardised measures using annual minimum and maximum values
*Underscore s refers to standardised measures
global var "atm bor com dep dom"
	foreach y of global var {
		sort year
		by year: egen MAX=max(`y')
		by year: egen MIN=min(`y')
		sort code year
		gen s_`y'=(`y'-MIN)/(MAX-MIN)
		drop MAX MIN
		}

*STEP 2: Derive the Euclidian distance measure
sort code year
gen FII=1-sqrt(1/5*((1-s_atm)^2+(1-s_bor)^2+(1-s_com)^2+(1-s_dep)^2+(1-s_dom)^2))

label var FII "Financial inclusion measure by Park and Mercado (2015)" 

*>>>>>>>>>>>>>>>>>>>> SAVE DATA<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
save INTERIM.dta, replace

*>>>>>>>>>>>>>>>>>>>> ANALYSIS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
use INTERIM.dta, clear

*>>>>>>>>>>>>>>>>>>>> COMPARISON <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
*Comparison of FII for all countries and sub-samples
*All countries
tabstat FII, by(year)

*China
tabstat FII if countrycode=="CHN", by(year)

*Brazil
tabstat FII if countrycode=="BRA", by(year)

****************************************************************************************************
*CFA ANALYSIS **************************************************************************************
****************************************************************************************************
*CFA model: measurement models for the two dimensions based on Park and Mercado (2015) 
sem (ACCESS -> atm com) (USE -> bor dep dom), method(ml) latent(ACCESS USE) standardized
estat gof, stats(all)
estat mindices
estimates store A

*>>>>>>>>>>>>>>>>>>>> TABLE CFA <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
estout A using T_CFA1.xls, c(b_std p std) replace

*Reestimate model with cov(e.bor,e.dep)
sem (ACCESS -> atm com) (USE -> bor dep dom), method(ml) latent(ACCESS USE) standardized cov(e.bor*e.dep)
estat gof, stats(all)

*Based on the model, we predict factor scores for latent variables
*We need to restrict the sample to cases where we have observations for at least one measure
gen out=1 if atm==. & com==. & bor==. & dep==. & dom==. 
replace out=0 if out==.

*Factor scores for latent variables
predict F_USE, latent(USE)
replace F_USE=. if out==1
predict F_ACCESS, latent(ACCESS)
replace F_ACCESS=. if out==1

*>>>>>>>>>>>>>>>>>>>> Comparison of components <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
*Comparison of factor scores for latent variables for all countries and sub-samples
*ALL
tabstat F_USE F_ACCESS, by(year)

*China
tabstat F_USE F_ACCESS if countrycode=="CHN", by(year)

*Brazil
tabstat F_USE F_ACCESS if countrycode=="BRA", by(year)


*******************************************************************************************
*DATA Park and Mercado (2015) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
*******************************************************************************************
*>>>>>>>>>>>>>>>>>>>> SAVE DATA<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
save FII.dta, replace


*******************************************************************************************
*Arora (2010)           <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
*******************************************************************************************
*Sorting data by country
forvalues i=1/5 {
	use Arora`i'.dta, clear
	sort code
	save Arora`i'.dta, replace
	}

*Merge data
use Arora1.dta, clear
merge 1:1 code using Arora2.dta
drop _merge
sort code
merge 1:1 code using Arora3.dta
drop _merge
sort code
merge 1:1 code using Arora4.dta
drop _merge
sort code
merge 1:1 code using Arora5.dta
drop _merge
sort code

order code country

*>>>>>>>>>>>>>>>>>>>> SAVE DATA<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
save INTERIM2.dta, replace

*>>>>>>>>>>>>>>>>>>>> ANALYSIS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
use INTERIM2.dta, clear

*Labels for variables
label var code "Identifier on country level"

label var country "Name of country"

label var branch_g "Geographic branch penetration (number)"

label var branch_d "Demographic branch penetration (number)"

label var atm_g "Geographic ATM penetration (number)"   

label var atm_d "Demographic ATM penetration (number)"

label var ratio "Ratio of private credit to GDP (average 1999 to 2003)"

label var gdp "GDP per capita, 2003 ($)"

label var number "Number of banks responding" 

label var share "Deposit market share (respondents share out of total system) 2004"

label var location "Locations to open deposit account (out of 3)"

label var min_c "Minimum amount to open checking account (% of GDPPC)"

label var min_s "Minimum amount to open savings account (% of GDPPC)"

label var min_c_m "Minimum amount to be maintained in checking account(% of GDPPC)"	

label var min_s_m "Minimum amount to be maintained in savings account(% of GDPPC)"

label var fee_c "Annual fees checking account (% of GDPPC)"

label var fee_s "Annual fees savings account (% of GDPPC)"

label var docs_c "No. of docs. to open checking account (out of 5)"

label var docs_s "No. of docs to open savings account (out of 5)" 

label var number_l "Number of banks responding"

label var share_l "Loan market share (respondents share out of total system) 2004"	

label var location_l "Locations to submit loan applications (out of 5)"

label var min_cl "Minimum amount consumer loan (% of GDPPC)"	

label var fee_cl "Fees consumer loan (% of min. loan amount)"

label var min_mo "Minimum amount mortgage loan (% of GDPPC)"	

label var fee_mo "Fee mortgage loan (% of min. loan amount)"

label var day_cl "Days to process consumer loan applications"	

label var day_mo "Days to process mortgage loan applications"

label var number_b "Number of banks responding"	

label var share_b "Loan market share (respondents share out of total system) 2004"	

label var location_b "Locations to submit loan applications (out of 5)"	

label var min_b "Minimum amount business loan (% of GDPPC)"	

label var fee_b "Fee business loan (% of min. loan amount)"	

label var min_sl "Minimum amount SME loan  (% of GDPPC)"	

label var fee_sl "Fees SME loan (% of min. loan amount)"	

label var days_b "Days to process business loan applications"

label var days_sl "Days to process SME loan applications"

label var number_t "Number of banks responding"	 

label var share_t "Deposit market share (respondents share out of total system) 2004"  

label var fee_t "Cost to transfer funds internationally (% of $250)" 

label var fee_atm "Amount of fee for using ATM cards (% of $100)"  

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*Constructing the Arora (2010) index
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*There are three dimensions, which is not based on any analysis
*Outreach, Ease and Cost
*Outreach: branch_g branch_d atm_g atm_d 
*Ease: location min_c min_s min_c_m min_s_m docs_s docs_c location_l min_cl min_mo day_cl day_mo
*Cost: fee_c fee_s fee_cl  fee_mo fee_t fee_atm

*Each variable is standardised see equation (2): similar to other methods
*STEP 1: standardised measures using annual minimum and maximum values
*Underscore s refers to standardised measures
global var "branch_g branch_d atm_g atm_d location min_c min_s min_c_m min_s_m docs_s docs_c location_l min_cl min_mo day_cl day_mo fee_c fee_s fee_cl fee_mo fee_t fee_atm"
	foreach y of global var {
		egen MAX=max(`y')
		egen MIN=min(`y')
		gen s_`y'=(`y'-MIN)/(MAX-MIN)
		drop MAX MIN
		}
		
*STEP 2: Determine dimensions using equal weights of variables - see equation (3)
gen Outreach=(s_branch_g+s_branch_d+s_atm_g+s_atm_d)/4 
label var Outreach "Outreach dimension"

gen Ease=(s_location+s_min_c+s_min_s+s_min_c_m+s_min_s_m+s_docs_s+s_docs_c+s_location_l+s_min_cl+s_min_mo+s_day_cl+s_day_mo)/12
label var Ease "Ease dimension"

gen Cost=(s_fee_c+s_fee_s+s_fee_cl+s_fee_mo+s_fee_t+s_fee_atm)/6
label var Cost "Cost dimension"

*STEP 3: Determine index using weight 2 for outreach and 1 for ease and 1 for cost - see equation (4)
*Note: notation in equation (4) is unclear
gen FAI=(2*Outreach+Ease+Cost)/4
label var FAI "Financial inclusion index based on Arora (2010)"

gen FAI_II=Outreach
label var FAI_II "Outreach only, covers more countries"

****************************************************************************************************
*CFA ANALYSIS **************************************************************************************
****************************************************************************************************
*CFA model: measurement models for the three dimensions based on Arora (2010)
sem (OUT -> s_branch_g s_branch_d s_atm_g s_atm_d) ///
(EASE -> s_location s_min_c s_min_s s_min_c_m s_min_s_m s_docs_s s_docs_c s_location_l s_min_cl s_min_mo s_day_cl s_day_mo) ///
(COST -> s_fee_c s_fee_s s_fee_cl s_fee_mo s_fee_t s_fee_atm), method(ml) latent(OUT EASE COST) standardized
estat gof, stats(all)
estat mindices
estimates store B

*>>>>>>>>>>>>>>>>>>>> TABLE CFA <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
estout B using T_CFA2.xls, c(b_std p std) replace

*Factor scores for latent variables
predict F_OUT, latent(OUT)
predict F_EASE, latent(EASE)
predict F_COST, latent(COST)

*Note: small number of observations to do a CFA on all dimensions in one model

*>>>>>>>>>>>Measurement models for the three dimensions<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
*Measurement model for outreach
*sem (OUT -> s_branch_g s_branch_d s_atm_g s_atm_d) ///
*, method(ml) latent(OUT) standardized
*estat gof, stats(all)
*estat mindices
*NOTE: does not converge
*High correlation between s_atm_g s_branch_g as ATMs are often placed in branches
*Adding covariance to the model does not fix the problem
*ATM needs to be removed
sem (OUT -> s_branch_g s_branch_d) ///
, method(ml) latent(OUT) standardized 
estat gof, stats(all)
estat mindices

*Measurement model for ease
sem (EASE -> s_location s_min_c s_min_s s_min_c_m s_min_s_m s_docs_s s_docs_c s_location_l s_min_cl s_min_mo s_day_cl s_day_mo) ///
, method(ml) latent(EASE) standardized
estat gof, stats(all)
estat mindices
*Improving the model by adding covariances
sem (EASE -> s_location s_min_c s_min_s s_min_c_m s_min_s_m s_docs_s s_docs_c s_location_l s_min_cl s_min_mo s_day_cl s_day_mo) ///
, method(ml) latent(EASE) standardized cov(e.s_docs_s*e.s_docs_c) cov(e.s_min_c_m*e.s_min_cl)
estat gof, stats(all)
estat mindices


*Measurement model for cost
sem (COST -> s_fee_c s_fee_s s_fee_cl s_fee_mo s_fee_t s_fee_atm), method(ml) latent(COST) standardized
estat gof, stats(all)
estat mindices
*Improving the model by adding covariances

*******************************************************************************************
*DATA Arora (2010) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
*******************************************************************************************
*>>>>>>>>>>>>>>>>>>>> SAVE DATA<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
save FAI.dta, replace

*******************************************************************************************
*Comparison Park and Mercado (2015) versus Arora (2010)   <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
*******************************************************************************************
*Take average values from 2004-2016 for Park and Mercado (2015)
*Arora (2010) is based on 2007 data

*******************************************************************************************
*>>>>>Work on Park and Mercado (2015)
*******************************************************************************************
use FII.dta, clear

sort code year
sort code
by code: egen FII_average=mean(FII)
label var FII_average "Park and Mercado (2015) averaged from 2005 to 2016"

*Focus on 2007 to compare with Arora (2010)
drop if year!=2007

*Focus on key variables
keep name code FII FII_average F_USE F_ACCESS

*Remove missing data
*Focus on average to avoid data loss
drop if FII_average==.
drop FII
rename FII_average FII

*Save data for merging
*Sort data based on country name
*To match other data, a rename is needed
rename name country 

*Problem with string matching
gen count=_n
sort count
save DATA_FOR_MERGE.dta, replace

*******************************************************************************************
*>>>>>Work on Arora (2010)
*******************************************************************************************
use FAI.dta, clear

*Focus on key variables
keep country Outreach Ease Cost FAI FAI_II F_OUT F_EASE F_COST 

*Remove missing data
*Focus on FAI_II to avoid data loss
drop if FAI_II==.

*Introduce count variable - see Excel file
sort country
merge using Code.dta
drop _merge
rename code count

*Merge with Park and Mercado (2015) data
sort count
merge count using DATA_FOR_MERGE.dta

drop if _merge!=3
drop _merge

*Are the indices constructed by Arora (2010) and Park and Mercado (2015) in agreement?
corr FAI FAI_II FII
spearman FAI FAI_II FII
ktau FAI FAI_II FII

*TABLE: Correlation between indices

*Insights from CFA factors
*Determine quintile based on scores
global var "FAI_II FII F_OUT F_EASE F_COST F_USE F_ACCESS"
	foreach y of global var {
		xtile Q_`y'=`y', n(5)
		}
sort FII	
br country FII FAI_II Q_*

*TABLE: Insights from CFA
