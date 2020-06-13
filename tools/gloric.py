
import math
import fillclip
from fillclip import fillclip


# parametres configuration
LE = 40   # largeur ecran
HE = 26   # hauteur ecran
EAH = 60  # demi-excursion angulaire Horizontale en degre
EAV = 40  # demi-excursion angulaire Verticale en degre

# donnees entree
nbfaces = 2
nbpoints = 4
faces = [[3, 2, 6]]
points = [[4,4,4],[4,4,-4], [-4, 4, -4],[-4, 4, 4],[4,-4,4],[4,-4,-4],[-4,-4,-4],[-4,-4,4]]
#points = [[-4,4,-4],[-4,-4,-4],[-4,-4,4]]
glCamPos=[-4, 4, 1]
camori=[-32, 0] # rotation Z puis X en 127ème de Pi radian

#system
screen = [[' ' for i in range(LE+1)] for j in range(HE+1)]

#Variables intermédiaires
points2 = []


## FAST ATAN

log_tab = [ 0 ]
for x in range (1,256): log_tab.append(round(math.log2(x)*32))

log_tab = [ 0x00,0x00,0x20,0x32,0x40,0x4a,0x52,0x59
		, 0x60,0x65,0x6a,0x6e,0x72,0x76,0x79,0x7d
		, 0x80,0x82,0x85,0x87,0x8a,0x8c,0x8e,0x90
		, 0x92,0x94,0x96,0x98,0x99,0x9b,0x9d,0x9e
		, 0xa0,0xa1,0xa2,0xa4,0xa5,0xa6,0xa7,0xa9
		, 0xaa,0xab,0xac,0xad,0xae,0xaf,0xb0,0xb1
		, 0xb2,0xb3,0xb4,0xb5,0xb6,0xb7,0xb8,0xb9
		, 0xb9,0xba,0xbb,0xbc,0xbd,0xbd,0xbe,0xbf
		, 0xc0,0xc0,0xc1,0xc2,0xc2,0xc3,0xc4,0xc4
		, 0xc5,0xc6,0xc6,0xc7,0xc7,0xc8,0xc9,0xc9
		, 0xca,0xca,0xcb,0xcc,0xcc,0xcd,0xcd,0xce
		, 0xce,0xcf,0xcf,0xd0,0xd0,0xd1,0xd1,0xd2
		, 0xd2,0xd3,0xd3,0xd4,0xd4,0xd5,0xd5,0xd5
		, 0xd6,0xd6,0xd7,0xd7,0xd8,0xd8,0xd9,0xd9
		, 0xd9,0xda,0xda,0xdb,0xdb,0xdb,0xdc,0xdc
		, 0xdd,0xdd,0xdd,0xde,0xde,0xde,0xdf,0xdf
		, 0xdf,0xe0,0xe0,0xe1,0xe1,0xe1,0xe2,0xe2
		, 0xe2,0xe3,0xe3,0xe3,0xe4,0xe4,0xe4,0xe5
		, 0xe5,0xe5,0xe6,0xe6,0xe6,0xe7,0xe7,0xe7
		, 0xe7,0xe8,0xe8,0xe8,0xe9,0xe9,0xe9,0xea
		, 0xea,0xea,0xea,0xeb,0xeb,0xeb,0xec,0xec
		, 0xec,0xec,0xed,0xed,0xed,0xed,0xee,0xee
		, 0xee,0xee,0xef,0xef,0xef,0xef,0xf0,0xf0
		, 0xf0,0xf1,0xf1,0xf1,0xf1,0xf1,0xf2,0xf2
		, 0xf2,0xf2,0xf3,0xf3,0xf3,0xf3,0xf4,0xf4
		, 0xf4,0xf4,0xf5,0xf5,0xf5,0xf5,0xf5,0xf6
		, 0xf6,0xf6,0xf6,0xf7,0xf7,0xf7,0xf7,0xf7
		, 0xf8,0xf8,0xf8,0xf8,0xf9,0xf9,0xf9,0xf9
		, 0xf9,0xfa,0xfa,0xfa,0xfa,0xfa,0xfb,0xfb
		, 0xfb,0xfb,0xfb,0xfc,0xfc,0xfc,0xfc,0xfc
		, 0xfd,0xfd,0xfd,0xfd,0xfd,0xfd,0xfe,0xfe
		, 0xfe,0xfe,0xfe,0xff,0xff,0xff,0xff,0xff]

# atan(2^(x/32))*128/pi
atan_tab = [0 for x in range (0,256)]
for x in range (1,256): atan_tab [x]= round(math.atan2(1,2**((255-x)/32))*127/math.pi)


