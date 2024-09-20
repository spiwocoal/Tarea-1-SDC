% Resolucion problema f
parametros;
constantes;
matrices;
 
T= 0.2; % Tiempo de muestreo

% Función para calcular la matriz A discreta
A_d = expm(A*T);

% Función para calcular la matriz B discreta
B_d_int = @(tau) expm(A*(T-tau)) * B;
B_d = integral(B_d_int, 0, T, 'ArrayValued', true);

% Matrices para salidas discretas
C_d1 = [1 0 0]; % psi
C_d3 = [0 0 1]; % omega

% Función de transferencia discreta psi
[nft_p , dft_p] = ss2tf(A_d ,B_d, C_d1, 0);
FT_d= tf(nft_p,dft_p,T);
disp('F. de T. discreta')
disp (FT_d)

% Valores propio de A_d
val_pro =eig(A_d);
disp('Valores propios de matriz Ad')
disp(val_pro)

% Para Calcular ganancia y luego v_i0
% Evaluar el polinomio del numerador y denominador en z = 1
num_z = polyval(FT_d.Numerator{1}, 1); 
den_z = polyval(FT_d.Denominator{1}, 1);  

% Ganancia DC discreta, psi_0 y v_i0
gdc_d =num_z/den_z;
psi_0 = pi/6;
v_i0 = psi_0 / gdc_d;

% Función de transferencia con salida omega(t)
[nft_w,dft_w]=ss2tf(A_d,B_d,C_d3,0);

% Tiempo de muestreo
t_dis= (0:T:10);

% Entrada v_i
v_i = @(k) v_i0 .* (rampa(k - 1 ) - rampa(k - 4)) / 3;

% Salidas
psi_d = filter(nft_p, dft_p, v_i(t_dis)) * 180/pi;
omega_d = filter(nft_w,dft_w,v_i(t_dis)).*60/(2*pi);

%Gráficos
f1 = figure(1);
subplot(3,1,1);
stem(t_dis, v_i(t_dis),'.green')
title("Voltaje del motor");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$v_i(kT)$", "Interpreter", "latex");
ylim([-1 28]);

subplot(3,1,2);
stem(t_dis, psi_d,'.red')
title("Ángulo de la bolita");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\psi(kT)$(grados)", "Interpreter", "latex");
ylim([-1 32]);

subplot(3,1,3);
stem(t_dis, omega_d,".","color",[0.4940 0.1840 0.5560])
title("Velocidad angular del anillo");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\omega(kT)$ (RPM)", "Interpreter", "latex");

if ~exist('exportar', 'var')
  exportar = false;
end

if exportar
  matlab2tikz('figurehandle', f1, 'width', '0.9\textwidth', 'height', '0.6\textheight', ...
    'interpretTickLabelsAsTex', true, './estado_pf.tex');
end