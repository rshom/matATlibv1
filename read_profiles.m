function [z,T,S,p] = read_profiles(fname)
% READ_PROFILES reads depth, temperature, and salinity profiles from
% nc files.


z = ncread(fname,'ctd_depth');
T = ncread(fname,'temperature');
S = ncread(fname,'salinity');
p = ncread(fname,'ctd_pressure');


end