atan_tab = [ 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
		,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
		,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
		,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
		,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
		,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
		,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
		,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
		,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
		,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
		,0x00,0x00,0x00,0x00,0x00,0x01,0x01,0x01
		,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01
		,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01
		,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01
		,0x01,0x01,0x01,0x01,0x01,0x02,0x02,0x02
		,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02
		,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02
		,0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x03
		,0x03,0x03,0x03,0x03,0x03,0x04,0x04,0x04
		,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04
		,0x05,0x05,0x05,0x05,0x05,0x05,0x05,0x05
		,0x06,0x06,0x06,0x06,0x06,0x06,0x06,0x06
		,0x07,0x07,0x07,0x07,0x07,0x07,0x08,0x08
		,0x08,0x08,0x08,0x08,0x09,0x09,0x09,0x09
		,0x09,0x0a,0x0a,0x0a,0x0a,0x0b,0x0b,0x0b
		,0x0b,0x0c,0x0c,0x0c,0x0c,0x0d,0x0d,0x0d
		,0x0d,0x0e,0x0e,0x0e,0x0e,0x0f,0x0f,0x0f
		,0x10,0x10,0x10,0x11,0x11,0x11,0x12,0x12
		,0x12,0x13,0x13,0x13,0x14,0x14,0x15,0x15
		,0x15,0x16,0x16,0x17,0x17,0x17,0x18,0x18
		,0x19,0x19,0x19,0x1a,0x1a,0x1b,0x1b,0x1c
		,0x1c,0x1c,0x1d,0x1d,0x1e,0x1e,0x1f,0x1f]




octant_adjust = [
    	0b00111111, #		;; x+,y+,|x|>|y|
		0b00000000, #		;; x+,y+,|x|<|y|
		0b11000000, #		;; x+,y-,|x|>|y|
		0b11111111, #		;; x+,y-,|x|<|y|
		0b01000000, #		;; x-,y+,|x|>|y|
		0b01111111, #		;; x-,y+,|x|<|y|
		0b10111111, #		;; x-,y-,|x|>|y|
		0b10000000, #		;; x-,y-,|x|<|y|
]

def bxor(b1, b2): # use xor for bytes
    #result = bytearray()
    #for b1, b2 in zip(b1, b2):
    #    result.append(b1 ^ b2)
    print (b1, b2)
    return int.from_bytes(bytes([b1 ^ b2]), byteorder='big', signed=True)

import struct
def fastAtan (y, x):
    noct = 0
    if (x<0):
        ix = struct.unpack('B',struct.pack("b", x))[0] ^ 0xFF
        noct |= 4
    else: ix = x
    if (y<0):
        iy = struct.unpack('B',struct.pack("b", y))[0] ^ 0xFF
        noct |= 2
    else: iy = y

    res_div = log_tab[ix] - log_tab [iy]

    if log_tab[ix] >= log_tab [iy]:
        idx = struct.unpack('B',struct.pack("b", res_div))[0] ^ 0xFF
        noct |= 1
    #
    #if (res_div > 0): idx = res_div ^ 0xFF
    else : idx = struct.unpack('B',struct.pack("b", res_div))[0]

    v= atan_tab[idx]
    #v = v ^ octant_adjust [noct]
    v = int.from_bytes(bytes([v ^ octant_adjust [noct]]), byteorder='big', signed=True)


##    if (x<0) : ix = (255 - x) % 256
##    else : ix = x
##    if (y<0) : iy = (255 - y) % 256
##    else : iy= y
##    res_div = log_tab[ix] - log_tab [iy]
##    if (res_div < 0): idx = struct.unpack('B',struct.pack("b", res_div))[0]
##    else: idx = 255 - abs(res_div)
##    #idx = 255 - abs(res_div)
##    v= atan_tab[idx]
##    v=struct.unpack('B',struct.pack("b", v))[0]
##    if (x>=0) and (y>0) and (abs(x) <  abs(y)): v=bxor(v,0b00111111) #v^= 0b00111111 #v = -v+1
##    if (x>=0) and (y>0) and (abs(x) > abs(y)): v=bxor(v,0b00000000) #v = -v
##    if (x>0) and (y>0) and (abs(x) == abs(y)): v = 32
##    if (x>=0) and (y<0) and (abs(x) <  abs(y)): v=bxor(v,0b11000000) #v = v+192
##    if (x>=0) and (y<0) and (abs(x) >  abs(y)): v=bxor(v,0b11111111) #v = -v+192
##    if (x>0) and (y<0) and (abs(x) == abs(y)): v = 224
##    if (x<=0) and (y>0) and (abs(x) >  abs(y)): v=bxor(v,0b01000000) #v = v+64
##    if (x<=0) and (y>0) and (abs(x) <  abs(y)): v=bxor(v,0b01111111) #v = -v+64
##    if (x<0) and (y>0) and (abs(x) == abs(y)): v = 96
##    if (x<=0) and (y<0) and (abs(x) >  abs(y)): v=bxor(v,0b10111111) #v = -v+128
##    if (x<=0) and (y<0) and (abs(x) <  abs(y)): v=bxor(v,0b10000000) #v = v+0b10000000
##    if (x<0) and (y<0) and (abs(x) == abs(y)): v = 160

