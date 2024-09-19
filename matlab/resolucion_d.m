%% Resolucion d
parametros;
pregunta_a;

syms k_a k_c k_st;

%% Lazo cerrado simbólico
% FdT lazo directo
h_ld = k_a * k_c * h_pv;
% FdT lazo cerrado
h_lc = h_ld / (1 + k_st * h_ld);

[num, den] = numden(h_lc);
disp('Denominador FdT:');
disp(collect(den,s));

% La parte derecha de la incuación la anotamos a mano 
num_ineq = -(a_1p*a_1w*(a_0p*a_1w + a_1p*a_0w) + a_2p*a_0w*(a_0p*a_1w + a_1p*a_0w) - a_2p*a_1w*a_0p*a_0w);
den_ineq = (a_1p*a_1w*k_a*k_st*b_1p*b_0w) + (a_2p*a_0w*k_a*k_st*b_1p*b_0w) - (a_2p*a_1w*k_a*k_st*b_0p*b_0w);

% Calcular KC_final
num_div_den = num_ineq /den_ineq;
disp('Parte derecha de la inecuación');
pretty(num_div_den);

%% Remplazo de valores numericicos
constantes;
k_a   = 100;   k_st  = 180/pi;

KC_final= subs(num_div_den);
disp('valor kc');
disp(double(KC_final));