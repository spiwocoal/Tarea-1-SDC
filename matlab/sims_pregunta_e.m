matrices;
psi_0   = 30 * pi/180;

%% Ganancias del sistema
k_st = 180/pi; k_a = 100; k_c = 10e-3;

%% Referencia
psi_d = @(t) psi_0 .* k_st .* (rampa(t - 1) - rampa(t - 4)) ./ 3;

%% Simulación
t  = linspace(0, 10, 1e4);        % Tiempo de simulación
dt = (t(end) - t(1)) / length(t); % Paso de integración

x_con  = zeros(3, length(t));
w_con  = zeros(1, length(t));
v_icon = zeros(1, length(t));

err_t = zeros(1, length(t));

for i = 1:length(t) - 1
  t_ac = t(i);       % Instante de tiempo actual
  x    = x_con(:,i); % Variables de estado en el instante previo 

  psi_m = k_st * x(1); % Ángulo medido
  err = psi_d(t_ac) - psi_m;
  err_t(i) = err;

  w   = trapz(dt, err_t(1:i), 2) * k_c;
  v_i = w * k_a;
  dx  = A * x + B * v_i;
  
  x_con(:,i+1) = x + dt * dx;
  w_con(i+1)   = w;
  v_icon(i+1)  = v_i;
end