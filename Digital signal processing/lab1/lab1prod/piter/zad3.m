% Wczytywanie danych z pliku 'adsl_x.mat'
Dane = load('adsl_x.mat');
sygnal = Dane.x;

% Ustawienie parametrów sygnału
LiczbaBlokow = 4; % Liczba bloków
DlugoscPrefiksu = 32; % Długość prefiksu
DlugoscBloku = 512; % Długość bloku

% Inicjalizacja wektora dla indeksów początkowych prefiksów
IndeksyPrefiksu = ["i", "i", "i", "i"];
figure;
% Dla każdego bloku:
for b = 1:LiczbaBlokow
    % Obliczanie indeksów początku i końca segmentu sygnału
    start = (b-1)*(DlugoscPrefiksu+DlugoscBloku) + 1;
    koniec = start + DlugoscPrefiksu + DlugoscBloku - 1;
    
    % Sprawdzenie, czy segment mieści się w sygnale
    if koniec <= length(sygnal)
        % Ekstrakcja segmentu sygnału
        segment = sygnal(start:koniec);
        
        % Wykonanie korelacji krzyżowej między segmentem a całym sygnałem
        korelacjaKrzyzowa = xcorr(segment, sygnal);
        
        plot(korelacjaKrzyzowa);
        hold on;
        % Wyznaczenie indeksu o największej wartości korelacji
        [~, maksIndeks] = max(korelacjaKrzyzowa);

        % Ustalenie indeksu początkowego prefiksu na podstawie maksymalnej wartości korelacji
        indeksStartowyPrefiksu = maksIndeks - DlugoscBloku + 1;

        % Zapisywanie wyniku
        IndeksyPrefiksu(b) = indeksStartowyPrefiksu;
    end
end

% Usuwanie nadmairowych prefixów
for i = 1:LiczbaBlokow
    if IndeksyPrefiksu(i) == "i"
        IndeksyPrefiksu(i) = [];
    end
end
% Prezentacja wyników
disp('Indeksy początkowe prefiksów:');
disp(IndeksyPrefiksu);


