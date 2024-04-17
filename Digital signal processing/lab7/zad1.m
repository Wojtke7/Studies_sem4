clc;
% Zadanie 1 - Projektowanie filtrów FIR metodą okien
clear all; close all;



%% Dane
N = 129;        % liczba próbek
fs = 1200;      % czżęstotliwość próbkowania

fp = 200;       % pasmo o szerokości 200Hz
fk = 400;       % częstotliwość środkowa 300Hz

band = [fp fk]/(fs/2);  % pasmo

%% Dane sygnał
L = 1200;
f1 = 100;
f2 = 300;
f3 = 500;

dt = 1/fs;                  % krok próbkowania
T  = L/fs;                  % czas trwania probkowania (1s)

sample = 0:dt:T-dt;         % przedział czasowy próbkowania

df = fs/L;
f  = 0:df:fs-df;

%% Tworzenie sygnału z sumy sinusów

s1 = @(t) sin(2*pi*f1*t);   
s2 = @(t) sin(2*pi*f2*t);
s3 = @(t) sin(2*pi*f3*t);

x = s1(sample) + s2(sample) + s3(sample);

X    = abs(fft(x)/(L/2));
X    = X/max(X);
Xlog = 20*log10(X);

%% Plotowanie sygnału wejściowego

t = dt*(0:L-1);
figure(1);
figure('Name', 'Sygnał wejściowy - suma 3 sygnałów (100Hz, 300Hz, 500Hz)');
set(figure(2),'units','points','position',[0,0,1440,750]);
plot(t, x,'b');
title('Sygnał wejściowy x');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
grid;

figure('Name', 'Charakterystyka a-cz sygnału wejściowego');
set(figure(3),'units','points','position',[0,0,1440,750]);

subplot(1,2,1);
plot(f, abs(X),'b');
title('Charakterystyka X w skali liniowej');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [V/V]');
grid;

subplot(1,2,2);
plot(f, Xlog,'b');
title('Charakterystyka X w skali decybelowej');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
grid;

%% Okna
wRct = rectwin(N);          % Prostokątne
wHan = hann(N);             % Hanning
wHam = hamming(N);          % Hamming
wBlk = blackman(N);         % Blackman
wBlH = blackmanharris(N);   % Blackman-Harris

%% Filtry
bRct = fir1(N-1, band, wRct);
bHan = fir1(N-1, band, wHan);
bHam = fir1(N-1, band, wHam);
bBlk = fir1(N-1, band, wBlk);
bBlH = fir1(N-1, band, wBlH);

% b = fir1(n,Wn,ftype) 
% designs a lowpass, highpass, bandpass, bandstop, or multiband filter,
% depending on the value of ftype and the number of elements of band.

[hRct, wRct] = freqz(bRct, 1, 512, fs);
[hHan, wHan] = freqz(bHan, 1, 512, fs);
[hHam, wHam] = freqz(bHam, 1, 512, fs);
[hBlk, wBlk] = freqz(bBlk, 1, 512, fs);
[hBlH, wBlH] = freqz(bBlH, 1, 512, fs);

% [h,w] = freqz(b,a,n) returns the n-point frequency response vector h 
% and the corresponding angular frequency vector w for the digital filter 
% with transfer function coefficients stored in b and a.

hRct    = hRct/max(hRct);
hlogRct = 20*log(abs(hRct));
hHan    = hHan/max(hHan);
hlogHam = 20*log(abs(hHam));
hHan    = hHan/max(hHan);
hlogHan = 20*log(abs(hHan));
hBlk    = hBlk/max(hBlk);
hlogBlk = 20*log(abs(hBlk));
hBlH    = hBlH/max(hBlH);
hlogBlH = 20*log(abs(hBlH));

%% Charakterystyka a-cz filtrów

figure('Name','Charakterystyka a-cz filtrów');
set(figure(4),'units','points','position',[0,0,1440,750]);
hold on;
plot(wRct, hlogRct,'b');
plot(wHan, hlogHan,'r');
plot(wHam, hlogHam,'y');
plot(wBlk, hlogBlk,'g');
plot(wBlH, hlogBlH,'k');
title('Charakterystyka a-cz filtrów');
legend('Rectangular','Hanning', 'Hamming', 'Blackman', 'Blackman-Harris');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
grid;
hold off;

%% Charakterystyka f-cz filtrów

