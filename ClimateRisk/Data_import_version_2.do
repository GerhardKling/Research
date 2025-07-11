*********************************************************
*DATA IMPORT
*********************************************************
*VERSION 2
**Additional data are imported see README.txt for details
**Merged data saved as DATA_FINAL.dta


*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\SOAS\CoC\DATA\"

use FINAL_COC_DATA.dta, clear

*********************************************************
*CONSTRUCTION OF VARIABLES
*********************************************************
*Corporate cash holding
gen CA_TA=CASH/TA
label var CA_TA "Corporate cash holding defined as cash relative to total assets"
*Zero a lower bound
replace CA_TA=0 if CA_TA<0 & CA_TA!=.

*Proxy for interest rates
gen COD=-INTER/DEBT if INTER<0 & DEBT>0
label var COD "Cost of debt"

*Average values for firms
sort CODE YEAR
by CODE: egen COD_FA=mean(COD)
label var COD_FA "Cost of debt, firm average over time"

*Leverage
gen LEV=DEBT/TA if DEBT>0 & TA>0
replace LEV=0 if LEV==. & DEBT!=. & TA!=.
label var LEV "Financial leverage defined as debt to total assets"

*Working capital
gen WC=(TCA-TCL)/TA if TA>0
replace WC=0 if WC==. & TA!=. & TCA!=. & TCL!=.
label var WC "Working capital to total assets"

*Interest coverage
gen EBIT=INC_BT+INTER
label var EBIT "Earnings before interest and taxes"
gen COVER=-EBIT/INTER if EBIT>0 & INTER<0
replace COVER=0 if COVER==1 & INTER!=. & EBIT!=.
label var COVER "Interest coverage defined as EBIT relative to interest expenses"


*********************************************************
*EXPOSURE TO CLIMATE RISK
*********************************************************
*Country with medium climate vulnerability
egen p75=pctile(R_VUL), p(75)

gen MEDIUM=1 if R_VUL>=p75 & R_VUL!=.
replace MEDIUM=0 if MEDIUM==. & R_VUL!=.
drop p75
label var MEDIUM "Dummy for countries with medium climate vulnerability, top 25%"

*Country with high climate vulnerability
egen p90=pctile(R_VUL), p(90)

gen HIGH=1 if R_VUL>=p90 & R_VUL!=.
replace HIGH=0 if HIGH==. & R_VUL!=.
drop p90
label var HIGH "Dummy for countries with high climate vulnerability, top 10%"

*======================>>>>>>>>>>>>>>>>>>  DECOMPOSITION OF COD  <<<<<<<<<<<<<<<
*Decomposition based on Rhodes-Kropf et al.(2005)
*(A) obtain \alpha_{jt}: coefficient for year and country
*Country slit or hgih versus low risk country

*Remove small countries
*84 countries with at least 1,000 observations
sort COUNTRY
by COUNTRY: gen count=_n
by COUNTRY: egen MAX=max(count)
drop if MAX<1000
drop count MAX

*Country codes in numeric format
encode COUNTRY, gen(FF)
label var FF "Country codes in numeric format"

gen alpha=.
label var alpha "Country and year constant term"
gen beta=.
label var beta "Country and year slope coefficient for debt"

*Log interest expense
gen m=ln(-INTER) if INTER<0
label var m "Temp variable for log interest expenses"

*Log debt
gen b=ln(DEBT) if DEBT>0
label var b "Temp variable for log debt"

*Year temp variable
gen year=YEAR
label var year "Year temp variable"

*High versus low risk countries
//drop FF
//gen FF=1 if MEDIUM==0
//replace FF=2 if MEDIUM==1

forvalues i=1/84 {
	forvalues t=1995/2016 {
		qui: {
		capture {
		reg m b if FF==`i' & year==`t'
		matrix b=get(_b)
		*a refers to slope coefficient
		matrix a=b[1,1]
		svmat a, n(a)
		replace a1=a1[_n-1] if a1==.
		*c refers to constant term
		matrix c=b[1,2]
		svmat c, n(c) 
		replace c1=c1[_n-1] if c1==.
		*Replace coefficients
		replace alpha=c1 if FF==`i' & year==`t'
		replace beta=a1 if FF==`i' & year==`t'
		matrix drop b a c
		drop a1 c1
		}
		}
		}
	}	

*(B) obtain \alpha_{j}: coefficient for country; long run averages
gen alpha_l=.
label var alpha_l "Country constant term; long run averages"
gen beta_l=.
label var beta_l "Country slope coefficient for log debt; long run averages"

