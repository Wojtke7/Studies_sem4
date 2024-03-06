import numpy as np
from dct_matrix import generate_dct_ii_matrix

N = 20
A = generate_dct_ii_matrix(N)
S = np.transpose(A)

# Mnożenie macierzy
I = np.dot(S, A)


tolA = np.max(np.abs(S - np.linalg.inv(A)))

isidentic = True
# Sprawdzenie czy macierz identycznościowa 
for o in range(N):
    for p in range(N):
        if abs(I[o, p]) != 0 and o != p:
            isidentic = False

        if abs(I[o, p]) != 1 and o == p:
            isidentic = False

if isidentic:
    print(f'Macierz I jest identycznościowa z błędem: {tolA}')
else:
    print('Macierz I nie jest identycznościowa')

srand = np.random.rand(N)
X = np.dot(A, srand)

rcnst = np.dot(S, X)

tolB = np.max(np.abs(srand - rcnst))

if tolB < 1e-10:
    print(f'Rekonstrukcja sygnału z błędem: {tolB}')