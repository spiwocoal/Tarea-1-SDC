function [y] = impulso(tt)
%IMPULSO Funcion impulso
y = zeros(size(tt));
y(tt == 0) = inf;
end

