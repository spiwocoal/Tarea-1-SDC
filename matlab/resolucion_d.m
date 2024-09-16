%%Resolucion e

% Definición de parámetros
r_b = 9.53e-3; r = 9.3e-3; g = 9.8;
G = 17.5e-3; H = 67.5; m = 28.2e-3;
R = 87.5e-3; b_b = 4.57e-6; tau = 0.66;

syms b_0w a_1w a_0w b_1p b_0p a_2p a_1p a_0p ka kc k_st s;

% Lazo cerrado simbólico
%psi/vi
psi_vi = ((b_0w*(b_0p + b_1p*s))/((a_0w + a_1w*s)*(a_2p*s^2 + a_1p*s + a_0p)));

%F_T lazo cerrado
F_T = ((kc).*ka.*psi_vi*k_st)./(1 + (kc).*ka.*psi_vi.*k_st);

[num,den] = numden(F_T);

FT_sym= collect(den,s);
disp('Denominador FT:');
disp(FT_sym);

%la parte derecha de la incuación la anotamos a mano 
num_ineq = -(a_1p*a_1w*(a_0p*a_1w + a_1p*a_0w) + a_2p*a_0w*(a_0p*a_1w + a_1p*a_0w) - a_2p*a_1w*a_0p*a_0w);
den_ineq = (a_1p*a_1w*ka*k_st*b_1p*b_0w) + (a_2p*a_0w*ka*k_st*b_1p*b_0w) - (a_2p*a_1w*ka*k_st*b_0p*b_0w);

% Calcular KC_final
num_div_den = num_ineq /den_ineq;
disp('Parte derecha de la inecuación');
pretty(num_div_den);

%% Remplazo de a valores numericicos
b_0w = G; 
a_1w = tau; 
a_0w = 1;
b_1p = H*(2/5)*(r_b/r)^2;
b_0p = H*b_b/(m*r^2);
a_2p = (2/5)*(r_b/r)^2+1;
a_1p = b_b/(m*r^2);
a_0p = g/R;
ka   = 100;
k_st  = 180/pi;


KC_final= subs(num_div_den);
disp('valor kc');
disp(double(KC_final));