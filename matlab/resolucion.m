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
    -a_0p/a_2p, -a_1p/a_2p,  (b_0p/a_2p)-(b_1p*a_0w)/(a_2p*a_1w);
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
t = 0:0.01:10;
vi = @(t) v_i0 .* (rampa(t-1) - rampa(t-4)) ./ 3;

% Resolver ecuaciones de estado
x0 = [0; 0; 0]; 
[t, X_prima] = ode45(@(t,x) A*x + B*vi(t), t, x0);

% Salidas 
psi = X_prima(:,1)* 180/pi;
psi_prima = X_prima(:,2);
omega = X_prima(:,3)* 60/(2*pi);

%% Graficar

f1 = figure(1);

plot(t, vi(t),"color",[0.4940 0.1840 0.5560]);
title("v_i");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$v_i(t)$", "Interpreter", "latex");
ylim([-1 28]);

% matlab2tikz('figurehandle', f1, 'width', '0.9\textwidth', ...
%     'height', '0.3\textheight', 'interpretTickLabelsAsTex', true, ...
%     './vi_pb.tex');

f2 = figure(2);

subplot(3,1,1);
plot(t, psi,"color",[0.4940 0.1840 0.5560]);
title("$\psi$", "Interpreter", "latex");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\psi(t)$", "Interpreter", "latex");

subplot(3,1,2);
plot(t, psi_prima,"color",[0.4940 0.1840 0.5560]);
title("$\dot{\psi(t)}$", "Interpreter", "latex");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\dot{\psi(t)}$", "Interpreter", "latex");

subplot(3,1,3);
plot(t, omega,"color",[0.4940 0.1840 0.5560]);
title("$\omega(t)$", "Interpreter", "latex");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\omega(t)$ (RPM)", "Interpreter", "latex");

% matlab2tikz('figurehandle', f2, 'width', '0.9\textwidth', ...
%     'height', '0.6\textheight', 'interpretTickLabelsAsTex', true, ...
%     './estado_pb.tex');