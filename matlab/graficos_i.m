sims_pregunta_i2;

dpsi  = x(:,2) * 180/pi;
omega = x(:,3) * 60/(2*pi);

%% Graficar simulación
f1 = figure(1);

stem(t, psi_m, 'r');
hold on
stem(t, psi_d, 'r.--')
title("Ángulo de referencia y la salida obtenida");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\psi$ (deg)", "Interpreter", "latex");
legend('medido', 'referencia');
%ylim([0 32])
hold off

f2 = figure(2);

subplot(2,2,1);
stem(t, w, 'b.');
title("Entrada al actuador");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$w$", "Interpreter", "latex");

subplot(2,2,2);
stem(t, v_i, 'g.');
title("Voltaje del motor");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$v_{i}(t)$ (V)", "Interpreter", "latex");

subplot(2,2,3);
stem(t, dpsi, 'r.');
title("Velocidad angular de la bolita");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\dot{\psi}(t)$ (deg/s)", "Interpreter", "latex");

subplot(2,2,4);
stem(t, omega, '.');
title("Velocidad angular del anillo");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\omega(t)$ (RPM)", "Interpreter", "latex");

if ~exist('exportar', 'var')
  exportar = false;
end

if exportar
  matlab2tikz('figurehandle', f1, 'width', '0.9\textwidth', 'height', '0.3\textheight', ...
    'interpretTickLabelsAsTex', true, './psi_pi.tex');
  
  matlab2tikz('figurehandle', f2, 'width', '0.9\textwidth', 'height', '0.6\textheight', ...
    'interpretTickLabelsAsTex', true, './estado_pi.tex');
end
