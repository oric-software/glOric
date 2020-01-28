/* lrsDrawing */


signed char _brX;
signed char _brY;
signed char _brDx;
signed char _brDy;
signed char _brDestX;
signed char _brDestY;
signed char _brErr;
signed char _brSx;
signed char _brSy;


void zplot(unsigned char X, unsigned char Y, unsigned char dist, char char2disp) {
	int  offset;
    char *ptrFbuf;
    unsigned char *ptrZbuf;
	if ((Y <= 0) || (Y>=SCREEN_HEIGHT) || (X <= 0) || (X>=SCREEN_WIDTH)) return;


		offset = Y*SCREEN_WIDTH+X; //multi40[Y] + X;
    ptrZbuf = zbuffer+offset;
    ptrFbuf = fbuffer+offset;
	//printf ("pl [%d %d] zbuff = %d , pointDist = %d\n", X, Y, *ptrZbuf, dist);
	if (dist < *ptrZbuf ){
            *ptrFbuf = char2disp;
            *ptrZbuf = dist;
    }

}

void change_char(char c, unsigned char patt01, unsigned char patt02, unsigned char patt03, unsigned char patt04, unsigned char patt05, unsigned char patt06, unsigned char patt07, unsigned char patt08)
{

	 unsigned char * adr;
   adr  =(unsigned char *) (0xB400 + c*8);
	 *(adr++) = patt01;
	 *(adr++) = patt02;
	 *(adr++) = patt03;
	 *(adr++) = patt04;
	 *(adr++) = patt05;
	 *(adr++) = patt06;
	 *(adr++) = patt07;
	 *(adr++) = patt08;

}
#define DOLLAR 36
void lrDrawLine (signed char x0, signed char y0, signed char x1, signed char y1, unsigned char distseg, char ch2disp) {

	signed char e2;
	char char2disp;


	_brX = x0;
	_brY = y0;
	_brDestX = x1;
	_brDestY = y1;
	_brDx =  abs(x1-x0);
	_brDy= -abs(y1-y0);
	_brSx = x0<x1 ? 1 : -1;
	_brSy = y0<y1 ? 1 : -1;
	_brErr=_brDx+_brDy;
    if ((_brErr > 64) ||(_brErr < -63)) return;

	if ((ch2disp == '/') && (_brSx == -1)) {
		char2disp = DOLLAR;
	} else {
		char2disp = ch2disp;
	}


	while (1) { // loop
        // plot (brX, brY, distseg, ch2disp)
		//printf ("plot [%d, %d] %d %s\n", _brX, _brY, distseg, ch2disp);
		zplot(_brX, _brY, distseg, char2disp);
        if ((_brX == _brDestX) && (_brY == _brDestY)) break;
        //e2 = 2*err;
		e2 = (_brErr < 0) ? (
			((_brErr & 0x40) == 0)?(
				0x80
			):(
				_brErr << 1
			)
		):(
			((_brErr & 0x40) != 0)?(
				0x7F
			):(
				_brErr << 1
			)
		);
        if (e2 >= _brDy) {
            _brErr += _brDy; // e_xy+e_x > 0
            _brX += _brSx;
        }
        if (e2 <= _brDx){ // e_xy+e_y < 0
            _brErr += _brDx;
            _brY += _brSy;
        }
    }
}

/*
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

    err = dx+dy;  # error value e_xy
    print ("0. dx=%d sx=%d dy=%d sy=%d err=%d"%(dx, sx, dy, sy, err))
    while (True):   # loop
        points2d.append([x0 , y0])
        print (x0, y0)
        if ((x0==x1) and (y0==y1)): break
        e2 = 2*err;
        if (e2 >=127) or (e2 <= -128): print (e2)
        if (e2 >= dy):
            err += dy; # e_xy+e_x > 0
            x0 += sx;
        if (e2 <= dx): # e_xy+e_y < 0
            err += dx;
            y0 += sy;
*/


void lrDrawSegments(){
	unsigned char ii = 0;
	unsigned char jj = 0;
	unsigned char idxPt1, idxPt2;
    unsigned char offPt1, offPt2;
    int d1, d2;
    int dmoy;
    unsigned char distseg;

#ifdef ANGLEONLY
	signed char P1AH, P1AV, P2AH, P2AV;
#endif

	for (ii = 0; ii< nbSegments; ii++){

        jj = ii << 2; // ii*SIZEOF_SEGMENT

		idxPt1 =            segments[jj++]; // ii*SIZEOF_SEGMENT +0
		idxPt2 =            segments[jj++]; // ii*SIZEOF_SEGMENT +1
		char2Display =      segments[jj];   // ii*SIZEOF_SEGMENT +2

        offPt1 = idxPt1<<2;
        offPt2 = idxPt2<<2;

        // dmoy = (d1+d2)/2;
        dmoy = *((int*)(points2d+(offPt1 | 0x02))); // points2d[offPt1+2]
        dmoy += *((int*)(points2d+(offPt2 | 0x02))); // points2d[offPt2+2]
        dmoy = dmoy>>1;

        //if (dmoy >= 256) {
        if ((dmoy & 0xFF00) != 0) continue;
        distseg = (unsigned char)((dmoy) & 0x00FF);
        distseg --; // FIXME

#ifndef ANGLEONLY
        jj = idxPt1 << 4; // idxPt1*SIZEOF_2DPOINT
		Point1X = points2d[jj++];
		Point1Y = points2d[jj];
        jj = idxPt2 << 4; // idxPt2*SIZEOF_2DPOINT
		Point2X = points2d[jj++];
		Point2Y = points2d[jj];

        //printf ("dl ([%d, %d] %d, [%d, %d] %d =>  %d\n", Point1X, Point1Y, d1, Point2X, Point2Y, d2, distseg);
        //get();
#else
 		/*
        P1AH = points2d[idxPt1*SIZEOF_2DPOINT + 0];
		P1AV = points2d[idxPt1*SIZEOF_2DPOINT + 1];
		P2AH = points2d[idxPt2*SIZEOF_2DPOINT + 0];
		P2AV = points2d[idxPt2*SIZEOF_2DPOINT + 1];
        */
        jj = idxPt1 << 2; // idxPt1*SIZEOF_2DPOINT
		P1AH = points2d[jj++];
		P1AV = points2d[jj];
        jj = idxPt2 << 2; // idxPt2*SIZEOF_2DPOINT
		P2AH = points2d[jj++];
		P2AV = points2d[jj];

        Point1X  =  (SCREEN_WIDTH-P1AH)>>1;
        Point1Y  =  (SCREEN_HEIGHT-P1AV)>>1;
        Point2X  =  (SCREEN_WIDTH-P2AH)>>1;
        Point2Y  =  (SCREEN_HEIGHT-P2AV)>>1;

        //printf ("dl ([%d, %d] %d, [%d, %d] %d => %d c=%d\n", Point1X, Point1Y, d1, Point2X, Point2Y, d2, distseg, 0);
        //get();
		lrDrawLine (Point1X, Point1Y, Point2X, Point2Y, distseg, char2Display);
#endif
	}
}
