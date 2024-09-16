pregunta_b_num;

%% Graficar simulación
f1 = figure(1);

plot(t, vi(t));
title("v_i");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$v_i(t)$ (V)", "Interpreter", "latex");
ylim([-1 28]);

f2 = figure(2);

subplot(3,1,1);
plot(t, psi_sim);
title("$\psi$", "Interpreter", "latex");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\psi(t)$ (deg)", "Interpreter", "latex");

subplot(3,1,2);
plot(t, dpsi_sim);
title("$\dot{\psi(t)}$", "Interpreter", "latex");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\dot{\psi(t)}$ (deg/s)", "Interpreter", "latex");

subplot(3,1,3);
plot(t, omega_sim);
title("$\omega(t)$", "Interpreter", "latex");
xlabel("Tiempo (s)", "Interpreter", "latex");
ylabel("$\omega(t)$ (RPM)", "Interpreter", "latex");

if ~exist('exportar', 'var')
  exportar = false;
end

if exportar
  matlab2tikz('figurehandle', f1, 'width', '0.9\textwidth', 'height', '0.3\textheight', ...
    'interpretTickLabelsAsTex', true, './vi_pb.tex');
  
  matlab2tikz('figurehandle', f2, 'width', '0.9\textwidth', 'height', '0.6\textheight', ...
    'interpretTickLabelsAsTex', true, './estado_pb.tex');
end
