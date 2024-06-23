% odbiornik FM: P. Swiatkiewicz, T. Twardowski, T. Zielinski, J. Bułat

clear all; close all;

%% Rzeczywisty sygnał fm
  fs = 3.2e6;         % sampling frequency
  N  = 32e6;         % number of samples (IQ)
  fc = 0.39e6;        % central frequency of MF station
  bwSERV = 80e3;     % bandwidth of an FM service (bandwidth ~= sampling frequency!)
  bwAUDIO = 16e3;     % bandwidth of an FM audio (bandwidth == 1/2 * sampling frequency!)
  f = fopen('samples_100MHz_fs3200kHz.raw');
  s = fread(f, 2*N, 'uint8');
  s = s-127;
  wideband_signal = s(1:2:end) + sqrt(-1)*s(2:2:end); 
  fclose(f);

%% Syntetyczny sygnał fm
 % fs = 1e6;         % sampling frequency
 % N  = 2.699993e6;         % number of samples (IQ)
 % fc = 0.25e6;        % central frequency of MF station
 % bwSERV = 100e3;     % bandwidth of an FM service (bandwidth ~= sampling frequency!)
 % bwAUDIO = 20e3;     % bandwidth of an FM audio (bandwidth == 1/2 * sampling frequency!)
 % s = load('stereo_samples_fs1000kHz_LR_IQ.mat');
 % wideband_signal = s.I+s.Q;

clear s;
% IQ --> complex
figure(1);
psd(spectrum.welch('Hamming',1024), wideband_signal(1:N),'Fs',fs);

% Przesunięcie sygnału do pasma podstawowego:
wideband_signal_shifted = wideband_signal .* exp(-sqrt(-1)*2*pi*fc/fs*[0:N-1]');

%Filtrowanie sygnału w celu wyodrębnienia pasma usługi:
[b,a] = butter(4, bwSERV/fs);

wideband_signal_filtered = filter( b, a, wideband_signal_shifted );

% Down-sample to service bandwidth - bwSERV = new sampling rate
% Zmniejszenie częstotliwości próbkowania
x = wideband_signal_filtered( 1:fs/(bwSERV*2):end );

% FM demodulation
dx = x(2:end).*conj(x(1:end-1));
y = atan2( imag(dx), real(dx) );
figure(5);
psd(spectrum.welch('Hamming',1024), y,'Fs',(bwSERV*2));
title("Gęstość widmowa mocy sygnału");


% PILOT
%Częstotliwości graniczne
Wn_pilot = [(18.95e3*2)/(bwSERV*2) (19.05e3*2)/(bwSERV*2)];
b_pilot = fir1(128, Wn_pilot, blackmanharris(128+1));
a_pilot = 1;
figure(6);
freqz(b_pilot, a_pilot, 512, bwSERV*2);
title("Charakterystyka a-cz i f-cz dla filtru filtrującego pilota");
y_pilot = filter( b_pilot, a_pilot, y );
figure(7)
spectrogram(y_pilot, 4096, 4096-512, [18e3:1:20e3], bwSERV*2);
title("Wykres spektrogramu dla pilota");
figure(8);
pwelch(y_pilot, 4096, 4096-512, [18e3:1:20e3], bwSERV*2);
title("Gęstość widmowa mocy dla pilota");

%% Decimate to audio signal bandwidth bwAUDIO
% Mono
Wn_down = (15e3*2)/(bwSERV*2);
b_down = fir1(128, Wn_down, blackmanharris(128+1));
a_down = 1;
figure(9);
freqz(b_down, a_down, 512, (bwSERV*2));
title("Charakterystyka a-cz i f-cz filtra dla sygnału mono")
y_audio_sum = filter( b_down, a_down, y ); % antyaliasing filter
figure(10);
psd(spectrum.welch('Hamming',1024), y_audio_sum,'Fs',bwAUDIO);
title("Widmo mono po filtrze antyaliasingowym")
ym = y_audio_sum(1:5:end);

% Stereo
Wn_dif = [(23e3*2)/(bwSERV*2) (53e3*2)/(bwSERV*2)];
b_dif = fir1(128, Wn_dif, blackmanharris(128+1));
% W przypadku filtrów FIR, mianownik jest zawsze równy 1, 
% ponieważ nie ma sprzężenia zwrotnego w filtrach FIR, 
% a ich odpowiedź impulsowa jest skończona.
a_dif = 1;
figure(11);
freqz(b_dif, a_dif, 512, (bwSERV*2));
y_audio_dif = filter( b_dif, a_dif, y );
title("Charakterystyka a-cz i f-cz filtra stereo");
figure(12);
psd(spectrum.welch('Hamming',1024), y_audio_dif,'Fs',bwSERV*2);
title("Widmo stereo po filtracji");
% Przesunięcie sygnału w częstotliwości
y_audio_dif = y_audio_dif .* cos(2*pi*38e3/(bwSERV*2)*[0:length(y_audio_dif)-1]');
figure(13);
psd(spectrum.welch('Hamming',1024), y_audio_dif,'Fs',bwSERV*2);
title("Widmo stereo po przesunięciu w częstotliwości");

% Zmniejszenie częstotliwości próbkowania do 30kHz
Wn_down_dif = (15e3*2)/(bwSERV*2);
b_down_dif = fir1(128, Wn_down_dif, blackmanharris(128+1));
a_down_dif = 1;
figure(14);
freqz(b_down_dif, a_down_dif, 512, (bwSERV*2));
title("Charakterystyki a-cz i f-cz");
y_audio_dif = filter( b_down_dif, a_down_dif, y_audio_dif ); % antyaliasing filter
figure(15);
psd(spectrum.welch('Hamming',1024), y_audio_dif,'Fs',bwAUDIO);
title("Widmo stereo po filtrze antyaliasingowym");
ys = y_audio_dif(1:5:end);

% Punkt 5
%% Listen to the final result
ym = ym-mean(ym);
ym = ym/(1.001*max(abs(ym)));
ys = ys/(1.001*max(abs(ys)));
yl = 0.5*(ym(1:end-13,1)+ys(14:end,1));
yr = 0.5*(ym(1:end-13,1)-ys(14:end,1));
yl = yl/(1.001*max(abs(yl)));
yr = yr/(1.001*max(abs(yr)));
figure(30);
    subplot(2,1,1);
        plot(yl)
        title("Składowe L i R wyjściowego sygnału stereo");
    subplot(2,1,2)
        plot(yr)
        % soundsc(yr, bwAUDIO*2);