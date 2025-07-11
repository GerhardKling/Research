*********************************************************
*EMPIRICAL ANALYSIS
*********************************************************

*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
*GK home office
cd "C:\Users\User\Documents\Gerhard\NEW\CoC_resubmission\Data"


*===============================================================================
*ISSUE I: Measurement of climate vulnerability
*===============================================================================
*********************************************************
*Raw data for indicators based on GAIN
*********************************************************
global var "vulnerability id_ecos_01 id_ecos_02 id_ecos_04 id_ecos_05 id_ecos_06 id_food_01 id_food_02 id_food_03 id_habi_01 id_habi_02 id_heal_01 id_heal_02 id_infr_01 id_infr_02 id_infr_03 id_infr_04 id_wate_01 id_wate_02 id_wate_03 id_wate_04"
foreach y of global var {
	insheet using `y'.csv, clear
	*Remove first line
	gen n=_n
	drop if n==1
	drop n
	rename v1 ISO3
	label var ISO3 "ISO 3 country code"
	rename v2 COUNTRY
	label var COUNTRY "Home country of firm"
	expand 23
	sort ISO3
	gen x=.
	by ISO3: gen count=_n
	*Order differs as v3 refers to 1995
	forvalues i=3/25 {
		replace x=v`i' if count==`i'-2
		drop v`i'
		}
	gen YEAR=1994+count	
	label var YEAR "Year from 1993 to 2017"	
	rename x `y'
	order COUNTRY YEAR
	drop count

	*Country name changes
	replace COUNTRY="Bolivia" if COUNTRY=="Bolivia, Plurinational State of"
	replace COUNTRY="China (Mainland)" if COUNTRY=="China"
	replace COUNTRY="Macedonia (the former Yugoslav Republic of)" if COUNTRY=="Macedonia"
	replace COUNTRY="Russia" if COUNTRY=="Russian Federation"
	replace COUNTRY="South Korea" if COUNTRY=="Korea, Republic of"
	replace COUNTRY="Syria" if COUNTRY=="Syrian Arab Republic"
	replace COUNTRY="Tanzania" if COUNTRY=="Tanzania, United Republic of"
	replace COUNTRY="Venezuela" if COUNTRY=="Venezuela, Bolivarian Republic o"
	replace COUNTRY="Vietnam" if COUNTRY=="Viet Nam"
	sort COUNTRY YEAR
	save `y'.dta, replace
	}
	
*******************************************************************
*Raw data for rainfall and temperature provided by the World Bank
*******************************************************************
*These must be exogenous by construction
*Monthly data 1991 to 2016
*Match data using ISO3, i.e. country code with three letters

*Rainfall
insheet using Rainfall.csv, clear	
rename rainfallmm RAIN
rename year YEAR
rename iso3 ISO3
drop v6 country statistics
sort ISO3 YEAR
by ISO3 YEAR: gen COUNT=_n
by ISO3 YEAR: egen M_RAIN=mean(RAIN)
by ISO3 YEAR: egen SD_RAIN=sd(RAIN)
drop if COUNT!=1
*Excess rain or temperature compared to 1991-2000
sort ISO3
by ISO3: egen MEAN=mean(RAIN) if YEAR<2001
by ISO3: egen MAX=max(MEAN)
drop MEAN
rename MAX MEAN
gen EX_RAIN=M_RAIN-MEAN 
label var EX_RAIN "Excess rain compared to 1991-2000"
drop COUNT RAIN MEAN
label var M_RAIN "Average monthly rainfall, World Bank"
label var SD_RAIN "Standard deviation of monthly rainfall, World Bank"
sort ISO3 YEAR
save RAIN.dta, replace
	
*Temperature
insheet using Temperature.csv, clear	
rename temperaturecelsius TEMP
rename year YEAR
rename iso3 ISO3
drop v6 country statistics
sort ISO3 YEAR
by ISO3 YEAR: gen COUNT=_n
by ISO3 YEAR: egen M_TEMP=mean(TEMP)
by ISO3 YEAR: egen SD_TEMP=sd(TEMP)
drop if COUNT!=1
*Excess rain or temperature compared to 1991-2000
sort ISO3
by ISO3: egen MEAN=mean(TEMP) if YEAR<2001
by ISO3: egen MAX=max(MEAN)
drop MEAN
rename MAX MEAN
gen EX_TEMP=M_TEMP-MEAN 
label var EX_TEMP "Excess temperature compared to 1991-2000"
drop COUNT TEMP MEAN
label var M_TEMP "Average monthly temperature, World Bank"
label var SD_TEMP "Standard deviation of monthly temperature, World Bank"
sort ISO3 YEAR
save TEMP.dta, replace



*********************************************************
*MERGE DATA
*********************************************************
use DATA_FINAL.dta, clear
global var "vulnerability id_ecos_01 id_ecos_02 id_ecos_04 id_ecos_05 id_ecos_06 id_food_01 id_food_02 id_food_03 id_habi_01 id_habi_02 id_heal_01 id_heal_02 id_infr_01 id_infr_02 id_infr_03 id_infr_04 id_wate_01 id_wate_02 id_wate_03 id_wate_04"
foreach y of global var {
	sort COUNTRY YEAR
	merge COUNTRY YEAR using `y'.dta
	drop _merge
	sort COUNTRY YEAR	
	}

