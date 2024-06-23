close all
clear all
clc

load("butter.mat")

fs = 16000;
fmin = 1189;
fmax = 1229;
wmin = 2*pi*fmin;
wmax = 2*pi*fmax;

[z_cyf, p_cyf , k_cyf] = bilinear(z,p,k, fs);
[a_cyf,b_cyf] = zp2tf(z_cyf,p_cyf,k_cyf);

% Wczytanie pliku .wav
[s, fs] = audioread('s2.wav'); % 'sX.wav' 

% Filtracja sygnału
filtered_signal = filter(a_cyf, b_cyf, s);

% Obliczenie opóźnienia sygnału
delay = (length(b_cyf)-1)/2;

% Skompensowanie opóźnienia, przesunięcie o wartość 'dealy' w lewo
filtered_signal_compensated = [filtered_signal(delay+1:end); zeros(delay, 1)];

% Spektrogram przed filtracją
figure;
subplot(2,1,1);
spectrogram(s, 4096, 4096-512, [0:5:2000], fs, 'yaxis');
title('Spektrogram przed filtracją');
fprintf("06512")

% Spektrogram po filtracji
subplot(2,1,2);
spectrogram(filtered_signal_compensated, 4096, 4096-512, [0:5:2000], fs, 'yaxis');
title('Spektrogram po filtracji');

% Wyświetlenie sygnałów w dziedzinie czasu
figure;
t = (0:length(s)-1)/fs;
t_compensated = (0:length(filtered_signal_compensated)-1)/fs;
plot(t, s, 'b', t_compensated, filtered_signal_compensated, 'r');
xlabel('Czas [s]');
ylabel('Amplituda');
legend('Przed filtracją', 'Po filtracji (skompensowane opóźnienie)');
title('Sygnały w dziedzinie czasu');