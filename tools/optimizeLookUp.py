#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      tbpk7658
#
# Created:     19/12/2019
# Copyright:   (c) tbpk7658 2019
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import math
import numpy as np
from scipy.optimize import minimize
import matplotlib.pyplot as plt
from mpl_toolkits import mplot3d

def norm (x,y):
    return math.sqrt(x**2 + y**2)

def npnorm(x, y):
    return np.sqrt(x ** 2 + y ** 2)

def fastnorm (px,py, A, B, C, D):
    ax, ay = abs(px), abs(py)
    if ax >= ay:
        x, y = ax, ay
    else:
        x, y = ay, ax
    if y > x/2 :
        # N = (math.sqrt(5)-math.sqrt(2))*x + (2*math.sqrt(2) - math.sqrt(5))*y
        #N = tabmult_sqrt5_m_sqrt2 [x] + tabmult_2sqrt2_m_sqrt5[y]
        N = C * x + D * y
    else:
        # N = x+(math.sqrt(5)/2 - 1)*y
        #N = x + tabmult_sqrt5_m2 [y]
        N = A * x + B * y
    return N

    #x = np.linspace(-127, 127, 255)
    #y = np.linspace(-127, 127, 255)
    #x_data = np.asarray([er[0] for er in tab_err])
    #y_data = np.asarray([er[1] for er in tab_err])
    #X, Y = np.meshgrid(x, y)
    #Z = npnorm(X, Y)
    #print (Z[0][0])
def fastnorm2 (px,py, A0, A1, A2, B0, B1, B2, C0, C1, C2, D0, D1, D2):
    ax, ay = abs(px), abs(py)
    if ax >= ay:
        x, y = ax, ay
    else:
        x, y = ay, ax
    if y > x/2 :
        # N = (math.sqrt(5)-math.sqrt(2))*x + (2*math.sqrt(2) - math.sqrt(5))*y
        #N = tabmult_sqrt5_m_sqrt2 [x] + tabmult_2sqrt2_m_sqrt5[y]
        N = C2 * (x**2) + C1 * x + C0 + D2 * (y**2) + D1 * y + D0
    else:
        # N = x+(math.sqrt(5)/2 - 1)*y
        #N = x + tabmult_sqrt5_m2 [y]
        N = A2 * (x**2) + A1 * x + A0 + B2 * (y**2) + B1 * y + B0
    return N

    #x = np.linspace(-127, 127, 255)
    #y = np.linspace(-127, 127, 255)
    #x_data = np.asarray([er[0] for er in tab_err])
    #y_data = np.asarray([er[1] for er in tab_err])
    #X, Y = np.meshgrid(x, y)
    #Z = npnorm(X, Y)
    #print (Z[0][0])

def rosen(x):
    [A, B, C, D] = x
    cumerr = 0
    for i in range (-127, 128):
        for j in range (-127, 128):
            res = fastnorm(i,j, A, B, C, D)
            nor = norm (i,j)
            err = nor - res
            cumerr += err**2
    res = cumerr
    return res

def rosen2(x):
    [A0, A1, A2, B0, B1, B2, C0, C1, C2, D0, D1, D2] = x
    cumerr = 0
    for i in range (-127, 128):
        for j in range (-127, 128):
            res = fastnorm2(i,j, A0, A1, A2, B0, B1, B2, C0, C1, C2, D0, D1, D2)
            nor = norm (i,j)
            err = nor - res
            cumerr += err**2
    res = cumerr
    return res



start = [1.0, math.sqrt(5) - 2, math.sqrt(5)-math.sqrt(2) , 2*math.sqrt(2) - math.sqrt(5)]
start2 = [
    0,  1.0,   0,
    0,  math.sqrt(5) - 2,   0,
    0,  math.sqrt(5)-math.sqrt(2) ,     0,
    0,  2*math.sqrt(2) - math.sqrt(5),  0
    ]

def displaySol (state):
    A, B, C, D = state
    x = np.linspace(-127, 127, 255)
    y = np.linspace(-127, 127, 255)
    #x_data = np.asarray([er[0] for er in tab_err])
    #y_data = np.asarray([er[1] for er in tab_err])
    X, Y = np.meshgrid(x, y)
    Z = npnorm(X, Y)
    #print (Z[0][0])
    for i in range (-127, 128):
        for j in range (-127, 128):
            res = fastnorm(i,j, A, B, C, D)
            nor = norm (i,j)
            Z[i+127][j+127] = res - nor
    #print (fakenorm2ndOrder(i,j))
    fig = plt.figure()
    ax = plt.axes(projection='3d')

    #err_data = np.asarray([er[3] for er in tab_err])

    #ax.scatter3D(x_data, y_data, err_data,  cmap='binary');
    ax.contour3D(X, Y, Z, 50, cmap='binary')
    plt.show()

def displaySol2 (state):
    A0, A1, A2, B0, B1, B2, C0, C1, C2, D0, D1, D2 = state
    x = np.linspace(-127, 127, 255)
    y = np.linspace(-127, 127, 255)
    #x_data = np.asarray([er[0] for er in tab_err])
    #y_data = np.asarray([er[1] for er in tab_err])
    X, Y = np.meshgrid(x, y)
    Z = npnorm(X, Y)
    #print (Z[0][0])
    for i in range (-127, 128):
        for j in range (-127, 128):
            res = fastnorm2(i,j, A0, A1, A2, B0, B1, B2, C0, C1, C2, D0, D1, D2)
            nor = norm (i,j)
            Z[i+127][j+127] = res - nor
    #print (fakenorm2ndOrder(i,j))
    fig = plt.figure()
    ax = plt.axes(projection='3d')

    #err_data = np.asarray([er[3] for er in tab_err])

    #ax.scatter3D(x_data, y_data, err_data,  cmap='binary');
    ax.contour3D(X, Y, Z, 50, cmap='binary')
    plt.show()

def main():
    # x0 = np.array(start)
    # displaySol (start)
    # print (start)
    # res = minimize(rosen, x0, method='nelder-mead', options={'xatol': 1e-8, 'disp': True})
    # print (res.x)
    # displaySol (res.x)
    
    x0 = np.array(start2)
    displaySol2 (start2)
    print (start2)
    #res = minimize(rosen2, x0, method='nelder-mead', options={'xatol': 1e-8, 'disp': True})
    #print (res.x)
    displaySol2 ([ 1.60431525e-02,  1.01438538e+00, -2.23050176e-04, -4.95743532e-03,
  1.03966260e-01,  2.65156968e-03, -1.25399371e-02,  8.51173164e-01,
 -2.18092268e-04,  2.02032598e-03,  5.39223578e-01,  3.71083013e-04])
   
    
if __name__ == '__main__':
    main()
