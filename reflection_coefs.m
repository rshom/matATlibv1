function [R, T] = reflection_coefs(roh1,roh2,c1,c2,theta,omega)

error('function not working properly because grazing angle is wrong')

k1 = omega/c1;
k2 = omega/c2;

theta1 = theta;
theta2 = acosd(k1*cosd(theta1)/k2);

theta2 = 90-theta;
R = (roh2*c2/sind(theta2)-roh1*c1/sind(theta1))/((roh2*c2/sind(theta2)-roh1*c1)/sind(theta1));
T = 1+R

%R = (Z-Z1)/(Z+Z1)

end