pRct = unwrap(angle(hRct));
pHan = unwrap(angle(hHan));
pHam = unwrap(angle(hHam));
pBlk = unwrap(angle(hBlk));
pBlH = unwrap(angle(hBlH));

figure('Name','Charakterystyka f-cz filtrów');
set(figure(5),'units','points','position',[0,0,1440,750]);
hold on;
plot(wRct,pRct);
plot(wHan,pHan);
plot(wHam,pHam);
plot(wBlk,pBlk);
plot(wBlH,pBlH);
title('Charakterystyka f-cz filtrów');
legend('Rectangular','Hanning', 'Hamming', 'Blackman', 'Blackman-Harris');
xlabel('Częstotliwość [Hz]');
ylabel('Faza [rad]');
grid;
hold off;

%% Sygnał wyjściowy
yRct    = filter(bRct, 1, X);
YRct    = abs(fft(yRct)/(L/2));
YRct    = YRct/max(YRct);
YlogRct = 20*log10(YRct);

yHan    = filter(bHan, 1, x);
YHan    = abs(fft(yHan)/(L/2));
Yhan    = YHan/max(YHan);
YlogHan = 20*log10(YHan);

yHam    = filter(bHam, 1, x);
YHam    = abs(fft(yHam)/(L/2));
Yham    = YHam/max(YHam);
YlogHam = 20*log10(YHam);

yBlk    = filter(bBlk, 1, x);
YBlk    = abs(fft(yBlk)/(L/2));
YBlk    = YBlk/max(YBlk);
YlogBlk = 20*log10(YBlk);

yBlH    = filter(bBlH, 1, x);
YBlH    = abs(fft(yBlH)/(L/2));
YBlH    = YBlH/max(YBlH);
YlogBlH = 20*log10(YBlH);

%% Plotowanie sygnału wyjściowego

t = dt*(0:L-1);
figure('Name', 'Sygnał wyjściowy - różne okna');
set(figure(6),'units','points','position',[0,0,1440,750]);
hold on;
plot(t, abs(yRct),'b');
plot(t, abs(yHan),'r');
plot(t, abs(yHam),'y');
plot(t, abs(yBlk),'p');
plot(t, abs(yBlH),'g');
title('Sygnał wyjściowy y');
legend('Rectangular','Hanning', 'Hamming', 'Blackman', 'Blackman-Harris');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
grid;
hold off;

figure('Name', 'Charakterystyka a-cz sygnału wyjściowego');
set(figure(7),'units','points','position',[0,0,1440,750]);

subplot(1,2,1);
hold on;
plot(f, abs(YRct),'b');
plot(f, abs(YHan),'r');
plot(f, abs(YHam),'y');
plot(f, abs(YBlk),'p');
plot(f, abs(YBlH),'g');
title('Charakterystyka Y w skali liniowej');
legend('Rectangular','Hanning', 'Hamming', 'Blackman', 'Blackman-Harris');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [V/V]');
grid;
hold off;

subplot(1,2,2);
hold on;
plot(f, YlogRct,'b');
plot(f, YlogHan,'r');
plot(f, YlogHam,'y');
plot(f, YlogBlk,'p');
plot(f, YlogBlH,'g');
title('Charakterystyka Y w skali decybelowej');
legend('Rectangular','Hanning', 'Hamming', 'Blackman', 'Blackman-Harris');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
grid;
hold off;

% Przyjmij stała długość filtru
%N=128 próbek albo 129 próbek. Jakie są konsekwencje tej różnicy?


% Z wykresów wynika, że w "nieidealnym" filtrze FIR zawsze występuje pasmo 
% przejściowe (transition band) w pobliżu częstotliwości granicznej. 
% Zgodnie z przewidywaniem, większa długość filtru powoduje zmniejszenie szerokości
% pasma przejściowego. W paśmie zaporowym występują zafalowania, 
% ich kształt również zależy od długości filtru.

% Większe okno obejmie dłuższy fragment idealnej odpowiedzi impulsowej filtru, 
% a więc można się spodziewać że charakterystyka filtru będzie "dokładniejsza".

% FIR. Polega na mnożeniu idealnej charakterystyki filtru 
% (np. dolnoprzepustowego, górnoprzepustowego, pasmowości pasywnej itp.) 
% przez tzw. funkcję okna. Funkcja okna jest używana do ograniczenia 
% odpowiedzi impulsowej filtra, co pozwala na kontrolę przebiegu czasowego 
% i częstotliwościowego charakterystyki filtru.

