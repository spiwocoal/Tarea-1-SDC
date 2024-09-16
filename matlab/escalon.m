function [y] = escalon(tt)
%ESCALON Funcion escalon
y = zeros(size(tt));
y(tt >= 0) = 1;
end
