clc;
clear all; close all;

% Wczytanie danych z pliku 'lab_03.mat'
bity = load('lab_03.mat');
modulo = mod(415626, 16) + 1,
x = bity.x_11;

% Parametry ramki
fraames = 8;
M = 32;
N = 512;
fr = zeros(fraames, N);

% Podział danych na ramki
for frameIndex = 0:7
    frs = frameIndex * (M + N) + 32 + 1; % początek ramki
    fre = frs + 511; % koniec ramki
    fr(frameIndex + 1, :) = x(frs:fre);
end

% Przetwarzanie ramek za pomocą FFT i rysowanie widma dla każdej ramki
for i = 1:fraames 
    X = fft(fr(i, :), 512);
    figure(3);
    plot(1:512, 20 * log10(abs(X)));
    title(['Widmo dla ramki ', num2str(i)]);
    xlabel('Indeks częstotliwości');
    ylabel('Amplituda (dB)');
    pause;

        % Wyznaczanie harmonicznych
    [~, sortedIndices] = sort(abs(X), 'descend');
    harmonicIndices = sortedIndices(1:5); % interesuje nas 5 najwyższych harmonicznych
    disp(['Harmoniczne w ramce ', num2str(i), ': ', num2str(harmonicIndices)]);
    pause;
end

% Rysowanie sygnału czasowego dla każdej ramki
for i = 1:fraames
    figure(4);
    stem(1:512, fr(i, :));
    title(['Sygnał czasowy dla ramki ', num2str(i)]);
    xlabel('Numer próbki');
    ylabel('Amplituda');
    pause;
end

%Kod przetwarza dane modulacyjne, dzieląc je na 8 ramek i analizując widma oraz sygnały czasowe każdej z nich za pomocą FFT.
% Widmo przedstawione jest w skali decybelowej, co pozwala na ocenę rozmieszczenia amplitud w dziedzinie częstotliwości.