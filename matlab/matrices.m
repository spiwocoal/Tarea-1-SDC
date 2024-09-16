constantes;

%% Matrices sistema
A = [        0,          1,                                    0 ;
    -a_0p/a_2p, -a_1p/a_2p,  (b_0p/a_2p)-(b_1p*a_0w)/(a_2p*a_1w) ;
             0,           0,                         -a_0w/a_1w ];
B = [                      0  ;
     (b_1p*b_0w)/(a_2p*a_1w)  ;
                   b_0w/a_1w ];

