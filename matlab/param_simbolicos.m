%% Constantes simbólicas
syms b_0w a_1w a_0w b_1p b_0p a_2p a_1p a_0p;
syms s;

%% Funciones de transferencia
% F.d.T. entre omega y v_i
h_wv = b_0w / (a_1w*s + a_0w);
% F.d.T. entre psi y omega
h_pw = (b_1p*s + b_0p) / (a_2p*s^2 + a_1p*s + a_0p);
