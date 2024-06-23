clc;
% Zadanie 3 -  DtFT rola funkcji okien i liczby próbek
clear all; close all;

% Dane
N = 100;    % liczba probek
fs = 1000;  % czestotliwosc probkowania
st = 1/fs;  % krok próbkowania
T = 0.1;    % czas trwania probkowania (100 probek dla 1000Hz = 0.1s)

sample = 0:st:T-st; % przedział czasowy próbkowania

%  Częstotliwości
f1 = 100;
f2 = 125;

% Amplitudy 
A1 = 1;
A2 = 0.0001;

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
legend('s1 100Hz','s2 125Hz');
xlabel('Numer próbki');

subplot(2,1,2);
plot(x, 'r-o')
title('Zsumowane cosinusy');
legend('s1 + s2');
xlabel('Numer próbki');
pause;

% Obliczanie DtFT
f = 0:0.1:500;
X = zeros(1,length(f));

for fi = 1:length(f)
    for n = 0:N-1
        X(fi) = X(fi) + x(n+1) * exp(-1i*2*pi*f(fi)*n/fs);
    end
end
X = X./N;

% figure(3);
% plot(f, real(X));
% title('DtFT x');
% xlabel('Częstotliwość [Hz]');

% Rysowanie widma y sygnału x
XRe = real(X);   %część rzeczywista
XIm = imag(X);   %część urojona
XA  = abs(X);    %moduł
XP  = angle(X);  %faza

% Skalowanie osi częstotliwości w Herzach

figure(4);
subplot(2,1,1);
plot(f,XRe, 'b-');
title('Re');
xlabel('Częstotliwość [Hz]');

subplot(2,1,2);
plot(f, XIm, 'r-');
title('Im');
xlabel('Częstotliwość [Hz]');
pause;


figure(5);
subplot(2,1,1);
plot(f, XA, 'b-');
title('A');
xlabel('Częstotliwość [Hz]');

subplot(2,1,2);
stem(f, XP, 'r-');
title('ϕ');
xlabel('Częstotliwość [Hz]');
pause;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wykresy okien
figure(6);
title('Okna');
hold all;
plot(0:N-1,rectpuls(sample,N/fs), 'b-');
plot(0:N-1,hamming(N), 'r-');
plot(0:N-1,blackman(N), 'k-');
plot(0:N-1,chebwin(N, 100), 'g-');
plot(0:N-1,chebwin(N, 120), 'm-');
legend('Prostokątne','Hamminga','Blackmana','Czebyszewa 100','Czebyszewa 120');
pause;
% wymnożenie sygnałów

xbox = rectpuls(sample,N/fs).*x';
Xbox(1:length(f)) = 0;

xham = hamming(N).*x';
Xham(1:length(f)) = 0;

xbla = blackman(N).*x';
Xbla(1:length(f)) = 0;

xche = chebwin(N, 100).*x';
Xche(1:length(f)) = 0;

xche2 = chebwin(N, 120).*x';
Xche2(1:length(f)) = 0;

% Obliczenie transformat 
for fre=1:length(f)
    for j=0:N-1
        Xbox(fre) = Xbox(fre) + 1/N * xbox(j+1)*exp(-1i*2*pi*f(fre)/fs*j);
        Xham(fre) = Xham(fre) + 1/N * xham(j+1)*exp(-1i*2*pi*f(fre)/fs*j);
        Xbla(fre) = Xbla(fre) + 1/N * xbla(j+1)*exp(-1i*2*pi*f(fre)/fs*j);
        Xche(fre) = Xche(fre) + 1/N * xche(j+1)*exp(-1i*2*pi*f(fre)/fs*j);
        Xche2(fre) = Xche2(fre) + 1/N * xche2(j+1)*exp(-1i*2*pi*f(fre)/fs*j);
    end
end

figure(7);
plot(f, abs(Xbox), "b-", f, abs(Xham), "r-", f, abs(Xbla), "k-", f, abs(Xche), "g-", f, abs(Xche2), "m-");
legend('Prostokątne','Hamminga','Blackmana','Czebyszewa 100 dB', 'Czebyszewa 120 dB');
pause;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zmiana liczby próbek na 1000 i powtórzenie ćwiczenia dla okna Czebyszewa

% Dane
N = 1000;    % liczba probek
fs = 1000;  % czestotliwosc probkowania
st = 1/fs;  % krok próbkowania
T = 1;    % czas trwania probkowania (100 probek dla 1000Hz = 0.1s)

sample = 0:st:T-st; % przedział czasowy próbkowania

%  Częstotliwości
f1 = 100;
f2 = 125;

% Amplitudy 
A1 = 1;
A2 = 0.0001;

% Kąty fazowe
p1 = (pi/7);
p2 = (pi/11);

% Tworzenie sygnału z sumy sinusów 
s1 = @(t) A1 * cos(2*pi*f1*t + p1);
s2 = @(t) A2 * cos(2*pi*f2*t + p2);

% Sygnał x z sumy sinusów 
x = s1(sample) + s2(sample);

% Obliczanie DtFT
% f = 0:0.1:500;
% X = zeros(1,length(f));
% 
% for fi = 1:length(f)
%     for n = 0:N-1
%         X(fi) = X(fi) + x(n+1) * exp(-1i*2*pi*f(fi)*n/fs);
%     end
% end
% X = X./N;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xche = chebwin(N, 100).*x';
Xche(1:length(f)) = 0;

xche2 = chebwin(N, 200).*x';
Xche2(1:length(f)) = 0;

for fre=1:length(f)
    for j=0:N-1
        Xche(fre) = Xche(fre) + 1/N * xche(j+1)*exp(-1i*2*pi*f(fre)/fs*j);
        Xche2(fre) = Xche2(fre) + 1/N * xche2(j+1)*exp(-1i*2*pi*f(fre)/fs*j);
    end
end

figure(8);
plot(f, abs(Xche), "b-", f, abs(Xche2), "r-");
legend('Czebyszewa 100dB', 'Czebyszewa 120dB');


 















