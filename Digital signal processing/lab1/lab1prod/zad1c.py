import numpy as np
import matplotlib.pyplot as plt

# Parametry sygnału
fs = 100  # Częstotliwość próbkowania
T = 1  # Czas trwania sygnału w sekundach
A = 1  # Amplituda


def show_sin_freq(range_temp, jump, probes):
    for f in range(0, range_temp, jump):
        signal = A * np.sin(2 * np.pi * f * probes)
        plt.figure(figsize=(10, 2))
        plt.plot(t, signal)
        plt.title(f'Sinusoida częstotliwość: {f} Hz, Obieg:{(f / 5) + 1}')
        plt.xlabel('Czas [s]')
        plt.ylabel('Amplituda')
        plt.grid(True)
        plt.show()


# Funkcja do generowania i porównywania sinusoid i cosinusoid
def generate_and_compare(frequencies, signal_type):
    t = np.arange(0, T, 1 / fs)
    plt.figure(figsize=(10, 6))

    for f in frequencies:
        if signal_type == 'sin':
            signal = A * np.sin(2 * np.pi * f * t)
        elif signal_type == 'cosin':
            signal = A * np.cos(2 * np.pi * f * t)
        else:
            raise ValueError("Nieprawidłowy typ sygnału. Wprowadź 'sin' lub 'cos'.")
        plt.plot(t, signal, label=f'{f} Hz ({signal_type})')

    plt.title(f'Porównanie {signal_type}usoid dla częstotliwości: {", ".join(map(str, frequencies))}')
    plt.xlabel('Czas [s]')
    plt.ylabel('Amplituda')
    plt.legend()
    plt.grid(True)
    plt.show()


# Lista zestawów częstotliwości do porównania
frequencies_to_compare = [[5, 105, 205], [95, 195, 295], [95, 105]]

t = np.arange(0, T, 1 / fs)  # probes
show_sin_freq(301, 5, t)

# Porównanie sinusoid
for frequencies in frequencies_to_compare:
    generate_and_compare(frequencies, 'sin')
    # faza się odwraca

# Porównanie cosinusoid
for frequencies in frequencies_to_compare:
    generate_and_compare(frequencies, 'cosin')
    # faza się nie odwraca

# faza początkowa jest inna