function [] = print_tf(tr_fn,var)
%PRINT_TF Summary of this function goes here
%   Detailed explanation goes here
old_FPO = sympref('FloatingPointOutput');
sympref('FloatingPointOutput', true);

num = round(cell2mat(tr_fn.Numerator), 4);
den = round(cell2mat(tr_fn.Denominator), 4);

num_sym = poly2sym(num, var);
den_sym = poly2sym(den, var);
tf_sym = num_sym / den_sym;

pretty(tf_sym);
sympref('FloatingPointOutput', old_FPO);
end