rename vulnerability VUL
label var VUL "Vulnerability sub-index GAIN updated"

*Rainfall data
sort ISO3 YEAR
merge ISO3 YEAR using RAIN.dta
drop _merge
	
*Temperature data
sort ISO3 YEAR
merge ISO3 YEAR using TEMP.dta
drop _merge	
	
*********************************************************
*CREATE NEW INDEX
*********************************************************
*New index should be less related to economic conditions
egen N_VUL = rowmean(id_*)
label var N_VUL "Vulnerability index created from raw data; excludes indictors with high correlation with GDP per capita"

*Drop all indicators
drop id_*


*********************************************************
*RESTRICT SAMPLE TO REGRESSION MODEL: LISTWISE DELETION
*********************************************************
qui: reg COD N_VUL LEV WC COVER SIZE DIV TANG ROA IND_RISK VOL GDP GROWTH POP LAW
predict r, res
drop if r==.
drop r

*********************************************************
*RESTRICT SAMPLE: REMOVE FINANCIAL SERVICES
*********************************************************
drop if GICS2==40



*Panel defined
tsset CODE YEAR


*********************************************************
*ANALYSIS OF CORRELATIONS
*********************************************************
corr VUL N_VUL GDP


*********************************************************
*ENDOGENEITY TESTS
*********************************************************
*The following is based on Section 11.2 in Wooldridge, MIT Press, 2010, 2nd edition

*==========>>>>>>>> TESTING VUL: ORIGINAL VARIABLE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
*Start with model COD VUL LEV WC COVER SIZE DIV TANG ROA
xtreg COD VUL LEV WC COVER SIZE DIV TANG ROA, re vce(cluster CODE)
*Add N_VUL as additional instrument so that L>M, where M is the number of explanatory variables in the first equation
*Run the following regression
reg VUL WC COVER SIZE DIV TANG ROA N_VUL
estimates store R1
*Predict residual and include in fixed-effects specification
predict VUL_hat, resid
xtreg COD VUL VUL_hat LEV WC COVER SIZE DIV TANG ROA, re vce(cluster CODE)
estimates store R2
drop VUL_hat
*We reject the null that coefficient of VUL_hat=0; hence, VUL is endogenous


*==========>>>>>>>> TESTING N_VUL: NEWLY CONSTRUCTED VARIABLE <<<<<<<<<<<<<<<<<<
*Run the following regression
reg N_VUL WC COVER SIZE DIV TANG ROA M_RAIN SD_RAIN M_TEMP SD_TEMP
estimates store R3
*Predict residual and include in fixed-effects specification
predict N_VUL_hat, resid
xtreg COD N_VUL N_VUL_hat LEV WC COVER SIZE DIV TANG ROA, re vce(cluster CODE)
estimates store R4
drop N_VUL_hat
*We do not reject the null that coefficient of N_VUL_hat=0; hence, N_VUL is exogenous

