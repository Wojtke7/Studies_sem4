clc;
% Zadanie 1 - Filtr cyfrowy IIR
clear all; close all;

load('butter.mat');  % Wczytaj plik butter.mat zawierający współczynniki z, p, k dla filtru Butterwortha.

%% Dane do sygnałów
N  = 16*10^3;  % Liczba próbek
fs = 16*10^3;  % Częstotliwość próbkowania w Hz

f1 = 1209;  % Częstotliwość pierwszego sygnału harmonicznego w Hz
f2 = 1272;  % Częstotliwość drugiego sygnału harmonicznego w Hz

dt = 1/fs;  % Krok próbkowania (czas między próbkami)
T  = N/fs;  % Całkowity czas próbkowania (1 sekunda)

sample = 0:dt:T-dt;  % Przedział czasowy próbkowania

%% Dane do filtrów
df = fs/N;  % Rozdzielczość częstotliwościowa
f  = 0:df:fs-df;  % Wektor częstotliwości
w  = 2*pi*f;  % Wektor częstotliwości kątowej

%% Tworzenie sygnału z sumy sinusów

s1 = @(t) sin(2*pi*f1*t);  % Pierwsza funkcja sinusoidalna
s2 = @(t) sin(2*pi*f2*t);  % Druga funkcja sinusoidalna

% Sygnał x z sumy sinusów
x = s1(sample) + s2(sample);  % Suma dwóch sinusoid

% Szybka transformata Fouriera (FFT)
X    = fft(x)/max(fft(x));  % Normalizacja FFT sygnału
Xlog = 20*log10(abs(X));  % Konwersja do skali decybelowej

%% Sygnał i jego charakterystyka

t = dt*(0:N-1);  % Wektor czasu do rysowania
figure('Name', 'Sygnał');
set(figure(1),'units','points','position',[0,400,720,350]);
plot(t, x,'b');  % Rysowanie sygnału w dziedzinie czasu
title('Sygnał wejściowy x');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
grid;

figure('Name', 'Charakterystyka amplitudowo-częstotliwościowa sygnału wejściowego');
set(figure(2),'units','points','position',[720,400,720,350]);

subplot(1,2,1);
plot(f, abs(X),'b');  % Rysowanie widma amplitudowego (skala liniowa)
title('Charakterystyka X w skali liniowej');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [V/V]');
xlim([1100 1300]);
ylim([0 1.2]);
grid;

subplot(1,2,2);
plot(f, Xlog,'b');  % Rysowanie widma amplitudowego (skala logarytmiczna)
title('Charakterystyka X w skali decybelowej');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
xlim([1100 1300]);
ylim([-350 20]);
grid;

%% Tworzenie filtru analogowego

bm = poly(z);  % Licznik filtru analogowego -> współczynniki wielomianu
an = poly(p);  % Mianownik filtru analogowego -> współczynniki wielomanu -> funkcja poly

Ha    = polyval(bm, j*w)./polyval(an, j*w);  % Odpowiedź częstotliwościowa filtru analogowego |H(jw)|
Ha    = Ha./max(Ha);  % Normalizacja odpowiedzi częstotliwościowej
Halog = 20*log10(abs(Ha));  % Konwersja do skali decybelowej

%% Tworzenie filtru cyfrowego
% Używając transformaty biliniowej wykonaj konwersję analogowego filtru 
% H(s) do postaci cyfrowej H(z). 
% Załóż, że częstotliwość próbkowania to fs=16 kHz.

[zd,pd,kd] = bilinear(z,p,k,fs);  % Transformacja biliniowa do konwersji filtru analogowego do cyfrowego

z  = exp(j*w/fs);  % Wektor częstotliwości dla filtru cyfrowego -> e^(jw/fs)
bm = poly(zd);  % Licznik filtru cyfrowego
an = poly(pd);  % Mianownik filtru cyfrowego

Hd    = kd * polyval(bm, z)./polyval(an, z);  % Odpowiedź częstotliwościowa filtru cyfrowego-> polyval obliczamy wartosc wielomianu w punktach
Hd    = Hd./max(Hd);  % Normalizacja odpowiedzi częstotliwościowej
Hdlog = 20*log10(abs(Hd));  % Konwersja do skali decybelowej

