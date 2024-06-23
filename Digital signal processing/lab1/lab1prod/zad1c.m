% Zadanie 1.C1
x = 0: 1/100 :1;
for f=0: 5 :300
    plot(x, sin(x * 2 * pi * f));
    title(f);
    pause;
end

close all;
f = @(t) sin(2 * pi * t);
% Porównanie różnych częstotliwości
title('1.C1 5, 105, 205');
autoplot_funs( f,100, 1, containers.Map({'k-o', 'm-o', 'c-o'},{ 5,    105,   205}));
pause;
close all;

title('1.C2 95, 195, 295');
autoplot_funs( f,100, 1, containers.Map({'r-o', 'g-o', 'b-o'},{ 95,    195,   295}));

pause;

close all;
title('1.C3 95, 105');
autoplot_funs( f, 100, 1, containers.Map({'r-o', 'g-*'},{ 95,    105}));

pause;