% cps_13_aac.m
% Podstawy kodera audio AAC z uzyciem nakladkowej transformacji MDCT
clear all; close all;

Nmany = 5000;                   % liczba przetwarzanych ramek sygnalu audio
% N = 2048;                     % dlugosc okna
% N= 32;                          
N = 128;
M = N/2;                        % przesuniecie okna 50% 
Nx = N+M*(Nmany-1);             % liczba przetwarzanych probek sygnalu audio

% Sygnal wejsciowy
[x, fpr ] = audioread('DontWorryBeHappy.wav'); size(x); % rzeczywisty wczytany
x = x(1:Nx,1);                                           % wez tylko poczatek
figure; plot(x);                                         % pokaz

% Macierze transformacji MDCT oraz IMDCT o wymiarach M=N/2 x N
win = sin(pi*((0:N-1)'+0.5)/N);                 % pionowe okno do wycinania fragmentu sygnalu
k = 0:N/2-1; n=0:N-1;                           % wiersze-czestotliwosci, kolumny-probki
C = sqrt(2/M)*cos(pi/M*(k'+1/2).*(n+1/2+M/2));  % macierz C (N/2)xN analizy MDCT
D = C'; % transpozycja                          % macierz D Nx(N/2)syntezy IMDCT

% Analiza-synteza AAC
sb = zeros(Nmany,M);                                % sygnal wyjsciowy
for k=1:Nmany                                       % PETLA ANALIZY SYGNALU - RAMKI AUDIO
    n = 1+(k-1)*M  : N + (k-1)*M;                   % numery probek fragmentu od-do
    bx = x( n ) .* win;                             % pobranie probek do bufora .* okno
    BX = C*bx;                                      % MDCT przejście z dziedziny czasu na częstotliwość 
    sb(k,1:M) = BX';                                % ew. zapamietanie do pozniejszej kwantyzacji
end                                                 % KONIEC PETLI 

sbmax = max( abs(sb) );                         
sc = 2^19;  % Q, współczynnik skalujący kwantyzacje
% dla N=32, około 18 dla bezstratnego; dla N=128, około 19/20  % metoda prob i bledow
sb = sbmax .* fix( sc .* (sb./sbmax) ) ./ sc;   % KWANTYZACJAAA !

%Wartość 
%  Proces kwantyzacji polega na skalowaniu współczynników MDCT przez sc, 
% zaokrąglaniu ich do najbliższej liczby całkowitej, a następnie ponownym skalowaniu.
%Q wpływa na liczbę bitów potrzebnych do reprezentacji skwantyzowanych współczynników. Wyższe 
%Q skutkuje bardziej precyzyjnymi poziomami kwantyzacji, co oznacza, że potrzebne są więcej bity, 
% prowadząc do wyższego bitrate, ale lepszej jakości dźwięku. Z kolei niższe 
% skutkuje grubsza kwantyzacja, co zmniejsza bitrate, ale może pogorszyć jakość dźwięku.
%Wyższe 
%Q (np. 2^19):
%Powoduje mniejszy błąd kwantyzacji.
%Zachowuje więcej szczegółów oryginalnego sygnału audio.
%Skutkuje wyższym bitrate i potencjalnie większym rozmiarem pliku.
%Osiąga wyższą jakość dźwięku, bliższą bezstratnej.
%Niższe Q (np. 2^10):
%Wprowadza większy błąd kwantyzacji.
%Może utracić pewne szczegóły oryginalnego sygnału audio.
%Skutkuje niższym bitrate i mniejszym rozmiarem pliku.
%Może pogorszyć jakość dźwięku z powodu większego zniekształcenia.


% Oblicz bitrate po kwantyzacji (kodowanie)
num_bits_encoded = numel(sb) * log2(sc); % liczba bitów zakodowanych współczynników
duration = length(x) / fpr; % czas trwania w sekundach
bitrate_encoded = num_bits_encoded / duration; % bitrate w bitach na sekundę

% Wyświetl bitrate po kwantyzacji
disp(['Bitrate (encoded): ', num2str(bitrate_encoded), ' bps']);

y = zeros(Nx,1);                                % sygnal wyjsciowy
for k=1:Nmany                                   % PETLA SYNTEZY SYGNALU
    n = 1+(k-1)*M  : N + (k-1)*M;               % numery probek od do
    BX = sb(k,1:M)';                            % odtworzenie podpasm
    by = D*BX;                                  % IMDCT przejście z dziedziny częstotliwości na dziedzinę czasu
    y( n ) = y( n ) + by .* win;                % rekonstrukcja sygnalu z oknem
end                                             

% Oblicz bitrate po dekodowaniu
num_bits_decoded = numel(y) * 16; % przypuszczamy 16-bit PCM data
bitrate_decoded = num_bits_decoded / duration; % bitrate w bitach na sekundę

% Wyświetl bitrate po dekodowaniu
%Bitrate dekodowanego sygnału PCM będzie taki sam, niezależnie od wartości 
%Q, ponieważ jest on określony przez format dekodowanego sygnału. 
% W przypadku standardowego sygnału audio PCM (np. 16-bitowy PCM), bitrate jest określony przez 
% częstotliwość próbkowania i rozdzielczość bitową, a nie przez stopień kompresji zastosowany w kodowaniu.
disp(['Bitrate (decoded): ', num2str(bitrate_decoded), ' bps']);

n = 1:Nx;
soundsc(y,fpr);                                                     % odsluchaj
figure; plot(n,x,'ro',n,y,'bx'); title('Input (o), Output (x)');    % porownaj
m=M+1:Nx-M;                                                         % indeksy probek
max_abs_error = max(abs(y(m)-x(m))),                                % blad,


% MDCT (Modified Discrete Cosine Transform) to zmodyfikowana wersja dyskretnej transformaty cosinusowej (DCT), 
% która jest używana w kompresji audio. Jest to transformacja często stosowana w kodowaniu dźwięku,
% takim jak AAC (Advanced Audio Coding) i MP3. 
% MDCT ma kilka cech, które czynią ją szczególnie przydatną w tych zastosowaniach:
%Blokowe przetwarzanie sygnału: MDCT przetwarza sygnał audio w blokach,
% które są częściowo nałożone na siebie. To oznacza, że dla każdego bloku N próbek,
% MDCT przetwarza N/2 nowych próbek i N/2 próbek z poprzedniego bloku.
% Dzięki temu unika się artefaktów na granicach bloków, które mogą wystąpić przy zwykłej DCT.
%Transformacja o współczynniku 2:1: MDCT przekształca N próbek czasowych na N/2 współczynników częstotliwościowych. 
% Dzięki temu redukuje liczbę danych potrzebnych do reprezentacji sygnału, co jest kluczowe dla kompresji.
%Energia współczynników: Dzięki właściwościom okna (funkcja sinusoidalna) używanego w MDCT, 
% energia sygnału jest bardziej równomiernie rozłożona między współczynniki, co ułatwia kwantyzację i kompresję.
%Brak aliasingu: Właściwości nakładania się bloków w MDCT eliminują aliasing, 
% który mógłby wprowadzać zniekształcenia do zrekonstruowanego sygnału.