clear all; close all; clc;

hz = input('Unesite visinu predajnika [m]: ');
hm = input('Unesite visinu prijemnika [m]: ');
r = input('Unesite rastojanje [m]: ');
direction1 = input('Izaberite usmerenost predajnika (1-Omni, 2-Bi, 3-Cardio, 4-Hyper): ');
direction2 = input('Izaberite usmerenost prijemnika (1-Omni, 2-Bi, 3-Cardio, 4-Hyper): ');
alpha = input('Izaberite refleksionu ravan (1-Beton, 2-Drveni podijum, 3-Apsorpcioni panel): ');
fprintf('Rachunam... \n');
if (alpha == 1)
    alpha_array = [0.01 0.01 0.01 0.02 0.02 0.02 0.05 0.05 0.05];
elseif (alpha == 2)
    alpha_array = [0.18 0.18 0.12 0.10 0.09 0.08 0.07 0.07 0.07];
else
    alpha_array = [0.46 0.46 0.93 1.00 1.00 1.00 1.00 1.00 1.00];
end
Pa = 1;
const = sqrt(413*Pa/(4*pi));
fs = 48000;
c = 340;

x = zeros(1,fs);
x(1) = 1;

r_d = sqrt(r^2 + (hz-hm)^2);

tau_d = ceil((r_d/c)*fs);

y_d = zeros(1,fs);
y_d(tau_d) = const/r_d;

d1 = r*hz/(hz+hm);
r1 = sqrt(d1^2 + hz^2);
d2 = r - d1;
r2 = sqrt(d2^2 + hm^2);
r_r = r1 + r2;

plotting(hz, hm, r, direction1, direction2, d1);

theta = acosd(d1/r1);
fprintf('Ugao [°]: %.2f\n', theta);

tau_r = ceil((r_r/c)*fs);

y_r = zeros(1,fs);
y_r(tau_r) = const/r_r;

normalize = max(y_d);
y_d = y_d/normalize;
y_r = y_r/normalize;

fc_smallest = 125;
fc_next = fc_smallest;
for i = 2:9
    if (i == 9)
        f_fir(i) = 1;
        break;
    end
    f_fir(i) = fc_next/(fs/2);
    fc_next = 2*fc_next;
end

N = 12;
a = sqrt(1-alpha_array);
h = fir2(N,f_fir,a);

y_ref_alpha = filter(h,1,y_r);

fi = atand(abs(hz-hm)/r);
if (direction1 == 2)
        y_d = y_d*cosd(fi);
        y_ref_alpha = y_ref_alpha*cosd(theta);
elseif (direction1 == 3)
        y_d = y_d*(1+cosd(fi))/2;
        y_ref_alpha = y_ref_alpha*(1+cosd(theta))/2;
elseif (direction1 == 4)
        y_d = y_d*(1+3*cosd(fi))/4;
        y_ref_alpha = y_ref_alpha*(1+3*cosd(theta))/4;
end
    
if (direction2 == 2)
    y_d = y_d*cosd(fi);
    if (hm > hz)
        y_ref_alpha = y_ref_alpha*abs(cosd(theta-fi+90));
    else
        y_ref_alpha = y_ref_alpha*cosd(theta);
    end
elseif (direction2 == 3)
    y_d = y_d*(1+cosd(fi))/2;
    if (hm > hz)
        y_ref_alpha = y_ref_alpha*((1+abs(cosd(theta-fi+90)))/2);
    else
        y_ref_alpha = y_ref_alpha*(1+cosd(theta))/2;
    end
elseif (direction2 == 4)
    y_d = y_d*(1+3*cosd(fi))/4;
    if (hm > hz)
        y_ref_alpha = y_ref_alpha*((1+abs(3*cosd(theta-fi+90)))/4);
    else
        y_ref_alpha = y_ref_alpha*(1+3*cosd(theta))/4;
    end
end

normalize = max(y_d);
y_final = y_d + y_ref_alpha;
y_final = y_final/normalize;

figure(2),stem(y_final);
title('Prikaz impulsnog odziva')
xlabel('Broj tacaka')
ylabel('Normalizovana vrednost [0 1]')
set(gcf,'Position',[1200 570 570 420])
Image = getframe(gcf);
imwrite(Image.cdata, 'figure(2).png');

Y = fft(y_final,fs);

auto_lim = 20*log10((abs(Y))/max(abs(Y)));
s = 0;

for i = 2 : length(auto_lim)-1
    if (auto_lim(i-1) < auto_lim(i) && auto_lim(i+1) < auto_lim(i))
       s = s + 1;
    end
    if (s == 10)
       break; 
    end
end

s = i;

figure(3),plot(0:length(Y)-1,20*log10((abs(Y))/max(abs(Y))));
title('Prikaz frekvencijskog odziva')
xlabel('Frekvencija [Hz]')
ylabel('Normalizovana vrednost [dB]')
set(gcf,'Position',[1200 65 570 420])
xlim([0 s])
ylim([min(20*log10((abs(Y(i)))/max(abs(Y))))-15 2])
Image = getframe(gcf);
imwrite(Image.cdata, 'figure(3).png');

fc_next = fc_smallest;
fft_temp = zeros(1,7);
for j = 1:7
    k = 0;
    for i = round(fc_next/sqrt(2))+1:round(fc_next*sqrt(2))
        fft_temp(j) = fft_temp(j) +  abs(Y(i));
        k = k + 1;
    end   
    fft_temp(j) = fft_temp(j)/k;
    fc_next = fc_next*2;
end

fft_temp = fft_temp/max(fft_temp);
fft_temp = 20*log10(fft_temp);

fc_next = fc_smallest;

for i = 1:7
    octave(ceil(fc_next/sqrt(2)):ceil(fc_next*sqrt(2))) = fft_temp(i);
    fc_next = fc_next*2;
end


figure(4),semilogx(0:length(octave)-1, octave);
title('Prikaz po oktavama')
xlabel('Frekvencija [Hz]')
ylabel('Normalizovana vrednost [dB]')
xlim([90 9500])
ylim([min(octave)-0.5 0.5])
Image = getframe(gcf);
imwrite(Image.cdata, 'figure(4).png');