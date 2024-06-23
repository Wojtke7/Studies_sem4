data = load('adsl_x.mat');
signal = data.x;

blocks = 4; % Liczba bloków
prefix_len = 32; % Długość prefiksu
block_len = 512; % Długość bloku

% Inicjalizacja wektora dla indeksów początkowych prefiksów
index_prefixes = ["i", "i", "i", "i"];
figure;
for b = 1:blocks
    % Obliczanie indeksów początku i końca segmentu sygnału
    start = (b-1)*(prefix_len+block_len) + 1;
    finish = start + prefix_len + block_len - 1;
    
    if finish <= length(signal)
        % Wyznacenie testowanego segmentu
        segment = signal(start:finish);
        
        % Sprawdzenie korelacji między segmentem a całym sygnałem
        cross_corr = xcorr(segment, signal);
        
        plot(cross_corr);
        hold on;
        % Wyznaczenie indeksu o największej wartości korelacji
        [~, max_index] = max(cross_corr);

        % Ustalenie indeksu początkowego prefiksu na podstawie maksymalnej wartości korelacji
        prefix_start_index = max_index - block_len + 1;

        % Zapisywanie wyniku
        index_prefixes(b) = prefix_start_index;
    end
end

% Usuwanie nadmairowych prefixów
for i = 1:blocks
    if index_prefixes(i) == "i"
        index_prefixes(i) = [];
    end
end
% Prezentacja wyników
disp('Prefix indexes:');
disp(index_prefixes);


