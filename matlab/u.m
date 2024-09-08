function [y] = u(tt)
%U Funcion escalon
y = zeros(size(tt));
y(tt >= 0) = 1;
end