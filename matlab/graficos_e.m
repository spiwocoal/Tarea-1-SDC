sims_pregunta_e;

psi   = x_con(1,:) * 180/pi;
dpsi  = x_con(2,:) * 180/pi;
omega = x_con(3,:) * 60/(2*pi);

%% Graficar simulación
f1 = figure(1);

plot(t, psi, 'r', t, psi_d(t), 'r--');
title("Ángulo de referencia y la salida");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\psi$ (deg)", "Interpreter", "latex");

f2 = figure(2);

subplot(2,2,1);
plot(t, w_con);
title("Entrada al actuador");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$w$", "Interpreter", "latex");

subplot(2,2,2);
plot(t, v_icon);
title("$v_{i}(t)$", "Interpreter", "latex");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$v_{i}(t)$ (V)", "Interpreter", "latex");

subplot(2,2,3);
plot(t, dpsi);
title("$\dot{\psi}(t)$", "Interpreter", "latex");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\dot{\psi}(t)$ (deg/s)", "Interpreter", "latex");

subplot(2,2,4);
plot(t, omega);
title("$\omega(t)$", "Interpreter", "latex");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\omega(t)$ (RPM)", "Interpreter", "latex");

if ~exist('exportar', 'var')
  exportar = false;
end

if exportar
  matlab2tikz('figurehandle', f1, 'width', '0.9\textwidth', 'height', '0.3\textheight', ...
    'interpretTickLabelsAsTex', true, './psi_pd.tex');
  
  matlab2tikz('figurehandle', f2, 'width', '0.9\textwidth', 'height', '0.6\textheight', ...
    'interpretTickLabelsAsTex', true, './estado_pd.tex');
end
