clear all; close all; clc;

% Stefan Acimovic 0255/17 %

N = input('Unesite broj tachkastih zvuchnih izvora: ');
if (N ~= 1)
    d = input('Unesite rastojanje izmedju izvora [m]: ');
    min = (-d/2)*N + d/2;
end
Choise = input('Izaberite karakteristiku izvora (1-Omni, 2-Bi, 3-Cardio, 4-Hyper): ');
alpha = input('Izaberite rezoluciju [°]: ');
FREQ = input('Izaberite frekvenciju za prikaz [Hz]: ');

fprintf('Rachunam... \n');

sol = zeros(1,N);
sinn = zeros(1,N);
coss = zeros(1,N);
rrx  = zeros(1,N);
tau = zeros(1,N);

if(N == 1)
    sol = 0;
else
    for i=1:N
       sol(i) = min;
       min = min + d;
    end
end    
if(mod(N,2) == 1 && N ~= 1)
  sol = sol - sol(fix(N/2) + 1);  
end

Pa = 1;
const = sqrt(413*Pa/(4*pi));
r = 10;
fs = 48000;
c = 340;

x = zeros(1,fs);
x(1) = 1;

y = zeros(1,fs);

fc_smallest = 125;

for i=0:alpha:360
    fc_next = fc_smallest;
    fft_temp = zeros(1,8);
    for j= 1:N
        sinn(j) = (r*sin(i*pi/180))-sol(j) ;
        coss(j) = r*cos(i*pi/180);
        rrx(j) = sqrt(sinn(j)^2 + coss(j)^2);
        tau(j) = ceil((rrx(j)/c)*fs);
        if (Choise == 1)
            y(tau(j)) = y(tau(j)) + const/rrx(j);
        elseif (Choise == 2)
            th = coss(j)/rrx(j);
            y(tau(j)) = y(tau(j)) + (const/rrx(j))*(abs(th));
        elseif (Choise == 3)
            th = coss(j)/rrx(j);
            y(tau(j)) = y(tau(j)) + (const/rrx(j))*(abs((1+th)/2));
        elseif (Choise == 4)
            th = coss(j)/rrx(j);
            y(tau(j)) = y(tau(j)) + (const/rrx(j))*(abs((1+3*th)/4));
        end
    end
    Y = fft(y,fs);
    for j = 1:8
        s = 0;
        for n = round(fc_next/sqrt(2))+1:round(fc_next*sqrt(2))
            fft_temp(j) = fft_temp(j) + (abs(Y(n+1)));
            s = s + 1;
        end
        polar_new(i+1,j) = (fft_temp(j))/s;
        fc_next = fc_next*2;
    end
    y = zeros(1,fs);
    polar(i+1) = (abs(Y(FREQ+1)));
end

polar_new = polar_new';

polar(polar==0)=[];
[row, ~] = size(polar_new);
polar_new(polar_new==0)=[];
polar_new_final = reshape(polar_new,row,size(polar,2));

teta = 0:alpha:360;

fontSize = 17;

fc_next = 16000;
for i = 10:-1:3
    figure(i), mmpolar(teta/180*pi,20*log10((polar_new_final(i-2,:)/max(abs(polar_new_final(i-2,:))))),'TTickDelta',30','RLimit',[0 -15],'TLimit',[-pi pi]);
    title(['Prikaz za ' num2str(fc_next) ' Hz oktavnu banku'], 'FontSize', fontSize);
    Image = getframe(gcf);
    string = sprintf('figure(%d).png', i);
    imwrite(Image.cdata, string);
    fc_next = fc_next/2;
end    
figure(2), mmpolar(teta/180*pi,20*log10(polar/max(abs(polar))),'TTickDelta',30','RLimit',[0 -15],'TLimit',[-pi pi]);
title(['Prikaz za frekvenciju: ' num2str(FREQ) ' Hz'], 'FontSize', fontSize);
Image = getframe(gcf);
imwrite(Image.cdata, 'figure(2).png');

xxx=0;
yyy=0;
thhh = 0:alpha:359;
xunit = r * cos(thhh*pi/180) + xxx;
yunit = r * sin(thhh*pi/180) + yyy;
figure(1),scatter(xunit, yunit, '*');
hold on;
for i = 1:length(sol)
   scatter(0, sol(i), 'd'); 
end
title(['Prikaz za broj zvuchnih izvora: ' num2str(N) ' i rezoluciju: ' num2str(alpha) '° '], 'FontSize', fontSize);  
xlim([-11 11]);
ylim([-11 11]);
xL = xlim;
yL = ylim;
line([0 0], yL);  %y-axis
line(xL, [0 0]);  %x-axis
Image = getframe(gcf);
imwrite(Image.cdata, 'figure(1).png');
