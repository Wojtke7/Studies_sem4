import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat
from corr_fun import corr_fun

data = loadmat('adsl_x.mat')
signal = np.array(data['x'])

prefix_length = 32
frame_length = 512
package_length = prefix_length + frame_length

max_correlation = 0
start_prefix_positions = np.zeros((3, 1))  # wiemy że są 3 prefiksy

for i in range(len(signal) // 3):
    # Sprawdzenie czy nie wyszliśmy poza zakres sygnału
    if (i + 3 * package_length) > len(signal):
        break

    total_correlation = 0
    tmp_start_prefix_positions = np.zeros((3, 1))

    # Wewnętrzna pętla iteruje po trzech prefiksach. Dla każdego prefiksu obliczamy jego korelację
    # z kopią kolejnego bloku danych (512 próbek). Sumujemy te korelacje dla każdego prefiksu w zmiennej
    # total_correlation.

    for j in range(3):
        prefix = signal[i + j * package_length: i + j * package_length + prefix_length]

        tmp_start_prefix_positions[j, 0] = i + j * package_length

        # Zmienna do przechowywania kolejnego bloku danych
        next_frame_prefix_copy = signal[i + j * package_length + frame_length:
                                  i + j * package_length + frame_length + prefix_length]

        # Obliczenie korelacji
        corr = corr_fun(prefix, next_frame_prefix_copy)
        total_correlation += np.mean(corr)

    if total_correlation > max_correlation:
        max_correlation = total_correlation
        start_prefix_positions = tmp_start_prefix_positions

plt.figure(figsize=(10, 6))
plt.plot(signal, "r-", label='Signal')
for i in range(3):
    plt.plot(start_prefix_positions[i, 0], 0, 'bo', label='Prefix beginning' if i == 0 else "")
plt.xlabel('Probe index')
plt.ylabel('Amplitude')
plt.legend()
plt.grid(True)
plt.show()
