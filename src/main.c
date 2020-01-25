#include "lib.h"

#include "config.h"
#include "glOric.h"

#include "externs.c"
#include "alphabet.c"
#include "traj.c"
#define abs(x) (((x)<0)?-(x):(x))


//
// ===== Display.s =====
//
extern unsigned char CurrentPixelX;             // Coordinate X of edited pixel/byte
extern unsigned char CurrentPixelY;             // Coordinate Y of edited pixel/byte

extern unsigned char OtherPixelX;               // Coordinate X of other edited pixel/byte
extern unsigned char OtherPixelY;               // Coordinate Y of other edited pixel/byte


//
// ====== Filler.s ==========

unsigned int	CurrentPattern=0;
extern	unsigned char	X0;
extern	unsigned char	Y0;
extern	unsigned char	X1;
extern	unsigned char	Y1;


 // Camera Position
extern int CamPosX;
extern int CamPosY;
extern int CamPosZ;

 // Camera Orientation
extern char CamRotZ;			// -128 -> -127 unit : 2PI/(2^8 - 1)
extern char CamRotX;


 // GEOMETRY BUFFERS
//extern char points3d[];
char points3d[NB_MAX_POINTS*SIZEOF_3DPOINT];
//extern unsigned char nbPts;
unsigned char nbPts=0;

extern char segments[];
extern unsigned char nbSegments;


//extern char points2d[];
char points2d [NB_MAX_POINTS*SIZEOF_2DPOINT];

#ifdef TEXTMODE
char faces[NB_MAX_FACES*SIZEOF_FACES];
unsigned char nbFaces=0;
//unsigned char distFaces[NB_MAX_FACES];

// TEXT SCREEN TEMPORARY BUFFERS
// z-depth buffer
unsigned char zbuffer [SCREEN_WIDTH*SCREEN_HEIGHT];
// frame buffer
char fbuffer [SCREEN_WIDTH*SCREEN_HEIGHT];

void initScreenBuffers(){
	memset (zbuffer, 0xFF, SCREEN_WIDTH*SCREEN_HEIGHT);
	memset (fbuffer, 0x20, SCREEN_WIDTH*SCREEN_HEIGHT); // Space
}

