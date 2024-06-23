function [,] = find_params(,)
%% Budowa filtra 
M = 7; %18 % d³ugoæ filtru
mi = 0.5;%0.275 % wspó³czynnik szybkoci adaptacji
snrMAX = 0;
Mbest = 0;
miBest = 0;
filtered_signal = [];
for M = 1:100
    for mi = 0.01:0.05:0.5

        y = []; e = []; % sygna³y wyjciowe z filtra
        bx = zeros(M,1); % bufor na próbki wejciowe x
        h = zeros(M,1); % pocz¹tkowe (puste) wagi filtru

        %% Filtracja 
        for n = 1 : length(x)
            bx = [ x(n); bx(1:M-1) ]; % pobierz now¹ próbkê x[n] do bufora
            y(n) = h' * bx; % oblicz y[n] = sum( x .* bx)  filtr FIR
            e(n) = d(n) - y(n); % oblicz e[n]
            h = h + mi * e(n) * bx; % LMS
            % h = h + mi * e(n) * bx /(bx'*bx); % NLMS
        end


        %% SNR
        SNR = 10*log10(sum(dref .* dref)/sum((dref - e) .^ 2));
        
        if SNR > snrMAX 
           snrMAX = SNR;
           Mbest = M;
           miBest = mi;        
           filtered_signal = e;
        end

    end
end
Mbest,
mi,
end

