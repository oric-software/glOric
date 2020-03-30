
#include "config.h"
#ifdef TARGET_ORIX
#include <string.h>
#include <stdio.h>
#include <conio.h>
#else
#include "lib.h"
#endif // TARGET_ORIX

#include "glOric_h.h"

#define max(a,b)            (((a) > (b)) ? (a) : (b))
#define min(a,b)            (((a) < (b)) ? (a) : (b))
#define abs(x)                 (((x)<0)?-(x):(x))

// from temp.(asm|s)

extern    unsigned char idxPt1, idxPt2, idxPt3;
extern    int           d1, d2, d3;
extern    int           dmoy;
 
extern    unsigned char idxPt1, idxPt2, idxPt3;

extern    unsigned char m1, m2, m3;
extern    unsigned char v1, v2, v3;
extern    unsigned char isFace2BeDrawn;

// from 

extern signed char A1X;
extern signed char A1Y;
extern signed char A1destX;
extern signed char A1destY;
extern signed char A1dX;
extern signed char A1dY;
extern signed char A1err;
extern signed char A1sX;
extern signed char A1sY;
extern char        A1arrived;

extern signed char A2X;
extern signed char A2Y;
extern signed char A2destX;
extern signed char A2destY;
extern signed char A2dX;
extern signed char A2dY;
extern signed char A2err;
extern signed char A2sX;
extern signed char A2sY;
extern char        A2arrived;

extern unsigned char A1Right;
extern unsigned char distface;
extern unsigned char distseg;
extern char          ch2disp;
extern    signed char   P1X, P1Y, P2X, P2Y, P3X, P3Y;
extern     signed char   P1AH, P1AV, P2AH, P2AV, P3AH, P3AV;

extern unsigned char log2_tab[];
extern signed char mDeltaY1, mDeltaX1, mDeltaY2, mDeltaX2;

extern signed char pDepX;
extern signed char pDepY;
extern signed char pArr1X;
extern signed char pArr1Y;
extern signed char pArr2X;
extern signed char pArr2Y;

extern unsigned char lineIndex;
extern unsigned char departX;
extern unsigned char finX;
extern signed char hLineLength;

#ifdef USE_SATURATION
extern unsigned char A1XSatur;
extern unsigned char A2XSatur;
#endif // USE_SATURATION


extern unsigned char zbuffer[];  // z-depth buffer SCREEN_WIDTH * SCREEN_HEIGHT
extern char          fbuffer[];  // frame buffer SCREEN_WIDTH * SCREEN_HEIGHT


void waitkey(){
#ifdef TARGET_ORIX
    cgetc();
#else
    get();
#endif
}

#include "initScreenBuffers.c"

#include "glProject.c"

#include "retrieveFaceData.c"
#include "sortPoints.c"
#include "guessIfFace2BeDrawn.c"
#include "angle2screen.c"
#include "prepareBresrun.c"
#include "isA1Right.c"
#include "satur.c"
#include "agent.c"
#include "reachScreen.c"
#include "hzfill_c.c"
#include "fill8_bresrun.c"
#include "fill8_c.c"
#include "fillFace.c"
#include "glDrawFaces.c"


#include "zplot_c.c"
#include "lrDrawLine.c"
#include "glDrawSegments.c"

#include "glDrawParticules.c"

#include "buffer2screen.c"



void change_char(char c, unsigned char patt01, unsigned char patt02, unsigned char patt03, unsigned char patt04, unsigned char patt05, unsigned char patt06, unsigned char patt07, unsigned char patt08) {
    unsigned char* adr;
    adr      = (unsigned char*)(0xB400 + c * 8);
    *(adr++) = patt01;
    *(adr++) = patt02;
    *(adr++) = patt03;
    *(adr++) = patt04;
    *(adr++) = patt05;
    *(adr++) = patt06;
    *(adr++) = patt07;
    *(adr++) = patt08;
}


