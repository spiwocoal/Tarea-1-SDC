function [y] = delta(tt)
%DELTA Funcion impulso
y = zeros(size(tt));
y(tt == 0) = inf;
end