*Can N_VUL be explained by rainfall and temperature data?
reg N_VUL M_RAIN SD_RAIN M_TEMP SD_TEMP

*==========>>>>>>>> TABLE 4 for endogeneity tests <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
esttab R1 R2 R3 R4 using Table4.rtf, ///
keep(VUL VUL_hat N_VUL N_VUL_hat LEV WC COVER SIZE DIV TANG ROA M_RAIN SD_RAIN M_TEMP SD_TEMP) ///
order(VUL VUL_hat N_VUL N_VUL_hat LEV WC COVER SIZE DIV TANG ROA M_RAIN SD_RAIN M_TEMP SD_TEMP) ///
rtf scalars(r2_a r2_w r2_b r2_o) b(%9.3f) not ///
title(Endogeneity tests) replace compress nogap ///
alignment(ll) ///
mtitles([R1] [R2] [R3] [R4]) nonumbers obslast ///
addnote("Note: All models refer to firm-level random effects with clustered standard errors.")	
*==========>>>>>>>> TABLE 4 for endogeneity tests <<<<<<<<<<<<<<<<<<<<<<<<<<<<<



*===============================================================================
*ISSUE II: The impact of the Asian crisis in 1997 the Global Financial Crisis
*===============================================================================
*Year dummies were used in original paper
*Run a regression with year dummies
*Plot residuals, i.e. adjusted cost of debt for time effects

*=====================>>>>>>>>> FIGURE 1 <<<<<<<<<<<<===========================
*Figure 1: compare cost of debt
*High versus low climate vulnerability
*The construction of COD_HIGH_RISK COD_LOW_RISK LOW_RISK HIGH_RISK TIME needs to be redone from Version 1
drop COD_HIGH_RISK COD_LOW_RISK LOW_RISK HIGH_RISK TIME

*Reason is that we restrict the sample in Version 2 to observations used in regression models
*Hence, listwise deletion is applied

*Account for year dummies
xi: reg COD i.YEAR
predict COD_res, res
*F-test
test _IYEAR_2001 _IYEAR_2003 _IYEAR_2005 _IYEAR_2006 _IYEAR_2007 ///
_IYEAR_2008 _IYEAR_2009 _IYEAR_2010 _IYEAR_2011 _IYEAR_2012 _IYEAR_2013 ///
_IYEAR_2014 _IYEAR_2015 _IYEAR_2016 _IYEAR_2017


*Use collapse command instead
gen LOW_RISK=COD_res if MEDIUM==0
gen HIGH_RISK=COD_res if MEDIUM==1

drop COD_res

*Preserve data
preserve

collapse (mean) LOW_RISK HIGH_RISK, by(YEAR)
drop if YEAR==2017
twoway (line LOW_RISK YEAR) (line HIGH_RISK YEAR), xtitle(Year) ///
ytitle(Year adjusted cost of debt) graphregion(style(none) color(white))
graph export Figure1.png, replace

*Restore data
restore

*Drop variables no longer needed
drop LOW_RISK HIGH_RISK
*=====================>>>>>>>>> FIGURE 1 <<<<<<<<<<<<===========================

save INTERIM.dta, replace


*===============================================================================
*EMPIRICAL ANALYSIS
*===============================================================================
use INTERIM.dta, clear

*=====================>>>>>>>>> TABLE 1 <<<<<<<<<<<<============================
*Cost of debt and key explanatory variables
asdoc sum COD LEV WC COVER, stat(N mean sd min p25 p50 p75 max) ///
by(MEDIUM) save(Table1.rtf) replace format(%9.3f)

*=====================>>>>>>>>> TABLE 1 <<<<<<<<<<<<============================


