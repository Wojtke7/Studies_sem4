L = load('adsl_x.mat');
signal = L.x;
f = abs(fft(signal)); % Przekształcenie sygnału z dziedziny czasu do dziedziny częstotliwości
% plot(f);
f_sort = sort(f, 'descend'); % Sortowanie częstotliwości od największej do najmniejszej
i1 = f_sort(1);
i2 = f_sort(2);
i3 = f_sort(3);
i4 = f_sort(4);
i = max(f);

hold on;
plot(signal(i1:i1+32) - signal(i2:i2+32), 'r-'); % Różnice między dwoma blokami sygnału
pause;
plot(signal(i2:i2+32) - signal(i3:i3+32), 'g-*');
pause;
plot(signal(i3:i3+32) - signal(i1:i1+32), 'b-o');
