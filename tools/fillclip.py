#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      TBPK7658
#
# Created:     28/12/2019
# Copyright:   (c) TBPK7658 2019
# Licence:     <your licence>
#-------------------------------------------------------------------------------

# parametres configuration
LE = 40   # largeur ecran
HE = 26   # hauteur ecran
EAH = 60  # demi-excursion angulaire Horizontale en degre
EAV = 40  # demi-excursion angulaire Verticale en degre

class bres_agent :
    def __init__ (self, x0, y0, x1, y1):
        self.X =  x0
        self.Y =  y0
        self.destX = x1
        self.destY = y1
        self.dX = abs(x1-x0)
        self.dY = -abs(y1-y0)
        self.err = self.dX + self.dY
        if (x0<x1):
            self.sx = 1
        else:
            self.sx = -1
        if (y0<y1):
            self.sy = 1
        else:
            self.sy = -1
        self.arrived = (self.X == self.destX) and ( self.Y == self.destY)

    def step(self,):

        e2 = 2*self.err;
        
        if (e2 >= self.dY):
            self.err += self.dY; # e_xy+e_x > 0 */
            self.X += self.sx;
        if (e2 <= self.dX): # e_xy+e_y < 0 */
            self.err += self.dX;
            self.Y += self.sy;

        if (self.X == self.destX) and ( self.Y == self.destY):
            self.arrived = True

        retval = [self.X, self.Y]
        return retval


    def stepY(self,):
        nxtY = self.Y+self.sy
        e2 = 2*self.err;
        if ((e2>127) or (e2<=-128)): print ("Error %d"%(e2))
        while ( not self.arrived and ((e2 > self.dX ) or (self.Y != nxtY))):
            if (e2 >= self.dY):
                self.err += self.dY; # e_xy+e_x > 0 */
                self.X += self.sx;
            if (e2 <= self.dX): # e_xy+e_y < 0 */
                self.err += self.dX;
                self.Y += self.sy;
    
            if (self.X == self.destX) and ( self.Y == self.destY):
                self.arrived = True
            e2 = 2*self.err;
            if ((e2>127) or (e2<=-128)): print ("Error %d"%(e2))
            
        retval = [self.X, self.Y]
        return retval

def fillclip (p1, p2, p3):
    if (p1[1] <= p2[1]):
        if (p2[1] <= p3[1]):
            pDep = p3 
            pArr1 = p2
            pArr2 = p1
        else:
            pDep = p2
            if (p1[1] <= p3[1]):
                pArr1 = p3
                pArr2 = p1
            else:
                pArr1 = p1
                pArr2 = p3
    else:
        if (p1[1] <= p3[1]): 
            pDep = p3 
            pArr1 = p1
            pArr2 = p2
        else:
            pDep = p1 
            if (p2[1] <= p3[1]):
                pArr1 = p3
                pArr2 = p2
            else:
                pArr1 = p2
                pArr2 = p3
                
    if (pDep[1] != pArr1[1]):       
        a1 = bres_agent(pDep[0],pDep[1],pArr1[0],pArr1[1])
        a2 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
        print ([a1.X, a1.Y], [a2.X, a2.Y])   
        # state = 0
        # while (not (a1.arrived and a2.arrived)):
        #     print (a1.stepY(), a2.stepY())
        #     if ((a2.arrived) and (state == 0)):
        #         a2 = bres_agent(pArr2[0],pArr2[1],pArr1[0],pArr1[1])
        #         state = 1
        #     elif ((a1.arrived) and (state == 0)):
        #         a1 = bres_agent(pArr1[0],pArr1[1],pArr2[0],pArr2[1])
        #         state = 1
        while (not (a1.arrived)):
            print (a1.stepY(), a2.stepY())
        a1 = bres_agent(pArr1[0],pArr1[1],pArr2[0],pArr2[1])
        while (not (a1.arrived and a2.arrived)):
            print (a1.stepY(), a2.stepY())
        
    else:
        a1 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
        a2 = bres_agent(pArr1[0],pArr1[1],pArr2[0],pArr2[1])
        print ([a1.X, a1.Y], [a2.X, a2.Y])
        while (not (a1.arrived and a2.arrived)):
            print (a1.stepY(), a2.stepY())

def attempt1():
    pDep = [1,5]
    pArr1 = [3,1]
    pArr2 = [7,3]
    a1 = bres_agent(pDep[0],pDep[1],pArr1[0],pArr1[1])
    a2 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])

    #print (a1.stepY(), a2.stepY())
    state = 0
    while (not (a1.arrived and a2.arrived)):
        print (a1.stepY(), a2.stepY())
        if ((a2.arrived) and (state == 0)):
            a2 = bres_agent(pArr2[0],pArr2[1],pArr1[0],pArr1[1])
            state = 1
        elif ((a1.arrived) and (state == 0)):
            a1 = bres_agent(pArr1[0],pArr1[1],pArr2[0],pArr2[1])
            state = 1
            
def main():
    fillclip ([7,3], [3,1], [1,5])
    print ("-----------------")
    fillclip ([1,5], [6,5], [5,1])
    print ("-----------------")
    fillclip ([-1,3], [2,-1], [5,5])
    #print (a1.stepY(), a2.stepY())
    #print (a1.stepY(), a2.stepY())
    # [a1x, a1y] = [a1.X, a1.Y]
    # [a2x, a2y] = [a2.X, a2.Y]
    # while (a1.Y == a1y): a1.step()
    # while (a2.Y == a2y): a2.step()
    # print ([a1.X, a1.Y], [a2.X,a2.Y])

   ##   [a1x, a1y] = [a1.X, a1.Y]
    # [a2x, a2y] = [a2.X, a2.Y]
    # while (a1.Y == a1y): a1.step()
    # while (a2.Y == a2y): a2.step()
    # print ([a1.X, a1.Y], [a2.X,a2.Y])

   ##   [a1x, a1y] = [a1.X, a1.Y]
    # [a2x, a2y] = [a2.X, a2.Y]
    # while (a1.Y == a1y): a1.step()
    # while (a2.Y == a2y): a2.step()
    # print ([a1.X, a1.Y], [a2.X,a2.Y])

    #print (a1.step())
    #print (a1.step())

if __name__ == '__main__':
    main()
