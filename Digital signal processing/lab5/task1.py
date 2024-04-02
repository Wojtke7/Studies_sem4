import numpy as np
import matplotlib.pyplot as plt

# Define poles and zeros
p12 = -0.5 + 9.5j
p34 = -1 + 10j
p56 = -0.5 + 10.5j
z12 = 5j
z34 = 15j

# Dodanie zer i biegunów transmitancji z przeciwnym znakiem przy części zespolonej
p = [p12, p34, p56, np.conj(p12), np.conj(p34), np.conj(p56)]
z = [z12, z34, np.conj(z12), np.conj(z34)]

# Współczynnik wzmocnienia
# Wzmocnienie takie jak na wykładzie
wzm = 0.42
# Dla wartości wzm = 1 mieliśmy amplitudę około 2.3

# Wykres biegunów i zer transmitancji
plt.figure(figsize=(8, 6))
plt.plot(np.real(p), np.imag(p), "*", label="Poles")
plt.plot(np.real(z), np.imag(z), "o", label="Zeros")
plt.grid(True)
plt.axis('equal')
plt.xlabel("Re(z)")
plt.ylabel("Im(z)")
plt.title("Poles and Zeros")
plt.legend()

# Utworzenie wielomianów
# Wielomian biegunów
a = np.poly(p)
# Wielomian zer
b = np.poly(z) * wzm

# Odpowiedź częstotliwościowa
# Zakres częstotliwości
w = np.arange(4, 16.1, 0.1)
# Zamiana transformaty La Place'a na Transformate Fouriera
s = w * 1j
Hlinear = np.abs(np.polyval(b, s) / np.polyval(a, s))

# Wykres odpowiedzi częstotliwościowej liniowej
plt.figure()
plt.plot(w, Hlinear)
plt.xlabel("Frequency [rad/s]")
plt.ylabel("|H(jw)|")
plt.title("Linear Frequency Response")

# Wykres odpowiedzi częstotliwościowej decybelowej
Hlog = 20 * np.log10(Hlinear)
plt.figure()
plt.semilogx(w, Hlog, 'r')
plt.xlabel("Frequency [rad/s]")
plt.ylabel("(|H(jw)|) dB")
plt.title("Logarithmic Frequency Response")

# Charakterystyka fazowa
H_phase = np.angle(np.polyval(b, s) / np.polyval(a, s))
plt.figure()
plt.plot(w, H_phase, 'g')
plt.xlabel('Frequency [rad/s]')
plt.ylabel('Angle [rad]')
plt.title('Phase-Frequency Characteristic')
plt.grid(True)

plt.show()

# Czy filtr ten jest pasmowo-przepustowy?, W oparciu o wykres odpowiedzi częstotliwościowej, filtr ten jest
# pasmowo-przepustowy, ponieważ ma pasmo przepustowe, gdzie amplituda jest wysoka, oraz pasmo zaporowe,
# gdzie amplituda jest niska.

# Jakie jest maksymalne i minimalne tłumienie w paśmie zaporowym?
# Max = około -341dB
# Min = około -10dB
# Maksymalne tłumienie w
# paśmie zaporowym można odczytać z wykresu odpowiedzi częstotliwościowej. Jest to wartość amplitudy dla
# częstotliwości w paśmie zaporowym. Minimalne tłumienie jest w paśmie przepustowym, gdzie amplituda jest maksymalna.

# Charakterystyka fazowa powinna być liniowa w paśmie przepustowym. To oznacza, że faza wyjściowego sygnału nie
# powinna zmieniać się znacząco w obrębie tego pasma.