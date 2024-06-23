import numpy as np


def corr_fun(x, y):
    # Długości wektorów
    n = len(x)
    m = len(y)

    # Średnie wartości obu wektorów
    x_mean = np.mean(x)
    y_mean = np.mean(y)

    # Odchylenie standardowe
    x_std = np.std(x)
    y_std = np.std(y)

    correlation_vector = np.zeros(n + m - 1)
    lags = np.arange(-n + 1, m)

    # Obliczanie korelacji przechodząc przez kazdy element
    for i in range(len(correlation_vector)):
        if lags[i] < 0:
            correlation_vector[i] = np.sum((x[0:n + lags[i]] - x_mean) * (y[-lags[i]:m] - y_mean))
        elif lags[i] == 0:
            correlation_vector[i] = np.sum((x - x_mean) * (y - y_mean))
        else:
            correlation_vector[i] = np.sum((x[lags[i]:n] - x_mean) * (y[0:m - lags[i]] - y_mean))
        # Normalizacja
        correlation_vector[i] = correlation_vector[i] / (x_std * y_std * (n - abs(lags[i])))

    return correlation_vector
