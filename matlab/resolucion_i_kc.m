%% Ejercicio i obtencion kc
syms a4 a3 a2 a1 a0 w kc  ;

%Obtener pz ordenado
Pz= (w+1)^5 + a4*((w+1)^4)*(1-w) + a3*((w+1)^3)*(1-w)^2 + (a2)*(w+1)^2 * (1-w)^3 + (a1) * (w + 1) * (1-w)^4  + (a0) * (1-w)^5 ;
Pz_ordenado = collect(Pz,w); disp(Pz_ordenado);

%valores numericos
ka = 100; kst = 180/ pi;
%cambios de variables
a4 = - 1.3895; a3 = 0.8998;
a2 = (0.009*kc*ka*kst-1.0775); a1 = (0.0058*kc*ka*kst+0.5673);
a0 = (-0.0038*kc*ka*kst);

A5 = (a1-a0-a2+a3-a4+1); A4 = (5*a0-3*a1+a2+a3-3*a4+5);
A3 = (2*a1-10*a0+2*a2-2*a3-2*a4+10);
A2 = (10*a0+2*a1-2*a2-2*a3+2*a4+10);
A1 = (a3-3*a1-a2-5*a0+3*a4+5); A0 = (a0+a1+a2+a3+a4+1);
% obtencion b3
num_b_3 = A4*A3 - A5*A2; den_b_3 = A4;
b3 = num_b_3/den_b_3;
% obtencion de b2
num_b_2 = A4*A1 -A5*A0; den_b_2 = A4;
b2 = num_b_2/den_b_2;
%obtencion de b1
num_b1 = b3*A2 - A4*b2; den_b1 = (b3);
b1= num_b1/den_b1;
%obtención de b0
num_b0 = b1*b2 - b3*A0; den_b0 = (b1);
b0= num_b0/den_b0;
%reordenamos y simplificamos
simp_b3=collect(b3,kc); disp(simb_b3);
simp_b2=collect(b2,kc); disp(simb_b2);
simp_b1=collect(b1,kc); disp(simb_b1);
simp_b0=collect(b0,kc); disp(simb_b0);
%obtención de posibles kc
kcb3=double(solve(simp_b3,kc)); disp(kcb3);
kcb2=double(solve(simp_b2,kc)); disp(kcb2);
kcb1=double(solve(simp_b1,kc)); disp(kcb1);
kcb0=double(solve(simp_b0,kc)); disp(kcb0);