%% Porównanie filtrów

figure('Name', 'Filtry analogowy i cyfrowy');
set(figure(3),'units','points','position',[0,30,720,306]);
hold on;
plot(f, Halog,'b');  % Rysowanie odpowiedzi filtru analogowego
plot(f, Hdlog,'r');  % Rysowanie odpowiedzi filtru cyfrowego
plot([f1 f1], [-70 20], 'k--');  % Zaznaczenie częstotliwości pierwszej harmonicznej
plot([f2 f2], [-70 20], 'k--');  % Zaznaczenie częstotliwości drugiej harmonicznej
hold off;
title('Filtr analogowy i cyfrowy (Ha, Hd)');
legend('Analogowy','Cyfrowy');
xlabel('Częstotliwość [Hz]');
ylabel('H [j\omega]');
xlim([1100 1300]);
ylim([-70 20]);
grid;
hold off;

%% Filtracja cyfrowa

y1 = filter(bm,an,x);  % Przefiltrowanie sygnału za pomocą filtru cyfrowego

% Własna implementacja algorytmu filtracji
% https://www.mathworks.com/help/matlab/ref/filter.html#buagwwg-2

N = length(an);  % Długość mianownika
ak = an(2:N);  % Usunięcie wiodącego współczynnika (zakładamy, że jest równy 1)
N = N-1;

M = length(bm);  % Długość licznika
xnm = zeros(1, M);  % Bufor dla próbek wejściowych
ynk = zeros(1, N);  % Bufor dla próbek wyjściowych
%% 
for n = 1:16e3
    xnm    = [x(n)  xnm(1:M-1)];  % Przesunięcie bufora wejściowego
    y2(n) = sum(xnm.*bm) - sum(ynk.*ak);  % Zastosowanie filtru
    ynk    = [y2(n) ynk(1:N-1)];  % Przesunięcie bufora wyjściowego
end

%% 
Y1    = fft(y1)/max(fft(y1));  % Normalizacja FFT przefiltrowanego sygnału (implementacja MATLAB)
Y1log = 20*log10(abs(Y1));  % Konwersja do skali decybelowej

Y2    = fft(y2)/max(fft(y2));  % Normalizacja FFT przefiltrowanego sygnału (własna implementacja)
Y2log = 20*log10(abs(Y2));  % Konwersja do skali decybelowej

figure('Name', 'Charakterystyka amplitudowo-częstotliwościowa sygnału wyjściowego');
set(figure(4),'units','points','position',[720,30,720,306]);

subplot(1,2,1);
hold on;
plot(f, abs(Y1),'b');  % Rysowanie widma amplitudowego przefiltrowanego sygnału (MATLAB)
plot(f, abs(Y2),'r');  % Rysowanie widma amplitudowego przefiltrowanego sygnału (własna implementacja)
plot([f1 f1], [0 1.2], 'k--');  % Zaznaczenie częstotliwości pierwszej harmonicznej
plot([f2 f2], [0 1.2], 'k--');  % Zaznaczenie częstotliwości drugiej harmonicznej
hold off;
title('Charakterystyka Y w skali liniowej');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [V/V]');
legend('matlab','własny');
xlim([1100 1300]);
ylim([0 1.2]);
grid;

subplot(1,2,2);
hold on;
plot(f, Y1log,'b');  % Rysowanie widma amplitudowego przefiltrowanego sygnału w dB (MATLAB)
plot(f, Y2log,'ro');  % Rysowanie widma amplitudowego przefiltrowanego sygnału w dB (własna implementacja)
plot([f1 f1], [-70 10], 'k--');  % Zaznaczenie częstotliwości pierwszej harmonicznej
plot([f2 f2], [-70 10], 'k--');  % Zaznaczenie częstotliwości drugiej harmonicznej
hold off;
title('Charakterystyka Y w skali decybelowej');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
legend('matlab','własny');
xlim([1100 1300]);
ylim([-70 10]);
grid;


% Filtr cyfrowy jest uzyskiwany poprzez dyskretną transformację filtru analogowego za pomocą metody biliniowej. 
% Ta transformacja może wprowadzić pewne zniekształcenia i przesunięcia, zwłaszcza w obszarach wysokich częstotliwości.