import scipy.io

for file in range(1, 16):
    fname = "f{:02d}.mat".format(file)

    mat = scipy.io.loadmat(fname)
    print("{}: [{} - {}]".format(file, mat['lb'][0][0], mat['ub'][0][0]))
