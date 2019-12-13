import math

tabmult = [round (  i*(math.sqrt(2)-1)) for i in range (128) ]
def norm (x,y):
    return math.sqrt(x**2 + y**2)
    
def fakenorm (x,y):
    if x>y:
        return x+tabmult[y]
    else:
        return y+tabmult[x]
    
def main():
    x,y = 2,4
    err = norm(x,y) - fakenorm(x,y)
    print ("%d %d err = %d"%(x,y,err))
    
    for i in range (0,len(tabmult),8):
            print (', '.join(tabmult[i:i+8]))
            if i%8 == 0 : print ("\n")
        
if __name__ == '__main__':
    main()


