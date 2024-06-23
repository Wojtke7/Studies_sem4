function dq = lab11_kwant(d, pom)
    % b = 4; % Liczba bitów do kwantyzacji
    % numLevels = 2^b; % Liczba poziomów kwantyzacji
    % stepSize = (maxVal - minVal) / numLevels, % Wielkość kroku kwantyzacji
    % 
    % % Kwantyzacja
    % d_normalized = (d - minVal) / stepSize; % Normalizacja do zakresu [0, numLevels-1]
    % d_quantized = round(d_normalized); % Kwantyzacja do najbliższego poziomu
    % dq = d_quantized *stepSize + minVal; % Denormalizacja do oryginalnego zakresu
    b=4;
    % Im więcej bitów tym więcej stanów można na nich zapsiać (na 4 bitach
    % można zapisać tylko 16 liczb)
    sc=2^b;
    dmax=max(abs(d));
    dq = dmax * fix( sc*d/dmax ) / sc + pom;
end