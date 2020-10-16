function [SSP] = import_noaa_profiles(lat,lon)
% IMPORT_NOAA_PROFILES accesses the NOAA website
% 
% Files are downloaded from the NOAA website using the format
% described below
% https://www.nodc.noaa.gov/OC5/woa13/readwoa13.html 
% 
% [V][TT][FF][GG].[EXT]
% 
% where:
% [V] - variable
% [TT] - time period
% [FF] - field type
% [GG] - grid (5deg- 5°, 01- 1°, 04 - 1/4°)
% [EXT] - file extention


dataDir = '../raw';          % TODO: move to some global env variables
fnameBase = 'woa13_decav_';
fnameExt = 'v2.csv';

timePeriod = '00';                    % TODO: autofill if not provided
% '00' Annual
% '13' Winter
% '14' Spring
% '15' Summer
% '16' Autumn
% '01'-'12' Jan-Dec

fieldType = 'an';                     % TODO: autofill if not provided
% 'an' Objectively analyzed mean 
% 'dd' Number of observations
% 'gp' Grid points
% 'ma' Season/month minus anual mean (no anual value)
% 'mn' Statistical mean
% 'oa' Statistical mean minus analyzed
% 'sd' Standard deviations
% 'se' Standard error of the mean

grid = '01';                          % TODO: autofill if not provided
% '5d' 5 degrees
% '01' 1 degree
% '04' 1/4 degree

% Pull each profile
tfname = [fnameBase 't' timePeriod fieldType grid fnameExt];
tfile = fullfile(dataDir, tfname);
worldTemps = importnoaadata(tfile);


sfname = [fnameBase 's' timePeriod fieldType grid fnameExt];
sfile = fullfile(dataDir, sfname);
worldSalinity = importnoaadata(sfile);

% Locate the closest profile
posit = floor([lat lon])+.5             % HACK
idx = (worldTemps(:,1)==posit(1) & worldTemps(:,2)==posit(2));
if ~idx
    error('Lat/Lon profile unavailable in temperature');
else
    SSP.T = worldTemps(idx,3:end);
end

idx = (worldTemps(:,1)==posit(1) & worldTemps(:,2)==posit(2));

if ~idx
    error('Lat/Lon profile unavailable in salinity');
else
    SSP.S = worldSalinity(idx,3:end);
end

% NOTE: I believe these depths are standard, but I have not proven it.
SSP.z =[0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,125,150,175,200,225,250,275,300,325,350,375,400,425,450,475,500,550,600,650,700,750,800,850,900,950,1000,1050,1100,1150,1200,1250,1300,1350,1400,1450,1500,1550,1600,1650,1700,1750,1800,1850,1900,1950,2000,2100,2200,2300,2400,2500,2600,2700,2800,2900,3000,3100,3200,3300,3400,3500,3600,3700,3800,3900,4000,4100,4200,4300,4400,4500,4600,4700,4800,4900,5000,5100,5200,5300,5400,5500];

SSP.c = sound_speed_teos10(SSP.z,SSP.T,SSP.S,lat,lon);

% TODO: have ability to change the sound speed equations
%SSP.c = sound_speed_medwin(z,T,S),-z); 

end

function woa13decavt14se01v2 = importnoaadata(filename, dataLines)
%IMPORTFILE Import data from a text file
%  WOA13DECAVT14SE01V2 = IMPORTFILE(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the numeric data.
%
%  WOA13DECAVT14SE01V2 = IMPORTFILE(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  woa13decavt14se01v2 = importfile("/Users/russ/Dropbox/7edu/URI/2020-Fall/acoustics/raw/woa13_decav_t14se01v2.csv", [3, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 16-Oct-2020 00:40:26

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [3, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 104);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";


% Specify column names and types
opts.VariableNames = ["COMMASEPARATEDLATITUDE", "LONGITUDE", "ANDVALUESATDEPTHSM0", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38", "VarName39", "VarName40", "VarName41", "VarName42", "VarName43", "VarName44", "VarName45", "VarName46", "VarName47", "VarName48", "VarName49", "VarName50", "VarName51", "VarName52", "VarName53", "VarName54", "VarName55", "VarName56", "VarName57", "VarName58", "VarName59", "VarName60", "VarName61", "VarName62", "VarName63", "VarName64", "VarName65", "VarName66", "VarName67", "VarName68", "VarName69", "VarName70", "VarName71", "VarName72", "VarName73", "VarName74", "VarName75", "VarName76", "VarName77", "VarName78", "VarName79", "VarName80", "VarName81", "VarName82", "VarName83", "VarName84", "VarName85", "VarName86", "VarName87", "VarName88", "VarName89", "VarName90", "VarName91", "VarName92", "VarName93", "VarName94", "VarName95", "VarName96", "VarName97", "VarName98", "VarName99", "VarName100", "VarName101", "VarName102", "VarName103", "VarName104"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];


% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
woa13decavt14se01v2 = readtable(filename, opts);

%% Convert to output type
woa13decavt14se01v2 = table2array(woa13decavt14se01v2);

end