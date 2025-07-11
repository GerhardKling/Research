*********************************************************
*DATA IMPORT
*********************************************************
*VERSION 1
*GK
**Data import from csv files
**Rename files in line with variables names
**Remove first row in csv file
**Name columns as years
**Country and code as identifier
**v3 is 2017 and v27 is 1993
**DESCRIPTIVES contains information about business as string
**gross revenue does not have enough observations
**interest expense 2 and Interest Income - Operating refer to operating interest exp, which is not financial
**interestrevenue has too few observations
**leased assets has too few observations
**Produces final dataset merging all files: FINAL_COC_DATA.dta
**Adding industry codes

*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\Current\CoC\DATA\"


*********************************************************
*IMPORT CSV FILES
*********************************************************
*Total assets
insheet using TA.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y TA
label var TA "Total assets reported"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save TA.dta, replace


*Amortisation
insheet using amortisation.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y AMOR
label var AMOR "Amortisation"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save AMOR.dta, replace


*Cash holding
insheet using cashassets.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y CASH
label var CASH "Cash and cash equivalents"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save CASH.dta, replace


*COGS
insheet using COGS.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y COGS
label var COGS "Cost of goods sold"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save COGS.dta, replace


*Depreciation
insheet using depreciation.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y DEP
label var DEP "Depreciation"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save DEP.dta, replace


*Employees
insheet using EMPLOYEES.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y EMP
label var EMP "Number of employees"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save EMP.dta, replace


*Dividends
insheet using DIV.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y DIV
label var DIV "Dividends"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save DIV.dta, replace


*Gross profit
insheet using grossprofit.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y PROF
label var PROF "Gross profit"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save PROF.dta, replace


*Net intangibles
insheet using intangiblesnet.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y INTAN
label var INTAN "Net intangibles"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save INTAN.dta, replace


*Interest expense
insheet using interestexpense1.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y INTER
label var INTER "Interest expense"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save INTER.dta, replace


*Inventory
insheet using inventory.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y INV
label var INV "Inventory"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save INV.dta, replace


*Net income before taxes
insheet using netincomebeforetaxes.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y INC_BT
label var INC_BT "Net income before taxes"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save INC_BT.dta, replace


*Net sales
insheet using netsales.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y SALES
label var SALES "Net sales"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save SALES.dta, replace


*Net income after taxes
insheet using netincomeaftertaxes.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y INC_AT
label var INC_AT "Net income after tax"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save INC_AT.dta, replace


*Operating lease maturing within 1 year
insheet using operatingleasematuringwithin1year.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y OPL_1
label var OPL_1 "Operating lease maturing within 1 year"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save OPL_1.dta, replace


*Operating lease maturing within 5 year
insheet using operatingleasematuringwithin5years.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y OPL_5
label var OPL_5 "Operating lease maturing within 5 years"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save OPL_5.dta, replace


*Research & development
insheet using r_d.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y R_D
label var R_D "Research & development"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save R_D.dta, replace


*Receivables
insheet using receivables.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y REC
label var REC "Receivables"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save REC.dta, replace


*Rental expense
insheet using rentalexpense.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y RENT
label var RENT "Represents rental expenses paid for offices, factories, machinery and equipment"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save RENT.dta, replace


*Sales and marketing
insheet using salesandmarketing.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y SGA
label var SGA "Selling/General/Administrative Expense"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save SGA.dta, replace


*Tangible assets
insheet using tangibleassets.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y TANG
label var TANG "Tangible assets"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save TANG.dta, replace


*Total current assets
insheet using totalcurrentassets.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y TCA
label var TCA "Total current assets"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save TCA.dta, replace


*Total current liabilities
insheet using totalcurrentliabilities.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y TCL
label var TCL "Total current liabilities"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save TCL.dta, replace


*Total equity
insheet using totalequity.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y TE
label var TE "Total equity"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save TE.dta, replace


*Total liabilities
insheet using totalliabilities.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y TL
label var TL "Total liabilities"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save TL.dta, replace


*Total long term debt
insheet using totallongtermdept.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y DEBT
label var DEBT "Total long term debt"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save DEBT.dta, replace


*Total operating expense
insheet using totaloperatingexpense.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y EXP
label var EXP "Total operating expense"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save EXP.dta, replace


