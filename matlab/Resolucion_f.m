%resolucion problema f
% Definición de parámetros
r_b = 9.53e-3; r = 9.3e-3; g = 9.8;
G = 17.5e-3; H = 67.5; m = 28.2e-3;
R = 87.5e-3; b_b = 4.57e-6; tau = 0.66;

b_0w = G; a_1w = tau; a_0w = 1;b_1p = H*(2/5)*(r_b/r)^2;
b_0p = H*b_b/(m*r^2); a_2p = (2/5)*(r_b/r)^2+1; a_1p = b_b/(m*r^2);
a_0p = g/R; 
T= 0.2; %tiempo T

%Funcion Rampa 
rampa = @(t) (t >= 0).*t;

%Matrices Continuas 
A_c = [0, 1, 0;   -a_0p/a_2p, -a_1p/a_2p, (b_0p/a_2p)-(b_1p*a_0w)/(a_2p*a_1w);
    0, 0, -a_0w/a_1w];
B_c = [0; (b_1p*b_0w)/(a_2p*a_1w); b_0w/a_1w];
C = [1, 0, 0];
D=0;

% Función para calcular la matriz A discreta
A_d = expm(A_c*T);

% Función para calcular la matriz B discreta
B_d_int = @(tau) expm(A_c*(T-tau)) * B_c;
B_d = integral(B_d_int, 0, T, 'ArrayValued', true);

%matrices para salidas discretas
C_d1= C; %psi
C_d3=[0 0 1]; %omega

%Función de Traferencia Discreta psi
[nft_p , dft_p] = ss2tf(A_d ,B_d, C_d1, D);
FT_d= tf(nft_p,dft_p,T);
disp('F. de T. discreta')
disp (FT_d)

%valores propio de A_d
val_pro =eig(A_d);
disp('Valores propios de matris Ad')
disp(val_pro)

%Para Calcular ganancia y luego v_i0
%Evaluar el polinomio del numerador y denominador en z = 1
num_z = polyval(FT_d.Numerator{1}, 1); 
den_z = polyval(FT_d.Denominator{1}, 1);  

%ganancia discreta, psi_0 y v_i0
gdc_d =num_z/den_z;
psi_0 = pi/6;
v_i0 = psi_0 / gdc_d;

% Función de transferencia con salida omega(t)
[nft_w,dft_w]=ss2tf(A_d,B_d,C_d3,D);

%tiempo muestreo
t_dis= (0:T:10);

%Entrada v_i
v_i = @(k) v_i0 .* (rampa(k - 1 ) - rampa(k - 4)) / 3;

%Salidas
psi_d = filter(nft_p, dft_p, v_i(t_dis)) * 180/pi;
omega_d = filter(nft_w,dft_w,v_i(t_dis)).*60/(2*pi);

%Gráficos
subplot(3,1,1);
stem(t_dis, v_i(t_dis),'.green')
title('Entrada v_i(kT)');
title("$v_i(kT)$", "Interpreter", "latex");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$v_i(kT)$", "Interpreter", "latex");
ylim([-1 28]);

subplot(3,1,2);
stem(t_dis, psi_d,'.red')
title("$\psi(kT)$", "Interpreter", "latex");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\psi(kT)$(grados)", "Interpreter", "latex");
ylim([-1 32]);

subplot(3,1,3);
stem(t_dis, omega_d,".","color",[0.4940 0.1840 0.5560])
title("$\omega(kT)$ (rpm) ", "Interpreter", "latex");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\omega(kT)$ (RPM)", "Interpreter", "latex");
