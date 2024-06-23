clc;
% Zadanie 1 -  DFT sygnału harmonicznego
clear all; close all;


% Dane
N = 100;    % liczba probek
fs = 1000;  % czestotliwosc probkowania
st = 1/fs;  % krok próbkowania
T = 0.1;    % czas trwania probkowania (100 probek dla 1000Hz = 0.1s)

sample = 0:st:T-st; % przedział czasowy próbkowania

%  Częstotliwości
f1 = 100;
f2 = 200;

% Amplitudy 
A1 = 100;
A2 = 200;

% Kąty fazowe
p1 = (pi/7);
p2 = (pi/11);

% Tworzenie sygnału z sumy sinusów 
s1 = @(t) A1 * cos(2*pi*f1*t + p1);
s2 = @(t) A2 * cos(2*pi*f2*t + p2);

% Sygnał x z sumy sinusów 
x = s1(sample) + s2(sample);

figure(2);
subplot(2,1,1);
hold all;
plot(s1(sample), 'r-o');
plot(s2(sample), 'b-o');
title('Dwa cosinusy');
legend('s1 100Hz','s2 200Hz');
xlabel('Numer próbki');

subplot(2,1,2);
plot(x, 'r-o')
title('Zsumowane cosinusy');
legend('s1 + s2');
xlabel('Numer próbki');
pause;
% Generowanie macierzy A - macierzy transformacji DFT
% W = exp(1i*2*pi/N)

for k = 1:N
    for n = 1:N
        A(k,n) = (1/sqrt(N)) * ((exp(1i*2*pi/N)) ^ (-(k-1)*(n-1)));
    end
end

% Dyskretna transformata Fouriera - DFT
X = A * x';

% Rysowanie widma y sygnału x
XRe = real(X);   % część rzeczywista
XIm = imag(X);   % część urojona
Amplitude  = abs(X);    % moduł
phase  = angle(X) .* (abs(X)>1);  % faza

% Skalowanie osi częstotliwości w Herzach
f = (0:N-1)*fs/N;

figure(3);
subplot(2,1,1);
stem(f,XRe, 'b-o');
title('Re');
xlabel('Częstotliwość [Hz]');

subplot(2,1,2);
stem(f, XIm, 'r-o');
title('Im');
xlabel('Częstotliwość [Hz]');
pause;

figure(4);
subplot(2,1,1);
stem(f, Amplitude, 'b-o');
title('A');
xlabel('Częstotliwość [Hz]');

subplot(2,1,2);
stem(f, phase, 'r-o');
title('ϕ');
xlabel('Częstotliwość [Hz]');
pause;

% Wyznaczanie B - macierzy rekonstrukcji macierzy A
B = A';
xrcnst = B * X;

figure(5);
subplot(2,1,1);
plot(real(xrcnst), 'b-o');
title('Sygnał zrekonstruowany x');
xlabel('Numer próbki');

subplot(2,1,2);
plot(x, 'r-o');
title('Sygnal oryginalny x');
xlabel('Numer próbki');
pause;

% Sprawdzenie czy transformata posiada 
% właściwość perfekcyjnej rekonstrukcji
err1 = max(max(abs(x'-xrcnst)));
fprintf('Klasyczna rekonstrukcja sygnału z błędem:  %u\n', err1)

% Zastąpienie operacji X = Ax przez X = fft(x) (transformata fouriera)
% Zastąpienie operacji Xrcnst = BX przez Xrcnst = ifft(X) (odwrotna
% transformata fouriera)
X = fft(x);
xrcnst = ifft(X);

% Sprawdzenie czy transformata posiada 
% właściwość perfekcyjnej rekonstrukcji
err2 = max(max(abs(x-xrcnst)));
fprintf('Rekonstrukcja sygnału przez iftt z błędem:  %u\n', err2)

fprintf('Różnica w rekonstrukcjach sygnału: %u\n', err2/err1)
pause;

% Zmiana f1 na 125Hz
f1 = 125;
s1 = @(t) A1 * cos(2*pi*f1*t + p1);
x = s1(sample) + s2(sample);

figure(6);
subplot(2,1,1);
hold all;
plot(s1(sample), 'r-o');
plot(s2(sample), 'b-o');
title('Dwa cosinusy do sumowania');
legend('s1 125Hz','s2 200Hz');
xlabel('Numer próbki');

subplot(2,1,2);
plot(x, 'r-o')
title('Zsumowane cosinusy');
legend('s1 + s2');
xlabel('Numer próbki');
pause;

% Dyskretna transformata Fouriera - DFT
X = A * x';

% Rysowanie widma y sygnału x
XRe = real(X);   %część rzeczywista
XIm = imag(X);   %część urojona
Amplitude  = abs(X);    %moduł
phase  = angle(X);  %faza

% Skalowanie osi częstotliwości w Herzach
f = (0:N-1)*fs/N;

figure(7);
subplot(2,1,1);
stem(f,XRe, 'b-o');
title('Re');
xlabel('Częstotliwość [Hz]');

subplot(2,1,2);
stem(f, XIm, 'r-o');
title('Im');
xlabel('Częstotliwość [Hz]');
pause;

figure(8);
subplot(2,1,1);
stem(f, Amplitude, 'b-o');
title('A');
xlabel('Częstotliwość [Hz]');

subplot(2,1,2);
stem(f, phase, 'r-o');
title('ϕ');
xlabel('Częstotliwość [Hz]');
pause;


