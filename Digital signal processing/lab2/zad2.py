import numpy as np
from dct_matrix import generate_dct_ii_matrix

N = 20
A = generate_dct_ii_matrix(N)
# Transponowanie macierzy A
S = np.transpose(A)

# Mnożenie macierzy
I = np.dot(S, A)

matrix_error = np.max(np.abs(S - np.linalg.inv(A)))

isIdentic = True
# Sprawdzenie czy macierz identycznościowa 
for o in range(N):
    for p in range(N):
        if not np.isclose(abs(I[o, p]), 0) and o != p:
            isIdentic = False

        if not np.isclose(abs(I[o, p]), 1) and o == p:
            isIdentic = False

if isIdentic:
    print(f'Macierz I jest identycznościowa błąd: {matrix_error}')
else:
    print('Macierz I nie jest identycznościowa')

random_signal = np.random.rand(N)
X = np.dot(A, random_signal)

reconstruction = np.dot(S, X)

reconstruction_error = np.max(np.abs(random_signal - reconstruction))

if reconstruction_error < 1e-10:
    print(f'Sygnał po rekonstrukcji z błędem: {reconstruction_error}')