##    if (y>0) and (x>0) and (abs(y) >  abs(x)): v=bxor(v,0b00111111) #v^= 0b00111111 #v = -v+1
##    if (y>0) and (x>0) and (abs(y) <  abs(x)): v=bxor(v,0b00000000) #v = -v
##    if (y>0) and (x>0) and (abs(y) == abs(x)): v = 32
##    if (y>0) and (x<0) and (abs(y) >  abs(x)): v=bxor(v,0b11000000) #v = v+192
##    if (y>0) and (x<0) and (abs(y) <  abs(x)): v=bxor(v,0b11111111) #v = -v+192
##    if (y>0) and (x<0) and (abs(y) == abs(x)): v = 224
##    if (y<0) and (x>0) and (abs(y) >  abs(x)): v=bxor(v,0b01000000) #v = v+64
##    if (y<0) and (x>0) and (abs(y) <  abs(x)): v=bxor(v,0b01111111) #v = -v+64
##    if (y<0) and (x>0) and (abs(y) == abs(x)): v = 96
##    if (y<0) and (x<0) and (abs(y) >  abs(x)): v=bxor(v,0b10111111) #v = -v+128
##    if (y<0) and (x<0) and (abs(y) <  abs(x)): v=bxor(v,0b10000000) #v = v+128
##    if (y<0) and (x<0) and (abs(y) == abs(x)): v = 160

    return v


## FAST NORM

[A0, A1, A2, B0, B1, B2, C0, C1, C2, D0, D1, D2] = [ 1.60431525e-02,  1.01438538e+00, -2.23050176e-04,
-4.95743532e-03,  1.03966260e-01,  2.65156968e-03,
-1.25399371e-02,  8.51173164e-01,  -2.18092268e-04,
 2.02032598e-03,  5.39223578e-01,  3.71083013e-04]


tabmult_A = [round (  (A0)+ (A1)*i + (A2) *(i**2) ) for i in range (128) ]

tabmult_B = [round (  (B0) + i*( B1) + (i**2)*( B2 )       ) for i in range (128) ]

tabmult_C = [round (  (C0) + i*(C1) + (i**2)*( C2 )    ) for i in range (128) ]

tabmult_D = [round ( ( D0) + i*( D1) + (i**2)*(D2)   ) for i in range (128) ]

#def fixTable ():
tabmult_C [1] =0
tabmult_D[3]=1
tabmult_C [4] =4
tabmult_D[5]=2
tabmult_C [5]=5

def fastNorm (px,py):
    ax, ay = abs(px), abs(py)
    if ax >= ay:
        x, y = ax, ay
    else:
        x, y = ay, ax
    if y > x/2 :
        N = tabmult_C [x] + tabmult_D[y]
    else:
        N = tabmult_A [x] + tabmult_B[y]
    return N




## LINE DRAWING

# from https://en.wikipedia.org/wiki/Bresenham's_line_algorithm#All_cases
def drawLine( x0,  y0,  x1,  y1):
    points2d = []

    dx =  abs(x1-x0);
    #sx = x0<x1 ? 1 : -1;
    if (x0<x1):
        sx = 1
    else:
        sx = -1

    dy = -abs(y1-y0);
    #sy = y0<y1 ? 1 : -1;
    if (y0<y1):
        sy = 1
    else:
        sy = -1

    err = dx+dy;  # error value e_xy */
    print ("0. dx=%d sx=%d dy=%d sy=%d err=%d"%(dx, sx, dy, sy, err))
    while (True):   # loop */
        points2d.append([x0 , y0])
        print (x0, y0)
        if ((x0==x1) and (y0==y1)): break
        e2 = 2*err;
        if (e2 >=127) or (e2 <= -128): print (e2)
        if (e2 >= dy):
            err += dy; # e_xy+e_x > 0 */
            x0 += sx;
        if (e2 <= dx): # e_xy+e_y < 0 */
            err += dx;
            y0 += sy;

    for [ptx, pty] in points2d:
        if ((pty >= 0) and (pty <= HE) and (ptx >= 0) and (ptx <= LE)): screen [pty][ptx] = '*'


