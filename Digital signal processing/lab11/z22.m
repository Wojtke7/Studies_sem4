clear all; close all;

% Wczytanie próbki dźwiękowej
[x, fs] = audioread('DontWorryBeHappy.wav'); 
x = mean(x, 2); % Konwersja do sygnału mono, jeśli jest stereo

% Parametry
N_values = [32, 128];
Q = 0.01; % Początkowa wartość Q, należy dostosować

figure;
for i = 1:length(N_values)
    N = N_values(i);
    
    % Obliczenie macierzy analizy i syntezy
    [A, S] = calculate_mdct_matrices(N);

    % Podział sygnału na okna
    frames = split_into_frames(x, N);

    % Transformacja MDCT
    mdct_coeffs = mdct(frames, A);

    % Kwantyzacja
    quantized_coeffs = quantize_mdct(mdct_coeffs, Q);

    % Dekodowanie
    dequantized_coeffs = dequantize_mdct(quantized_coeffs, Q);
    reconstructed_frames = imdct(dequantized_coeffs, S);

    % Rekonstrukcja sygnału
    y = overlap_add(reconstructed_frames, N);

    % Obcięcie do oryginalnej długości sygnału
    y = y(1:length(x));

    % Obliczenie średniego błędu kwadratowego (MSE)
    mse = mean((x - y).^2);
    disp(['Średni błąd kwadratowy (MSE) dla N = ', num2str(N), ': ', num2str(mse)]);

    % Wykres porównujący oryginalny i zrekonstruowany sygnał
    subplot(length(N_values), 1, i);
    plot(x, 'b');
    hold on;
    plot(y, 'r');
    hold off;
    legend('Oryginalny sygnał', 'Zrekonstruowany sygnał');
    title(['Porównanie sygnału oryginalnego i zrekonstruowanego dla N = ', num2str(N)]);
    xlabel('Numer próbki');
    ylabel('Amplituda');

    % Zapis wyniku do pliku (opcjonalnie)
    audiowrite(['reconstructed_N', num2str(N), '.wav'], y, fs);
end

% Funkcje pomocnicze
function [A, S] = calculate_mdct_matrices(N)
    % Calculate the analysis and synthesis matrices for MDCT
    A = zeros(N/2, N);
    for k = 0:(N/2-1)
        for n = 0:(N-1)
            A(k+1, n+1) = sqrt(4/N) * cos(2*pi*(k + 0.5)*(n + 0.5 + N/4)/N);
        end
    end
    S = A';  % Synthesis matrix is the transpose of analysis matrix
end

function frames = split_into_frames(x, N)
    % Split the signal into overlapping frames
    hop_size = N/2;
    num_frames = ceil(length(x) / hop_size) - 1;
    x_padded = [x; zeros(N - mod(length(x), hop_size), 1)];
    frames = zeros(N, num_frames);

    for i = 1:num_frames
        start_idx = (i-1) * hop_size + 1;
        frames(:, i) = x_padded(start_idx : start_idx + N - 1) .* sin(pi * (0:N-1 + 0.5) / N)';
    end
end

function mdct_coeffs = mdct(frames, A)
    % Apply MDCT to each frame
    mdct_coeffs = A * frames;
end

function quantized_coeffs = quantize_mdct(mdct_coeffs, Q)
    % Quantize MDCT coefficients
    quantized_coeffs = round(mdct_coeffs / Q);
end

function dequantized_coeffs = dequantize_mdct(quantized_coeffs, Q)
    % Dequantize MDCT coefficients
    dequantized_coeffs = quantized_coeffs * Q;
end

function reconstructed_frames = imdct(mdct_coeffs, S)
    % Apply inverse MDCT to each frame
    reconstructed_frames = S * mdct_coeffs;
end

function reconstructed_signal = overlap_add(frames, N)
    % Overlap-add the frames to reconstruct the signal
    hop_size = N/2;
    num_frames = size(frames, 2);
    reconstructed_signal = zeros((num_frames + 1) * hop_size, 1);

    for i = 1:num_frames
        start_idx = (i-1) * hop_size + 1;
        reconstructed_signal(start_idx : start_idx + N - 1) = ...
            reconstructed_signal(start_idx : start_idx + N - 1) + frames(:, i);
    end
end
