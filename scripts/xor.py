# This is to xor two lists of numbers

# create list a
a = []

# create list b
b = []

# output
c = []

for i in range(len(a)):
    d = chr(a[i]^b[i])
    c.append(d)

print c
print ''.join(c)
