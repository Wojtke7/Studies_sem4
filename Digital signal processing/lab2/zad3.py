import numpy as np
import matplotlib.pyplot as plt
from dct_matrix import generate_dct_ii_matrix

# Dane
N = 100
fs = 1000
st = 1/fs
T = 0.1

f1 = 50
f2 = 100
f3 = 150

A1 = 50
A2 = 100
A3 = 150

probe_time = np.arange(st, T+st, st)  # przedział czasowy próbkowania

# Tworzenie sygnału z sumy sinusów
s1 = lambda t: A1 * np.sin(2*np.pi*f1*t)
s2 = lambda t: A2 * np.sin(2*np.pi*f2*t)
s3 = lambda t: A3 * np.sin(2*np.pi*f3*t)

# Sygnał x z sumy sinusów
x = s1(probe_time) + s2(probe_time) + s3(probe_time)

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
plt.plot(probe_time, s1(probe_time), 'g-o', label='s1 50Hz')
plt.plot(probe_time, s2(probe_time), 'r-o', label='s2 100Hz')
plt.plot(probe_time, s3(probe_time), 'b-o', label='s3 150Hz')
plt.title('Trzy sinusy do sumowania')
plt.xlabel("Przedział czasowy próbkowania[s)")
plt.ylabel("Amplitudas")
plt.legend()

plt.subplot(2, 1, 2)
plt.plot(probe_time, x, 'r-o')
plt.title('Zsumowane sinusy')
plt.xlabel('Przedział czasowy próbkowania [s]')
plt.ylabel("Amplituda")


# Budowanie macierzy A=DCT i S=IDCT dla 100 próbek
A = generate_dct_ii_matrix(N)
# Odwrócenie macierzy
S = np.linalg.inv(A)

# Analiza sygnału y=Ax
y = np.dot(A, x)

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
f = np.arange(1, N+1) * fs / (2 * N)

plt.stem(f, y, 'b')
plt.title('Obserwacja współczynników')
plt.xlabel('Częstotliwość [Hz]')

plt.subplot(2, 1, 2)
plt.plot(probe_time, x, 'b-o')
plt.title('Sygnał sumy sinusów')
plt.xlabel('Numer próbki')

# Rekonstrukcja sygnału
reconstruction = np.dot(S, y)

# Sprawdzenie czy transformata posiada
# właściwość perfekcyjnej rekonstrukcji
tol = np.max(np.abs(x - reconstruction))
print(f'Rekonstrukcja sygnału z błędem: {tol}')

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
plt.plot(probe_time, x, 'b')
plt.title('Sygnał sumy sinusów')

plt.subplot(2, 1, 2)
plt.plot(probe_time, reconstruction, 'g')
plt.title('Rekonstrukcja sygnału sumy sinusów')

# plt.show()









# Zmiana f2 na 105 Hz
f2 = 105
s2 = lambda t: A2 * np.sin(2*np.pi*f2*t)
x = s1(probe_time) + s2(probe_time) + s3(probe_time)

# Analiza sygnału y=Ax
y = np.dot(A, x)

plt.figure(figsize=(10, 8)) # zrobienie nowego wykresu

plt.subplot(2, 1, 1)
f = np.arange(1, N+1) * fs / (2 * N)

plt.stem(f, y, 'b') # stem plot
plt.title('Obserwacja współczynników, f2 + 5Hz')
plt.xlabel('Częstotliwość [Hz]')

plt.subplot(2, 1, 2)
plt.plot(probe_time, x, 'r-o')
plt.title('Sygnał sumy sinusów, f2 + 5Hz')
plt.xlabel('Numer próbki')

# Rekonstrukcja sygnału
reconstruction = np.dot(S, y)

# Sprawdzenie czy transformata posiada
# właściwość perfekcyjnej rekonstrukcji
tol = np.max(np.abs(x - reconstruction))
print(f'Rekonstrukcja sygnału ze zmienioną częstotliwością o {f2} z błędem: {tol}')

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
plt.plot(probe_time, x, 'b')
plt.title('Sygnał sumy sinusów')

plt.subplot(2, 1, 2)
plt.plot(probe_time, reconstruction, 'g-')
plt.title('Rekonstrukcja sygnału sumy sinusów')

# plt.show()











# Zmiana częstotliwości o 2.5 Hz
f1 = 52.5
f2 = 102.5
f3 = 152.5

# Tworzenie sygnału z sumy sinusów
s1 = lambda t: A1 * np.sin(2*np.pi*f1*t)
s2 = lambda t: A2 * np.sin(2*np.pi*f2*t)
s3 = lambda t: A3 * np.sin(2*np.pi*f3*t)

# Sygnał x z sumy sinusów
x = s1(probe_time) + s2(probe_time) + s3(probe_time)

# Analiza sygnału y=Ax
y = np.dot(A, x)

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
f = np.arange(1, N+1) * fs / (2 * N)
plt.stem(f, y, 'b')
plt.title('Obserwacja współczynników, f1, f2, f3 + 2.5 Hz')
plt.xlabel('Częstotliwość [Hz]')

plt.subplot(2, 1, 2)
plt.plot(probe_time, x, 'r-o')
plt.title('Sygnał sumy sinusów, f1, f2, f3 + 2.5 Hz')
plt.xlabel('Numer próbki')

# Rekonstrukcja sygnału
reconstruction = np.dot(S, y)

# Sprawdzenie czy transformata posiada
# właściwość perfekcyjnej rekonstrukcji
tol = np.max(np.abs(x - reconstruction))
print(f'Rekonstrukcja sygnału ze zmienionymi wszystkimi częstotliwościami o {f1} błędem: {tol}')

plt.figure(figsize=(10, 8))

plt.subplot(2, 1, 1)
plt.plot(probe_time, x, 'b')
plt.title('Sygnał sumy sinusów')

plt.subplot(2, 1, 2)
plt.plot(probe_time, reconstruction, 'g')
plt.title('Rekonstrukcja sygnału sumy sinusów')

plt.show()













# wektor częstotliwości
# f to wektor reprezentujący numery indeksów współczynników transformacji DCT

# * fs mnozy kazdy element przez czestotliwosc probkowania to konwertuje indeksy wspolczynnikow
# na odpowiadajace im czestotliwosci wykorzystujac relacje pomiedzy indeksem a czestotliwoscia w dziedzinie czestotliwosci

# / (2*N)-> Dzieli wynik przez dwukrotność liczby próbek 'N'. To skaluje częstotliwości tak aby reprezentować zakres od 0 do połowy częstotliwości próbkowania,
# co jest charakterystyczną cechą transformacji DCT