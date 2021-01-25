function [Gain, Pase, Lost, Ch_loc3] = TKS_OSNR_OADM(A_min, BA_High, MUX, DEMUX, VOA_Up, VOA_Down, LP_Tx, LP_Rx, P_los1, P_los2, IU, Use1, Use2, Mask1, Mask2, MCD_12_Pre, MCD_12_Post, MCD_end, A_G_Ase, PA_G_Ase, FRA_G_Ase, BA_G_Ase, RA_G_Ase)

PA_min = -22;
n = 1;

switch MCD_12_Pre
    case 20
        MCD_12_Pre_dB = 4;
    case 40
        MCD_12_Pre_dB = 5;   
    case 60
        MCD_12_Pre_dB = 6; 
    case 80
        MCD_12_Pre_dB = 7; 
    case 100
        MCD_12_Pre_dB = 8; 
    otherwise
        MCD_12_Pre_dB = 0;
end

switch MCD_12_Post
    case 20
        MCD_12_Post_dB = 4;
    case 40
        MCD_12_Post_dB = 5;   
    case 60
        MCD_12_Post_dB = 6; 
    case 80
        MCD_12_Post_dB = 7; 
    case 100
        MCD_12_Post_dB = 8; 
    otherwise
        MCD_12_Post_dB = 0;
end

switch MCD_end
    case 20
        MCD_end_dB = 4;
    case 40
        MCD_end_dB = 5;   
    case 60
        MCD_end_dB = 6; 
    case 80
        MCD_end_dB = 7; 
    case 100
        MCD_end_dB = 8; 
    otherwise
        MCD_end_dB = 0;
end

switch Use1(1)
    case A_G_Ase(1)
        if (Mask1 == 0)
            Boost1 = A_G_Ase;
            min1 = A_min;
        else
            Boost1 = BA_G_Ase;
            min1 = BA_High;
        end
    otherwise
        Boost1 = [0 0];
end

switch Use1(2)
    case FRA_G_Ase(1)
        Boost2 = FRA_G_Ase;
    otherwise
        Boost2 = [0 0];
end

switch Use1(3)
    case RA_G_Ase(1)
        Boost3 = RA_G_Ase;
    otherwise
        Boost3 = [0 0];
end

%%loc1
Ch_loc1 = PA_min + PA_G_Ase(1);
VOA_Difference = abs(min1 + MCD_12_Pre_dB - Ch_loc1);
Ch_loc1 = Ch_loc1 - VOA_Difference - MCD_12_Pre_dB;
Gain(n) = PA_G_Ase(1);
Pase(n) = PA_G_Ase(2);
Lost(n) = VOA_Difference + MCD_12_Pre_dB;
n = n + 1;
%case BA, bolje prosledi se BA
Ch_loc1 = Ch_loc1 + Boost1(1) + Boost2(1);
Ch_loc1 = Ch_loc1 - IU - LP_Tx - P_los1;
Gain(n) = Boost1(1);
Pase(n) = Boost1(2);
Lost(n) = IU + LP_Tx;
n = n + 1;
Gain(n) = Boost2(1);
Pase(n) = Boost2(2);
Lost(n) = P_los1;
n = n + 1;

switch Use2(1)
    case A_G_Ase(1)
        if (Mask2 == 0)
            Boost4 = A_G_Ase;
            min2 = A_min;
        else
            Boost4 = BA_G_Ase;
            min2 = BA_High;
        end
    otherwise
        Boost4 = [0 0];
end

switch Use2(2)
    case FRA_G_Ase(1)
        Boost5 = FRA_G_Ase;
    otherwise
        Boost5 = [0 0];
end

switch Use2(3)
    case RA_G_Ase(1)
        Boost6 = RA_G_Ase;
    otherwise
        Boost6 = [0 0];
end

%%loc2
Ch_loc2 = Ch_loc1;
%case RA
Ch_loc2 = Ch_loc2 + Boost3(1);
Ch_loc2 = Ch_loc2 - IU - LP_Rx;
VOA_loc2 = 0;
if(Ch_loc2 < VOA_Down)
    VOA_loc2 = abs(Ch_loc2-VOA_Down);
    Ch_loc2 = VOA_Down;
elseif(Ch_loc2 > VOA_Up)
    VOA_loc2 = abs(Ch_loc2-VOA_Up);
    Ch_loc2 = VOA_Up;
end
Gain(n) = Boost3(1);
Pase(n) = Boost3(2);
Lost(n) = LP_Rx + IU + VOA_loc2;
n = n + 1;

Ch_loc2 = Ch_loc2 + PA_G_Ase(1);
VOA_Difference = abs(A_min + MCD_12_Post_dB - Ch_loc2); %%A
Gain(n) = PA_G_Ase(1);
Pase(n) = PA_G_Ase(2);
Lost(n) = VOA_Difference + MCD_12_Post_dB;
n = n + 1;
Ch_loc2 = Ch_loc2 - VOA_Difference - MCD_12_Post_dB;
Ch_loc2 = Ch_loc2 + Boost4(1);
Ch_loc2 = Ch_loc2 - DEMUX - MUX;
VOA_Difference = abs(min2 - Ch_loc2);
Ch_loc2 = Ch_loc2 - VOA_Difference;
Gain(n) = A_G_Ase(1);
Pase(n) = A_G_Ase(2);
Lost(n) = DEMUX + MUX + VOA_Difference;
n = n + 1;
Ch_loc2 = Ch_loc2 + Boost4(1) + Boost5(1);
Ch_loc2 = Ch_loc2 - IU - LP_Tx  - P_los2;
Gain(n) = Boost4(1) + Boost5(1);
Pase(n) = Boost4(2) + Boost5(2);
Lost(n) = IU + LP_Tx + P_los2;
n = n + 1;

%%loc3
Ch_loc3 = Ch_loc2 - IU - LP_Rx + Boost6(1);
VOA_loc3 = 0;
if(Ch_loc3 < VOA_Down)
    VOA_loc3 = abs(Ch_loc3-VOA_Down);
    Ch_loc3 = VOA_Down;
elseif(Ch_loc3 > VOA_Up)
    VOA_loc3 = abs(Ch_loc3-VOA_Up);
    Ch_loc3 = VOA_Up;
end
Gain(n) = Boost6(1);
Pase(n) = Boost6(2);
Lost(n) = IU + LP_Rx + VOA_loc3;
n = n + 1;

Ch_loc3 = Ch_loc3 + PA_G_Ase(1);
VOA_Difference = abs(PA_min + MCD_end_dB - Ch_loc3); %%A
Gain(n) = PA_G_Ase(1);
Pase(n) = PA_G_Ase(2);
Lost(n) = VOA_Difference + MCD_end_dB;
n = n + 1;
Ch_loc3 = Ch_loc3 - VOA_Difference - MCD_end_dB;
Ch_loc3 = Ch_loc3 + A_G_Ase(1);
Gain(n) = A_G_Ase(1);
Pase(n) = A_G_Ase(2);