/*
void addCube3(char X, char Y, char Z){
	unsigned char ii, jj;
	for (jj=0; jj < NB_POINTS_CUBE; jj++){
		points3d[(nbPts+jj)* SIZEOF_3DPOINT + 0] = ptsCube[jj*SIZEOF_3DPOINT + 0] + X;  				// X coord
		points3d[(nbPts+jj)* SIZEOF_3DPOINT + 1] = ptsCube[jj*SIZEOF_3DPOINT + 1] + Y;                // Y coord
		points3d[(nbPts+jj)* SIZEOF_3DPOINT + 2] = ptsCube[jj*SIZEOF_3DPOINT + 2] + Z;                // Z coord
	}
	for (jj=0; jj < NB_SEGMENTS_CUBE; jj++){
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 0] = segCube[jj*SIZEOF_SEGMENT + 0]+nbPts; // Index Point 1
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 1] = segCube[jj*SIZEOF_SEGMENT + 1]+nbPts; // Index Point 2
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 2] = segCube[jj*SIZEOF_SEGMENT + 2]; // Character
	}
   	for (jj=0; jj < NB_FACES_CUBE; jj++){
		faces[(nbFaces+jj)* SIZEOF_FACES + 0] = facCube[jj*SIZEOF_FACES + 0]+nbPts; // Index Point 1
		faces[(nbFaces+jj)* SIZEOF_FACES + 1] = facCube[jj*SIZEOF_FACES + 1]+nbPts; // Index Point 2
		faces[(nbFaces+jj)* SIZEOF_FACES + 2] = facCube[jj*SIZEOF_FACES + 2]+nbPts; // Index Point 3
		faces[(nbFaces+jj)* SIZEOF_FACES + 3] = facCube[jj*SIZEOF_FACES + 3]; // Character
	}

	nbPts += NB_POINTS_CUBE;
	nbSegments += NB_SEGMENTS_CUBE;
	nbFaces += NB_FACES_CUBE;
}
*/
void addPlan(signed char X, signed char Y, unsigned char L, signed char orientation, char char2disp){
	unsigned char ii, jj;
	ii = (orientation == 0)?0:-L;
	jj = (orientation == 0)?-L:0;
	//printf ("plane [%d %d], l= %d, ori = %d, t = %c\n", X	, Y, L, orientation, char2disp); get();
    points3d[nbPts* SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts* SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPts* SIZEOF_3DPOINT + 2] = 3;
	//printf ("p3d [%d %d %d]\n", points3d[nbPts* SIZEOF_3DPOINT + 0]	, points3d[nbPts* SIZEOF_3DPOINT + 1], points3d[nbPts* SIZEOF_3DPOINT + 2]); get();
    nbPts ++;
	ii = (orientation == 0)?0:-L;
	jj = (orientation == 0)?-L:0;
    points3d[nbPts* SIZEOF_3DPOINT + 0] = X + ii ;
    points3d[nbPts* SIZEOF_3DPOINT + 1] = Y + jj ;
    points3d[nbPts* SIZEOF_3DPOINT + 2] = 0;
	//printf ("p3d [%d %d %d]\n", points3d[nbPts* SIZEOF_3DPOINT + 0]	, points3d[nbPts* SIZEOF_3DPOINT + 1], points3d[nbPts* SIZEOF_3DPOINT + 2]); get();
    nbPts ++;
	ii = (orientation == 0)?(0):L;
	jj = (orientation == 0)?(L):0;
    points3d[nbPts* SIZEOF_3DPOINT + 0] = X + ii ;
    points3d[nbPts* SIZEOF_3DPOINT + 1] = Y + jj ;
    points3d[nbPts* SIZEOF_3DPOINT + 2] = 0;
	//printf ("p3d [%d %d %d]\n", points3d[nbPts* SIZEOF_3DPOINT + 0]	, points3d[nbPts* SIZEOF_3DPOINT + 1], points3d[nbPts* SIZEOF_3DPOINT + 2]); get();
    nbPts ++;
	ii = (orientation == 0)?(0):L;
	jj = (orientation == 0)?(L):0;
    points3d[nbPts* SIZEOF_3DPOINT + 0] = X + ii ;
    points3d[nbPts* SIZEOF_3DPOINT + 1] = Y + jj ;
    points3d[nbPts* SIZEOF_3DPOINT + 2] = 3;
	//printf ("p3d [%d %d %d]\n", points3d[nbPts* SIZEOF_3DPOINT + 0]	, points3d[nbPts* SIZEOF_3DPOINT + 1], points3d[nbPts* SIZEOF_3DPOINT + 2]); get();
    nbPts ++;
    faces[nbFaces* SIZEOF_FACES + 0] = nbPts-4; // Index Point 1
    faces[nbFaces* SIZEOF_FACES + 1] = nbPts-3; // Index Point 2
    faces[nbFaces* SIZEOF_FACES + 2] = nbPts-2; // Index Point 3
    faces[nbFaces* SIZEOF_FACES + 3] = char2disp; // Index Point 3
    nbFaces ++;
    faces[nbFaces* SIZEOF_FACES + 0] = nbPts-4; // Index Point 1
    faces[nbFaces* SIZEOF_FACES + 1] = nbPts-2; // Index Point 2
    faces[nbFaces* SIZEOF_FACES + 2] = nbPts-1; // Index Point 3
    faces[nbFaces* SIZEOF_FACES + 3] = char2disp; // Index Point 3
    nbFaces ++;
    
    
	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-4; // Index Point 1
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-3; // Index Point 2
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '|'; // Character
	nbSegments ++;
    
	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-3; // Index Point 1
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-2; // Index Point 2
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '-'; // Character
	nbSegments ++;
    
	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-2; // Index Point 1
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-1; // Index Point 2
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '|'; // Character
	nbSegments ++;
    
	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-4; // Index Point 1
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-1; // Index Point 2
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '-'; // Character
	nbSegments ++;
	//printf ("%d Points, %d Segments, %d Faces\n", nbPts, nbSegments, nbFaces); get();
}



