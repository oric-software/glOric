#include "lib.h"

#include "config.h"
#include "glOric.h"

#include "externs.c"
#include "alphabet.c"
#include "traj.c"

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
unsigned char nbPts;

extern char segments[];
extern unsigned char nbSegments;

//extern char points2d[];
char points2d [NB_MAX_POINTS*SIZEOF_2DPOINT];



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
/*
void drawSegments(){
	unsigned char ii = 0;
	unsigned char idxPt1, idxPt2;
	for (ii = 0; ii< nbSegments; ii++){

		idxPt1 =            segments[ii*SIZEOF_SEGMENT + 0];
		idxPt2 =            segments[ii*SIZEOF_SEGMENT + 1];
		char2Display =      segments[ii*SIZEOF_SEGMENT + 2];

		Point1X = points2d[idxPt1*SIZEOF_2DPOINT + 0];
		Point1Y = points2d[idxPt1*SIZEOF_2DPOINT + 1];
		Point2X = points2d[idxPt2*SIZEOF_2DPOINT + 0];
		Point2Y = points2d[idxPt2*SIZEOF_2DPOINT + 1];

		drawLine ();
	}
}
*/
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

#include "txtDemo.c"

#include "hrsDemo.c"



void main()
{
	int i=0;
	CamPosX = -24;
	CamPosY = 0;
	CamPosZ = 3;

 	CamRotZ = 64 ;	
	CamRotX = 2;

#ifdef TEXTMODE
	textDemo();
#else
	hiresDemo();
#endif

}