*Total operating leases
insheet using totaloperatingleases.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y OPL
label var OPL "Total operating leases"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save OPL.dta, replace


*Total revenue
insheet using totalrevenue.csv, clear
rename country COUNTRY
label var COUNTRY "Home country of firm"
rename code CODE
label var CODE "Firm identifier"

expand 25
sort CODE
gen y=.
by CODE: gen YEAR=_n
forvalues i=3/27 {
	replace y=v`i' if YEAR==`i'-2
	drop v`i'
	}
rename y REV
label var REV "Total revenue"
replace YEAR=2018-YEAR	
label var YEAR "Year from 1993 to 2017"
sort CODE YEAR
order CODE YEAR COUNTRY

save REV.dta, replace


*********************************************************
*MERGE CSV FILES
*********************************************************
use TA.dta, clear

merge CODE YEAR using AMOR.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using CASH.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using COGS.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using DEP.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using EMP.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using DIV.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using PROF.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using INTAN.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using INTER.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using INV.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using INC_BT.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using SALES.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using INC_AT.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using OPL_1.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using OPL_5.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using R_D.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using REC.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using RENT.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using SGA.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using TANG.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using TCA.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using TCL.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using TE.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using TL.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using DEBT.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using EXP.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using OPL.dta
drop _merge
sort CODE YEAR

merge CODE YEAR using REV.dta
drop _merge
sort CODE YEAR

save FINAL_COC_DATA.dta, replace

*Years outside range with no observations
drop if YEAR<1993

*********************************************************
*SAVE FINAL DATASET
*********************************************************
save FINAL_COC_DATA.dta, replace

*********************************************************
*ADD CLIMATE RISK DATA
*********************************************************
**22 years of data from 1995 to 2016
**Order differs as v3 refers to 1995 and v24 to 2016

*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\Current\CoC\DATA_RISK\"

*Vulnerability
insheet using vulnerability.csv, clear

*Remove first line
gen n=_n
drop if n==1
drop n
rename v1 ISO3
label var ISO3 "ISO 3 country code"
rename v2 COUNTRY
label var COUNTRY "Home country of firm"
expand 22
sort ISO3
gen y=.
by ISO3: gen count=_n
*Order differs as v3 refers to 1995
forvalues i=3/24 {
	replace y=v`i' if count==`i'-2
	drop v`i'
	}
gen YEAR=1994+count	
label var YEAR "Year from 1993 to 2017"	
rename y R_VUL
label var R_VUL "Vulnerability"
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
save R_VUL.dta, replace


*Sensitivity
insheet using sensitivity.csv, clear

*Remove first line
gen n=_n
drop if n==1
drop n
rename v1 ISO3
label var ISO3 "ISO 3 country code"
rename v2 COUNTRY
label var COUNTRY "Home country of firm"
expand 22
sort ISO3
gen y=.
by ISO3: gen count=_n
*Order differs as v3 refers to 1995
forvalues i=3/24 {
	replace y=v`i' if count==`i'-2
	drop v`i'
	}
gen YEAR=1994+count	
label var YEAR "Year from 1993 to 2017"	
rename y R_SEN
label var R_SEN "Sensitivity"
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
save R_SEN.dta, replace


*Readiness
insheet using readiness.csv, clear

*Remove first line
gen n=_n
drop if n==1
drop n
rename v1 ISO3
label var ISO3 "ISO 3 country code"
rename v2 COUNTRY
label var COUNTRY "Home country of firm"
expand 22
sort ISO3
gen y=.
by ISO3: gen count=_n
*Order differs as v3 refers to 1995
forvalues i=3/24 {
	replace y=v`i' if count==`i'-2
	drop v`i'
	}
gen YEAR=1994+count	
label var YEAR "Year from 1993 to 2017"	
rename y R_READ
label var R_READ "Readiness"
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
save R_READ.dta, replace


*Exposure
insheet using exposure.csv, clear

*Remove first line
gen n=_n
drop if n==1
drop n
rename v1 ISO3
label var ISO3 "ISO 3 country code"
rename v2 COUNTRY
label var COUNTRY "Home country of firm"
expand 22
sort ISO3
gen y=.
by ISO3: gen count=_n
*Order differs as v3 refers to 1995
forvalues i=3/24 {
	replace y=v`i' if count==`i'-2
	drop v`i'
	}
gen YEAR=1994+count	
label var YEAR "Year from 1993 to 2017"	
rename y R_EXP
label var R_EXP "Exposure"
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
save R_EXP.dta, replace


*Capacity
insheet using capacity.csv, clear

*Remove first line
gen n=_n
drop if n==1
drop n
rename v1 ISO3
label var ISO3 "ISO 3 country code"
rename v2 COUNTRY
label var COUNTRY "Home country of firm"
expand 22
sort ISO3
gen y=.
by ISO3: gen count=_n
*Order differs as v3 refers to 1995
forvalues i=3/24 {
	replace y=v`i' if count==`i'-2
	drop v`i'
	}
gen YEAR=1994+count	
label var YEAR "Year from 1993 to 2017"	
rename y R_CAP
label var R_CAP "Capacity"
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
save R_CAP.dta, replace


*********************************************************
*MERGE WITH MASTERFILE
*********************************************************
**Issues with matches:
*Bermuda: NO DATA
*British Virgin Islands: NO DATA
*Cayman Islands: NO DATA
*Guernsey: NO DATA
*Isle of Man: NO DATA
*Ivory Coast: NO DATA
*Jersey: NO DATA
*Palestinian Territories: NO DATA
*Puerto Rico: NO DATA
*Taiwan: NO DATA

*Bolivia: called Bolivia, Plurinational State of
*China (Mainland): called China
*Hong Kong: called China
*Macau: called China
*Macedonia (the former Yugoslav Republic of): called Macedonia
*Russia: called Russian Federation
*South Korea: called Korea, Republic of
*Syria: called Syrian Arab Republic
*Tanzania: called Tanzania, United Republic of
*Venezuela: called Venezuela, Bolivarian Republic o
*Vietnam: called Viet Nam

*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\Current\CoC\DATA\"

use FINAL_COC_DATA.dta, clear

*Country name changes to match data
replace COUNTRY="China (Mainland)" if COUNTRY=="Hong Kong"
replace COUNTRY="China (Mainland)" if COUNTRY=="Macau"
sort COUNTRY YEAR

*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\Current\CoC\DATA_RISK\"

merge COUNTRY YEAR using R_VUL.dta
drop _merge
sort COUNTRY YEAR

merge COUNTRY YEAR using R_SEN.dta
drop _merge
sort COUNTRY YEAR

merge COUNTRY YEAR using R_READ.dta
drop _merge
sort COUNTRY YEAR

merge COUNTRY YEAR using R_EXP.dta
drop _merge
sort COUNTRY YEAR

merge COUNTRY YEAR using R_CAP.dta
drop _merge
sort COUNTRY YEAR

*********************************************************
*CHANGE WORKING DIRECTORY
*********************************************************
cd "C:\Users\User\Documents\Gerhard\Current\CoC\DATA\"

*********************************************************
*SAVE FINAL DATA
*********************************************************
save FINAL_COC_DATA.dta, replace

*********************************************************
*ADDING INDUSTRY CODES
*********************************************************
*GICS codes: Global Industry Classification Standard
insheet using industrycode1.csv, clear

rename gicssectorcode GICS2 
rename gicsindustrygroupcode GICS4
rename gicsindustrycode GICS6 
rename gicssubindustrycode GICS8

label var GICS2 "Two digit GICS code"
label var GICS4 "Four digit GICS code"
label var GICS6 "Six digit GICS code"
label var GICS8 "Eight digit GICS code"

rename gicssubindustryname GICS2_NAME
rename gicsindustryname GICS4_NAME
rename gicsindustrygroupname GICS6_NAME
rename gicssectorname GICS8_NAME

label var GICS2_NAME "Names for two digit GICS code"
label var GICS4_NAME "Names for four digit GICS code"
label var GICS6_NAME "Names for six digit GICS code"
label var GICS8_NAME "Names for eight digit GICS code"

rename code CODE

sort CODE

save GICS.dta, replace

*********************************************************
*MERGE WITH FINAL DATA
*********************************************************
use FINAL_COC_DATA.dta, clear
sort CODE

merge CODE using GICS.dta
drop _merge

sort CODE YEAR

*********************************************************
*SAVE FINAL DATA
*********************************************************
save FINAL_COC_DATA.dta, replace

exit







