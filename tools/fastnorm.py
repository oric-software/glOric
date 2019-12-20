import math
from operator import itemgetter, attrgetter, methodcaller

import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits import mplot3d
tabmult_sqrt2 = [round (  i*(math.sqrt(2))) for i in range (128) ]

tabmult_sqrt2_m1 = [round (  i*(math.sqrt(2)-1)) for i in range (128) ]

tabmult_sqrt5_div2 = [round (  i*(math.sqrt(5)/2)) for i in range (128) ]

tabmult_sqrt5_m_sqrt2 = [round (  i*(math.sqrt(5)-math.sqrt(2))) for i in range (128) ]

tabmult_2sqrt2_m_sqrt5 = [round (  i*(2*math.sqrt(2)-math.sqrt(5))) for i in range (128) ]

tabmult_sqrt5_m2 = [round ( i*(  (math.sqrt(5)-2.0))  ) for i in range (128) ]

def norm (x,y):
    return math.sqrt(x**2 + y**2)

def fakenorm1stOrder_int  (x,y):
    if x>y:
        return x+tabmult_sqrt2_m1[y]
    else:
        return y+tabmult_sqrt2_m1[x]

def fakenorm2ndOrder (px,py):
    ax, ay = abs(px), abs(py)
    if ax==ay:
       return math.sqrt(2) * ax
    elif ax > ay:
        x, y = ax, ay
    else:
        x, y = ay, ax
    if y == x/2:
        return x*(math.sqrt(5)/2)
    elif y > x/2 :
        N = (math.sqrt(5)-math.sqrt(2))*x + (2*math.sqrt(2) - math.sqrt(5))*y
    else:
        N = x+(math.sqrt(5)/2 - 1)*y
    return N

def fakenorm2ndOrder_int (px,py):
    ax, ay = abs(px), abs(py)
    #if ax==ay:
    #   return tabmult_sqrt2[ax]
    #el
    if ax >= ay:
        x, y = ax, ay
    else:
        x, y = ay, ax
    #if y == x/2:
    #    return tabmult_sqrt5_div2[x] #x*(math.sqrt(5)/2)
    #el
    if y > x/2 :
        # N = (math.sqrt(5)-math.sqrt(2))*x + (2*math.sqrt(2) - math.sqrt(5))*y
        N = tabmult_sqrt5_m_sqrt2 [x] + tabmult_2sqrt2_m_sqrt5[y]
    else:
        # N = x+(math.sqrt(5)/2 - 1)*y
        N = x + tabmult_sqrt5_m2 [y]
    return N

nb_max = 127
tab_err = []
def exploreDomain():
    score = 0
    for x in range (0, nb_max+1):
        for y in range (0,x+1):

#    x,y = 127,64
            real_norm = norm(x,y)

            firstNorm = fakenorm1stOrder_int(x,y)

            secondNorm = fakenorm2ndOrder_int(x,y)

            err = norm(x,y) - fakenorm2ndOrder_int(x,y)
            score += abs(err)
            if (abs(err) > 0.5) :
                #print ("%d %d norm = %f err = %f"%(x,y,real_norm, err))
                tab_err.append((x, y , abs(err), (100*abs(err))/norm(x,y)))
    #for i in range (0,len(tabmult),8):
    #        print (', '.join(tabmult[i:i+8]))
    #        if i%8 == 0 : print ("\n")
    print ("score = ", int(sum([abs(er[2]) for er in tab_err])), int(score))

