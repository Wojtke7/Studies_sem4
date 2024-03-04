clc;
clear all; close all;

% Generator wzorców cosinusowych w pętli
N = 20;
sk = sqrt(1/N);

for k = 1:N 
    for n = 1:N 
        A(k,n) = sk * cos(pi*(k-1)/N * ((n-1)+0.5));
    end
    sk = sqrt(2/N);
end

% przykład obliczania iloczynu skalarnego
% w1 = A(1,:);
% w2 = A(2,:);
% w12 = w1 .* w2; 


% Sprawdzenie czy wektory w wierszach macierzy 
% są do siebie ortonormalne, czyli
% czy iloczyn skalarny wszystkich par jest równy zero. 

% Suma iloczynów odpowiadających sobie próbek:
% prod1 = sum(w12) 

B = zeros(N,N);
tol = 10^(-14);

for l = 1:N
    w1 = A(l,:);
    for m = 1:N
        w2 = A(m,:);
        w12 = w1 .* w2;
        prod1 = sum(w12);

        % ortonormalne czyli równe 0 (bliskie 0 przez matlaba)
        % przyrównujemy je do 0
        if abs(prod1) < tol && l~=m
            prod1 = 0;
            fprintf('Para %u, %u jest ortonormalna \n', l,m);
        else 
            % na przekątnej równe 1 (bliskie 1 przez matlaba)
            % przyrównujemy je do 1
            prod1 = 1;
        end
        B(l,m) = prod1;
    end
end