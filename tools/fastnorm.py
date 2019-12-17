import math

tabmult = [round (  i*(math.sqrt(2)-1)) for i in range (128) ]

def norm (x,y):
    return math.sqrt(x**2 + y**2)
    
def fakenorm (px,py):
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
    
def main():
    x,y = 8,8
    err = norm(x,y) - fakenorm(x,y)
    print ("%d %d err = %d"%(x,y,err))
    
    #for i in range (0,len(tabmult),8):
    #        print (', '.join(tabmult[i:i+8]))
    #        if i%8 == 0 : print ("\n")
        
if __name__ == '__main__':
    main()