*=====================>>>>>>>>> TABLE 2 <<<<<<<<<<<<============================
*Descriptive statistics
asdoc sum COD ///
COE COED BETA MRP ///
VUL N_VUL M_RAIN SD_RAIN M_TEMP SD_TEMP ///
LEV WC COVER SIZE DIV TANG ROA ///
IND_RISK VOL ///
GDP GROWTH POP LAW ///
, stat(N mean sd min p25 p50 p75 max) ///
save(Table2.rtf) replace format(%9.2f)

*=====================>>>>>>>>> TABLE 2 <<<<<<<<<<<<============================


*=====================>>>>>>>>> TABLE 3 <<<<<<<<<<<<============================
*List of measures used to construct the climate vulnerability index
*=====================>>>>>>>>> TABLE 3 <<<<<<<<<<<<============================


*=====================>>>>>>>>> TABLE 4 <<<<<<<<<<<<============================
*Constructed above - see line 236 to 245 - in response to reviewers' comments
*=====================>>>>>>>>> TABLE 4 <<<<<<<<<<<<============================


*===============================================================================
*ANALYSIS OF COST OF COST OF DEBT
*===============================================================================
*Panel defined
tsset CODE YEAR

*Instrumental variable approach
qui:{
*Base estimate
xi: xtivreg COD i.COUNTRY i.YEAR (VUL = N_VUL), re vce(conventional)
estimates store A1
*Firm controls: remove CASH and R_D as they have low obs.
xi: xtivreg COD WC COVER SIZE DIV TANG ROA i.COUNTRY i.YEAR (VUL = N_VUL), re vce(conventional)
estimates store A2
*Industry effects
xi: xtivreg COD WC COVER SIZE DIV TANG ROA IND_RISK VOL i.COUNTRY i.YEAR (VUL = N_VUL), re vce(conventional)
estimates store A3
*Country controls
xi: xtivreg COD WC COVER SIZE DIV TANG ROA IND_RISK VOL GDP GROWTH POP LAW i.COUNTRY i.YEAR (VUL = N_VUL), re vce(conventional)
estimates store A4
xi: xtivreg COD LEV WC COVER SIZE DIV TANG ROA IND_RISK VOL GDP GROWTH POP LAW i.COUNTRY i.YEAR (VUL = N_VUL), re vce(conventional)
estimates store A5
}

estimates table A1 A2 A3 A4 A5, star stats(N r2_o r2_b r2_w) b(%9.3f) ///
keep(VUL WC COVER SIZE DIV TANG ROA IND_RISK VOL GDP GROWTH POP LAW LEV)

*=====================>>>>>>>>> TABLE 5 <<<<<<<<<<<<============================
esttab A1 A2 A3 A4 A5 using Table5.rtf, ///
keep(VUL WC COVER SIZE DIV TANG ROA IND_RISK VOL GDP GROWTH POP LAW LEV) ///
order(VUL WC COVER SIZE DIV TANG ROA IND_RISK VOL GDP GROWTH POP LAW LEV) ///
rtf scalars(N r2_o r2_b r2_w) b(%9.3f) not ///
title(Determinants of cost of debt) replace compress nogap ///
alignment(lllll) ///
mtitles([A1] [A2] [A3] [A4] [A5]) nonumbers obslast 
*=====================>>>>>>>>> TABLE 5 <<<<<<<<<<<<============================



*===============================================================================
*ANALYSIS OF COST OF EQUITY
*===============================================================================
*Panel defined
tsset CODE YEAR

*Country level regressions
*Indicator
sort COUNTRY YEAR
by COUNTRY YEAR: gen IDENT=_n
label var IDENT "Dummy for country-year pair if equal to one"

