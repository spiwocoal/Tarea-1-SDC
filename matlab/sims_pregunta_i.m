matrices;
psi_0 = 30 * pi/180;
T = 200e-3;

% Matriz A discreta
A_d = expm(A*T);

% Matriz B discreta
B_d_int = @(tau) expm(A*(T-tau)) * B;
B_d = integral(B_d_int, 0, T, 'ArrayValued', true);

%% Ganancias del sistema
k_st = 180/pi; k_a = 100; k_c = 4e-3;

%% Referencia
psi_d = @(t) psi_0 .* k_st .* (rampa(t - 1) - rampa(t - 4)) ./ 3;

%% Simulación
t  = 0:T:10;        % Tiempo de simulación

x_con  = zeros(3, length(t));
w_d = zeros(1, length(t));
w_con  = zeros(1, length(t));
v_icon = zeros(1, length(t));

err_t = zeros(1, length(t));

for i = 1:length(t) - 1
  t_ac = t(i);       % Instante de tiempo actual
  x = x_con(:,i);  % Variables de estado en el instante previo 

  psi_m = k_st * x(1); % Ángulo medido
  err = psi_d(t_ac) - psi_m;
  err_t(i) = err;

  w = trapz(T, err_t(1:i), 2) * k_c;
  v_i = w_con(i) * k_a; % Se utiliza valor previo debido a retardo por calculos
  
  x_con(:,i+1) = A_d * x + B_d * v_i;
  w_con(i+1)   = w; % Se almacena el valor de w calculado para la proxima iteración
  v_icon(i+1)  = v_i;
end