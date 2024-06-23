% cps_13_aac.m

% Podstawy kodera audio AAC z uzyciem nakladkowej transformacji MDCT
clear all; close all;

% liczba przetwarzanych ramek sygnalu audio
Nmany = 100;    

% AAC ma długośc okien dla sygnału tonowanego 2048 a dla zaszumionego 248 
% Okna sprawiają że sygnał jest łatwiejszy do dalszej przetwarzania 
% N= 32; 
N=128;
% N = 2048; 

M = N/2;                    % przesuniecie okna 50% 
Nx = N+M*(Nmany-1);         % liczba przetwarzanych probek sygnalu audio

% Sygnal wejsciowy
[x, fpr ] = audioread('DontWorryBeHappy.wav'); size(x),   % rzeczywisty wczytany
% fpr=44100; x=0.3*randn(Nx,1);                          % syntetyczny szum
% fpr=44100; x = 0.5*sin(2*pi*200/fpr*(0:Nx-1)');        % syntetyczny sinus
x = x(1:Nx,1);                                           % wez tylko poczatek  
figure; plot(x);                                  % pokaz

% Macierze transformacji MDCT oraz IMDCT o wymiarach M=N/2 x N
win = sin(pi*((0:N-1)'+0.5)/N);    % pionowe okno do wycinania fragmentu sygnalu (hamminga) 
k = 0:N/2-1; n=0:N-1;              % wiersze-czestotliwosci, kolumny-probki
C = sqrt(2/M)*cos(pi/M*(k'+1/2).*(n+1/2+M/2)); % macierz C (N/2)xN analizy MDCT
% Kodowanie jest jak analiza
D = C'; % transpozycja                         % macierz D Nx(N/2)syntezy IMDCT

% Analiza AAC
sb = zeros(Nmany,M);       % sb jest buforem przechowującym współczynniki MDCT dla każdej ramki.        
for k=1:Nmany                                     % PETLA ANALIZY SYGNALU - RAMKI AUDIO (przetwarza kolejne ramki)
    n = 1+(k-1)*M  : N + (k-1)*M;                 % ustalenie ideksów próbek dla danej ramki
    bx = x( n ) .* win;                           % pobranie probek do bufora .* okno
    BX = C*bx;                                    % MDCT
    sb(k,1:M) = BX';                              % ew. zapamietanie do pozniejszej kwantyzacji
end                                               % KONIEC PETLI 

sbmax = max( abs(sb) );                         % znajdz maksima
sc = 2^19; %Q dla 32 18 zeby byla bezstratna, dla 128 ~ 19
sb = sbmax .* fix( sc .* (sb./sbmax) ) ./ sc;   % skwantowanie

% Synteza AAC
% Macierzy syntezy służy do odtworzenia zakodowanego sygnału
y = zeros(Nx,1);                                % sygnal wyjsciowy
for k=1:Nmany                                   % PETLA SYNTEZY SYGNALU
    n = 1+(k-1)*M  : N + (k-1)*M;               % numery probek od do
    BX = sb(k,1:M)';                            % odtworzenie podpasm
    by = D*BX;                                  % IMDCT
    y( n ) = y( n ) + by .* win;                % rekonstrukcja sygnalu z oknem, dodanie probek do poprzedniej ramki
end                                             % KONIEC PETLI

n = 1:Nx;
% soundsc(y,fpr);                                    
figure; plot(n,x,'ro',n,y,'bx'); title('Input (o), Output (x)'); 
m=M+1:Nx-M;                                       % indeksy probek
max_abs_error = max(abs(y(m)-x(m))),        % blad

