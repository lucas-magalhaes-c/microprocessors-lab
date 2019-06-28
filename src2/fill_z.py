import argparse

parser = argparse.ArgumentParser()
parser.add_argument('n')
args  = parser.parse_args()
n = args.n

n = str(n).zfill(32)

print('N = ' + n[31])
print('Z = ' + n[30])
print('C = ' + n[29])
print('Z = ' + n[28])
