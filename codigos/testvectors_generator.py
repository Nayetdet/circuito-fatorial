WIDTH_IN      = 8
WIDTH_OUT     = 16
NUM_TESTCASES = 12

def to_bin(value, width):
    return bin(value)[2:].zfill(width)

def calculate_factorial(value, width):
    max_value = 2 ** width - 1
    factorial = 1
    for i in range(value, -1, -1):
        factorial *= i if i else 1
        if factorial > max_value:
            break

    truncated_factorial = factorial & max_value
    return truncated_factorial

def main():
    testvectors = []
    for n in range(NUM_TESTCASES):
        out = calculate_factorial(n, width = WIDTH_OUT)
        n_to_bin   = to_bin(n, width = WIDTH_IN)
        out_to_bin = to_bin(out, width = WIDTH_OUT)
        testvectors.append('_'.join([n_to_bin, out_to_bin]))

    with open('testvectors.txt', 'w') as file:
        file.write('\n'.join(testvectors))

if __name__ == '__main__':
    main()
