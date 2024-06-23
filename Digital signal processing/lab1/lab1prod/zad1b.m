f = @(t) sin(50 *2*pi*t);

close all;
hold on;

autoplot_fun(f, 1, containers.Map({'b-', 'g-o', 'r -o', 'k-o'},{10^4,   51,    50,    49}));
title('1.B1');
pause;
close all;
hold on;

autoplot_fun(f, 1,containers.Map({'b-', 'g-o', 'r-o', 'k-o'}, {10^4,   26,    25,    24}));

title('1.B2');
pause;
close all;