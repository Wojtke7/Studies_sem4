import numpy as np
import matplotlib.pyplot as plt

sin_frequency = 1
# sampling_frequency = 200
# Lepsza widoczność dla mniejszej częstotliwości próbkowania, stąd zmiana zadanej w zadaniu
sampling_frequency = 10
T1 = 1 / sampling_frequency  # Okres próbkowania

rec_signal_frequency = sampling_frequency * 50  # Częstotliwość sygnału odtworzonego
T2 = 1 / rec_signal_frequency  # Okres sygnału odtworzonego

duration = 1
sampling_time = np.arange(0, duration, T1)  # Czas próbkowania
sampled_signal = np.sin(2 * np.pi * sin_frequency * sampling_time)  # Sygnał spróbkowany

fig, (p1, p2) = plt.subplots(2, 1, figsize=(8, 6))

p1.plot(sampling_time, sampled_signal, color="blue", marker="o", label="Sampling signal")
p1.set_title(f"Sampling signal {sampling_frequency} Hz")
p1.set_xlabel("Time [s]")
p1.set_ylabel("Amplitude [V]")
p1.legend()
p1.grid(True)

rec_time = np.arange(0, duration, T2)  # Czas sygnału odtwarzanego
rec_signal = np.zeros(len(rec_time))  # Sygnał odtwarzany

for x2 in range(len(rec_time)):  # Dla każdego punktu sygnału odtworzonego wyznaczamy wartość
    rec_value = 0
    for x1 in range(len(sampling_time)):  # Na podstawie wzoru z zadania
        rec_point_value = np.pi / T1 * ((x2 * T2) - (x1 * T1))  # Obliczenie mianownika
        sampling_value = 1
        if rec_point_value != 0:  #  Sprawdzenie czy mianownik różny od zera
            sampling_value = np.sin(rec_point_value) / rec_point_value   # Obliczenie wartośći sinc()
        rec_value += sampled_signal[x1] * sampling_value
    rec_signal[x2] = rec_value

p2.plot(rec_time, rec_signal, color="green", marker="x", label="Reconstructed signal")
p2.set_title(f"Reconstructed signal {rec_signal_frequency} Hz")
p2.set_xlabel("Time [s]")
p2.set_ylabel("Amplitude [V]")
p2.legend()
p2.grid(True)

plt.tight_layout()
plt.show()
