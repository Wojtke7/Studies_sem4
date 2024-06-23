close all; clear all;

% Uruchomienie kodera dla N=32
%mdct_coder(32, 2.7);

% Uruchomienie kodera dla N=128
mdct_coder(128, 3);


function mdct_coder(N, Q_target)

    % Wczytanie sygnału
    [x, fpr] = audioread('DontWorryBeHappy.wav');
    x = double(x);
    x = x(:, 1); % przetwarzamy lewy kanal

    % Okno analizy i syntezy
    n = 0:N-1;
    h = sin(pi*(n+0.5)/N);  % okno analizy i syntezy

    figure;
    plot(n, h, 'o')
    hold all
    grid
    title("Okno analizy i syntezy")
    xlabel("Próbki"); ylabel("Amplituda");

    % Macierz analizy Modified DCT
    A = zeros(N/2, N);
    for k = 1:N/2 
        A(k, :) = sqrt(4/N) * cos(2*pi/N * (k-1 + 0.5) * (n + 0.5 + N/4));
    end

    % Macierz syntezy (transponowanie macierzy analizy)
    S = A';

    % Kodowanie transformacyjne
    Q = Q_target; % współczynnik skalujący kwantyzację
    y = zeros(1, length(x));
    dref = y;

    for i = 1:N/2:length(x)-N
        % Pobranie próbki o długości okna
        probka = x(i:i+N-1);
        % Okienkowanie; mnożenie przez okno
        okienkowany = probka'.*h;
        % Analiza; mnożenie przez macierz analizy
        analizowany = A * okienkowany';
        % Kwantyzacja
        kwantyzowany = round(analizowany * Q);
        % Synteza; mnożenie przez macierz syntezy
        syntezowany = S * kwantyzowany;
        % Ponowne okienkowanie
        odokienkowany = h .* syntezowany';
        % Zapisywanie do sygnału
        y(i:i+N-1) = y(i:i+N-1) + odokienkowany;

        % Referencja bez kwantyzacji
        syntezowany = S * analizowany;
        odokienkowany = h .* syntezowany';
        dref(i:i+N-1) = dref(i:i+N-1) + odokienkowany;
    end

    % Zmniejszanie amplitudy, pomaga ukryć szumy
    y = y / Q;

    % Błąd
    max_error = max(abs(x - y'))
    mean_error = mean(abs(x - y'))

    % Wykresy
    n = 1:length(x);

    figure;
    hold all;
    plot(n, x)
    plot(n, y);
    title(['Sygnał oryginalny vs po odkodowaniu z MDCT dla N=', num2str(N)]);
    legend('Referencyjny', 'Zrekonstruowany')

    % Obliczanie przepływności bitów
    num_samples = length(x);
    num_frames = floor((num_samples - N) / (N/2)) + 1;
    bits_per_frame = N/2 * log2(Q);  % liczba bitów na ramkę
    bitrate = bits_per_frame * num_frames * fpr / num_samples;

    fprintf('Przepływność bitów dla N=%d: %.2f kbps\n', N, bitrate / 1000);

    % Słuchanie
    soundsc(y, fpr)

end

