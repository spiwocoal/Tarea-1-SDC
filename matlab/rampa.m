function [y] = rampa(tt)
%RAMPA Funcion rampa
y = tt;
y(tt < 0) = 0;
end