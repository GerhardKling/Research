README FILE
The data is related to the paper Kling, G., Volz, U., Murinde, V., Ayas, S. (2021) The impact of climate vulnerability on firms’ cost of capital and access to finance, 
World Development 137: 105131. https://doi.org/10.1016/j.worlddev.2020.105131.

Please cite this paper if you want to use the data or STATA do files for your research.

Data are compiled in three STATA do files. Please execute the do-file Data_import_version_1.do first. 
Please note that you must adjust the paths used for the change directory commands in the do file (see STATA command cd).

Raw data are stored in different folders:
1. DATA: refers to all firm-level data from Eikon; all files are csv files.

2. DATA_RISK: contains csv files for climate risk indices from ND-GAIN.

The STATA do file, Data_import_version_1.do, produces the STATA dataset FINAL_COC_DATA.dta.

Next, run the STATA do file Data_import_version_2.do. 
Please note that you must adjust the paths used for the change directory commands in the do file (see STATA command cd).
The do file starts with FINAL_COC_DATA.dta, defines variables and imports additional data. 
The file does conduct a Decomposition based on Rhodes-Kropf et al.(2005), which is not used in the final version of the paper.
This might be useful for future research.

For additional data input, raw data are stored in different folders:
3. DATA_MACRO: macroeconomic variables stored as csv files; World Development Indicators;
in this folder, the Excel file Matching countries.xlsx shows how countries are matched as strings do differ between datasets.

4. DATA_INDEX: the folder contains stock market index data for 79 countries from Eikon; all files are csv files.

5. DATA_MRP: the folder contains data on market risk premiums, ratings and spreads; based on Damodaran et al. (2013); all files are csv files.

REFERENCES
Damodaran, A. et al. (2013). Equity risk premiums (erp): Determinants, estimation and implications–the 2013 edition, 
Managing and Measuring Risk: Emerging Global Standards and Regulations After the Financial Crisis, 343–455.

The merged data is saved as DATA_FINAL.dta.

Finally, the STATA do file Data_import_analysis.do import additional data and conducts the empirical analysis.
Please note that you must adjust the paths used for the change directory commands in the do file (see STATA command cd).

For additional data input, raw data are stored in the following folder:
6. DATA: Additional data are sued to construct a new climate vulnerability index from raw data based on ND-GAIN;
Climate data are imported from the Word Bank; all files are csv files.

Please contact me: gerhard.kling@abdn.ac.uk if you have any additional questions.