#endif
/*
void test_atan2() {

tx=0; ty=0; res=0; atan2_8();if (res!=0) printf("ERR atan(%d, %d)= %d\n",tx,ty,res);
tx=0; ty=1; res=0; atan2_8();if (res!=64) printf("ERR atan(%d, %d)= %d\n",tx,ty,res);
tx=0; ty=-1; res=0; atan2_8();if (res!=-64) printf("ERR atan(%d, %d)= %d\n",tx,ty,res);
tx=1; ty=0; res=0; atan2_8();if (res!=0) printf("ERR atan(%d, %d)= %d\n",tx,ty,res);
tx=-1; ty=0; res=0; atan2_8();if (res!=-128) printf("ERR atan(%d, %d)= %d\n",tx,ty,res);
tx=1; ty=1; res=0; atan2_8();if (res!=32) printf("ERR atan(%d, %d)= %d\n",tx,ty,res);
tx=-1; ty=1; res=0; atan2_8();if (res!=96) printf("ERR atan(%d, %d)= %d\n",tx,ty,res);
tx=1; ty=-1; res=0; atan2_8();if (res!=-32) printf("ERR atan(%d, %d)= %d\n",tx,ty,res);
tx=-1; ty=-1; res=0; atan2_8();if (res!=-96) printf("ERR atan(%d, %d)= %d\n",tx,ty,res);
//#include "output.txt"

}
*/
/*
void doProjection(){
	unsigned char ii = 0;
	for (ii = 0; ii< nbPts; ii++){
		PointX = points3d[ii*SIZEOF_3DPOINT + 0];
		PointY = points3d[ii*SIZEOF_3DPOINT + 1];
		PointZ = points3d[ii*SIZEOF_3DPOINT + 2];
		project();
		points2d[ii*SIZEOF_2DPOINT + 0] = ResX;
		points2d[ii*SIZEOF_2DPOINT + 1] = ResY;
	}
}
*/

void zplot(unsigned char X, unsigned char Y, unsigned char dist, char char2disp) {
	int  offset;
    char *ptrFbuf;
    unsigned char *ptrZbuf;
	if ((Y <= 0) || (Y>=SCREEN_HEIGHT) || (X <= 0) || (X>=SCREEN_WIDTH)) return;
    offset = Y*SCREEN_WIDTH+X;
    ptrZbuf = zbuffer+offset;
    ptrFbuf = fbuffer+offset;
	//printf ("pl [%d %d] zbuff = %d , pointDist = %d\n", X, Y, *ptrZbuf, dist);
	if (dist < *ptrZbuf ){
            *ptrFbuf = char2disp;
            *ptrZbuf = dist;
    }
	
}

signed char _brX;
signed char _brY;
signed char _brDx;
signed char _brDy;
signed char _brDestX;
signed char _brDestY;
signed char _brErr;
signed char _brSx;
signed char _brSy;