def analyseErr (x, y):
    print ("--------------")
    print ("X = %d , Y = %d, n = %f, err = %f"%(x, y, norm(x,y), norm(x,y) - fakenorm2ndOrder_int(x,y)))
    if y > x/2 :
        print ("y > x/2")
        # N = (math.sqrt(5)-math.sqrt(2))*x + (2*math.sqrt(2) - math.sqrt(5))*y
        intN = tabmult_sqrt5_m_sqrt2 [x] + tabmult_2sqrt2_m_sqrt5[y]
        fltN = (math.sqrt(5)-math.sqrt(2))*x + (2*math.sqrt(2) - math.sqrt(5))*y
        print ("tabmult_sqrt5_m_sqrt2 [%s] = %d ins of %f, tabmult_2sqrt2_m_sqrt5[%d] = %d ins of %f"%(x, tabmult_sqrt5_m_sqrt2 [x],(math.sqrt(5)-math.sqrt(2))*x , y, tabmult_2sqrt2_m_sqrt5[y], (2*math.sqrt(2) - math.sqrt(5))*y))
    else:
        print ("y <= x/2")
        # N = x+(math.sqrt(5)/2 - 1)*y
        intN = x + tabmult_sqrt5_m2 [y]
        fltN = x+(math.sqrt(5)/2 - 1)*y
        print ("tabmult_sqrt5_m2 [%d] = %d ins of %f"%(y, tabmult_sqrt5_m2 [y] , (math.sqrt(5) - 2)*y))
    print ("intN = %d , fltN = %f"%(intN, fltN))

