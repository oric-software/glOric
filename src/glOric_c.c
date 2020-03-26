
#include "config.h"

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


#ifdef USE_C_ARRAYSPROJECT
void glProjectArrays(){
    unsigned char ii;
    signed char x, y, z;
    signed char ah, av;
    unsigned int dist ;
    unsigned char options=0;

    for (ii = 0; ii < nbPoints; ii++){
        x = points3dX[ii];
        y = points3dY[ii];
        z = points3dZ[ii];

        projectPoint(x, y, z, options, &ah, &av, &dist);

        points2aH[ii] = ah;
        points2aV[ii] = av;
        points2dH[ii] = (signed char)((dist & 0xFF00)>>8) && 0x00FF;
        points2dL[ii] = (signed char) (dist & 0x00FF);

    }
}
#endif // USE_C_ARRAYSPROJECT

#include "retrieveFaceData.c"
#include "sortPoints.c"
#include "guessIfFace2BeDrawn.c"
#include "angle2screen.c"
#include "prepareBresrun.c"
#include "isA1Right.c"
#include "satur.c"
#include "agent.c"
#include "reachScreen.c"
#include "hzfill.c"
#include "fill8_bis.c"
#include "fill8.c"
#include "fillFace.c"
#include "glDrawFaces.c"

