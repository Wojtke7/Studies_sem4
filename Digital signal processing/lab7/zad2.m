clc;
clear all; close all;


%% Dane
N  = 1e5;
fs = 2e5;

%% Pasma Mono i Pilota 

bandMono   = [30 15e3]/(fs/2);
bandPilot  = [18999 19001]/(fs/2);
bandStereo = [23e3 53e3]/(fs/2);

%% Okna Mono, Pilota, Stereo

L1 = 128;
L2 = 256;
L3 = 256;

% Został wybrany filtr hamminga, ponieważ nie ma on zafalowań w paśmie
% przepustowym i stosunkowo niewielkie pasmo przejściowe
wHamMono   = hamming(L1);
wHamPilot  = hamming(L2);
wHamStereo = hamming(L3);

% w = hamming(L) returns an L-point symmetric Hamming window.
% L — Window length

%% Filtry Mono i Pilota

hHamMono   = fir1(L1-1, bandMono,  wHamMono);
hHamPilot  = fir1(L2-1, bandPilot, wHamPilot);
hHamStereo = fir1(L3-1, bandStereo, wHamStereo);

% b = fir1(n,Wn,ftype) 
% designs a lowpass, highpass, bandpass, bandstop, or multiband filter,
% depending on the value of ftype and the number of elements of band.

%% Odpowiedź impulsowa filtrów Mono i Pilota

[hM, wM] = freqz(hHamMono, 1, N, fs);
[hP, wP] = freqz(hHamPilot, 1, N, fs);
[hS, wS] = freqz(hHamStereo, 1, N, fs);

hMlog = 20*log10(abs(hM));
hPlog = 20*log10(abs(hP));
hSlog = 20*log10(abs(hS));

% [h,w] = freqz(b,a,n) returns the n-point frequency response vector h 
% and the corresponding angular frequency vector w for the digital filter 
% with transfer function coefficients stored in b and a.

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

fs = 3.2e6;         % sampling frequency
N  = 32e6;         % number of samples (IQ)
fc = 0.39e6;        % central frequency of MF station

bwSERV = 80e3;     % bandwidth of an FM service (bandwidth ~= sampling frequency!)
bwAUDIO = 16e3;     % bandwidth of an FM audio (bandwidth == 1/2 * sampling frequency!)

f = fopen('samples_100MHz_fs3200kHz.raw');
s = fread(f, 2*N, 'uint8');
fclose(f);

s = s-127;

% IQ --> complex
wideband_signal = s(1:2:end) + sqrt(-1)*s(2:2:end); clear s;

% Extract carrier of selected service, then shift in frequency the selected service to the baseband
wideband_signal_shifted = wideband_signal .* exp(-sqrt(-1)*2*pi*fc/fs*[0:N-1]');

% % Filter out the service from the wide-band signal
[b,a] = butter(4, bwSERV/fs);

wideband_signal_filtered = filter( b, a, wideband_signal_shifted );

% Down-sample to service bandwidth - bwSERV = new sampling rate
x = wideband_signal_filtered( 1:fs/(bwSERV*2):end );

% FM demodulation
dx = x(2:end).*conj(x(1:end-1));
y = atan2( imag(dx), real(dx) );
figure(5);
psd(spectrum.welch('Hamming',1024), y,'Fs',(bwSERV*2));
title('Gęstośc widmowa mocy sygnału');

Wn_down = (15e3*2)/(bwSERV*2);
% Decimate to audio signal bandwidth bwAUDIO
% [b_down,a_down] = butter(4, bwAUDIO/(bwSERV*2));
b_down = fir1(128, Wn_down, hamming(128+1));
a_down = 1;
figure(6);
freqz(b_down, a_down, 512, (bwSERV*2));
title("Charakterystyki A-cz i f-cz dla filtru filtrującego sygnał mono");
y_audio = filter( hHamMono, a_down, y ); % antyaliasing filter
figure(7);
psd(spectrum.welch('Hamming',1024), y_audio,'Fs',bwAUDIO);
title("Charakterystyka A-cz po zastosowaniu antyaliasingu")
% decimate (1/5)
ym = y_audio(1:5:end);


% PILOT
% Pasmo
Wn_pilot = [(18.95e3*2)/(bwSERV*2) (19.05e3*2)/(bwSERV*2)];
% Zamiana filtru irr na fir
b_pilot = fir1(128, Wn_pilot, hamming(128+1));
a_pilot = 1;
figure(8);
freqz(b_pilot, a_pilot, 512, bwSERV*2);
title("Charakterystyka a-cz i f-cz dla filtru filtrującego pilota");
y_pilot = filter( hHamPilot, a_pilot, y );
figure(9)
spectrogram(y_pilot, 4096, 4096-512, [18e3:1:20e3], bwSERV*2);
title("Wykres spektrogramu dla pilota");
figure(10);
pwelch(y_pilot, 4096, 4096-512, [18e3:1:20e3], bwSERV*2);
title("Gęstość widmowa mocy dla pilota");


% Listen to the final result
ym = ym-mean(ym);
ym = ym/(1.001*max(abs(ym)));
figure(11);
plot(ym)
title("Sygnał wyjściowy");
soundsc( ym, bwAUDIO*2);
