#include "lib.h"

#include "config.h"
#include "glOric.h"

#include "externs.c"
#include "data/geom.c"

#define abs(x) (((x)<0)?-(x):(x))

#ifndef TEXTMODE
#include "data/traj.c"
#endif

 // Camera Position
extern int CamPosX;
extern int CamPosY;
extern int CamPosZ;

 // Camera Orientation
extern char CamRotZ;			// -128 -> -127 unit : 2PI/(2^8 - 1)
extern char CamRotX;



#ifdef LRSMODE

// TEXT SCREEN TEMPORARY BUFFERS
// z-depth buffer
unsigned char zbuffer [SCREEN_WIDTH*SCREEN_HEIGHT];
// frame buffer
char fbuffer [SCREEN_WIDTH*SCREEN_HEIGHT];

void initScreenBuffers(){
	memset (zbuffer, 0xFF, SCREEN_WIDTH*SCREEN_HEIGHT);
	memset (fbuffer, 0x20, SCREEN_WIDTH*SCREEN_HEIGHT); // Space
}

void buffer2screen(){
    memcpy((void*)0xBB80, fbuffer, SCREEN_HEIGHT* SCREEN_WIDTH);
}


#endif

#ifndef HRSMODE
char status_string[50];

void dispInfo(){
	sprintf(status_string,"(x=%d y=%d z=%d) [%d %d]", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
	AdvancedPrint(2,1,status_string);

}
#endif

#ifdef TEXTMODE
#include "logic.c"
#include "txtDemo.c"
#endif

#ifdef HRSMODE
#include "render\hrsDrawing.c"
#include "hrsDemo.c"
#endif

#ifdef LRSMODE
#include "raster\bresfill.c"
#include "render\lrsDrawing.c"
#include "logic.c"
#include "lrsDemo.c"
#endif


void main()
{
	
 
#ifdef TEXTMODE
	textDemo();
#endif
#ifdef HRSMODE
	hiresDemo();
#endif
#ifdef LRSMODE
	faceDemo();
#endif

}
