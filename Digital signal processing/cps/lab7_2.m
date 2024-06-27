clc;
clear all; close all;


%% Dane
N  = 1e5; % liczba próbek
fs = 2e5; % czestotliwosc probkowania

%% Pasma Mono i Pilota 

bandMono   = [30 15e3]/(fs/2);
bandPilot  = [18999 19001]/(fs/2);
bandStereo = [23e3 53e3]/(fs/2);

%% Okna Mono, Pilota, Stereo

L1 = 256;
L2 = 512;
L3 = 512;

% Został wybrany filtr hamminga, ponieważ nie ma on zafalowań w paśmie
% przepustowym i stosunkowo niewielkie pasmo przejściowe
wHamMono   = hamming(L1);
wHamPilot  = hamming(L2);
wHamStereo = hamming(L3);

%% Filtry Mono i Pilota

hHamMono   = fir1(L1-1, bandMono,  wHamMono); % zwraca wektor z wartosciami dla okna (wspolczynnik filtru fir)
hHamPilot  = fir1(L2-1, bandPilot, wHamPilot);
hHamStereo = fir1(L3-1, bandStereo, wHamStereo);

%% Odpowiedź impulsowa filtrów Mono i Pilota

[hM, wM] = freqz(hHamMono, 1, N, fs); % zwraca nam odpowiedz czestotliwoscia w dziedzinie czestotliwosci w formie amplitudy i fazy
[hP, wP] = freqz(hHamPilot, 1, N, fs);
[hS, wS] = freqz(hHamStereo, 1, N, fs);

hMlog = 20*log10(abs(hM)); % zamiana amplitudy na skale logarytmiczna
hPlog = 20*log10(abs(hP)); 
hSlog = 20*log10(abs(hS));

%% Plotowanie
figure('Name','Filtry Mono, Pilota i Stereo (filtrem Hamminga)');
set(figure(2),'units','points','position',[0,0,1440,750]);

hold on;
plot(wM, hMlog);
plot(wP, hPlog);
plot(wS, hSlog);
plot([0 1e5], [-40 -40], 'k-');
plot([30 30], [40 -160], 'k-');
plot([15e3 15e3], [50 -200], 'k-'); 
plot([19e3 19e3], [50 -200], 'k-'); 
plot([23e3 23e3], [50 -200], 'k-'); 
plot([53e3 53e3], [50 -200], 'k-'); 
title('Filtry Mono,Pilota i Stereo (filtrem Hamminga)');
legend('Mono','Pilot','Stereo');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda [dB]');
grid;
hold off;

%% Poziomy tłumień dla ważnych częstotliwości

disp('Tłumienie Mono w 19k:'); 
disp(hMlog(19e3));
disp('Tłumienie Mono w 23k:'); 
disp(hMlog(23e3));
disp('Tłumienie Mono w 53k:'); 
disp(hMlog(53e3));
disp('Tłumienie Pilota w 15k:'); 
disp(hPlog(15e3));
disp('Brak tłumienia pilota w 19k:'); 
disp(hPlog(19e3));
disp('Tłumienie Pilota w 23k:'); 
disp(hPlog(23e3));
disp('Tłumienie Pilota w 53k:'); 
disp(hPlog(53e3));
disp('Tłumienie Stereo w 15k:'); 
disp(hSlog(15e3));
disp('Tłumienie Stereo w 19k:'); 
disp(hSlog(19e3));

fs = 3.2e6;         % częstotliwość próbkowania
N  = 32e6;         % liczba próbek
fc = 0.39e6;        % środkowa częstotliwość stacji mf

bwSERV = 80e3;     % Szerokość pasma usługi FM (szerokość pasma nie jest równa częstotliwości próbkowania!)
bwAUDIO = 16e3;     %  Szerokość pasma audio FM (szerokość pasma == 1/2 * częstotliwość próbkowania!)

f = fopen('samples_100MHz_fs3200kHz.raw');
s = fread(f, 2*N, 'uint8'); % 2 bajty na próbke
fclose(f);

s = s-127;  % zmieniamy punkt odniesienia sygnalu z 127 na 0

wideband_signal = s(1:2:end) + sqrt(-1)*s(2:2:end); clear s; % wybieramy co drugi element z wektora s, 
% co odpowiada próbkom dla kanału rzeczywistego

