% Lab 9, zadanie 2b - Kasowanie echa
clear all; close all;
%% ladowanie sygnalow
[sA,fs1]=audioread('mowa_1.wav');   %glos A - niemozliwy do zarejestrowania, referencja -> macierz z próbkami audio i częstotliwość próbkowania
[sB,fs2]=audioread('mowa_2.wav');   %glos B
[sAG,fs3]=audioread('mowa_3.wav');  %glos osoby A zaszumiony g�osem B
sA = sA';
aB = sB';
sAG = sAG';
d = sAG; %Osoba B "zaszumiona" A
x = sB; %Osoba B
dref = sA;%Osoba A

fs = length(sA)-1;
t = 0:1/fs:1;

%% Budowa filtra 
M = 0; %18 % długość filtru 
mi = 0;%0.275 % współczynnik szybkości adaptacji -> współczynnik uczenia
snrMAX = 0;
Mbest = 0;
miBest = 0;
filtered_signal = [];
for M = 1:10
    for mi = 0.01:0.05:0.1

        y = []; e = []; % sygnały wyjściowe z filtra
        bx = zeros(M,1); % bufor na próbki wejściowe x
        h = zeros(M,1); % początkowe (puste) wagi filtru

        %% Filtracja 
        for n = 1 : length(x)
            bx = [ x(n); bx(1:M-1) ]; % pobierz nową próbkę x[n] do bufora
            y(n) = h' * bx; % oblicz y[n] = sum( x .* bx) z filtr FIR -> iloczyn wag i bufora bx  -> wyjście filtru
            e(n) = d(n) - y(n); % oblicz e[n]-> błąd obliczamy jako różnica między sygnałem odniesienia a wyjściem filtra
            h = h + mi * e(n) * bx; % LMS -> aktualizujemy wagi filtra zgodnie z regułą LMS -> optymalizujemy
        end

        %Y - sygnał osoby B
        %E - sygnał osoby a
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
%% odsluch po przejsciu przez filtr
soundsc(filtered_signal,fs1) %e - sygnal odszumiony
pause;
soundsc(sA, fs1); pause;
soundsc(sB, fs2); pause;
soundsc(sAG, fs3);

%% wykresy
figure(1);
plot(t,dref);
title("Sygnal czysty");
figure(2);
plot(t,d);
title("Sygnal zaszumiony (2 osoby)");
figure(3);
plot(t,filtered_signal);
title("Sygnal odszumiony Po odzyskaniu");

figure(4);
plot(t,dref,t,d,t,filtered_signal);
title('ox - czas, oy - amplituda');
legend('Sygnal czysty','Zaszumiony (2 osoby)','Po odzyskaniu (druga pani przyciszona)');

% Algorytm LMS (Least Mean Squares) to jeden z najczęściej stosowanych algorytmów 
% adaptacyjnych w dziedzinie cyfrowego przetwarzania sygnałów. 
% Jego głównym zadaniem jest minimalizacja średniego kwadratu błędu między sygnałem odniesienia 
% a sygnałem wyjściowym filtra adaptacyjnego. 
% Działa on na zasadzie stopniowego dostosowywania współczynników filtra FIR (Finite Impulse Response) 
% w celu zmniejszenia różnicy (błędu) między sygnałem odniesienia a filtrowanym sygnałem.

%% Długośc filtra
% Dłuższa długośc filtra - większa złożoność obliczeniowa i dłuższy czas
% konwergencji, filtr się wolniej dostosowywuje (stabilizacji współczynników i minimalizacji błędów)

% Krótsza długośc filtra - krótsza konweregencja i mniejsza złożoność
% obliczeniowa, mniej współczynników do dostosowania (mniejsza dokładność)

%% Współczynnik adaptacji mi
% krok adaptacji, kontroluje szybkość, z jaką algorytm LMS dostosowuje swoje współczynniki filtra.
% Jest to kluczowy parametr, który wpływa na stabilność i szybkość konwergencji algorytmu.

% Mały współczynnik - powolne zmiany współczynników filtra, zwiększa
% stabilność ale wolniejsza konwergencja - słabsze dostosowywanie się

% Duży współczynnik - szybkie zmiany współczynników, mniejsza stabliność
% (współczynniki filtra mogą nadmiernie oscylować, zmieniają się w
% niekontrolowany sposób) (zwiększona podatność na zakłócenia)