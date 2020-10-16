function c = sound_speed_medwin(z,T,S)
%SOUND_SPEED calculates the speed of sound in water based on MEDWIN's
%equation.

c = 1449.2 + 4.6.*T - 0.055.*T.^2 + 0.00029.*T.^3 + (1.34-0.01.*T).*(S-35)+0.016.*z;



end

