import numpy as np


def generate_dct_ii_matrix(N):
    matrix = np.zeros((N, N))
    for k in range(N):
        for n in range(N):
            if k == 0:
                matrix[k, n] = np.sqrt(1 / N)
            else:
                matrix[k, n] = np.sqrt(2 / N) * np.cos((np.pi * k * (2 * n + 1)) / (2 * N))
    return matrix
