from sys import argv

with open(argv[1], 'r') as f:
    l = f.readlines()
    
with open(argv[2], 'w') as g:
    g.write("iter,theta,mu,var\n")
    for i in range(0, len(l)-4, 4):
        a = l[i+0].split()[-1]
        b = l[i+1].split()[-1][:-1]
        c = l[i+2].split()[-1][:-1]
        d = l[i+3].split()[-1][:-1]
        g.write("{},{},{},{}\n".format(a, b, c, d))
