clear all; close all; clc

%% DPCM (Differential Pulse Code Modulation) 
% to metoda kompresji sygnałów, która opiera się na kodowaniu różnic między kolejnymi próbkami sygnału. 
% Celem jest zmniejszenie ilości danych potrzebnych do reprezentacji sygnału, 
% co jest osiągane poprzez wykorzystanie korelacji między kolejnymi próbkami.

% Ponieważ różnice między próbkami są zwykle mniejsze niż same próbki,
% można je reprezentować mniejszą liczbą bitów. 
% To pozwala na efektywniejsze kompresowanie sygnału i zmniejszenie wymaganej przepustowości
% do przesyłania danych.

% Przy kodowaniu bezpośrednich wartości próbek, potrzeba szerokiego 
% zakresu kodowania (dużej liczby bitów), aby uwzględnić wszystkie możliwe wartości sygnału. 
% Kodowanie różnicowe zmniejsza zakres wartości, które muszą być kodowane, 
% co pozwala na użycie mniejszej liczby bitów na każdą próbkę.


%% Wczytanie próbki dzwiekowej
[x,Fs] = audioread( 'DontWorryBeHappy.wav', 'native' );
x = double( x );

%% KODER
a = 0.9545; % parametr a kodera, czyli współczynnik predykcji
d = x - a*[[0,0]; x(1:end-1,:)]; % KODER, [0,0], bo potrzebna jest pierwsza x(n-1) próbka

%% KWANTYZACJA
% rozdzielczosc sygnalu w bitach - ilosc stanow 2^n wartości
ile_bitow = 4; %liczba bitów, mająca wpływ na ilość stanów (2^ile_bitow)
dq = lab11_kwant(d,ile_bitow); % kwantyzator

n=1:length(x); % oś X do wykresow

% wykres porownujacy sygnal przed i po kwantyzacji

figure;
n=1:length(x);
subplot(2,2,1);
hold on;
plot( n, d(:,1), 'k');
% plot( n, dq(:,1), 'r');
title('Oryginalny kanal lewy'); 
subplot(2,2,2);
hold on;
plot( n, d(:,2), 'k');
% plot( n, dq(:,2), 'r');
title('Oryginalny kanal prawy'); 
subplot(2,2,3);
hold on;
plot( n, dq(:,1), 'r');
title('Kwantyzacja kanal lewy'); 
subplot(2,2,4);
hold on;
plot( n, dq(:,2), 'r');
title('Kwantyzacja kanal prawy'); 

%% DEKODER - faktyczne zadanie
% dekodowanie sygnalu nieskwantyzowanego
y1(1) = d(1,1); % kanal lewy
for k=2:length(dq)
    y1(k) = d(k,1) + a*y1(k-1);
end

y2(1) = d(1,2); % kanal prawy
for k=2:length(dq)
    y2(k) = d(k,2) + a*y2(k-1);
end


% dekodowanie sygnalu z kwantyzacja 
ydl(1) = dq(1,1); %kanal lewy
for k=2:length(dq)
    ydl(k) = dq(k,1) + a*ydl(k-1);
end


ydp(1) = dq(1,2); %kanal prawy
for k=2:length(dq)
    ydp(k) = dq(k,2) + a*ydp(k-1);
end

%% Wykresy (po dekodowaniu)
figure;
subplot(1,2,1);
hold on;
plot( n, x(:,1), 'k');
plot( n, y1, 'r'); % daj tutaj '%' aby wyświetlić sam sygnał oryginalny
title('Zdekodowany kanal lewy'); 
legend('Oryginalny','Zdekodowany');
subplot(1,2,2);
hold on;
plot( n, y2, 'r'); % daj tutaj '%' aby wyświetlić sam sygnał oryginalny
plot( n, x(:,2), 'k');

title('Zdekodowany kanal prawy'); 
legend('Oryginalny','Zdekodowany');

figure;
subplot(1,2,1);
hold on;
plot( n, x(:,1), 'k');
plot( n, ydl, 'r');
title('Zdekodowany kanal lewy (z kwantyzacja)');
legend('Oryginalny','Zdekodowany');
subplot(1,2,2);
hold on;
plot( n, x(:,2), 'k');
plot( n, ydp, 'r');

title('Zdekodowany kanal prawy (z kwantyzacja)'); 
legend('Oryginalny','Zdekodowany');

%
disp('Roznica miedzy oryginalem a odtworzonym:');
display(abs(max(x(:,1)-y1')));
display(abs(max(x(:,2)-y2')));
% disp('Roznica miedzy oryginalem skwantowanym a odtworzonym:');
% display(abs(max(x(:,1)-ydl')));
% display(abs(max(x(:,2)-ydp')));

% laczymy zdekodowanysygnal prawy z lewym
y_kwant = vertcat(ydl,ydp); 
% soundsc(y_kwant,Fs); % odtwarzamy stereo





%% Wykres 1:
% Na 1 wykresie widzimy, że wykres sygnału po przybliżeniu stał się
% bardziej schodkowy, co świadczy o zajściu kwantyzacji i wyborze wartości
% przybliżonych zamiast orginalnych amplitud sygnału. Kwantyzacja jest
% złotym środkiem pomiędzy jakością, a rozmiarem, jeżeli dobrze doierzemy liczbę bitów.

%% Wykres 2:
%Zdekodowany sygnał bez kwantyzacji:

%Lewy kanał: Zdekodowany sygnał (czerwona linia) jest nałożony na oryginalny sygnał (czarna linia). 
% Po przybliżeniu nie widać sygnału oryginalnego, to może być spowodowane 
% bardzo dokładnym odwzorowaniem sygnału przez dekoder. 
% Różnice są minimalne, a czerwona linia całkowicie pokrywa czarną.
%Prawy kanał: Podobna sytuacja jak w lewym kanale. 
% Jeśli zdekodowany sygnał dokładnie odwzorowuje oryginalny, różnice są minimalne.

%% Wykres 3:

% Na 3 wykresie widzimy, że wykres sygnału zdekodowanego z kwantyzacją
% różni się od oryginalnego dokładnością, w zależności od doboru liczby
% bitów.