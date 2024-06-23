% Lab 9, zadanie 2b - Kasowanie echa
clear all; close all;
%% £adowanie sygna³ów
[sA,fs1]=audioread('mowa_1.wav');   %glos A - niemo¿liwy do zarejestrowania, referencja
[sB,fs2]=audioread('mowa_2.wav');   %glos B
[sAG,fs3]=audioread('mowa_3.wav');  %glos osoby A zaszumiony g³osem B
sA = sA';
aB = sB';
sAG = sAG';
d = sAG; %Osoba B "zaszumiona" A
x = sB; %Osoba B
dref = sA;%Osoba A

fs = 38527;
t = 0:1/fs:1;

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
miBest,
%% odsluch po przejsciu przez filtr
pause;
soundsc(filtered_signal,fs1) %e - sygnal odszumiony
pause;
soundsc(sA, fs1); pause;
soundsc(sB, fs2); pause;
soundsc(sAG, fs3);




%% wykresy
figure(1);
subplot(3,1,1);
plot(t,dref);
title("Sygnal czysty");
subplot(3,1,2);
plot(t,d);
title("Sygnal zaszumiony (2 osoby)");
subplot(3,1,3);
plot(t,filtered_signal);
title("Sygnal odszumiony Po odzyskaniu");
legend('Sygnal czysty','Zaszumiony (2 osoby)','Po odzyskaniu (druga pani przyciszona)');

figure(4);
plot(t,dref,t,d,t,filtered_signal);
title('ox - czas, oy - amplituda');
legend('Sygnal czysty','Zaszumiony (2 osoby)','Po odzyskaniu (druga pani przyciszona)');