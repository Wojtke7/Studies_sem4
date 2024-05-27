clc; clear all; close all;
%% Dane
N     = 128;    % liczba próbek
Nprim = 129;
fs   = 1200;    % czżęstotliwość próbkowania

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
Xlog = 20*log10(X);

%% Okno i Filtr
wBlH = blackmanharris(N);                  % Blackman-Harris
hBlH = fir1(N-1, band, wBlH);

wBlHprim = blackmanharris(Nprim);          % Blackman-Harris
hBlHprim = fir1(Nprim-1, band, wBlHprim);

%% Charakterystyka a-cz filtrów

hfvt = fvtool(hBlH, 1, hBlHprim, 1);
legend(hfvt,'Blackman-Harris', 'Blackman-Harrisprim');

% fvtool(obj,ind) visualizes the filters corresponding to the elements in the vector ind.

%% Charakterystyka f-cz filtrów

pBlH     = phasez(hBlH);
pBlHprim = phasez(hBlHprim);

figure(2)
set(figure(2),'units','points','position',[0,0,1440,750]);
hold on;
plot(0:(fs/2)/length(pBlH):(fs/2)-(fs/2)/length(pBlH), pBlH);
plot(0:(fs/2)/length(pBlHprim):(fs/2)-(fs/2)/length(pBlHprim), pBlHprim);
title('Charakterystyka f-cz filtrów');
legend('Blackman-Harris', 'Blackman-Harrisprim');
xlabel('Częstotliwość [Hz]');
ylabel('Faza [rad]');
grid;
hold off;

%% Sygnał wyjściowy
yBlH    = filter(hBlH, 1, x);
YBlH    = abs(fft(yBlH));
YBlH    = YBlH/max(YBlH);
YlogBlH = 20*log10(YBlH);

yBlHprim    = filter(hBlHprim, 1, x);
YBlHprim    = abs(fft(yBlHprim));
YBlHprim    = YBlHprim/max(YBlHprim);
YlogBlHprim = 20*log10(YBlHprim);

%% Plotowanie sygnału wyjściowego

t = dt*(0:L-1);
figure(3)
set(figure(3),'units','points','position',[0,0,1440,750]);
hold on;
plot(t, yBlH,'r-p');
plot(t, yBlHprim,'k-o');
title('Sygnał wyjściowy y');
legend('Blackman-Harris', 'Blackman-Harrisprim');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
grid;
hold off;

figure(4)
set(figure(4),'units','points','position',[0,0,1440,750]);
subplot(1,2,1);
hold on;
plot(f, abs(YBlH),'r-p');
plot(f, abs(YBlHprim),'k-o');
title('Charakterystyka Y w skali liniowej');
legend('Blackman-Harris', 'Blackman-Harrisprim');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [V/V]');
grid;
hold off;

subplot(1,2,2);
hold on;
plot(f, YlogBlH,'r-p');
plot(f, YlogBlHprim,'k-o');
title('Charakterystyka Y w skali decybelowej');
legend('Blackman-Harris', 'Blackman-Harrisprim');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
grid;
hold off;

% Na wykresie odpowiedzi impulsowej widzimy że, jest ona symetryczna. 
% Ponieważ wybraliśmy parzystą liczbę próbek (128), środek symetrii 
% leży pomiędzy środkowymi próbkami. Gdybyśmy wzięli nieparzystą długość filtru, 
% środkowa próbka wyznaczałaby środek symetrii.

