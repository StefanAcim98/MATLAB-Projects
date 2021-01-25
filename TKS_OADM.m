function [Ch_Out_Low, Ch_Out_High, Ch_In, Ch_In_RA] = TKS_OADM(BA_Low, BA_High, Pch_Low, MUX, DEMUX, IU, LP_Tx, LP_Rx, RA_G_Ase, BA_G_Ase, VOA_Down)

fprintf('------------------------------OADM------------------------------\n')

Ch_OADM = Pch_Low - DEMUX - MUX;

fprintf('------------------------------OBA------------------------------\n\n')
if (Ch_OADM ~= BA_Low)
    VOA_Difference1 = abs(Ch_OADM - BA_Low);
    Ch_OADM_Low = BA_Low;
else
    VOA_Difference1 = 0;
    Ch_OADM_Low = BA_Low;
end
if (Ch_OADM ~= BA_High)
    VOA_Difference2 = abs(Ch_OADM - BA_High);
    Ch_OADM_High = BA_High;  
else
    VOA_Difference2 = 0;
    Ch_OADM_High = BA_High;
end

fprintf('Slabljenje VOA u OBA za slabi BA: %ddB\n', VOA_Difference1);
fprintf('Slabljenje VOA u OBA za jaki BA: %ddB\n\n', VOA_Difference2);

fprintf('------------------------------OADM IZLAZ------------------------------\n')
Ch_Out_Low = Ch_OADM_Low + BA_G_Ase(1) - IU - LP_Tx;
Ch_Out_High = Ch_OADM_High + BA_G_Ase(1) - IU - LP_Tx;

fprintf('Izlaz iz OADM uz slabi BA: %ddB\n', Ch_Out_Low);
fprintf('Izlaz iz OADM uz jaki BA: %ddB\n\n', Ch_Out_High);

fprintf('------------------------------OADM ULAZ------------------------------\n')
Ch_In = VOA_Down + IU + LP_Rx;
Ch_In_RA = Ch_In - RA_G_Ase(1);

fprintf('Ulaz u OADM: %ddB\n', Ch_In);
fprintf('Ulaz u OADM uz RA: %ddB\n\n', Ch_In_RA);

fprintf('----------------------------------------------------------------\n');