close all; 
clear all;

%% DANE 
fs  = 8000;     %czestotliwosc probkowania
t = 0:1/fs:1;
A1 = -0.5;      %amplitudy zadane
A2 = 1;
f1 = 34.2;
f2 = 115.5;

% filtry adaptayjne - zostawiają w sygnale tylko te próbki których kolejne
% dają się przewidzieć. Czyli składowe sinusoidalne/deterministyczne
% w filtrze odejmujemy próbki sygnału od sygnału referencyjnego i wynik traktujemy jako błąd,
% co powoduje przestrajanie filtra żeby minimalizować różnicę, upodobnić y do y - referencyjnego

%% sygnal czysty do porownania - referencyjny
dref = A1*cos(2*pi*f1*t) + A2*cos(2*pi*f2*t);
%% awgn 10dB

d = awgn(dref, 10, 'measured'); 
%dref, snr (im mniejszy snr tym wiekszy szum i bardziej postrzępiony wykres)
x = [ d(1) d(1:end-1) ];    %sygnał filtrowany - opóźniony

M = 100;                    
% długości filtru i wspł. szybkjośći adaptacji  wyznaczone metodą prób i błędów 
% Im dłuższy filtr tym większa dokładność, ale potrzeba więcej czasu na
% odwzorowanie 

% mi = 0.01;
mi = 0.01;
% współczynnik szybkości adaptacji
% im większy, tym filtr szybciej się adaptuje, nie możemy przesadzić, bo
% sygnał zacznie się adaptować do szumu zamiast sygnału referencyjnego
% im mniejszy tym filtr będzie się wolniej zmieniał (adapptował)


y = [];             %sygnały wyjściowe z filtra
e = [];            
bx = zeros(M,1);    %bufor na próbki sygnału wejściowego
h = zeros(M,1);     %początkowe (puste) wagi filtru

for n = 1 : length(x)
    bx = [ x(n); bx(1:M-1) ];   %pobierz nowe próbki x[n] do bufora
    y(n) = h' * bx;             %oblicz y[n] = sum( x .* bx) - filtr FIR
    e(n) = d(n) - y(n);         %oblicz e[n]
    h = h + mi * e(n) * bx;     %LMS
    % To jest krok adaptacji wag filtru. W algorytmie LMS, 
    % wagi są aktualizowane proporcjonalnie do iloczynu błędu e(n) i wektora bufora bx, 
    % pomnożonego przez współczynnik uczenia mi. 
    % To prowadzi do iteracyjnej optymalizacji wag filtru w kierunku minimalizacji błędu kwadratowego.
    % h = h + mi * e(n) * bx /(bx'*bx); % NLMS
end

%% awgn 20dB
d2 = awgn(dref, 20, 'measured'); 
x2 = [ d2(1) d2(1:end-1) ]; 
M2 = 100; 
mi2 = 0.01; 

y2 = []; e2 = []; 
bx2 = zeros(M2,1); 
h2 = zeros(M2,1); 

for m = 1 : length(x2)
    bx2 = [ x2(m); bx2(1:M2-1) ]; 
    y2(m) = h2' * bx2; 
    e2(m) = d2(m) - y2(m);
    h2 = h2 + mi2 * e2(m) * bx2; 
    % h2 = h2 + mi2 * e2(m) * bx2 /(bx2'*bx2); % NLMS
end

%%awgn 40dB
% za długo się dostosowuje i za mało próbek żeby osiągnąć wartość SNR koło 40
d4 = awgn(dref, 40,'measured'); 
x4 = [ d4(1) d4(1:end-1) ]; 
M4 = 100; 
mi4 = 0.01; 

y4 = []; e4 = []; 
bx4 = zeros(M4,1); 
h4 = zeros(M4,1); 

for j = 1 : length(x4)
    bx4 = [ x4(j); bx4(1:M4-1) ]; 
    y4(j) = h4' * bx4; 
    e4(j) = d4(j) - y4(j); 
    h4 = h4 + mi4 * e4(j) * bx4; 
    % h4 = h4 + mi4 * e4(j) * bx4 /(bx4'*bx4); % NLMS
end

%% wykresy
% Wykres SNR 10dB
figure(1);
subplot(3,1,1);
plot(t,dref);
title('Sygnał czysty - SNR 10dB');

subplot(3,1,2);
plot(t,d,'r');
title('Sygnał zaszumiony - SNR 10dB');

subplot(3,1,3);
plot(t,y,'g');
title('Sygnał odszumiony - SNR 10dB');

% Wykres SNR 20dB
figure(2);
subplot(3,1,1);
plot(t,dref);
title('Sygnał czysty - SNR 20dB');

subplot(3,1,2);
plot(t,d2,'r');
title('Sygnał zaszumiony - SNR 20dB');

subplot(3,1,3);
plot(t,y2,'g');
title('Sygnał odszumiony - SNR 20dB');

% Wykres SNR 40dB
figure(3);
subplot(3,1,1);
plot(t,dref);
title('Sygnał czysty - SNR 40dB');

subplot(3,1,2);
plot(t,d4,'r');
title('Sygnał zaszumiony - SNR 40dB');

subplot(3,1,3);
plot(t,y4,'g');
title('Sygnał odszumiony - SNR 40dB');

%% SNR
SNR10 = 10*log10((1/fs*sum(dref.^2))/(1/fs*sum((dref-y).^2)));
display(SNR10);

SNR20 = 10*log10((1/fs*sum(dref.^2))/(1/fs*sum((dref-y2).^2)));
display(SNR20);

SNR40 = 10*log10((1/fs*sum(dref.^2))/(1/fs*sum((dref-y4).^2)));
display(SNR40);
