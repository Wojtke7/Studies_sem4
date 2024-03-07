import numpy as np
from dct_matrix import generate_dct_ii_matrix
N = 20

dct_ii_matrix = generate_dct_ii_matrix(N)

# Iloczyn skalarny każdej pary różnych wektorów powinien wynosić 0, a każdego wektora z samym sobą 1
is_orthonormal = True

for i in range(N):
    for j in range(i, N):
        # Iloczyn skalarny dwóch wektorów
        dot_product = np.dot(dct_ii_matrix[i], dct_ii_matrix[j])

        if i == j:
            # Dla tej samej pary wektorów oczekujemy wartości 1
            if not np.isclose(dot_product, 1):
                is_orthonormal = False
                break
        else:
            # Dla różnych wektorów oczekujemy wartości bliskiej 0
            if not np.isclose(dot_product, 0):
                is_orthonormal = False
                break

    if not is_orthonormal:
        break

print(f"Czy macierz DCT-II jest ortonormalna? {is_orthonormal}")
