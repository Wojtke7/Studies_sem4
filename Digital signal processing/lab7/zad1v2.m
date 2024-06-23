clc;
% Zadanie 1 - Projektowanie filtrów FIR metodą okien
clear all; close all;

%% Dane
% Częstotliwość próbkowania (f_p) - to liczba próbek sygnału pobieranych w ciągu sekundy. W zadaniu jest to 1200 Hz.
% Szerokość pasma przejściowego (d_f) - to zakres częstotliwości między pasmem przepustowym a zaporowym, tutaj 200 Hz.
% Częstotliwość środkowa pasma przepustowego (f_c) - częstotliwość w centrum pasma, które filtr ma przepuszczać,
% tutaj 300 Hz.

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
figure('Name', 'Sygnał wejściowy - suma 3 sygnałów (100Hz, 300Hz, 500Hz)');
set(figure(1),'units','points','position',[0,0,1440,750]);
plot(t, x,'b');
title('Sygnał wejściowy x');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
grid;

figure('Name', 'Charakterystyka a-cz sygnału wejściowego');
set(figure(2),'units','points','position',[0,0,1440,750]);

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

% Odpowiedzi częstotliwościowe
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
set(figure(3),'units','points','position',[0,0,1440,750]);
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
set(figure(4),'units','points','position',[0,0,1440,750]);
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

t = dt*(0:L-1)
figure('Name', 'Sygnał wyjściowy - różne okna');
set(figure(5),'units','points','position',[0,0,1440,750]);
subplot(3,2,1);
hold on;
plot(t, yRct,'b');
title('Sygnał wyjściowy y - Filtr Rectangular');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
subplot(3,2,2);
plot(t, yHan,'r');
title('Sygnał wyjściowy y - Filtr Hanning');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
subplot(3,2,3);
plot(t, yHam,'y');
title('Sygnał wyjściowy y - Filtr Haming');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
subplot(3,2,4);
plot(t, yBlk,'r');
title('Sygnał wyjściowy y - Filtr Blackman');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
subplot(3,2,5);
plot(t, yBlH,'k');
title('Sygnał wyjściowy y - Filtr Blackman-Harris');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
grid;
hold off;

figure('Name', 'Charakterystyka a-cz sygnału wyjściowego');
set(figure(6),'units','points','position',[0,0,1440,750]);

subplot(1,2,1);
hold on;
plot(f, abs(YRct),'b');
plot(f, abs(YHan),'r');
plot(f, abs(YHam),'y');
plot(f, abs(YBlk),'p');
plot(f, abs(YBlH),'k');
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
plot(f, YlogBlH,'k');
title('Charakterystyka Y w skali decybelowej');
legend('Rectangular','Hanning', 'Hamming', 'Blackman', 'Blackman-Harris');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
grid;
hold off;

% Obliczanie poziomu tłumienia w paśmie zaporowym

% Pasmo zaporowe (stopband) - częstotliwości od fk do fs/2 (znormalizowane)
stopband = [fk fs]/(fs/2);

% Wartości tłumienia w paśmie zaporowym
tulRct = max(hlogRct(wRct >= stopband(1) & wRct <= stopband(2)));
tulHam = max(hlogHam(wHam >= stopband(1) & wHam <= stopband(2)));
tulHan = max(hlogHan(wHan >= stopband(1) & wHan <= stopband(2)));
tulBlk = max(hlogBlk(wBlk >= stopband(1) & wBlk <= stopband(2)));
tulBlH = max(hlogBlH(wBlH >= stopband(1) & wBlH <= stopband(2)));

fprintf('Poziom tłumienia w paśmie zaporowym:\n');
fprintf('Rectangular: %.2f dB\n', tulRct);
fprintf('Hamming: %.2f dB\n', tulHam);
fprintf('Hanning: %.2f dB\n', tulHan);
fprintf('Blackman: %.2f dB\n', tulBlk);
fprintf('Blackman-Harris: %.2f dB\n', tulBlH);


% Ogólny wstęp:
% 
% 1. Filtry FIR (Finite Impulse Response)
% Filtry FIR są jednym z dwóch głównych typów filtrów cyfrowych (drugim są filtry IIR - Infinite Impulse Response).
% Charakteryzują się tym, że ich odpowiedź impulsowa ma skończoną długość, czyli po podaniu impulsu,
% filtr reaguje tylko przez ograniczony czas.
% Odpowiedź impulsowa - to reakcja filtra na sygnał wejściowy,
% który ma wartość jedynie w jednym punkcie czasowym (jest to delta Diraca).
% 2. Projektowanie metodą okien
% Metoda okien jest techniką używaną do projektowania filtrów FIR.
% Polega na przemnożeniu idealnej odpowiedzi impulsowej przez funkcję okna, co zmniejsza niepożądane efekty,
% takie jak tzw. „przecieki” czy „oscylacje Gibbsa”.

