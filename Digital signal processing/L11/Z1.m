clear all; close all;
clc;

%% Wczytanie danych i zdefiniowanie potrzebnych parametrów
[x, Fs] = audioread('DontWorryBeHappy.wav'); % wczytanie próbki dźwiękowej
x = double(x);
a = 0.9545;


%%  Inicjalizacja macierzy d
d = zeros(size(x));
d(1,:) = x(1,:);
d(2:end, :) = x(2:end, :) - a * x(1:end-1, :);

%% Kwantyzacja
dq(:,1) = lab11_kwant(d(:,1) - mean(d(:,1)), mean(d(:,1)));
dq(:,2) = lab11_kwant(d(:,2) - mean(d(:,2)), mean(d(:,2)));

%% Dekodowanie
y = zeros(size(x));
y(1,:) = dq(1,:);
for n = 2:length(dq)
    y(n,:) = dq(n,:) + a*y(n-1,:);
end

m=1:length(d);
max_abs_error  = max(abs(y(m)-x(m))), % maksymalny błąd odwzorowania po rekonstrukcji sygnału
mean_abs_error = mean(abs(y(m) - x(m))),

sound(y, Fs);
%% Przedstawienie wyników
figure( 1 );
n=1:length(x);
plot( n, x, 'b', n, y, 'r' );





