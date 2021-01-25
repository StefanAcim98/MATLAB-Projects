function [Ch_Out_Low, Ch_Out_High, Ch_In, Ch_In_RA] = TKS_OLA(Pch_Low, Pch_High, IU, LP_Tx, LP_Rx, RA_G_Ase, VOA_Down)

fprintf('------------------------------OLA------------------------------\n')

Ch_Out_Low = Pch_Low - IU - LP_Tx;
Ch_Out_High = Pch_High - IU - LP_Tx;

fprintf('------------------------------OLA IZLAZ------------------------------\n')

fprintf('Izlaz iz OLA uz slabi BA: %ddB\n', Ch_Out_Low);
fprintf('Izlaz iz OLA uz jaki BA: %ddB\n\n', Ch_Out_High);

fprintf('------------------------------OLA ULAZ------------------------------\n')
Ch_In = VOA_Down + IU + LP_Rx;
Ch_In_RA = Ch_In - RA_G_Ase(1);

fprintf('Ulaz u OLA: %ddB\n', Ch_In);
fprintf('Ulaz u OLA uz RA: %ddB\n\n', Ch_In_RA);
fprintf('----------------------------------------------------------------\n');