
#include "config.h"
#include "glOric.h"

#ifdef USE_HIRES_RASTER
extern unsigned int CurrentPattern;

//
// ====== Filler.s ==========

extern unsigned char X0;
extern unsigned char Y0;
extern unsigned char X1;
extern unsigned char Y1;

extern unsigned char OtherPixelX, OtherPixelY, CurrentPixelX, CurrentPixelY;
#endif // USE_HIRES_RASTER

#ifdef HRSDEMO

void hrDrawSegments(char p2d[], unsigned char segments[], unsigned char nbSegments) {
    unsigned char ii = 0;
    unsigned char idxPt1, idxPt2;
    for (ii = 0; ii < nbSegments; ii++) {
        idxPt1 = segments[ii * SIZEOF_SEGMENT + 0];
        idxPt2 = segments[ii * SIZEOF_SEGMENT + 1];
        //char2Display =      segments[ii*SIZEOF_SEGMENT + 2];

        OtherPixelX   = p2d[idxPt1 * SIZEOF_2DPOINT + 0];
        OtherPixelY   = p2d[idxPt1 * SIZEOF_2DPOINT + 2];
        CurrentPixelX = p2d[idxPt2 * SIZEOF_2DPOINT + 0];
        CurrentPixelY = p2d[idxPt2 * SIZEOF_2DPOINT + 2];
        if ((OtherPixelX > 0) && (OtherPixelX < 240) && (CurrentPixelY > 0) && (CurrentPixelY < 200)) {
            DrawLine8();
        }
    }
}

#ifdef USE_HIRES_RASTER
void AddTriangle(unsigned char x0, unsigned char y0, unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2, unsigned char pattern) {
    X0 = x0;
    Y0 = y0;
    X1 = x1;
    Y1 = y1;
    AddLineASM();
    X0 = x0;
    Y0 = y0;
    X1 = x2;
    Y1 = y2;
    AddLineASM();
    X0 = x2;
    Y0 = y2;
    X1 = x1;
    Y1 = y1;
    AddLineASM();

    CurrentPattern = pattern << 3;
    FillTablesASM();
}

void hrDrawFace(char p2d[], unsigned char idxPt1, unsigned char idxPt2, unsigned char idxPt3, unsigned char pattern) {
    AddTriangle(
        p2d[idxPt1 * SIZEOF_2DPOINT + 0], p2d[idxPt1 * SIZEOF_2DPOINT + 2],
        p2d[idxPt2 * SIZEOF_2DPOINT + 0], p2d[idxPt2 * SIZEOF_2DPOINT + 2],
        p2d[idxPt3 * SIZEOF_2DPOINT + 0], p2d[idxPt3 * SIZEOF_2DPOINT + 2],
        (pattern & 3));
}

#endif // USE_HIRES_RASTER
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
        glProject (points2d, points3d, nbPts, 0);
        //memset ( 0xa000, 64, 8000); // clear screen
		hrDrawSegments2();
		//hrDrawFaces();
    }

	//leaveSC();

}
*/

#endif // HRSDEMO