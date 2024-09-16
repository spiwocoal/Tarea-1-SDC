pregunta_b_simb;
constantes;
matrices;

%% Polos, ceros y ganancia DC
gdc = double(subs(gdc_simb)); % Ganancia DC 
p = double(subs(p_simb));     % Polos       
z = double(subs(z_simb));     % Ceros       

%% Estado estacionario
psi_0   = 30 * pi/180;
v_i0    = psi_0 / gdc;

%% Simulación
tspan = [0 10];
vi = @(t) v_i0 .* (rampa(t - 1) - rampa(t - 4)) ./ 3;

x0 = [0; 0; 0];
[t, dx] = ode45(@(t,x) A*x + B*vi(t), tspan, x0);

% Variables de estado
psi_sim   = dx(:,1) * 180/pi;    % En grados
dpsi_sim  = dx(:,2) * 180/pi;    % En grados/s
omega_sim = dx(:,3) * 60/(2*pi); % En RPM
