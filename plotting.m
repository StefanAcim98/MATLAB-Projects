function plotting(hz, hm, r, direction1, direction2, d1)

x1 = 0;
y1 = hz;
R = r;
ang=0:0.01:2*pi; 
r_source = 0.1;

if (hz > 8 || hm > 8)
    marker = 17;
else
    marker = 35;
end

if (direction1 == 1)
    r1 = sqrt(2)/2;
elseif (direction1 == 2) 
    r1 = abs(cos(ang));
elseif (direction1 == 3)
    r1 = abs(1+cos(ang))/2;
elseif (direction1 == 4) 
    r1 = abs((1+3*cos(ang))/4);    
end

xp=r1.*cos(ang);
yp=r1.*sin(ang);
figure(1),plot(x1+xp,y1+yp);
title('Graficki prikaz za unete vrednosti')
xlabel('Rastojanje [m]')
ylabel('Visina [m]')
if (R > hz || R > hm)
    set(gcf,'Position',[200 100 900 500])
else
    set(gcf,'Position',[200 100 500 900])
end
% set(gca,'Color',[.255 .193 .211]);
hold on
xp=r_source.*cos(ang);
yp=r_source.*sin(ang);
plot(x1+xp,y1+yp, '.k', 'MarkerSize',3);
hold on

x2 = R;
y2 = hm;
if (direction2 == 1)
    r2 = sqrt(2)/2;
elseif (direction2 == 2) 
    r2 = abs(cos(ang));
elseif (direction2 == 3)
    r2 = -abs(1+cos(ang))/2;
elseif (direction2 == 4) 
    r2 = -abs((1+3*cos(ang))/4);    
end
xp=r2.*cos(ang);
yp=r2.*sin(ang);
plot(x2+xp,y2+yp, 'Color',[.61 .51 .74]);
xlim([min(-R/2,min(-hz/2,-hm/2)) max(3*R/2,max(hz/2, hm/2))])
ylim([-0.5 2*max(hz,hm)])
hold on 
x = [R-0.1 R+0.1 R+0.1 R-0.1, R-0.1];
y = [y2-0.1 y2-0.1 y2+0.1 y2+0.1, y2-0.12];
plot(x,y,'k', 'LineWidth',1.1)
hold on
line([min(-R/2,min(-hz/2,-hm/2)) max(3*R/2,max(hz/2, hm/2))],[0,0], 'Color','k', 'LineWidth',2);
line([min(-R/2,min(-hz/2,-hm/2)) max(3*R/2,max(hz/2, hm/2))],[-0.25,-0.25], 'Color','k', 'LineWidth', marker);
% OVO POPRAVITI
hold on
line([0,R],[y1,y2], 'Color','b', 'LineWidth',1.2);
hold on
line([0,d1],[y1,0], 'Color',[.84 .22 .180], 'LineWidth',1.2);
line([d1,R],[0,y2], 'Color',[.84 .22 .180], 'LineWidth',1.2);
Image = getframe(gcf);
imwrite(Image.cdata, 'figure(1).png');

