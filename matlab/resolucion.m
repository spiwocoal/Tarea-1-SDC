%% Definición de parámetros
r_b = 9.3e-3; r = 9.3e-3; g = 9.8;
G = 17.5e-3; H = 67.5; m = 28.2e-3;
R = 87.5e-3; b_b = 4.57e-6; tau = 0.66;

syms b_0w a_1w a_0w b_1p b_0p a_2p a_1p a_0p;

%% Funciones de transferencia
syms s;

% F.d.T. entre omega y v_i
h_wv = b_0w / (a_1w*s + a_0w);

% F.d.T. entre psi y omega
h_pw = (b_1p*s + b_0p) / (a_2p*s^2 + a_1p*s + a_0p);

%% Pregunta a)

% F.d.T. entre psi y v_i
h_pv = h_wv * h_pw;
disp('Función de trasnferencia entre \psi y v_i')
pretty(h_pv);

% Ecuaciones de estado
A_sym = [0, 1, 0;
    -a_1p/a_2p, a_0p/a_2p, (b_0p/a_2p)-(b_1p*a_0w)/(a_2p*a_1w);
    0, 0, -a_0w/a_1w];
B_sym = [0; (b_1p*b_0w)/(a_2p*a_1w); b_0w/a_1w];
C = [1, 0, 0];
% C = eye(3);

%% Pregunta b) simbólico
warning('off', 'symbolic:solve:SolutionsDependOnConditions');

% Ganancia DC
gdc_sym = limit(h_pv);
disp('Ganancia DC simbólica:');
pretty(gdc_sym);

% Polos
p_sym = poles(h_pv, s);
disp('Polos simbólicos:');
pretty(p_sym);

% Ceros
z_sym = solve(h_pv, s);
disp('Ceros simbólicos:');
pretty(z_sym);


%% Pregunta b) numérico
b_0w = G; a_1w = tau; a_0w = 1; b_1p = H*(2/5)*(r_b/r)^2;
b_0p = H*b_b/(m*r^2); a_2p = (2/5)*(r_b/r)^2+1; a_1p = b_b/(m*r^2);
a_0p = g/R;

gdc = subs(gdc_sym);
disp('Ganancia DC:');
disp(gdc);
p = subs(p_sym);
disp('Polos:');
disp(p);
z = subs(z_sym);
disp('Ceros:');
disp(z);

% Entrada estado estacionario
psi_0 = pi/6;
v_i0 = double(psi_0 / gdc); % Ganancia DC es ganancia en estado estacionario
w_0 = double(v_i0 * subs(limit(h_wv)));
disp('Valor de v_i0');
disp(v_i0);

% Simulación
A = double(subs(A_sym)); B = double(subs(B_sym));

vi = @(t) v_i0 .* (rampa(t-1) - rampa(t-4)) ./ 3;