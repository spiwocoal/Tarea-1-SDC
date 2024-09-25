function sig_c = zoh(sig_d, t_d, t_c)
%ZOH Zero Order Hold
%   Aplica un retentor de orden cero a la señal discreta sig_d.
sig_c = zeros(size(sig_d));

idx1 = 1;
for idx2 = 1:length(t_c)
    if t_c(idx2) >= t_d(idx1+1)
        idx1 = idx1 + 1;
    end
    sig_c(idx2) = sig_d(idx1);
end

end