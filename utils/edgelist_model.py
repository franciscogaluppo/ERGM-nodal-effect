from sys import argv

edges = list()

with open(argv[1], 'r') as file:
    for line in file:
        edge = tuple([int(x) for x in line.split()])
        edges.append(edge)

edges.sort()

with open(argv[2], 'w') as file:
    for edge in edges:
        file.write("{} {}\n".format(edge[0]-1, edge[1]-1))
