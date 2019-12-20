import math
from operator import itemgetter, attrgetter, methodcaller

import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits import mplot3d

[A0, A1, A2, B0, B1, B2, C0, C1, C2, D0, D1, D2] = [ 1.60431525e-02,  1.01438538e+00, -2.23050176e-04, 
-4.95743532e-03,  1.03966260e-01,  2.65156968e-03, 
-1.25399371e-02,  8.51173164e-01,  -2.18092268e-04,  
 2.02032598e-03,  5.39223578e-01,  3.71083013e-04]


tabmult_A = [round (  (A0)+ (A1)*i + (A2) *(i**2)                 ) for i in range (128) ]

tabmult_B = [round (  (B0) + i*( B1) + (i**2)*( B2 )       ) for i in range (128) ]

tabmult_C = [round (  (C0) + i*(C1) + (i**2)*( C2 )    ) for i in range (128) ]

tabmult_D = [round ( ( D0) + i*( D1) + (i**2)*(D2)   ) for i in range (128) ]



def norm (x,y):
    return math.sqrt(x**2 + y**2)

def fastnorm2 (px,py):
    ax, ay = abs(px), abs(py)
    if ax >= ay:
        x, y = ax, ay
    else:
        x, y = ay, ax
    if y > x/2 :
        # N = (math.sqrt(5)-math.sqrt(2))*x + (2*math.sqrt(2) - math.sqrt(5))*y
        #N = tabmult_sqrt5_m_sqrt2 [x] + tabmult_2sqrt2_m_sqrt5[y]
        N = tabmult_C [x] + tabmult_D[y]
    else:
        # N = x+(math.sqrt(5)/2 - 1)*y
        #N = x + tabmult_sqrt5_m2 [y]
        N = tabmult_A [x] + tabmult_B[y]
    return N

nb_max = 127
tab_err = []
def exploreDomain():
    score, score2 = 0, 0
    for x in range (0, nb_max+1):
        for y in range (0,x+1):

            err = norm(x,y) - fastnorm2 (x,y)
            score += abs(err)
            if ((x!=0) or (y!=0)) : score2 += (100*abs(err))/norm(x,y)
            if (abs(err) > 0.5) :
                #print ("%d %d norm = %f err = %f"%(x,y,real_norm, err))
                tab_err.append((x, y , abs(err), (100*abs(err))/norm(x,y)))
    #for i in range (0,len(tabmult),8):
    #        print (', '.join(tabmult[i:i+8]))
    #        if i%8 == 0 : print ("\n")
    print ("score = ", int(sum([abs(er[2]) for er in tab_err])), int(score), int(score2))

def analyseErr (x, y):
    print ("--------------")
    print ("X = %d , Y = %d, n = %f, err = %f"%(x, y, norm(x,y), norm(x,y) - fastnorm2(x,y)))
    if y > x/2 :
        print ("y > x/2")
        # N = (math.sqrt(5)-math.sqrt(2))*x + (2*math.sqrt(2) - math.sqrt(5))*y
        intN = tabmult_C [x] + tabmult_D[y]
        fltN = (C0) + x*(C1) + (x**2)*( C2 ) +  ( D0) + y*( D1) + (y**2)*(D2)
        print ("tabmult_C [%d] =%d ins of %f, tabmult_D[%d]=%d ins of %f"%(x, tabmult_C [x],(C0) + x*(C1) + (x**2)*( C2 ) , y, tabmult_D[y], ( D0) + y*( D1) + (y**2)*(D2)))
    else:
        print ("y <= x/2")
        # N = x+(math.sqrt(5)/2 - 1)*y
        intN = tabmult_A [x] + tabmult_B[y]
        fltN = (A0)+ (A1)*x + (A2) *(x**2) + (B0) + y*( B1) + (y**2)*( B2 )
        print ("tabmult_A [%d] = %d ins of %f tabmult_B[%d] = %d ins of %f"%(x, tabmult_A [x], (A0)+ (A1)*x + (A2) *(x**2),y , tabmult_B[y] , (B0) + y*( B1) + (y**2)*( B2 )))
    print ("intN = %d , fltN = %f"%(intN, fltN))

def fixTable ():
    #tabmult_D[1]=0 #=> 2874 3966 5049
    tabmult_C [1] =0
    #tabmult_C [3] = 2 # was 3 s 1 => 2874 3965
    #tabmult_D[2]=2 # was 1 s 1.1 => 2874 3966
    #tabmult_C [2] = 1 # was 2 s1.1.1 => 2873 3965
    #tabmult_D[4]=3 # was 2 s1.1.1.1 => 2875 3966
    #tabmult_C [4] = 4# was 3 s1.1.1.2 => 2874 3966
    tabmult_D[3]=1
    tabmult_C [4] =4
    #tabmult_D[3]=1
    # tabmult_D[3]=1
    # tabmult_D[4]=2
    tabmult_D[5]=2
    # 
    # tabmult_C [4]=4
    tabmult_C [5]=5
    #tabmult_C [6] =7
    # tabmult_C [6]=5
    # tabmult_C [10]=9
    # tabmult_B[3] = 1
    #tabmult_B[4] = 1
    pass

known_issues = [
 [6, 3]
]


def exportTable (table2export):
    strres= ""
    ii=0
    for v in table2export:
        
        if (ii == 0):
            strres += "\t .byt %d"%(v)
        elif (ii % 8 == 0) :
            strres += ",\n\t .byt %d"%(v)
        else:
            strres += ", %d"%(v)
        ii += 1
    strres += ""
    return strres
    
def main():
    fixTable ()

    print ("tabmult_A")
    print (exportTable (tabmult_A))
    print ("tabmult_B")
    print (exportTable (tabmult_B))
    print ("tabmult_C")
    print (exportTable (tabmult_C))
    print ("tabmult_D")
    print (exportTable (tabmult_D))
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
    print ("\n".join([str(er) for er in stab[0:5]]))
    print ("--------------")
    stab2 = sorted(tab_err, key=itemgetter(3), reverse=True)
    print ("\n".join([str(er) for er in stab2[0:20]]))
    print ("--------------")
    ii=0
    cur_err = stab2 [ii]
    while ([cur_err[0], cur_err[1]] in known_issues):
        ii+=1
        cur_err = stab2 [ii]
    analyseErr (cur_err[0], cur_err[1])
if __name__ == '__main__':
    main()


