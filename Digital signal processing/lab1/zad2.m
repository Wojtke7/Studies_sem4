clear all;
close all;

t2 = 4*pi;
f1 = 5;
T1 = 1/f1;

x1 = 0: 1/f1: t2;
y1 = sin(x1);

f2 = f1 * 10;
T2 = 1/f2;

x2 = 0: 1/f2 :t2;
y2 = zeros(length(x2), 1);

for i = 1:length(x2)
    y = 0;
    for j = 1:length(x1)
        b = pi / T1 * ((i-1)*T2 - (j-1)*T1);
        sb = 1;
        if b ~= 0
            sb = sin(b) / b;
        end
        y = y + y1(j) * sb;
    end
    y2(i) = y;
end
hold on;
plot(x1, y1, 'r-o');
plot(x2, y2, 'g-x');

