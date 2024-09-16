parametros;
pregunta_a;
warning('off', 'symbolic:solve:SolutionsDependOnConditions');

%% Polos, ceros y ganancia DC
gdc_simb = limit(h_pv);  % Ganancia DC
p_simb   = poles(h_pv, s); % Polos 
z_simb   = solve(h_pv, s); % Ceros