forvalues i=1/84 {
	qui: {
	capture {
	reg m b if FF==`i' 
	matrix b=get(_b)
	*a refers to slope coefficient
	matrix a=b[1,1]
	svmat a, n(a)
	replace a1=a1[_n-1] if a1==.
	*c refers to constant term
	matrix c=b[1,2]
	svmat c, n(c) 
	replace c1=c1[_n-1] if c1==.
	*Replace coefficients
	replace alpha_l=c1 if FF==`i'
	replace beta_l=a1 if FF==`i' 
	matrix drop b a c
	drop a1 c1
	}
	}
	}

*Firm, country and long-run
gen FIRM_COMP=m-alpha-beta*b
label var FIRM_COMP "Firm-specific log interest expenses"
gen COUNTRY_COMP=(alpha+beta*b)-(alpha_l+beta_l*b)
label var COUNTRY_COMP "Country-specific log interest expenses"
gen LONGRUN_COMP=alpha_l+beta_l*b-b
label var LONGRUN_COMP "Long-run component in log interest expenses"

*Drop temp variables
*drop year m b

*********************************************************
*WINSORIZATION
*********************************************************
*Issues with outliers

global var "COD COD_FA LEV WC COVER"
foreach y of global var {
	egen p5=pctile(`y'), p(5)
	egen p95=pctile(`y'), p(95)
	replace `y'=p5 if `y'<p5 & `y'!=.
	replace `y'=p95 if `y'>p95 & `y'!=.
	drop p5 p95
	}


*===============================================================================
*SAVE INTERIM DATA
*===============================================================================	
save INTERIM.dta, replace

*
*
*
*START FROM HERE: INTERIM to FINAL_DATA
*
*
*
*===============================================================================
*ADDITIONAL MACRO DATA
*===============================================================================	
*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\SOAS\CoC\DATA\"
use INTERIM.dta, clear

*********************************************************
*IMPORT DATA FROM WORLD DEVELOPMENT INDICATORS
*********************************************************
*Adjust country names in master data to match World Development Indicators
replace COUNTRY="China" if COUNTRY=="China (Mainland)"
replace COUNTRY="Egypt, Arab Rep." if COUNTRY=="Egypt"
replace COUNTRY="North Macedonia" if COUNTRY=="Macedonia (the former Yugoslav Republic of)"
replace COUNTRY="Russian Federation" if COUNTRY=="Russia"
replace COUNTRY="Slovak Republic" if COUNTRY=="Slovakia"

*Drop unmatched countries
drop if COUNTRY=="Guernsey"
drop if COUNTRY=="Jersey"
drop if COUNTRY=="Palestinian Territories"
drop if COUNTRY=="Taiwan"

*Import data from csv
*Change to folder
cd "C:\Users\User\Documents\Gerhard\SOAS\CoC\DATA_MACRO\"

*Save master data in folder
save INTERIM2.dta, replace

*GDP
insheet using GDP.csv, clear
*Remove first row
gen n=_n
drop if n==1
drop n
rename v1 COUNTRY
label var COUNTRY "Home country of firm"
expand 25
sort COUNTRY
gen y=.
by COUNTRY: gen YEAR=_n
forvalues i=2/26 {
	replace y=v`i' if YEAR==`i'-1
	drop v`i'
	}
rename y GDP
label var GDP "GDP per capita in constant 2010 USD, WDI"
replace YEAR=YEAR+1992	
label var YEAR "Year from 1993 to 2017"
sort COUNTRY YEAR
order COUNTRY YEAR

save GDP.dta, replace

*GOV
insheet using GOV.csv, clear
*Remove first row
gen n=_n
drop if n==1
drop n
rename v1 COUNTRY
label var COUNTRY "Home country of firm"
expand 25
sort COUNTRY
gen y=.
by COUNTRY: gen YEAR=_n
forvalues i=2/26 {
	replace y=v`i' if YEAR==`i'-1
	drop v`i'
	}
rename y GOV
label var GOV "Quality of governance, WDI"
replace YEAR=YEAR+1992	
label var YEAR "Year from 1993 to 2017"
sort COUNTRY YEAR
order COUNTRY YEAR

save GOV.dta, replace

*Growth
insheet using Growth.csv, clear
*Remove first row
gen n=_n
drop if n==1
drop n
rename v1 COUNTRY
label var COUNTRY "Home country of firm"
expand 25
sort COUNTRY
gen y=.
by COUNTRY: gen YEAR=_n
forvalues i=2/26 {
	replace y=v`i' if YEAR==`i'-1
	drop v`i'
	}
rename y Growth
label var Growth "Annual GDP per capita growth rate, WDI"
replace YEAR=YEAR+1992	
label var YEAR "Year from 1993 to 2017"
sort COUNTRY YEAR
order COUNTRY YEAR

save Growth.dta, replace

*POP
insheet using POP.csv, clear
*Remove first row
gen n=_n
drop if n==1
drop n
rename v1 COUNTRY
label var COUNTRY "Home country of firm"
expand 25
sort COUNTRY
gen y=.
by COUNTRY: gen YEAR=_n
forvalues i=2/26 {
	replace y=v`i' if YEAR==`i'-1
	drop v`i'
	}
rename y POP
label var POP "Population density, WDI"
replace YEAR=YEAR+1992	
label var YEAR "Year from 1993 to 2017"
sort COUNTRY YEAR
order COUNTRY YEAR

save POP.dta, replace

*LAW
insheet using LAW.csv, clear
*Remove first row
gen n=_n
drop if n==1
drop n
rename v1 COUNTRY
label var COUNTRY "Home country of firm"
expand 25
sort COUNTRY
gen y=.
by COUNTRY: gen YEAR=_n
forvalues i=2/26 {
	replace y=v`i' if YEAR==`i'-1
	drop v`i'
	}
rename y LAW
label var LAW "Rule of law, World Governance Indicators"
replace YEAR=YEAR+1995
label var YEAR "Year from 1993 to 2017"
sort COUNTRY YEAR
order COUNTRY YEAR

save LAW.dta, replace

*********************************************************
*MERGE CSV FILES
*********************************************************
use INTERIM2.dta, clear
sort COUNTRY YEAR

merge COUNTRY YEAR using GDP.dta
drop _merge
sort COUNTRY YEAR

merge COUNTRY YEAR using GOV.dta
drop _merge
sort COUNTRY YEAR

merge COUNTRY YEAR using Growth.dta
drop _merge
sort COUNTRY YEAR

merge COUNTRY YEAR using POP.dta
drop _merge
sort COUNTRY YEAR

merge COUNTRY YEAR using LAW.dta
drop _merge
sort COUNTRY YEAR

drop if CODE==.
sort CODE YEAR


*===============================================================================
*COUNYRY CODES
*===============================================================================
*Define country codes - see Excel file on country matching in DATA_MACRO
*Used for country betas
gen COUNTRY_CODE=.
label var COUNTRY_CODE "Code for country"

encode COUNTRY, gen(NEW)
replace COUNTRY_CODE=NEW-1+1
drop NEW

*===============================================================================
*SAVE FINAL DATA
*===============================================================================	
*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\SOAS\CoC\DATA_FINAL\"
save DATA_FINAL.dta, replace


*===============================================================================
*ADDITIONAL MACRO DATA
*===============================================================================	
*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\SOAS\CoC\DATA_INDEX\"

*Convert country files with stock index data
*Convert date format and sort
forvalues i=1/80 {
capture {
	insheet using `i'.csv, clear
	gen DATE = date(timestamp, "DMY", 2018)
	format DATE %td
	drop timestamp
	rename x INDEX_`i'
	sort DATE
	save `i'.dta, replace
	}
	}

*Merge all indices
use 1.dta, clear
sort DATE
forvalues i=2/80 {
capture {
	merge DATE using `i'.dta
	drop _merge
	sort DATE
	}
	}

order DATE

*Time dimension 
gen t=_n
sort t

*Drop missing variables
drop if DATE==.	
	
*Match closest dates
*Lead
global var "4 59"
foreach y of global var {
	gen R=INDEX_`y'[_n+1]
	replace INDEX_`y'=R
	drop R
	}

*Lag	
global var "21 32 39 52 58 61"
foreach y of global var {
	gen R=INDEX_`y'[_n-1]
	replace INDEX_`y'=R
	drop R
	}	

global var "61"
foreach y of global var {
	gen R=INDEX_`y'[_n-1]
	replace INDEX_`y'=R
	drop R
	}		

*From t>=3350	
global var "4"
foreach y of global var {
	gen R=INDEX_`y'[_n-2]
	replace INDEX_`y'=R if t>3350
	drop R
	}	

*From t>=3526	
global var "61"
foreach y of global var {
	gen R=INDEX_`y'[_n+1]
	replace INDEX_`y'=R if t>=3526
	drop R
	}		
	
*From t>=869 to t<=2062	
global var "61"
foreach y of global var {
	gen R=INDEX_`y'[_n+1]
	replace INDEX_`y'=R if t>=869 & t<=2062
	drop R
	}			
	
*From t>=3658
global var "59"
foreach y of global var {
	gen R=INDEX_`y'[_n-1]
	replace INDEX_`y'=R if t>=3658
	drop R
	}				

*US is leading index
*Drop if missing
drop if INDEX_78==.	
drop t

*Year variable for matching	
gen YEAR=year(DATE)
sort DATE

*Create log returns
forvalues i=1/80 {
capture {
	gen R_`i'=ln(INDEX_`i')-ln(INDEX_`i'[_n-1])
	drop INDEX_`i'
	}
	}

*Country betas	
*Create log returns
*CAREFUL WITH CAPTURE IN DOUBLE LOOPS
forvalues i=1/80 {
capture {
	forvalues t=1993/2017 {
		capture {
		reg R_`i' R_78 if YEAR==`t'
		matrix B=get(_b)
		matrix C=B[1,1]
		svmat C, n(C)
		rename C1 BETA_`i'_`t'
		}
		}
	}
	}
drop R*
drop YEAR DATE
drop if BETA_1_1993==.

*Obtain country betas for different years
expand 25

*80 countries
expand 80
gen t=_n

*Country code
gen COUNTRY_CODE=.
forvalues i=1/80 {
	replace COUNTRY_CODE=`i' if t<=25*`i' & COUNTRY_CODE==.
	}

sort COUNTRY_CODE
by COUNTRY_CODE: gen YEAR=_n+1992	
drop t

gen BETA=.
forvalues i=1/80 {
capture {
	forvalues t=1993/2017 {
		capture {
		replace BETA=BETA_`i'_`t' if BETA==. & COUNTRY_CODE==`i' & YEAR==`t'
		}
		}
	}
	}
drop BETA_*
sort COUNTRY_CODE YEAR

*===============================================================================
*SAVE COUNRTY BETAS
*===============================================================================	
*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\SOAS\CoC\DATA_FINAL\"
save COUNTRY_BETAS.dta, replace

*Merge date
use DATA_FINAL.dta, clear
sort COUNTRY_CODE YEAR
merge COUNTRY_CODE YEAR using COUNTRY_BETAS.dta
drop _merge

*Add labels and sort
sort CODE YEAR

label var BETA "Country beta"

*===============================================================================
*SAVE MERGED DATA
*===============================================================================
save DATA_FINAL.dta, replace


*===============================================================================
*ADDITIONAL DATA ON MRP, RATING AND SPREAD
*===============================================================================	
*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\SOAS\CoC\DATA_MRP\"

*MRP
insheet using MRP.csv, clear
rename country_code COUNTRY_CODE
drop finalcountries 
expand 17
sort COUNTRY_CODE
gen y=.
by COUNTRY_CODE: gen YEAR=_n
forvalues i=3/19 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y MRP
label var MRP "Market risk premium, Aswath Damodaran"
replace YEAR=YEAR+2000
label var YEAR "Year from 1993 to 2017"
sort COUNTRY_CODE YEAR
order COUNTRY_CODE YEAR

save MRP.dta, replace

*RATING
insheet using RATING.csv, clear
rename country_code COUNTRY_CODE
drop finalcountries 
expand 17
sort COUNTRY_CODE
gen y=""
by COUNTRY_CODE: gen YEAR=_n
forvalues i=3/19 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y RATING
label var RATING "Moody's country rating, Aswath Damodaran"
replace YEAR=YEAR+2000
label var YEAR "Year from 1993 to 2017"
sort COUNTRY_CODE YEAR
order COUNTRY_CODE YEAR

save RATING.dta, replace

*SPREAD
insheet using SPREAD.csv, clear
rename country_code COUNTRY_CODE
drop finalcountries 
expand 17
sort COUNTRY_CODE
gen y=.
by COUNTRY_CODE: gen YEAR=_n
forvalues i=3/19 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
replace y=y/100
rename y SPREAD
label var SPREAD "Default spread of country, Aswath Damodaran"
replace YEAR=YEAR+2000
label var YEAR "Year from 1993 to 2017"
sort COUNTRY_CODE YEAR
order COUNTRY_CODE YEAR

save SPREAD.dta, replace

*===============================================================================
*MERGE DATA
*===============================================================================	
*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\SOAS\CoC\DATA_FINAL\"
use DATA_FINAL.dta, clear

sort COUNTRY_CODE YEAR


*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\SOAS\CoC\DATA_MRP\"

merge COUNTRY_CODE YEAR using MRP.dta
drop _merge
sort COUNTRY_CODE YEAR

merge COUNTRY_CODE YEAR using RATING.dta
drop _merge
sort COUNTRY_CODE YEAR

merge COUNTRY_CODE YEAR using SPREAD.dta
drop _merge
sort COUNTRY_CODE YEAR

sort CODE YEAR

*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\SOAS\CoC\DATA_FINAL\"
save DATA_FINAL.dta, replace


