function [P_los1, P_los2, Use1, Use2, Mask1, Mask2, MCD_12_Pre, MCD_12_Post, MCD_end] = TKS_Plos(dB_km, L1, L2, Polar, Polar_Up, Ch_Out_Low, Ch_Out_High, Ch_OADM_In, Ch_In_RA, A_G_Ase, PA_G_Ase, FRA_G_Ase, BA_G_Ase, RA_G_Ase)

Use1 = [0 0 0];
Use2 = [0 0 0];

fprintf('------------------------------P_LOS------------------------------\n');

A_NaN = Ch_Out_Low - Ch_OADM_In;
BA_NaN = Ch_Out_High - Ch_OADM_In;
A_RA = Ch_Out_Low - Ch_In_RA;
BA_RA = Ch_Out_High - Ch_In_RA;
A_FRA_RA = Ch_Out_Low + FRA_G_Ase(1) - Ch_In_RA;

P_los1 = L1*dB_km + 3;
P_los2 = L2*dB_km + 3;

fprintf('P_los1: %.3fdB\n', P_los1);
fprintf('P_los2: %.3fdB\n\n', P_los2);

if (P_los1 < A_NaN)
    Use1(1) = A_G_Ase(1);
    Mask1 = 0;
elseif (A_NaN < P_los1 && P_los1 < BA_NaN)
    Use1(1) = BA_G_Ase(1);
    Mask1 = 1;
elseif (BA_NaN < P_los1 && P_los1 < A_RA)
    Use1(1) = A_G_Ase(1);
    Use1(3) = RA_G_Ase(1);
    Mask1 = 0;
elseif (A_RA < P_los1 && P_los1 < BA_RA)
    Use1(1) = BA_G_Ase(1);
    Use1(3) = RA_G_Ase(1);
    Mask1 = 1;
else
    Use1(1) = A_G_Ase(1);
    Use1(2) = FRA_G_Ase(1);
    Use1(3) = RA_G_Ase(1);
    Mask1 = 0;
end

fprintf('%d %d %d [%d]\n', Use1(1), Use1(2), Use1(3), Mask1);
fprintf('A/BA FRA RA za OTM predaju i line\n');

if (P_los2 < A_NaN)
    Use2(1) = A_G_Ase(1);
    Mask2 = 0;
elseif (A_NaN < P_los2 && P_los2 < BA_NaN)
    Use2(1) = BA_G_Ase(1);
    Mask2 = 1;
elseif (BA_NaN < P_los2 && P_los2 < A_RA)
    Use2(1) = A_G_Ase(1);
    Use2(3) = RA_G_Ase(1);
    Mask2 = 0;
elseif (A_RA < P_los2 && P_los2 < BA_RA)
    Use2(1) = BA_G_Ase(1);
    Use2(3) = RA_G_Ase(1);
    Mask2 = 1;
else
    Use2(1) = A_G_Ase(1);
    Use2(2) = FRA_G_Ase(1);
    Use2(3) = RA_G_Ase(1);
    Mask2 = 0;
end

fprintf('%d %d %d [%d]\n', Use2(1), Use2(2), Use2(3), Mask2);
fprintf('A/BA FRA RA za OTM prijem\n');

link_12 = L1*Polar;
MCD_12 = 20;

while(link_12 > Polar_Up)
    link_12 = (L1-MCD_12)*Polar;
    MCD_12 = MCD_12 + 20;
end
MCD_12 = MCD_12 - 20;

%fprintf("------------------------------MCD------------------------------\n");

if (MCD_12 > 100)
   MCD_12_Pre = MCD_12 - 100;
   MCD_12_Post = 100;
else
   MCD_12_Pre = 0;
   MCD_12_Post = MCD_12; 
end

%fprintf('Prekompenzacija: %d Postkompenzacija: %d\n', MCD_12_Pre, MCD_12_Post);

link_123 = (L1+L2)*Polar;
MCD_123 = MCD_12;

while(link_123 > Polar_Up)
    link_123 = (L1+L2-MCD_123)*Polar;
    MCD_123 = MCD_123 + 20;
end
MCD_123 = MCD_123 - 20;
MCD_end = MCD_123 - MCD_12;

if (MCD_end > 100)
    s = 1;
    while(MCD_end > 101)
        if(mod(s,2) == 1 )
           MCD_12_Post = MCD_12_Post + 20;
        else
           MCD_12_Pre = MCD_12_Pre + 20;
        end
        s = s + 1;
        MCD_end = MCD_end - 20;
    end
end

link_12 = (L1-MCD_12_Pre - MCD_12_Post)*Polar;
link_23 = (L2 - MCD_end)*Polar;
link_123 = (L1+L2-MCD_12_Pre - MCD_12_Post - MCD_end)*Polar;

fprintf('------------------------------MCD------------------------------\n');
fprintf('Prekompenzacija: %d  Postkompenzacija: %d  ', MCD_12_Pre, MCD_12_Post);
fprintf('Kraj: %d\n', MCD_end);
fprintf('link 1-2: %d ps/nm\n', link_12);
fprintf('link 2-3: %d ps/nm\n', link_23);
fprintf('link 1-2-3: %d ps/nm\n', link_123);