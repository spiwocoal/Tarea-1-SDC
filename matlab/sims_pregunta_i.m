matrices;
psi_0 = 30 * pi/180;
T = 200e-3;

% Matriz A discreta
A_d = expm(A*T);

% Matriz B discreta
B_d_int = @(tau) expm(A*(T-tau)) * B;
B_d = integral(B_d_int, 0, T, 'ArrayValued', true);

C = [1 0 0];

%% Ganancias del sistema
k_st = 180/pi; k_a = 100; k_c = 4e-3;

%% Simulación
t  = 0:T:10;        % Tiempo de simulación
psi_d = psi_0 .* k_st .* (rampa(t - 1) - rampa(t - 4)) ./ 3; % Referencia

cnt = tf(k_c, [1 -1], T); % Controlador
ret = tf(1, [1 0], T); % Retardo
sys = ss(A_d, B_d, C, 0, T);
LaD = cnt * ret * k_a * sys; % Lazo directo

LaC = LaD / (1 + k_st*LaD); % Lazo cerrado

psi = lsim(LaC, psi_d, t); % Salida del sistema
psi_m = k_st * psi; % Salida medida

err = psi_d' - psi_m; % Error del controlador
w = lsim(cnt*ret, err, t); % Entrada al actuador
v_i = w * k_a; % Voltaje del motor

tt = linspace(0, 10, 1e4);
sys_c = ss(A, B, C, 0);
v_ic = zoh(v_i, t, tt);

[~, ~, x] = lsim(sys_c, v_ic, tt); % Variables de estado