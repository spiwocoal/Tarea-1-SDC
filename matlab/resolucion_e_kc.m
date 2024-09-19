%%Resolucion e para encontar kc
parametros;
pregunta_a;

syms k_a k_c k_st s;

%% Lazo cerrado simbólico
% FdT lazo directo
h_ld = (k_c/s) * k_a * h_pv;

% FdT lazo cerrado
h_lc = h_ld / (1 + k_st * h_ld);

[num,den] = numden(h_lc);
disp('Denominador FT:');
disp(collect(den,s));

% Resultados del criterio de Routh-Hurwitz
a_4 = (a_2p .* a_1w);
a_3 = (a_1p .* a_1w) + (a_2p .* a_0w) ;
a_2 = (a_0p .* a_1w) + (a_1p .* a_0w) ;
a_1 = (a_0p .* a_0w) + (b_1p .* b_0w .*k_st .*k_a.* k_c) ;
a_0 = (b_0p .* b_0w .* k_st .* k_a .* k_c) ;
b_1 = (a_3 * a_2 - a_4 * a_1) / a_3 ;
c_1 = (b_1 * a_1 - a_3 * a_0) / b_1;

% kc en b_1 es 
k_c = ((a_3 .* a_2)./(a_4 .* b_1p .* b_0w .* k_st .* k_a)) - ((a_0p .* a_0w)./ (b_1p .* b_0w .* k_st .* k_a));

%% Remplazo de los valores numericos
constantes;
k_a   = 100; k_st  = 180/pi;

KC_final= subs(k_c);
disp('valor kc');
disp(double(KC_final));