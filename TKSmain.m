clear all; close all; clc;

N = 80;
L1 = 115; %km
L2 = 85; %km
dB_km = 0.275;
Polar = 18;
Polar_Up = 500;
Polar_Down = -300;
OTU = -2; %dBm
MUX = 7; %dB
DEMUX = 7; %dB
Interleaver = 3; %dB
IU = 1.5; %dB
LP_Tx = 3.5; %dB
LP_Rx = 1.5; %dB
VOA_Up = -22; %dBm
VOA_Down = -32; %dBm
G_Low = 20; %dBm
G_High = 23; %dBm
RA_G_Ase = [10, -48];
BA_G_Ase = [23, -29.1];
FRA_G_Ase = [8, -49];
PA_G_Ase = [21, -33.3];
A_G_Ase = [23, -30.4];

BA_Low = -22;
BA_High = -19;

A_min = -22;

%%Tx i Rx
[Pch_Low, Pch_High] = Tx_Rx(OTU, MUX, DEMUX, Interleaver, VOA_Up, VOA_Down, G_Low, G_High, N, IU, LP_Tx, LP_Rx, RA_G_Ase);

%%OADM prorachun
[Ch_Out_Low, Ch_Out_High, Ch_In, Ch_In_RA] = TKS_OADM(BA_Low, BA_High, Pch_Low, MUX, DEMUX, IU, LP_Tx, LP_Rx, RA_G_Ase, BA_G_Ase, VOA_Down);

%%OLA prorachun
%[Ch_Out_Low, Ch_Out_High, Ch_In, Ch_In_RA] = TKS_OLA(Pch_Low, Pch_High, IU, LP_Tx, LP_Rx, RA_G_Ase, VOA_Down);

%%Plos
[P_los1, P_los2, Use1, Use2, Mask1, Mask2, MCD_12_Pre, MCD_12_Post, MCD_end] = TKS_Plos(dB_km, L1, L2, Polar, Polar_Up, Ch_Out_Low, Ch_Out_High, Ch_In, Ch_In_RA, A_G_Ase, PA_G_Ase, FRA_G_Ase, BA_G_Ase, RA_G_Ase);

%%Rachun deonice
[Gain, Pase, Lost, Ch_loc3] = TKS_OSNR_OADM(A_min, BA_High, MUX, DEMUX, VOA_Up, VOA_Down, LP_Tx, LP_Rx, P_los1, P_los2, IU, Use1, Use2, Mask1, Mask2, MCD_12_Pre, MCD_12_Post, MCD_end, A_G_Ase, PA_G_Ase, FRA_G_Ase, BA_G_Ase, RA_G_Ase);

%%Sredjivanje koda
[Gain1, Pase1, Lost1] = Gain_check(Gain, Pase, Lost, MCD_12_Pre, MCD_12_Post, MCD_end);

%%OSNR
OSNR = OSNR_prorachun2(Gain1, Pase1, Lost1, Ch_loc3);