wideband_signal_shifted = wideband_signal .* exp(-sqrt(-1)*2*pi*fc/fs*[0:N-1]');
%  generujemy ciąg zespolonych wartości eksponencjalnych, które odpowiadają przesunięciu częstotliwości 
% o fc (środkowa częstotliwość stacji) do pasma bazowego.

[b,a] = butter(4, bwSERV/fs); % zastosowanie filtru butterwortha -> zwraca wspolczynniki
% 4 rzędu charakterystyka i bwSERV/fs -> granica pasma przepustowego filtra
% czyli po prostu czestotliwosc graniczna

wideband_signal_filtered = filter( b, a, wideband_signal_shifted ); % filtrowanie przez filtr butterwortha

% dokonujemy zmniejszania czestotliwosci probkowania do bwSERV zeby wybrac
% tylko istotna czesc sygnalu
x = wideband_signal_filtered( 1:fs/(bwSERV*2):end );

% FM demodulacja
dx = x(2:end).*conj(x(1:end-1)); % obliczenie roznicy fazowej
y = atan2( imag(dx), real(dx) ); % obliczanie fazy sygnalu 
figure(5);
psd(spectrum.welch('Hamming',1024), y,'Fs',(bwSERV*2));
title('Gęstość widmowa mocy sygnału'); 

pause;
Wn_down = (15e3*2)/(bwSERV*2);% Obliczamy granicę pasma dla filtru dolnoprzepustowego.
b_down = fir1(128, Wn_down, hamming(128+1)); % Projektujemy filtr dolnoprzepustowy o długości 128 próbek
a_down = 1;
figure(6);
%następnie rysujemy charakterystykę częstotliwościową filtru FIR za pomocą funkcji freqz. 
% Argumenty tej funkcji to współczynniki b i a filtru, liczba punktów do obliczenia (512), 
% oraz maksymalna częstotliwość (znormalizowana do wartości Nyquista), która wynosi bwSERV*2.
freqz(b_down, a_down, 512, (bwSERV*2));
title("Charakterystyki A-cz i f-cz dla filtru filtrującego sygnał mono");
pause;
y_audio = filter( hHamMono, a_down, y ); % antyaliasing filter
figure(7);
psd(spectrum.welch('Hamming',1024), y_audio,'Fs',bwAUDIO);
title("Charakterystyka A-cz po zastosowaniu antyaliasingu")
pause;
% decimate (1/5)
ym = y_audio(1:5:end);


% PILOT
% Pasmo
Wn_pilot = [(18.95e3*2)/(bwSERV*2) (19.05e3*2)/(bwSERV*2)]; % obliczamy dolne i górne wartości zakresu czestotliwosci pilota
% Zamiana filtru irr na fir
b_pilot = fir1(128, Wn_pilot, hamming(128+1));
a_pilot = 1;
figure(8);
freqz(b_pilot, a_pilot, 512, bwSERV*2);
title("Charakterystyka a-cz i f-cz dla filtru filtrującego pilota");
pause;
y_pilot = filter( hHamPilot, a_pilot, y );
figure(9)
spectrogram(y_pilot, 4096, 4096-512, [18e3:1:20e3], bwSERV*2);
%y_pilot: sygnał pilota FM,
%4096: liczba próbek używanych do obliczenia każdej kolumny spektrogramu,
%4096-512: liczba próbek przesunięcia między kolejnymi kolumnami spektrogramu (zapewnia overlaping),
%[18e3:1:20e3]: zakres częstotliwości, który zostanie wyświetlony na osi x spektrogramu (od 18 kHz do 20 kHz z krokiem 1 Hz),
%bwSERV*2: nowa częstotliwość próbkowania sygnału, która jest używana do normalizacji osi częstotliwości.
title("Wykres spektrogramu dla pilota");
pause;
figure(10);
pwelch(y_pilot, 4096, 4096-512, [18e3:1:20e3], bwSERV*2);
title("Gęstość widmowa mocy dla pilota");
pause;

% Listen to the final result
ym = ym-mean(ym); % normalizacja sygnalu audio
ym = ym/(1.001*max(abs(ym))); % Następnie sygnał ym normalizujemy przez jego maksymalną wartość bezwzględną. Dzięki temu operacji sygnał jest przeskalowany tak, aby jego największa wartość bezwzględna wynosiła 1.001. Dzięki tej operacji sygnał jest skalowany do zakresu od -1 do 1.
figure(11);
plot(ym)
title("Sygnał wyjściowy");
soundsc( ym, bwAUDIO*2);