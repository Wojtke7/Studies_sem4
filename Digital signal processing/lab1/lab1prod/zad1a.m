close all;
hold on;

f = @(t) 230 * sin(50 *2*pi*t);
    
autoplot_fun(f,0.1,containers.Map({'b-', 'r-o', 'k-x'},{ 10^4,  500,   200}));

title('1.A');
pause;
close all;