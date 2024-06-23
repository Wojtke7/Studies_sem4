clc; % Czyszczenie okna poleceń
clear all; % Usuwanie wszystkich zmiennych z przestrzeni roboczej
close all; % Zamykanie wszystkich otwartych okien figure

%% Definicje parametrów
fs = 3.2e6;         % Częstotliwość próbkowania
N  = 32e6;          % Liczba próbek (IQ)
fc = 2.79375e6;     % Częstotliwość środkowa stacji MF (0, 0.2, 0.4, 0.9)

bwSERV  = 80e3;     % Pasmo FM (pasmo ~= częstotliwość próbkowania!)
bwAUDIO = 16e3;     % Pasmo audio FM (pasmo == 1/2 * częstotliwość próbkowania!)

%% Odczyt próbek z pliku
f = fopen('samples_100MHz_fs3200kHz.raw'); % Otwarcie pliku do odczytu
s = fread(f, 2*N, 'uint8'); % Odczytanie danych z pliku
fclose(f); % Zamknięcie pliku

s = s-127; % Normalizacja danych

%% Konwersja IQ na liczbę zespoloną
wideband_signal = s(1:2:end) + sqrt(-1)*s(2:2:end); clear s; % Konwersja na sygnał zespolony

%% Ekstrakcja nośnej wybranego serwisu, a następnie przesunięcie w częstotliwości wybranego serwisu do pasma podstawowego
wideband_signal_shifted = wideband_signal .* exp(-sqrt(-1)*2*pi*fc/fs*[0:N-1]'); % Przesunięcie sygnału

%% Filtrowanie serwisu z sygnału szerokopasmowego
% Zmiana filtra na cyfrowy IIR typu Butterworth LP rzędu 4 o częstotliwości granicznej 80 kHz
[bm,an] = butter(4, bwSERV/fs, 'low'); % Projektowanie filtra Butterwortha
wideband_signal_filtered = filter(bm, an, wideband_signal_shifted); % Filtracja sygnału

%% Próbkowanie w dół do pasma serwisu - bwSERV = nowa częstotliwość próbkowania
x = wideband_signal_filtered(1:fs/(bwSERV*2):end); % Próbkowanie w dół

%% Demodulacja FM
dx = x(2:end).*conj(x(1:end-1)); % Obliczenie różnicy fazy
y  = atan2(imag(dx), real(dx)); % Obliczenie kąta fazy

%% Próbkowanie w dół do pasma sygnału audio bwAUDIO
f_norm  = bwAUDIO/bwSERV;     % Próbkowanie w dół (1/5) % znormalizowana częstotliwość odcięcia
[ba,aa] = butter(4,f_norm);    % Filtr Butterwortha n-tego rzędu 
ym = filter(ba, aa, y);       % Filtr antyaliasingowy
ym = decimate(ym,5); % Próbkowanie w dół

%% De-emfaza DODANE
f_norm  = 2.1e3/16e3; % Znormalizowana częstotliwość odcięcia
[bd,ad] = butter(1,f_norm); % Filtr Butterwortha pierwszego rzędu
yde     = filter(bd,ad,ym); % Filtracja sygnału

%% Odsłuchaj końcowy wynik
yde = yde-mean(yde); % Usunięcie składowej stałej
yde = yde./(1.001*max(abs(yde))); % Normalizacja sygnału
%soundsc(yde, bwAUDIO*2); % Odtworzenie sygnału bwAudio->frequency

%% Wykresy
M = min(length(wideband_signal), 1e6); % Długość sygnału do wyświetlenia (ograniczenie dla szybkości obliczeń)

% Wykres widma sygnału oryginalnego
psd(spectrum.welch('Hamming',1024), wideband_signal(1:M),'Fs',fs);
title('Widmo gęstości mocy oryginalnego sygnału');

% Wykres widma przesuniętego sygnału
figure;
psd(spectrum.welch('Hamming',1024), wideband_signal_shifted(1:M),'Fs',fs);
title('Widmo gęstości mocy przesuniętego sygnału');

% Wykres widma przefiltrowanego sygnału
figure;
psd(spectrum.welch('Hamming',1024), wideband_signal_filtered(1:M),'Fs',fs);
title('Widmo gęstości mocy przefiltrowanego sygnału');

% Wykres widma próbkowanego w dół sygnału
figure;
psd(spectrum.welch('Hamming',1024), x,'Fs',fs/(fs/(bwSERV*2)));
title('Widmo gęstości mocy próbkowanego w dół sygnału');

% Wykres widma demodulowanego sygnału
figure;
psd(spectrum.welch('Hamming',1024), y,'Fs',fs/(fs/(bwSERV*2)));
title('Widmo gęstości mocy demodulowanego sygnału');

% Wykres widma sygnału po de-emfazie
figure;
psd(spectrum.welch('Hamming',1024), yde,'Fs',bwAUDIO);
title('Widmo gęstości mocy sygnału po de-emfazie');

% Wykres sygnału w dziedzinie czasu
figure;
plot(yde);
title('Sygnał w dziedzinie czasu');

% % Wykres spektrogramu
% figure;
% spectrogram(wideband_signal_filtered,4096, 512, [0:20000:3200000], fs);
% title('Spektrogram sygnału przefiltrowanego');


% Stabilność, aby filtr był stabilny, musi on spełniać kryterium Nyquista, które mówi, że krzywa odpowiedzi częstotliwościowej nie może przecinać osi rzeczywistej w prawej półpłaszczyźnie zespolonej.

