function [y] = r(tt)
%R Funcion rampa
y = tt;
y(tt < 0) = 0;
end