% 4. Typy okien
% Prostokątne - najprostsze okno, które jest funkcją jednostkową; daje najostrzejsze przejście między pasmami,
% ale największe oscylacje Gibbsa.
% Hanninga i Hamminga - okna mające na celu zredukowanie oscylacji Gibbsa kosztem szerokości pasma przejściowego.
% Blackmana i Blackmana-Harrisa - bardziej złożone okna,
% które pozwalają na jeszcze lepszą redukcję bocznych płatów widma kosztem pasma przejściowego.
% 6. Długość filtra
% N - liczba próbek w odpowiedzi impulsowej, czyli długość filtra. W zadaniu przyjmuje się długość 128 lub 129 próbek.
% 7. Projektowanie i analiza sygnału
% Zaprojektujesz filtr pasmowoprzepustowy i przeanalizujesz jego właściwości,
% wykonując zadania takie jak porównanie charakterystyk i narysowanie widma sygnału przed i po filtracji.


% Analiza wykresów:
% 
% Sygnał wejściowy
% Figure 1 pokazuje sygnał wejściowy w dziedzinie czasu, złożony z sumy trzech różnych częstotliwości sinusoidalnych. 
% To ciągły sygnał oscylujący, który jest typowy dla złożonego sygnału sinusoidalnego.
% 
% Charakterystyki amplitudowo-częstotliwościowe sygnału wejściowego
% Figure 2 zawiera dwa wykresy:
% 
% Lewy wykres pokazuje charakterystykę amplitudowo-częstotliwościową sygnału wejściowego w skali liniowej. 
% Można zauważyć trzy główne piky, które odpowiadają trzem częstotliwościom sygnałów sinusoidalnych użytych 
% do stworzenia sygnału wejściowego (100 Hz, 300 Hz, 500 Hz).
% Prawy wykres to ta sama charakterystyka w skali decybelowej. Piki są wyraźnie widoczne, 
% ale występuje dużo "szumu" wokół, co może wskazywać na to, że potrzebna jest większa rozdzielczość przy 
% obliczaniu transformacji Fouriera lub na nieidealności w danych sygnału.
% Charakterystyki filtrów
% Figure 3 pokazuje charakterystykę amplitudowo-częstotliwościową zaprojektowanych filtrów. 
% Każdy kolor reprezentuje inne okno. Można tu zobaczyć, 
% jak różne okna wpływają na przepuszczalność filtru w różnych częstotliwościach. 
% Charakterystyki filtrów pokazują, że wszystkie dobrze tłumią częstotliwości poza pasmem przepustowym, 
% ale różnią się w stromości zboczy oraz poziomie tłumienia w pasmie zaporowym.
% 
% Figure 4 to charakterystyka fazowo-częstotliwościowa filtrów. 
% Prezentuje ona zmianę fazy sygnału przechodzącego przez filtr w zależności od częstotliwości. 
% Idealnie liniowy przebieg fazy oznaczałby, że wszystkie częstotliwości są opóźnione o ten sam czas; 
% nieliniowości mogą powodować zniekształcenia sygnału.
% 
% Charakterystyki sygnału wyjściowego
% Figure 5 zawiera wykresy przedstawiające sygnał po przejściu przez filtry.
% 
% Lewy wykres pokazuje charakterystykę amplitudową w skali liniowej, gdzie widać, jak filtracja wpłynęła na sygnał. 
% Każdy filtr różnie wpływa na sygnał, 
% co jest widoczne w postaci różnych poziomów tłumienia dla poszczególnych częstotliwości.
% Prawy wykres pokazuje tę samą charakterystykę w skali decybelowej, gdzie można zauważyć, że po filtracji, 
% sygnał został znacząco zmieniony.
% Figure 6 to sygnał wyjściowy w dziedzinie czasu. 
% Wyraźne są transjenty (przejściowe zakłócenia sygnału) na początku i na końcu, które są typowe dla filtracji FIR. 
% Główne części sygnału wydają się być dobrze odfiltrowane, z widocznymi pikami tam, 
% gdzie spodziewamy się częstotliwości składowych sygnału.
% 
% Podsumowanie analizy
% Na podstawie tych wykresów możemy wnioskować, że różne okna mają różny wpływ na charakterystyki filtrów, 
% co prowadzi do różnych efektów na sygnał wyjściowy. Wykresy pozwalają na porównanie, 
% jak każde okno wpływa na filtrację sygnału, 
% umożliwiając wybór najodpowiedniejszego filtra w zależności od wymagań zastosowania. Na przykład, 
% okno Blackmana-Harrisa pokazuje bardzo małe oscylacje boczne (tłumienie poza pasmem przepustowym), 
% ale w zamian ma szerokie pasmo przejściowe, co jest widoczne na charakterystykach amplitudowych.