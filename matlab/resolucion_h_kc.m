%% Ejercio h obtencion kc
syms a3 a2 a1 a0 w kc  ;

%Obtener pz ordenado
Pz= (w+1)^4 + a3*(w+1)^3*(1-w) + (a2)*(w+1)^2 * (1-w)^2 + (a1) * (w + 1) * (1-w)^3  + (a0) * (1-w)^4 ;
Pz_ordenado= collect(Pz,w)
%valores numericos
ka= 100 ;
kst =  180/ pi;
a3 = -0.3895;
a2 = (0.0090*ka*kst*kc+0.5102) ;
a1 = (0.0058*ka*kst*kc-0.5673) ;
a0 = (-0.0038*ka*kst*kc);
% obtencion de b1
num_b_1= ((2*a1 - 4*a0 - 2*a3 + 4)*(6*a0 - 2*a2 + 6)-(a0 - a1 + a2 - a3 + 1)*(2*a3 - 2*a1 - 4*a0 + 4));
den_b_1= (2*a1 - 4*a0 - 2*a3 + 4);
b1= num_b_1/den_b_1;
%obtencion de b0
num_b0=(b1*(2*a3 - 2*a1 - 4*a0 + 4) - (2*a1 - 4*a0 - 2*a3 + 4)*( a0 + a1 + a2 + a3 + 1));
den_b0= (b1);
b0= num_b0/den_b0;

%reordenamos y simplificamos
simp_b1=collect(b1,kc)
simp_b0=collect(b0,kc)
%obtención de posibles kc
kcb1=double(solve(simp_b1,kc))
kcb0=double(solve(simp_b0,kc))

%prueba de kc que cumple con columna pivote
kc =0.0068; %aqui vamos provando kc caso kc<0.0069

w4=subs(a0 - a1 + a2 - a3 + 1)
w3=subs(2*a1 - 4*a0 - 2*a3 + 4)
b1=subs(b1)
b0=subs(b0)
w0=subs(a0 + a1 + a2 + a3 + 1)