def fixTable ():
    tabmult_sqrt5_m_sqrt2 [3]=2
    #tabmult_sqrt5_m_sqrt2 [7] = 5
    #tabmult_sqrt5_m_sqrt2[6] = 4
    tabmult_sqrt5_m_sqrt2 [8] = 6
    #tabmult_sqrt5_m_sqrt2 [15]=13
    #tabmult_sqrt5_m_sqrt2 [20] = 17
    tabmult_sqrt5_m_sqrt2 [78]=63


    #tabmult_2sqrt2_m_sqrt5 [6] = 4
    #tabmult_2sqrt2_m_sqrt5 [16] = 10
    #tabmult_sqrt5_m2 []=
    #tabmult_sqrt5_m_sqrt2 [] =

    #tabmult_2sqrt2_m_sqrt5 [] =
    tabmult_2sqrt2_m_sqrt5[1] = 0
    tabmult_2sqrt2_m_sqrt5[2] = 2
    tabmult_2sqrt2_m_sqrt5[4] = 2
    #tabmult_2sqrt2_m_sqrt5[7] = 5
    tabmult_2sqrt2_m_sqrt5[11] = 6
    #tabmult_2sqrt2_m_sqrt5[6] = 3
    #tabmult_2sqrt2_m_sqrt5[6] = 3
    tabmult_2sqrt2_m_sqrt5[50] = 29
    tabmult_2sqrt2_m_sqrt5[51] = 30
    tabmult_2sqrt2_m_sqrt5[52] = 30
    tabmult_2sqrt2_m_sqrt5[53] = 31
    tabmult_2sqrt2_m_sqrt5[54] = 31
    tabmult_2sqrt2_m_sqrt5[55] = 32
    tabmult_2sqrt2_m_sqrt5[56] = 32
    tabmult_2sqrt2_m_sqrt5[57] = 33
    tabmult_2sqrt2_m_sqrt5[58] = 33
    tabmult_2sqrt2_m_sqrt5[59] = 34
    tabmult_2sqrt2_m_sqrt5[60] = 34
    tabmult_2sqrt2_m_sqrt5[61] = 35
    tabmult_2sqrt2_m_sqrt5[62] = 36
    tabmult_2sqrt2_m_sqrt5[63] = 36
    tabmult_2sqrt2_m_sqrt5[64] = 37
    tabmult_2sqrt2_m_sqrt5[65] = 37
    tabmult_2sqrt2_m_sqrt5[66] = 38
    tabmult_2sqrt2_m_sqrt5[67] = 38
    tabmult_2sqrt2_m_sqrt5[68] = 39
    tabmult_2sqrt2_m_sqrt5[69] = 40
    tabmult_2sqrt2_m_sqrt5[70] = 41
    tabmult_2sqrt2_m_sqrt5[71] = 41
    tabmult_2sqrt2_m_sqrt5[72] = 42
    tabmult_2sqrt2_m_sqrt5[73] = 42
    tabmult_2sqrt2_m_sqrt5[74] = 43
    tabmult_2sqrt2_m_sqrt5[75] = 43
    tabmult_2sqrt2_m_sqrt5[76] = 44
    tabmult_2sqrt2_m_sqrt5[77] = 44
    tabmult_2sqrt2_m_sqrt5[78] = 45
    tabmult_2sqrt2_m_sqrt5[79] = 45
    tabmult_2sqrt2_m_sqrt5[80] = 46
    tabmult_2sqrt2_m_sqrt5[81] = 47
    tabmult_2sqrt2_m_sqrt5[82] = 47
    tabmult_2sqrt2_m_sqrt5[83] = 48
    tabmult_2sqrt2_m_sqrt5[84] = 48
    tabmult_2sqrt2_m_sqrt5[85] = 49
    tabmult_2sqrt2_m_sqrt5[86] = 49
    tabmult_2sqrt2_m_sqrt5[87] = 50
    tabmult_2sqrt2_m_sqrt5[88] = 51
    tabmult_2sqrt2_m_sqrt5[89] = 51
    tabmult_2sqrt2_m_sqrt5[90] = 52
    tabmult_2sqrt2_m_sqrt5[91] = 53
    tabmult_2sqrt2_m_sqrt5[92] = 53
    tabmult_2sqrt2_m_sqrt5[93] = 54
    tabmult_2sqrt2_m_sqrt5[94] = 54
    tabmult_2sqrt2_m_sqrt5[95] = 55
    tabmult_2sqrt2_m_sqrt5[96] = 55
    tabmult_2sqrt2_m_sqrt5[97] = 56
    tabmult_2sqrt2_m_sqrt5[98] = 57
    tabmult_2sqrt2_m_sqrt5[99] = 57
    tabmult_2sqrt2_m_sqrt5[100] = 58
    tabmult_2sqrt2_m_sqrt5[101] = 59
    tabmult_2sqrt2_m_sqrt5[102] = 59
    tabmult_2sqrt2_m_sqrt5[103] = 60
    tabmult_2sqrt2_m_sqrt5[104] = 60
    tabmult_2sqrt2_m_sqrt5[105] = 61
    tabmult_2sqrt2_m_sqrt5[106] = 61
    tabmult_2sqrt2_m_sqrt5[107] = 62
    tabmult_2sqrt2_m_sqrt5[108] = 63
    tabmult_2sqrt2_m_sqrt5[109] = 64
    tabmult_2sqrt2_m_sqrt5[110] = 64
    tabmult_2sqrt2_m_sqrt5[111] = 64
    tabmult_2sqrt2_m_sqrt5[112] = 66
    tabmult_2sqrt2_m_sqrt5[113] = 66
    tabmult_2sqrt2_m_sqrt5[114] = 66
    #tabmult_sqrt5_m2 [3]=1
    #tabmult_sqrt5_m2 [4]=1
    #tabmult_sqrt5_m2 [7]=2
    #tabmult_sqrt5_m2 [8]=2
    #tabmult_sqrt5_m2 [9]=2
    #tabmult_sqrt5_m2 [10]=3
    #tabmult_sqrt5_m2 [11]=3
    #tabmult_sqrt5_m2 [12]=2
    #tabmult_sqrt5_m2 [15] =3
    tabmult_sqrt5_m2 [11] =2
    tabmult_sqrt5_m2 [12] =2
    tabmult_sqrt5_m2 [13] =2
    tabmult_sqrt5_m2 [14] =2
    tabmult_sqrt5_m2 [15] =2
    tabmult_sqrt5_m2 [16] =2
    tabmult_sqrt5_m2 [17] =3
    tabmult_sqrt5_m2 [18] =3
    tabmult_sqrt5_m2 [19] =3
    tabmult_sqrt5_m2 [20]=3
    tabmult_sqrt5_m2 [21]=3
    tabmult_sqrt5_m2 [22]=3
    tabmult_sqrt5_m2 [23]=3
    tabmult_sqrt5_m2 [24]=4
    tabmult_sqrt5_m2 [25]=4
    tabmult_sqrt5_m2 [26]=4
    tabmult_sqrt5_m2 [27]=4
    tabmult_sqrt5_m2 [28]=4
    tabmult_sqrt5_m2 [29]=5
    tabmult_sqrt5_m2 [30]=5
    tabmult_sqrt5_m2 [31]=5
    tabmult_sqrt5_m2 [32]=5
    tabmult_sqrt5_m2 [33]=6
    tabmult_sqrt5_m2 [34]=6
    tabmult_sqrt5_m2 [35]=6
    tabmult_sqrt5_m2 [36]=6
    tabmult_sqrt5_m2 [37]=7
    tabmult_sqrt5_m2 [38]=7
    tabmult_sqrt5_m2 [39]=7
    tabmult_sqrt5_m2 [40]=8
    tabmult_sqrt5_m2 [41] = 8
    tabmult_sqrt5_m2 [42] = 8
    tabmult_sqrt5_m2 [43] = 8
    tabmult_sqrt5_m2 [44] = 9
    tabmult_sqrt5_m2 [45] = 9
    tabmult_sqrt5_m2 [46] = 9
    tabmult_sqrt5_m2 [47] = 10
    tabmult_sqrt5_m2 [48] = 10
    tabmult_sqrt5_m2 [49] = 10
    tabmult_sqrt5_m2 [50] = 10
    tabmult_sqrt5_m2 [51] = 11
    tabmult_sqrt5_m2 [52] = 11
    tabmult_sqrt5_m2 [53] = 11
    tabmult_sqrt5_m2 [54] = 11
    pass

