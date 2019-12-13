#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      tbpk7658
#
# Created:     10/12/2019
# Copyright:   (c) tbpk7658 2019
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import math

log_tab = [ 0 ]
for x in range (1,256): log_tab.append(round(math.log2(x)*32))

# atan(2^(x/32))*128/pi
atan_tab = [0 for x in range (0,256)]
for x in range (1,256): atan_tab [x]= round(math.atan2(1,2**((255-x)/32))*127/math.pi)

def main():
    x , y = 1, 16
    print (math.atan2(y,x)*127/math.pi)
    v = 255 - abs(log_tab [x] - log_tab[y])
    print (x, y , log_tab[x]/32, log_tab[y]/32, (log_tab [x] - log_tab[y])/16, v)
    print (atan_tab[v])
    #print (v*)
    #print (log2tab [4] - log2tab[2])
    print (atan_tab)
    pass

if __name__ == '__main__':
    main()
