function [Pch_Low, Pch_High] = Tx_Rx(OTU, MUX, DEMUX, Interleaver, VOA_Up, VOA_Down, G_Low, G_High, N, IU, LP_Tx, LP_Rx, RA_G_Ase)

%%PREDAJA
fprintf('-----------------------------PREDAJA-----------------------------\n');

Ch_In_Tx = OTU - MUX - Interleaver;
if (Ch_In_Tx > VOA_Up)
    VOA_Difference = Ch_In_Tx - VOA_Up;
    Ch_In_Tx = VOA_Up;
elseif (Ch_In_Tx < VOA_Down )
    VOA_Difference = VOA_Down - Ch_In_Tx;
    Ch_In_Tx = VOA_Down;    
end

fprintf('Slabljenje VOA: %ddB\n', VOA_Difference);

%%Ovde treba if sa printom za gresku
Pch_Low = ceil(10*log10((10^(G_Low/10))/N)); %dBm    
Pch_High = ceil(10*log10((10^(G_High/10))/N)); %dBm

fprintf('Izlaz iz slabog OA: %ddB\n', Pch_Low);
fprintf('Izlaz iz jakog OA: %ddB\n', Pch_High);

Ch_In_Tx_Low = Pch_Low - IU - LP_Tx;
Ch_In_Tx_High = Pch_High - IU - LP_Tx;

fprintf('Izlaz predaja uz slabi OA: %ddB\n', Ch_In_Tx_Low);
fprintf('Izlaz predaja uz jaki OA: %ddB\n\n', Ch_In_Tx_High);
fprintf('----------------------------------------------------------------\n');

%%PRIJEM

fprintf('-----------------------------PRIJEM-----------------------------\n');

Ch_In_Rx = VOA_Down + IU + LP_Rx;
Ch_In_Rx_RA = Ch_In_Rx - RA_G_Ase(1);

fprintf('Ulaz prijem: %ddB\n', Ch_In_Rx);
fprintf('Ulaz prijem uz RA: %ddB\n', Ch_In_Rx_RA);

%%Ovde treba if sa printom za gresku
if (Pch_Low - Interleaver - DEMUX > -10)
    Ch_Out_Rx = Pch_Low - Interleaver - DEMUX;
    fprintf('Ulaz u OTU: %ddB\n\n', Ch_Out_Rx);
else
   fprintf('Nivo signala je preslab za ulaz u OTU\n\n'); 
end

fprintf('----------------------------------------------------------------\n');

%%Da li je signal u granicama prijema OTU?