*OLS regression with robust standard errors and year dummies
qui:{
*Country-level COE
xi: ivregress 2sls COE BETA MRP GDP GROWTH POP LAW i.YEAR (VUL = N_VUL) if IDENT==1, vce(robust)
estimates store B1
*Country betas
xi: ivregress 2sls BETA i.YEAR (VUL = N_VUL) if IDENT==1, vce(robust)
estimates store B2
*Market risk premiums
xi: ivregress 2sls MRP i.YEAR (VUL = N_VUL) if IDENT==1, vce(robust)
estimates store B3
*Firm level estimates: all controls
xi: xtivreg COED LEV WC COVER SIZE TANG ROA IND_RISK VOL GDP GROWTH POP LAW i.COUNTRY i.YEAR (VUL = N_VUL), re vce(conventional)
estimates store B4
}

estimates table B1 B2 B3 B4, star stats(N r2_a r2_o r2_b r2_w) b(%9.3f) ///
keep(VUL BETA MRP LEV WC COVER SIZE TANG ROA IND_RISK VOL GDP GROWTH POP LAW)

*=====================>>>>>>>>> TABLE 6 <<<<<<<<<<<<============================
esttab B1 B2 B3 B4 using Table6.rtf, ///
keep(VUL BETA MRP LEV WC COVER SIZE TANG ROA IND_RISK VOL GDP GROWTH POP LAW) ///
order(VUL BETA MRP LEV WC COVER SIZE TANG ROA IND_RISK VOL GDP GROWTH POP LAW) ///
rtf scalars(N r2_a r2_o r2_b r2_w) b(%9.3f) not ///
title(Determinants of cost of equity) replace compress nogap ///
alignment(cccc) ///
mtitles([B1] [B2] [B3] [B4]) nonumbers obslast 
*=====================>>>>>>>>> TABLE 6 <<<<<<<<<<<<============================




*===============================================================================
*STRUCTURAL EQUATION MODEL
*===============================================================================

*=============>>>>>>>>>>>>>>>>RUN MODELS TO FIND GOOD MODEL FIT<<<<<<<<<<<<<<<<<*
qui: xi: sem (COD <- VUL LEV WC COVER SIZE DIV TANG ROA IND_RISK VOL GDP GROWTH POP LAW) ///
(LAW <- GDP) (VUL <- GDP N_VUL) (LEV <- VUL COVER SIZE DIV TANG ROA GDP GROWTH POP LAW), ///
nocapslatent standardized
estat eqgof // R-squared
estat gof, stats(all) // Goodness of fit
estat mindices // Modification indices
eststo B1

*B1 with RMSEA of 0.108>0.1 and CFI of 0.943<0.95

*Highest modification index is population to explain GAIN-ND vulnerability index
qui: xi: sem (COD <- VUL LEV WC COVER SIZE DIV TANG ROA IND_RISK VOL GDP GROWTH POP LAW) ///
(LAW <- GDP) (VUL <- GDP N_VUL POP) (LEV <- VUL COVER SIZE DIV TANG ROA GDP GROWTH POP LAW), ///
nocapslatent standardized
estat eqgof // R-squared
estat gof, stats(all) // Goodness of fit
estat mindices // Modification indices
eststo B2

*B2 with RMSEA of 0.085<0.1 and CFI of 0.966>0.95

*Consider country and time effects
xi: sem (COD <- VUL LEV WC COVER SIZE DIV TANG ROA IND_RISK VOL GDP GROWTH POP LAW i.YEAR i.COUNTRY) ///
(LAW <- GDP) (VUL <- GDP N_VUL POP) (LEV <- VUL COVER SIZE DIV TANG ROA GDP GROWTH POP LAW), ///
nocapslatent standardized
eststo B3
estat teffects, standardized // Direct and indirect effects

*=====================>>>>>>>>> TABLE 7 <<<<<<<<<<<<============================
esttab B3 using Table7.rtf, b(%9.3f) not ///
star replace rtf keep(VUL N_VUL LEV WC COVER SIZE DIV TANG ROA IND_RISK VOL GDP GROWTH POP LAW) ///
order(VUL N_VUL LEV WC COVER SIZE DIV TANG ROA IND_RISK VOL GDP GROWTH POP LAW)
*=====================>>>>>>>>> TABLE 7 <<<<<<<<<<<<============================