known_issues = [
#[7, 3],
[7, 6], #[8,3], [8,5], [8,6], [9,4], [9,6], [10,4], [12,8]
[47, 23], [48, 23], [49, 23],[50, 23],[51, 23],
[78, 77], [78, 75], [78, 76],
[73, 36], [74, 36], [75, 36], [71,35], [76,36], [72,35],[77,36], [78,36],
[61, 30],[63, 31],[64, 31], [65, 31], [65, 32], [66, 31], [66, 32],[67, 32],[68, 32],[69, 32],[69, 34],[70, 32],[73, 35],
[54, 26],
[55, 27], [56,27],  [57,27], [57,28], [58,27], [58,28], [59,28], [60,28], [61,28], [62,28], [63,28], [53,26],
[127,39], [79,39], [80,39], [127, 35], [127, 36], [126, 22], [127, 22], [45, 22], [46, 22],
[87, 43], [88, 43], [88, 86]
]

def main():
    fixTable ()

    #t1=np.linspace(0,127,128)

    #plt.plot(t1, np.asarray(tabmult_sqrt5_m2), 'r--')
    #plt.show()


    exploreDomain()


    #fig = plt.figure()
    #ax = plt.axes(projection='3d')

    #x_data = np.asarray([er[0] for er in tab_err])
    #y_data = np.asarray([er[1] for er in tab_err])
    #err_data = np.asarray([er[3] for er in tab_err])

    #ax.scatter3D(x_data, y_data, err_data,  cmap='binary');
    #ax.contour3D(x_data, y_data, err_data, 50, cmap='binary')
    #plt.show()
    # print ("\n".join([str(er) for er in tab_err]))


    print ("--------------")
    stab = sorted(tab_err, key=itemgetter(2), reverse=True)
    print ("\n".join([str(er) for er in stab[0:10]]))
    print ("--------------")
    stab2 = sorted(tab_err, key=itemgetter(3), reverse=True)
    print ("\n".join([str(er) for er in stab2[0:10]]))
    print ("--------------")
    ii=0
    cur_err = stab2 [ii]
    while ([cur_err[0], cur_err[1]] in known_issues):
        ii+=1
        cur_err = stab2 [ii]
    analyseErr (cur_err[0], cur_err[1])
if __name__ == '__main__':
    main()


