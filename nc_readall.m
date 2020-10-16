function vars = nc_readall(fname)
% MATLAB script  to inquire about variable names and read in all variables
% from a netcdf file.  Uses native netcdf support in MATLAB 
%
% Usage:  
% 
% oid='myfile.nc';
% 
% nc_readall
%
% Warning: this reads in variables and assigns them to the same
% variable name in MATLAB as in the netcdf file does not handle
% udunits, so time coordinate typically needs to be modified for use
% in MATLAB.
%
% fname  file name or URL to a netcdf file

error('This function does not work right -RJS')

f = ncinfo(fname);
nvars = length(f.Variables)
vars = [];

for k = 1:nvars

   varname=f.Variables(k).Name;
   disp(['Reading:  ' varname]);
   var = eval([varname ' = ncread(''' fname ''',''' varname ''');']);
   vars = [vars var];

end

end