void lrDrawLine (signed char x0, signed char y0, signed char x1, signed char y1, unsigned char distseg, char ch2disp) {


	
	signed char e2;
	
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
	
	
	while ((_brX != _brDestX) || (_brY != _brDestY)) { // loop 
        // plot (brX, brY, distseg, ch2disp)
		//printf ("plot [%d, %d] %d %s\n", _brX, _brY, distseg, ch2disp);
		zplot(_brX, _brY, distseg, ch2disp);
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
	unsigned char idxPt1, idxPt2;
    unsigned char offPt1, offPt2;
    int d1, d2;
    int dmoy;
    unsigned char distseg;
    
#ifdef ANGLEONLY
	signed char P1AH, P1AV, P2AH, P2AV;
#endif

	for (ii = 0; ii< nbSegments; ii++){

		idxPt1 =            segments[ii*SIZEOF_SEGMENT + 0];
		idxPt2 =            segments[ii*SIZEOF_SEGMENT + 1];
		char2Display =      segments[ii*SIZEOF_SEGMENT + 2];
        
        offPt1 = idxPt1<<2;
        offPt2 = idxPt2<<2;
        d1 = *((int*)(points2d+offPt1+2));
        //d2 = points2d [idxPt2*SIZEOF_2DPOINT+3]*256 + points2d [idxPt2*SIZEOF_2DPOINT+2];
        d2 = *((int*)(points2d+offPt2+2));
        
        dmoy = (d1+d2)>>1;
        if (dmoy >= 256) {
            //distFaces[ii] = 256;
            dmoy = 256;
        }/* else {			
            distFaces[ii] = dmoy;
        }*/
        distseg = (unsigned char)((dmoy-1) & 0x00FF); // FIXME -1 is a ugly hack
        
#ifndef ANGLEONLY
		Point1X = points2d[idxPt1*SIZEOF_2DPOINT + 0];
		Point1Y = points2d[idxPt1*SIZEOF_2DPOINT + 1];
		Point2X = points2d[idxPt2*SIZEOF_2DPOINT + 0];
		Point2Y = points2d[idxPt2*SIZEOF_2DPOINT + 1];
        
        //printf ("dl ([%d, %d] %d, [%d, %d] %d =>  %d\n", Point1X, Point1Y, d1, Point2X, Point2Y, d2, distseg);
        //get();
#else
 		P1AH = points2d[idxPt1*SIZEOF_2DPOINT + 0];
		P1AV = points2d[idxPt1*SIZEOF_2DPOINT + 1];
		P2AH = points2d[idxPt2*SIZEOF_2DPOINT + 0];
		P2AV = points2d[idxPt2*SIZEOF_2DPOINT + 1];
   
        Point1X  =  (SCREEN_WIDTH-P1AH)/2;
        Point1Y  =  (SCREEN_HEIGHT-P1AV)/2;
        Point2X  =  (SCREEN_WIDTH-P2AH)/2;
        Point2Y  =  (SCREEN_HEIGHT-P2AV)/2;

        //printf ("dl ([%d, %d] %d, [%d, %d] %d => %d c=%d\n", Point1X, Point1Y, d1, Point2X, Point2Y, d2, distseg, 0);
        //get();
		lrDrawLine (Point1X, Point1Y, Point2X, Point2Y, distseg, char2Display);
#endif
	}
}

char status_string[50];

void dispInfo(){
#ifdef TEXTMODE
	sprintf(status_string,"(x=%d y=%d z=%d) [%d %d]", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
	AdvancedPrint(2,1,status_string);
#else
	printf("\nMike 8bit: ");
	printf ("(x=%d y=%d z=%d) [%d %d]", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
#endif
}

#ifdef TEXTMODE
#include "txtDemo.c"
#else
#include "hrsDemo.c"
#endif
/*
void hrDrawSegments2(){
	unsigned char ii = 0;
	unsigned char idxPt1, idxPt2;
	int OtherPixelX, OtherPixelY, CurrentPixelX, CurrentPixelY;
	for (ii = 0; ii< nbSegments; ii++){

		idxPt1 =            segments[ii*SIZEOF_SEGMENT + 0];
		idxPt2 =            segments[ii*SIZEOF_SEGMENT + 1];

        //OtherPixelX= (int)points2d[idxPt1*SIZEOF_2DPOINT + 0];
		OtherPixelX=((int *)points2d)[idxPt1*2];
        //OtherPixelY= (int)points2d[idxPt1*SIZEOF_2DPOINT + 2];
		OtherPixelY=((int *)points2d)[idxPt1*2+1];

        //CurrentPixelX=(int)points2d[idxPt2*SIZEOF_2DPOINT + 0];
		CurrentPixelX=((int *)points2d)[idxPt2*2];
        //CurrentPixelY=(int)points2d[idxPt2*SIZEOF_2DPOINT + 2];
		CurrentPixelY=((int *)points2d)[idxPt2*2+1];
		printf("%d %d %d %d \n",
		OtherPixelX, OtherPixelY, CurrentPixelX, CurrentPixelY);
		//cgetc();
		//tgi_line(OtherPixelX,OtherPixelY,CurrentPixelX,CurrentPixelY);
	}
}


void debugHiresIntro (){
    int i;
    //hires();

	CamPosX = -24;
	CamPosY = 0;
	CamPosZ = 3;

 	CamRotZ = 64 ;
	CamRotX = 2;

    for (i=0;i<2;) {
		CamPosX = traj[i++];
		CamPosY = traj[i++];
		CamRotZ = traj[i++];
		i = i % (NB_POINTS_TRAJ*SIZE_POINTS_TRAJ);
        glProject (points2d, points3d, nbPts);
        //memset ( 0xa000, 64, 8000); // clear screen
		hrDrawSegments2();
		//hrDrawFaces();
    }

	//leaveSC();

}
*/
#ifdef TEXTMODE

#include "fill8.c"

void buffer2screen(){
	/*int ii, jj;*/
    memcpy((void*)0xBB80, fbuffer, SCREEN_HEIGHT* SCREEN_WIDTH);
	/* clearScreen(); 
	for (ii=0;ii<SCREEN_HEIGHT; ii++){
		for (jj=2; jj < SCREEN_WIDTH; jj++){
			PutChar(jj,ii,fbuffer[ii*SCREEN_WIDTH+jj]);
		}
	}*/
}

fillFace (signed char P1AH, signed char P1AV, signed char P2AH, signed char P2AV, signed char P3AH, signed char P3AV, unsigned char distface, char ch2disp) {
    
    signed char P1X, P1Y, P2X, P2Y, P3X, P3Y;
    
    P1X  =  (SCREEN_WIDTH-P1AH)/2;
    P1Y  =  (SCREEN_HEIGHT-P1AV)/2;
    P2X  =  (SCREEN_WIDTH-P2AH)/2;
    P2Y  =  (SCREEN_HEIGHT-P2AV)/2;
    P3X  =  (SCREEN_WIDTH-P3AH)/2;
    P3Y  =  (SCREEN_HEIGHT-P3AV)/2;
    //printf ("P1A: [%d, %d], P2A: [%d, %d], P3A [%d, %d]\n", P1AH, P1AV, P2AH, P2AV, P3AH, P3AV);
    //printf ("[%d, %d], [%d, %d], [%d, %d]\n", P1X, P1Y, P2X, P2Y, P3X, P3Y);
    //get();
    fill8(P1X, P1Y, 
        P2X, P2Y, 
        P3X, P3Y,
        distface, ch2disp);

}
// extern void PutChar(char x_pos,char y_pos,char ch2disp);
void fillFaces() {

    unsigned char ii=0;
    unsigned char jj = 0;
    int d1, d2, d3;
    int dmoy;
    unsigned char idxPt1, idxPt2, idxPt3, distface;
    unsigned char offPt1, offPt2, offPt3;
    signed char P1X, P1Y, P2X, P2Y, P3X, P3Y;
#ifdef ANGLEONLY
	signed char tmpH, tmpV;
	signed char P1AH, P1AV, P2AH, P2AV, P3AH, P3AV;
    unsigned char m1, m2, m3;
	unsigned char v1, v2, v3;
#endif
	//printf ("%d Points, %d Segments, %d Faces\n", nbPts, nbSegments, nbFaces); get();
	for (ii=0; ii< nbFaces; ii++) {
        jj = ii << 2;
        /*idxPt1 = faces[ii*SIZEOF_FACES+0];
        idxPt2 = faces[ii*SIZEOF_FACES+1];
        idxPt3 = faces[ii*SIZEOF_FACES+2];*/
        
		/*idxPt1 = faces[jj++];
        idxPt2 = faces[jj++];
        idxPt3 = faces[jj++];*/
        
        offPt1 = faces[jj++] << 2;
        offPt2 = faces[jj++] << 2;
        offPt3 = faces[jj++] << 2;
        //printf ("face %d : %d %d %d\n",ii, offPt1, offPt2, offPt3);get();
        d1 = *((int*)(points2d+offPt1+2));

        d2 = *((int*)(points2d+offPt2+2));

        d3 = *((int*)(points2d+offPt3+2));
        

        //dmoy = (d1+d2+d3)/3;
        dmoy = (d1+d2+d3)/3;
        if (dmoy >= 256) {
            //distFaces[ii] = 256;
            dmoy = 256;
        }/* else {			
            distFaces[ii] = dmoy;
        }*/
        distface = (unsigned char)(dmoy & 0x00FF);
#ifndef ANGLEONLY
        P1X=points2d [offPt1+0];
        P1Y=points2d [offPt1+1];
        P2X=points2d [offPt2+0];
        P2Y=points2d [offPt2+1];
        P3X=points2d [offPt3+0];
        P3Y=points2d [offPt3+1];

        //printf ("[%d, %d], [%d, %d], [%d, %d]\n", P1X, P1Y, P2X, P2Y, P3X, P3Y);get();
		
        fill8(P1X, P1Y, 
            P2X, P2Y, 
            P3X, P3Y,
            distface, faces[jj]);

#else
		P1AH =  points2d [offPt1+0];
		P1AV =  points2d [offPt1+1];
		P2AH =  points2d [offPt2+0];
		P2AV =  points2d [offPt2+1];
		P3AH =  points2d [offPt3+0];
		P3AV =  points2d [offPt3+1];
        //
        
        //printf ("P1 [%d, %d], P2 [%d, %d], P3 [%d %d]\n", P1AH, P1AV, P2AH, P2AV,  P3AH, P3AV); get();

        if (abs(P2AH) < abs(P1AH)){
            //printf("swap P1 P2\n");
            tmpH = P1AH;
            tmpV = P1AV;
            P1AH = P2AH;
            P1AV = P2AV;
            P2AH = tmpH;
            P2AV = tmpV;
        } 
        if (abs(P3AH) < abs(P1AH)){
            //printf("swap P1 P3\n");
            tmpH = P1AH;
            tmpV = P1AV;
            P1AH = P3AH;
            P1AV = P3AV;
            P3AH = tmpH;
            P3AV = tmpV;            
        } 
        if (abs(P3AH) < abs(P2AH)){
            //printf("swap P2 P3\n");
            tmpH = P2AH;
            tmpV = P2AV;
            P2AH = P3AH;
            P2AV = P3AV;
            P3AH = tmpH;
            P3AV = tmpV;
            
        } 
#define ANGLE_MAX 0xC0        
#define ANGLE_VIEW 0xE0        

        m1 = P1AH & ANGLE_MAX;
        m2 = P2AH & ANGLE_MAX;
        m3 = P3AH & ANGLE_MAX;
        v1 = P1AH & ANGLE_VIEW;
        v2 = P2AH & ANGLE_VIEW;
        v3 = P3AH & ANGLE_VIEW;
        //printf ("AHs [%d, %d, %d] [%x, %x], %x], %x, %x, %x]\n", P1AH, P2AH, P3AH, m1, m2, m3, v1,v2,v3);
        //get();
/*
     P1 P2 P3
_1_   b  x  x   => rien
_2_   f  b  x   => rien
_3_   f  f  b   Si signe(P1AH)!=signe(P2AH) => XXXX
                Sinon => rien
_4_   f  f  f   Si signe(P1AH)!=signe(P2AH)  OU signe(P1AH)!=signe(P3AH) => XXXX
                Sinon => rien
      v  b  b   Si signe (P1AH) != signe(P2AH) et P2AH proche de -128/127 => clip
                
      v  f  b
      v  f  f 
      v  v  b
      v  v  v
*/        
        if ((m1 == 0x00) || (m1 == ANGLE_MAX)){
            if ((v1 == 0x00) || (v1 == ANGLE_VIEW)) {
                // P1 VISIBLE
                // _5_
                // _6_
                // _7_
                // _8_
                /*if ((m2 == 0x00) || (m2 == ANGLE_MAX)){
                    if ((v2 == 0x00) || (v2 == ANGLE_VIEW)) {
                        // P2 VISIBLE
                        if ((m3 == 0x00) || (m3 == ANGLE_MAX)){
                            if ((v3 == 0x00) || (v3 == ANGLE_VIEW)) {
                                // P3 VISIBLE 
                                fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                            } else {
                                // P3 FRONT
                            }
                        } else {
                            // P3 BACK
                        }
                    } else {	
                        // P2 FRONT
                    }
                } else {
                    //   
                }
                */
                if (
                    (
                        (P1AH & 0x80) != (P2AH & 0x80)
                    )||(
                        (P1AH & 0x80) != (P3AH & 0x80)
                    )
                ){
                    if ((abs(P3AH) < 127 - abs(P1AH))){
                        fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                    }
                } else {
                
                    fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                }

            } else {
                // P1 FRONT
                if ((m2 == 0x00) || (m2 == ANGLE_MAX)){
                    // P2 FRONT
                    if ((m3 == 0x00) || (m3 == ANGLE_MAX)){
                        // P3 FRONT
                        // _4_
                        if (((P1AH & 0x80) != (P2AH & 0x80)) || ((P1AH & 0x80) != (P3AH & 0x80))) {
                            fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV,distface, faces[jj]);
                        } else {
                            // nothing to do
                        }
                    } else {
                        // P3 BACK
                        // _3_
                        if ((P1AH & 0x80) != (P2AH & 0x80)) {
                            if (abs (P2AH) < 127 - abs (P1AH)) {
                                fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                            }
                        } else {
                            if ((P1AH & 0x80) != (P3AH & 0x80)) {
                                if (abs (P3AH) < 127 - abs (P1AH)) {
                                    fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                                }
                            }
                        }
                                            
                        if ((P1AH & 0x80) != (P3AH & 0x80)) {
                            if (abs (P3AH) < 127 - abs (P1AH)) {
                                fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                            }
                        }
                        }
                } else {
                    // P2 BACK
                    // _2_ nothing to do 
                    if ((P1AH & 0x80) != (P2AH & 0x80)) {
                        if (abs (P2AH) < 127 - abs (P1AH)) {
                            fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                        }
                    } else {
                        if ((P1AH & 0x80) != (P3AH & 0x80)) {
                            if (abs (P3AH) < 127 - abs (P1AH)) {
                                fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                            }
                        }
                    }
                                        
                    if ((P1AH & 0x80) != (P3AH & 0x80)) {
                        if (abs (P3AH) < 127 - abs (P1AH)) {
                            fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                        }
                    }
                }
            }
        } else {
            // P1 BACK
            // _1_ nothing to do 
        }
        //get();
        
   
#endif
    }

}
void faceIntro() {
    int i;
    get();
    enterSC();

	CamPosX = 0;
	CamPosY = 0;
	CamPosZ = 1;

 	CamRotZ = 0;
	CamRotX = 0;

    for (i=0;i<120;) {
		CamPosX = traj[i++]/4;
		CamPosY = traj[i++]/4;
		CamRotZ = traj[i++];
		i = i % (NB_POINTS_TRAJ*SIZE_POINTS_TRAJ);
        glProject (points2d, points3d, nbPts);
        initScreenBuffers();
        fillFaces();
        lrDrawSegments();
        buffer2screen();
    }

/*	CamPosX = -8;
	CamPosY = 8;
	CamPosZ = 1;

 	CamRotZ = -32 ;
	CamRotX = 0;
	for (i= 0; i< 16; i++) {
		forward();
        glProject (points2d, points3d, nbPts);
        initScreenBuffers();
        fillFaces();
        lrDrawSegments();
        buffer2screen();
	}
*/
	leaveSC();

}
void txtGameLoop2() {

	char key;
    unsigned char ii;    
	//key=get();
	glProject (points2d, points3d, nbPts);
    
    
    /*printf ("(x=%d y=%d z=%d) [%d %d]\n", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
        for (ii=0; ii< nbPts; ii++){
            printf ("[%d %d %d] => [%d %d] %d \n"
            , points3d [ii*SIZEOF_3DPOINT+0], points3d[ii*SIZEOF_3DPOINT+1], points3d[ii*SIZEOF_3DPOINT+2]
            , points2d [ii*SIZEOF_2DPOINT+0], points2d [ii*SIZEOF_2DPOINT+1], points2d[ii*SIZEOF_2DPOINT+2]
            );
        }
        get();
    */
	initScreenBuffers();
	fillFaces();
    lrDrawSegments();
    while (1==1) {
		//clearScreen();
		//drawSegments();
		buffer2screen();
		dispInfo();
		key=get();
		switch (key)	// key
		{
		case 8:	// gauche => tourne gauche
			CamRotZ += 4;
			break;
		case 9:	// droite => tourne droite
			CamRotZ -= 4;
			break;
		case 10: // bas => recule
			backward();
			break;
		case 11: // haut => avance
			forward();
			break;
		case 80: // P
			CamPosZ += 1;
			break;
		case 59: // ;
			CamPosZ -= 1;
			break;
		case 81: // Q
			CamRotX += 2;
			break;
		case 65: // A
			CamRotX -= 2;
			break;
		case 90: // Z
			shiftLeft();
			break;
		case 88: // X
			shiftRight();
			break;
		}
		glProject (points2d, points3d, nbPts);
		initScreenBuffers();
		fillFaces();
        lrDrawSegments();
	}
}

void faceDemo(){
	nbPts =0 ;
	nbSegments =0 ;
    nbFaces =0 ;
	//addCube3(-12, -12, 0);
    //addCube3(0, 0, 0);
    //addPlan();
    addPlan(0, 2, 2, 64, '.');
    addPlan(2, 0, 2, 0, ':');
    addPlan(0, -2, 2, 64, ';');
    addPlan(-2, 0, 2, 0, '\'');
    //addPlan(4, 4, 2, 64, ':');
    //printf ("nbPoints = %d, nbSegments = %d, nbFaces = %d\n",nbPts, nbSegments, nbFaces);
	lores0();
	faceIntro();

    /*CamPosX = -8;
	CamPosY = 0;
	CamPosZ = 2;

 	CamRotZ = 0;
	CamRotX = 0;
    */

	txtGameLoop2();

}
#endif

void main()
{
    
	faceDemo();
/* THINK OF ANGLEONLY !!!!     
#ifdef TEXTMODE
	textDemo();
#else
	hiresDemo();
#endif
 */
}
