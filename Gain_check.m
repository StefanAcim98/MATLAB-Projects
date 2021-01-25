function [Ga, Pa, Lo] = Gain_check(Gain, Pase, Lost, MCD_12_Pre, MCD_12_Post, MCD_end)

Ga= Gain;
Pa = Pase;
Lo = Lost;

for n = 1:length(Ga)-2
   if (Ga(n) == 0)
      Ga(n) = [];
      Pa(n) = [];
      Lo(n-1) = Lo(n-1) + Lo(n);
      Lo(n) = [];
   end
end

for n = 1:length(Ga)-2
   if (Ga(n) == 0)
      Ga(n) = [];
      Pa(n) = [];
      Lo(n-1) = Lo(n-1) + Lo(n);
      Lo(n) = [];
   end
end

for n = 1:length(Ga)-2
   if (Ga(n) == 0)
      Ga(n) = [];
      Pa(n) = [];
      Lo(n-1) = Lo(n-1) + Lo(n);
      Lo(n) = [];
   end
end

fprintf('------------------------------G and L------------------------------\n\n')

str = '';

for n = 1:length(Ga)
    switch Ga(n)
        case 23
            if (Pa(n) == -30.4)
                s = '---A---';
                str = strcat(str,s);
            else
                s = '---BA---';
                str = strcat(str,s);
            end
        case 21
            s = '---PA---';
            str = strcat(str,s);
        case 10
            s = '---RA---';
            str = strcat(str,s);
        case 8 
            s = '---FRA---';
            str = strcat(str,s);
        case 31
            if (Pa(n) == -79.4)
                s = '---A---FRA---';
                str = strcat(str,s);
            else
                s = '---BA---FRA---';
                str = strcat(str,s);
            end
    end
end

fprintf(str);
fprintf('\n');
fprintf('---------OTM1[%d]---------LINE[%d]---------OTM2[%d]---------\n', MCD_12_Pre, MCD_12_Post, MCD_end);

for n = 1:length(Lo)
   fprintf('L%d = %.2f ', n, Lo(n)); 
end
fprintf('[dB]');
fprintf('\n\n');