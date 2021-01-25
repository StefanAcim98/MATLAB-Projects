clear all; close all; clc;

r = 10;
sol = [-0.34 0 0.34];
xxx=0;
yyy=0;
thhh = 0:5:359;
xunit = r * cos(thhh*pi/180) + xxx;
yunit = r * sin(thhh*pi/180) + yyy;
figure(10),scatter(xunit, yunit, '*');
hold on;
for i = 1:length(sol)
   scatter(0, sol(i), 'd'); 
end
xlim([-11 11]);
ylim([-11 11]);
xL = xlim;
yL = ylim;
line([0 0], yL);  %y-axis
line(xL, [0 0]);  %x-axis