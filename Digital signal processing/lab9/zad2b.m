close all; 
clear all;

%% wczytanie sygnalow mowy
[SA,FS1]=audioread('mowa_1.wav');   %glos osoby A - to co chcemy uzyskaæ
[SB,FS2]=audioread('mowa_2.wav');   %glos osoby B
[SAG,FS3]=audioread('mowa_3.wav');  %glos osoby A zaszumiony G(Sb)
d = SAG';
x = SB';
dref = SA';
fs = 38527;
t = 0:1/fs:1;

%% tworzenie filtru adaptacyjnego i filtracja
M=60;
mi=0.075; 
y=[];
e=[];
bx=zeros(M,1);
h=zeros(M,1);
for n=1:length(x)
    bx=[x(n); bx(1:M-1)];
    y(n)=h'*bx;
    e(n)=d(n)-y(n);
    h=h+mi*e(n)*bx;
    %h=h+mi*e(n)*bx/(bx'*bx);
end

%% odsluch po przejsciu przez filtr
soundsc(e,FS1) %e - sygnal odszumiony (ten gdzie gada niby jedna)
pause;
soundsc(d,FS1) %d - sygnal zaszumiony (ten gdzie gadaj¹ naraz)
pause;
soundsc(dref,FS1) %dref - referencyjny
%% SNR
SNR = 10*log10((sum(dref.^2))/(sum((dref-e).^2)));
display(SNR);

%% wykresy
figure(1);
plot(t,dref,t,d,t,e);
title('ox - czas, oy - amplituda');
legend('Sygnal czysty','Zaszumiony (2 osoby)','Po odzyskaniu (druga pani przyciszona)');
