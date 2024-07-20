from cec2013lsgo import cec2013

bench = cec2013.Benchmark(1, 1000)

for f in range(1, 16):
    info = bench.get_info(f)
    print("{}: [{} - {}]".format(f, info['lower'], info['upper']))
