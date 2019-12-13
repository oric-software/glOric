import math


def norm (x,y):
    return math.sqrt(x**2 + y**2)
    
def fakenorm (x,y):
    return x+y*(math.sqrt(2)-1)
    
def main():
    x,y = 4,1
    err = norm(x,y) - fakenorm(x,y)
    print ("%d %d err = %d"%(x,y,err))
    

if __name__ == '__main__':
    main()


