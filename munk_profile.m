function c = munk_profile(z)
%MUNK_PROFILE returns a canonical sound speed profile along given depths

zmod = 2*(z-1300)/1300;
c = 1500*(1+.00737*(zmod-1+exp(-zmod)));

end

