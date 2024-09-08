% Archivo: tfd_numerica.m

function tf = tfd_numerica(func,T,N)
%TFD Calcula la Transformada de Fourier Discreta
% de una funcion para un valor de m
    function tf_numerica = tf_numerica(m)
        tf_numerica = 0;
        for k = 0:(N-1)
            tf_numerica = tf_numerica +  ...
                func(k*T) .* exp(-1i.*m.*k.*2.*pi./N);
        end
        tf_numerica = tf_numerica ./ N;
    end
    tf = @(m) tf_numerica(m);
end