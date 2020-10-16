function c = sound_speed_teos10(z,T,S,lat,lon)
%SOUND_SPEED_TEOS10 calculates the sound speed based on the thermodynamic
%equations.

p = gsw_p_from_z(-z,lat);
SA = gsw_SA_from_SP(S,p,lon,lat);
CT = gsw_CT_from_t(SA,T,p);
c = gsw_sound_speed(SA,CT,p);

end

