clear all;
close all;
%% 1. generowanie pilota 19kHz o stalym przesunieciu fazowym
fpilot = 19000; % Częstotliwość 19 kHz
fs = 44100; % Częstotliwość próbkowania
t = 0:1/fs:1; % Wektor czasu od 0 do 1 sekundy z częstotliwością próbkowania fs

df = 10; % Zmiana częstotliwości ±10 Hz
fm = 0.1; % Częstotliwość zmiany częstotliwości (10 sekund)

phase_offset = pi/4; % Przesunięcie fazowe o pi/4 radianów (możesz zmienić na dowolną wartość)

p = sin(2*pi*fpilot*t + phase_offset); %sygnal wejsciowy z przesunieciem

change = df * sin(2*pi*fm*t);
p = sin(2*pi*(fpilot + change).*t + phase_offset);

%% 3. Dodanie szumu i ocena szybkości zbieżności pętli PLL
noise_dB = [0, 5, 10, 20]; % szum AWGN o mocy w dB
convergence_threshold = 1e-3; % Próg zbieżności
for i = 1:length(noise_dB)
    
    % Dodanie szumu
    p_awgn = awgn(p, noise_dB(i), 'measured');
    
    % Cyfrowa pętla PLL
    freq = 2*pi*fpilot/fs;
    theta = zeros(1,length(p_awgn)+1);
    alpha = 1e-2;
    beta = alpha^2/4;
    converged = false;
    for n = 1 : length(p_awgn)
        perr = -p_awgn(n)*sin(theta(n));
        theta(n+1) = theta(n) + freq + alpha*perr;
        freq = freq + beta*perr;
        
         % Sprawdzenie zbieżności dla wszystkich nosnych
        c1n = cos((1/19)*theta(n));
        c19n = cos(theta(n));
        c38n = cos(2*theta(n));
        c57n = cos(3*theta(n));
        
        
        if ~converged && abs(p_awgn(n) - c19n) < convergence_threshold
            fprintf('Dostrojenie nastąpiło przy próbce %d dla szumu %d dB\n', n, noise_dB(i));
            converged = true;
        end
    end
    
    c1(:,1) = cos((1/19)*theta(1:end-1));
    c19(:,1) = cos(theta(1:end-1));
    c38(:,1) = cos(2*theta(1:end-1));
    c57(:,1) = cos(3*theta(1:end-1)); % Wygenerowanie nosnej 57 kHz
    

end


%szum jest losowy stad roznice