def drawFace( xA,  yA,  xB,  yB, xC, yC):

    drawLine( xA,  yA,  xB,  yB)
    drawLine( xB,  yB,  xC,  yC)
    drawLine( xC,  yC,  xA,  yA)



def project ():
    global points2
    LV = LE / 2
    HV = HE / 2

    points2 = []
    for p in points:
        ang1 = math.atan2((p[1]-glCamPos[1]),(p[0]-glCamPos[0])) - camori[0]*(math.pi/128)
        dist = math.sqrt ((p[1]-glCamPos[1])**2+(p[0]-glCamPos[0])**2)
        ang2 = math.atan2((p[2]-glCamPos[2]),dist) - camori[1]*(math.pi/128)

        X = ((-ang1 * LV) / math.radians(EAH)) + LV #(ang1 * (127 / math.pi)) / 2 + (LE / 2) #
        Y = ((-ang2 * HV) / math.radians(EAV)) + HV
        p2d = [int(round(X)), int(round(Y))]
        print (str (p), str(p2d), ang1, dist, ang2)
        points2.append (p2d)

def intProject ():
    global points2

    points2 = []
    for p in points:
        DeltaX = p[0]-glCamPos[0]
        DeltaY = p[1]-glCamPos[1]

        AngleH = fastAtan(DeltaY,DeltaX)

        Norm = fastNorm (DeltaY,DeltaX)

        DeltaZ = p[2]-glCamPos[2]
        AngleV = fastAtan(DeltaZ,Norm)

        AnglePH = AngleH - camori[0]
        AnglePV = AngleV -camori[1]

        X = -(AnglePH //2 ) + LE // 2 # ((AngleH * LV) / math.radians(EAH)) + LV
        Y = -(AnglePV //2 ) + HE // 2 #((-AngleV * HV) / math.radians(EAV)) + HV
        p2d = [int(X), int(Y)]
        print (str (p), str(p2d), AnglePH, Norm, AnglePV)
        points2.append (p2d)


def clip(subjectPolygon, clipPolygon):
   def inside(p):
      return(cp2[0]-cp1[0])*(p[1]-cp1[1]) > (cp2[1]-cp1[1])*(p[0]-cp1[0])

   def computeIntersection():
      dc = [ cp1[0] - cp2[0], cp1[1] - cp2[1] ]
      dp = [ s[0] - e[0], s[1] - e[1] ]
      n1 = cp1[0] * cp2[1] - cp1[1] * cp2[0]
      n2 = s[0] * e[1] - s[1] * e[0]
      n3 = 1.0 / (dc[0] * dp[1] - dc[1] * dp[0])
      return [(n1*dp[0] - n2*dc[0]) * n3, (n1*dp[1] - n2*dc[1]) * n3]

   outputList = subjectPolygon
   cp1 = clipPolygon[-1]

   for clipVertex in clipPolygon:
      cp2 = clipVertex
      inputList = outputList
      outputList = []
      s = inputList[-1]

      for subjectVertex in inputList:
         e = subjectVertex
         if inside(e):
            if not inside(s):
               outputList.append(computeIntersection())
            outputList.append(e)
         elif inside(s):
            outputList.append(computeIntersection())
         s = e
      cp1 = cp2
   return(outputList)


def initScreen (): screen = [[' ' for i in range(LE)] for j in range(HE)]

def printScreen ():
    st = ""
    for li in screen:
        st += '|' + ''.join(li) + '|\n'
    print (st)

def main():

    initScreen ()
    #project ()

    intProject ()
    #print (points2[7], points2[6], points2[5])
    #fillclip(points2[7], points2[6], points2[5])
    #fillclip([59, 1], [-16, 29], [-16,1])
    #drawLine( -16, 29,  59, 1)
    #drawLine(59, 1, -16, 29)
    #print (fastAtan (-3, 3))

    #for [pA, pB, pC, fst] in faces:
    #    print ("face",pA, pB, pC, points2[pA], points2[pB], points2[pC])
    #    drawFace( points2[pA][0],  points2[pA][1],  points2[pB][0],  points2[pB][1],  points2[pC][0],  points2[pC][1])
    #printScreen ()

    #subjectPolygon =  [ ( -5 , 5 ) , ( 20 , -5 ) , ( 45, 5 ) ]
    ##clipPolygon =  [ ( 100 , 100 ) , ( 300 , 100 ) , ( 300 , 300 ) , ( 100 , 300 ) ]
    #clipPolygon =  [ ( 0 , 0 ) , ( 39 , 0 ) , ( 39 , 26 ) , ( 0 , 26 ) ]
    #lPts = clip(subjectPolygon, clipPolygon)
    #print (lPts)

if __name__ == '__main__':
    main()
