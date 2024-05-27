% przykład 15.1: Demonstracja kodowania podpasmowego

clc; clear; close all
[x,Fs] = audioread('DontWorryBeHappy.wav'); 	% Wczytanie sygnału z pliku wav
x = x(:,2);
x = x(1:6000);
soundsc(x,Fs)                           % odsłuchanie
figure(1)
specgram(x,2048,Fs,2000)                % demonstracja spektrogramu
title('Sygnał oryginalny')
pause;

% Zakodowanie koderem podpasmowym z użyciem 8 podpasm i 6 bitów na próbkę
% UWAGA: przed skwantowaniem każde pasmo jest normalizowane do zakresu –1..1
[y2,bps] = kodowanie_podpasmowe(x,8,6);
soundsc(y2,Fs)
figure(2)
specgram(y2,2048,Fs,2000)
title(sprintf('Liczba bitów na próbkę: %1.2f\n',bps))
pause;


% Zakodowanie koderem podpasmowym z użyciem 32 podpasm i 6 bitów na próbkę
[y3,bps] = kodowanie_podpasmowe(x,32,6);
soundsc(y3,Fs)
figure(3)
specgram(y3,2048,Fs,2000)
title(sprintf('Liczba bitów na próbkę: %1.2f\n',bps))
pause;

% Zakodowanie koderem podpasmowym z użyciem 32 podpasm i zmienna liczba bitów, kolejno: 8, 8, 7, 6
[y4,bps] = kodowanie_podpasmowe(x,32,[8 8 7 6]);
soundsc(y4,Fs)
figure(4)
specgram(y4,2048,Fs,2000)
title(sprintf('Liczba bitów na próbkę: %1.2f\n',bps))

%todo obliczanie kompresji 


