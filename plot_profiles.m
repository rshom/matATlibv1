function plot_profiles(z,c,T,S)
%PLOT_PROFILES makes a plot of sound speed and other depth related data.

figure;

ax1 = subplot(1,3,1);
plot(c,-z,'.');
title('Sound Speed')
xlabel('Sound Speed (m/s)')
ylabel('Depth (m)')

ax2 = subplot(1,3,2);
plot(T,-z,'.');
title('Temperature')
xlabel('Temp (deg C)')

ax3 = subplot(1,3,3);
plot(S,-z,'.');
title('Salinity');
xlabel('Salinity (ppm)');

linkaxes([ax1,ax2,ax3],'y');


end

