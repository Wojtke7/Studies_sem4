clear all; close all;
% Wczytanie próbki dźwiękowej
[x, Fs] = audioread('DontWorryBeHappy.wav'); % wczytanie próbki dźwiękowej
x = double(x);

% Sprawdzenie, czy sygnał jest mono czy stereo
if size(x, 2) > 1
    x = mean(x, 2); % konwersja sygnału stereo na mono poprzez uśrednianie kanałów
end

a = 0.9545; % parametr a kodera

% Koder
d = x - a * [0; x(1:end-1)]; 

% Kwantyzacja
dq = lab11_kwant(d); 

% Dekoder
y = zeros(size(x));
y(1) = dq(1); % inicjalizacja pierwszej próbki

for n = 2:length(dq)
    y(n) = dq(n) + a * y(n-1); % Dekoder
end

% Rysowanie wykresów
figure(1);
n = 1:length(x);
plot(n, x, 'b', n, y, 'r');
legend('Oryginalny sygnał x(n)', 'Zrekonstruowany sygnał y(n)');
title('Porównanie sygnału oryginalnego z zrekonstruowanym');
xlabel('Numer próbki');
ylabel('Amplituda');

%Odsłuchanie dźwięku przed i po operacjach
disp('Odtwarzanie oryginalnego sygnału...');
sound(x, Fs);
pause(length(x)/Fs + 2); % Pauza na czas trwania sygnału + 2 sekundy

disp('Odtwarzanie zrekonstruowanego sygnału...');
sound(y, Fs);
pause(length(y)/Fs + 2); % Pauza na czas trwania sygnału + 2 sekundy

% Funkcja do kwantyzacji
function dq = lab11_kwant(d)
    min_d = min(d);
    max_d = max(d);
    num_levels = 128; % 4 bity -> 2^4 = 16 stanów
    step_size = (max_d - min_d) / (num_levels - 1);
    
    % Kwantyzacja
    dq = round((d - min_d) / step_size) * step_size + min_d;
end