clc;
% Zadanie 2 -  DtFT sygnału harmonicznego
clear all; close all;

% Dane
N = 100;    % liczba probek
fs = 1000;  % czestotliwosc probkowania
ds = 1/fs;  % krok próbkowania
T = 0.1;    % czas trwania probkowania (100 probek dla 1000Hz = 0.1s)

sample = 0:ds:T-ds; % przedział czasowy próbkowania

%  Częstotliwości
f1 = 125;
f2 = 200;

% Amplitudy 
A1 = 100;
A2 = 200;

% Kąty fazowe
p1 = (pi/7);
p2 = (pi/11);

% Tworzenie sygnału z sumy sinusów 
s1 = @(t) A1 * cos(2*pi*f1*t + p1);
s2 = @(t) A2 * cos(2*pi*f2*t + p2);

% Sygnał x z sumy sinusów 
x = s1(sample) + s2(sample);

figure(2);
subplot(2,1,1);
hold all;
plot(s1(sample), 'r-o');
plot(s2(sample), 'b-o');
title('Dwa cosinusy do sumowania');
legend('s1 125Hz','s2 200Hz');
xlabel('Numer próbki');

subplot(2,1,2);
plot(x, 'r-o')
title('Zsumowane cosinusy');
legend('s1 + s2');
xlabel('Numer próbki');
pause;

% Generowanie macierzy A - macierzy transformacji DFT
% W = exp(1i*2*pi/N)

for k = 1:N
    for n = 1:N
        A(k,n) = (1/sqrt(N)) * ((exp(1i*2*pi/N)) ^ (-(k-1)*(n-1)));
    end
end

% Dyskretna transformata Fouriera - DFT - otrzymujemy X1
X1 = A * x';

% Zwiększ rozdzielczości częstotliwości poprzez 
% dołączenie 100 zer na końcu sygnału x, otrzymujemy xz
M = 100;
xz = x;
xz(1,101:M+N) = 0;

% DFT xz podstawie wzoru - otrzymujemy X2
X2 = fft(xz)./(N+M);

% DtFT x na podstawie wzoru - otrzymujemy X3
df = 0.25;
f = 0:df:1000;

X3 = zeros(1,length(f));
for q = 1:length(f)
    for n = 0:N-1
        X3(q) = X3(q) + x(n+1) * exp(-1i*2*pi*f(q)*n/fs);
    end
end
X3 = X3./N;

% Skalowanie osi częstotliwości w Herzach
fx1 = (0:N-1)*fs/N;
fx2 = (0:N+M-1)*fs/(N+M);
fx3 = f;

figure(3);
subplot(1,3,1);
plot(fx1, real(X1));
title('X1 - DFT');
xlabel('Częstotliwość [Hz]');

subplot(1,3,2);
plot(fx2, real(X2));
title('X2 - 100 zer na końcu x');
xlabel('Częstotliwość [Hz]');

subplot(1,3,3);
plot(fx3, real(X3));
title('X3 - DtFT');
xlabel('Częstotliwość [Hz]');
pause;


figure(4);
plot(fx1,abs(X1),'b',fx2,abs(X2),'r',fx3,abs(X3),'g');
%xlim([0 fs/2]);
legend('X1','X2','X3');
title('Widma sygnałów nałożone na siebie');
xlabel('Częstotliwość [Hz]');
pause;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DtFT x na podstawie wzoru - otrzymujemy X3
df = 0.25;
f = -2000:df:2000;

X3 = zeros(1,length(f));
for q = 1:length(f)
    for n = 0:N-1
        X3(q) = X3(q) + x(n+1) * exp(-1i*2*pi*f(q)*n/fs);
    end
end
X3 = X3./N;

% Skalowanie osi częstotliwości w Herzach
fx1 = (0:N-1)*fs/N;
fx2 = (0:N+M-1)*fs/(N+M);
fx3 = f;

figure(5);
subplot(1,3,1);
plot(fx1, real(X1));
title('X1 - DFT');
xlabel('Częstotliwość [Hz]');

subplot(1,3,2);
plot(fx2, real(X2));
title('X2 - 100 zer na końcu x');
xlabel('Częstotliwość [Hz]');

subplot(1,3,3);
plot(fx3, real(X3));
title('X3 - DtFT');
xlabel('Częstotliwość [Hz]');
pause;

figure(6);
plot(fx1,abs(X1),'b',fx2,abs(X2),'r',fx3,abs(X3),'g');
%xlim([0 fs/2]);
legend('X1','X2','X3');
title('Widma sygnałów nałożone na siebie');
xlabel('Częstotliwość [Hz]');







%Program ten służy do zrozumienia różnic między dyskretną transformatą 
% Fouriera (DFT), która operuje na skończonej liczbie próbek, a dyskretną 
% transformatą Fouriera w czasie (DtFT), która pozwala na analizę sygnałów
% w dziedzinie częstotliwości w sposób ciągły. Porównanie wyników różnych 
% transformacji pomaga zrozumieć ich właściwości i ograniczenia.






