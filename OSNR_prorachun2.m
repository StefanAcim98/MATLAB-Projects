function OSNR = OSNR_prorachun2(Gain, Pase, Lost, Ch_loc3)

fprintf('------------------------------OSNR------------------------------\n\n');

G = Gain;
L = Lost;
P = Pase;
Out = Ch_loc3;

for n = 1:length(G) 
    for m = n:length(L)
        P(n) = P(n) + G(m+1) - L(m);  
    end
    if (n<=length(L))
        P(n) = 10^(0.1*P(n));
    end
end
P(n) = 10^(0.1*P(n));


Ptot = 10*log10(sum(P));

OSNR = Out - Ptot;


fprintf('OSNR = %.3fdB\n', OSNR);

end