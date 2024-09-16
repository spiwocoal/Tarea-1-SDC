%% Cargar parámetros y F.d.T. dadas
parametros;

%% Pregunta a)

% F.d.T. entre psi y v_i
h_pv = h_wv * h_pw;
disp('Función de transferencia entre \psi y v_i')
pretty(h_pv);

% Ecuaciones de estado
A_sym = [0, 1, 0;
    -a_0p/a_2p, -a_1p/a_2p,  (b_0p/a_2p)-(b_1p*a_0w)/(a_2p*a_1w);
    0, 0, -a_0w/a_1w];
B_sym = [0; (b_1p*b_0w)/(a_2p*a_1w); b_0w/a_1w];
C = [1, 0, 0];

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

gdc = double(subs(gdc_sym));
disp('Ganancia DC:');
disp(gdc);
p = double(subs(p_sym));
disp('Polos:');
disp(p);
z = double(subs(z_sym));
disp('Ceros:');
disp(z);

% Entrada estado estacionario
psi_0 = pi/6;
v_i0 = double(psi_0 / gdc); % Ganancia DC es ganancia en estado estacionario
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
psi_prima = X_prima(:,2)*180/pi;
omega = X_prima(:,3)* 60/(2*pi);

% Graficar
f1 = figure(1);

plot(t, vi(t),"color",[0.4940 0.1840 0.5560]);
title("v_i");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$v_i(t)$", "Interpreter", "latex");
ylim([-1 28]);

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

% matlab2tikz('figurehandle', f1, 'width', '0.9\textwidth', 'height', '0.3\textheight', ...
% 'interpretTickLabelsAsTex', true, './vi_pb.tex');

% matlab2tikz('figurehandle', f2, 'width', '0.9\textwidth', 'height', '0.6\textheight', ...
% 'interpretTickLabelsAsTex', true, '.estado_pb.tex');

%% Pregunta c)

k_st = 180/pi; k_a = 100; k_c = 10e-3;

psi_d = @(t) psi_0 .* k_st .* (rampa(t-1) - rampa(t-4)) ./ 3;
% psi_d = @(t) psi_0 .* k_st .* (u(t-2));
t = linspace(0, 10, 1e6);
dt = (t(end) - t(1)) / length(t);

psi_c   = zeros(length(t), 1);
dpsi_c  = zeros(length(t), 1);
omega_c = zeros(length(t), 1);
w_c     = zeros(length(t), 1);
v_ic    = zeros(length(t), 1);

e = zeros(length(t), 1);

x = [0; 0; 0];

for i = 1:length(t)-1
    err = psi_d(t(i)) - k_st * x(1);

    w = err * k_c;
    v_i = w * k_a;
    dx = A * x + B * v_i;
    
    x = x + dt * dx;
    
    e(i) = err;
    psi_c(i+1) = x(1);
    dpsi_c(i+1) = x(2);
    omega_c(i+1) = x(3);
    w_c(i+1) = w;
    v_ic(i+1) = v_i;
end

figure(3)
subplot(3,1,1)
plot(t, k_st*psi_c, 'r', t, psi_d(t), 'r--');
subplot(3,1,2)
plot(t, k_st*dpsi_c);
subplot(3,1,3)
plot(t, omega_c*60/(2*pi));
