%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: C:\Users\conor\Box\NIEHS Hydrogel R01\AIM2_data\O2\ratedata_complete_full_perday.xlsx
%    Worksheet: Sheet1
%
% Auto-generated by MATLAB on 25-Jul-2022 17:43:25

%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 34);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "B6:AI6";

% Specify column names and types
opts.VariableNames = ["VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Import the data
ratedatacompletefullperday = readtable("C:\Users\conor\Box\NIEHS Hydrogel R01\AIM2_data\O2\ratedata_complete_full_perday.xlsx", opts, "UseExcel", false);

%% Convert to output type
rates = table2array(ratedatacompletefullperday);

%% Clear temporary variables
clear opts

rates1 = rates(1:17);
rates30 = rates(18:end);

[h,p] = ttest(rates1,rates30,'Alpha',0.9)