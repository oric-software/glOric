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

const char sentence[] = "MERCI RENE";

void addData(const char *tPoint, unsigned char nPoint, const char *tSeg, unsigned char nSeg, char offsetPos){
	unsigned char jj;
	for (jj=0; jj < nPoint; jj++){
		points3d[(nbPts+jj)* SIZEOF_3DPOINT + 0] = tPoint[jj*SIZEOF_3DPOINT + 0] + offsetPos*8;  // X coord
		points3d[(nbPts+jj)* SIZEOF_3DPOINT + 1] = tPoint[jj*SIZEOF_3DPOINT + 1];                // Y coord
		points3d[(nbPts+jj)* SIZEOF_3DPOINT + 2] = tPoint[jj*SIZEOF_3DPOINT + 2];                // Z coord
	}
	for (jj=0; jj < nSeg; jj++){
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 0] = tSeg[jj*SIZEOF_SEGMENT + 0]+nbPts; // Index Point 1
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 1] = tSeg[jj*SIZEOF_SEGMENT + 1]+nbPts; // Index Point 2
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 2] = tSeg[jj*SIZEOF_SEGMENT + 2]; // Character
	}
	nbPts += nPoint;
	nbSegments += nSeg;

}

void initBuffers(){
	unsigned char ii;
	char c;
	ii = 0;
	nbPts = 0;
	while((c=sentence[ii]) != 0) {

		switch (c) {
			case 'M':addData(ptsM, NB_POINTS_M, segM, NB_SEGMENTS_M, ii);break;
			case 'C':addData(ptsC, NB_POINTS_C, segC, NB_SEGMENTS_C, ii);break;
			case 'I':addData(ptsI, NB_POINTS_I, segI, NB_SEGMENTS_I, ii);break;
			case 'R':addData(ptsR, NB_POINTS_R, segR, NB_SEGMENTS_R, ii);break;
			case 'E':addData(ptsE, NB_POINTS_E, segE, NB_SEGMENTS_E, ii);break;
			case 'N':addData(ptsN, NB_POINTS_N, segN, NB_SEGMENTS_N, ii);break;
			default:
				break;
		}
		ii++;
	}
}

void addCube(char X, char Y, char Z){
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
	nbPts += NB_POINTS_CUBE;
	nbSegments += NB_SEGMENTS_CUBE;
}

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

void forward() {
	if (-112 >= CamRotZ) {
		CamPosX--;
	} else if ((-112 < CamRotZ) && (-80 >= CamRotZ)){
		CamPosX--; CamPosY--;
	} else if (( -80 < CamRotZ) && (-48 >= CamRotZ)){
		CamPosY--;
	} else if (( -48 < CamRotZ) && (-16 >= CamRotZ)){
		CamPosX++; CamPosY--;
	} else if (( -16 < CamRotZ) && ( 16 >= CamRotZ)){
		CamPosX++;
	} else if ((  16 < CamRotZ) && ( 48 >= CamRotZ)){
		CamPosX++; CamPosY++;
	} else if ((  48 < CamRotZ) && ( 80 >= CamRotZ)){
		CamPosY++;
	} else if ((  80 < CamRotZ) && (112 >= CamRotZ)){
		CamPosX--; CamPosY++;
	} else {
		CamPosX--;
	}
}
void backward() {
	if (-112 >= CamRotZ) {
		CamPosX++;
	} else if ((-112 < CamRotZ) && (-80 >= CamRotZ)){
		CamPosX++; CamPosY++;
	} else if (( -80 < CamRotZ) && (-48 >= CamRotZ)){
		CamPosY++;
	} else if (( -48 < CamRotZ) && (-16 >= CamRotZ)){
		CamPosX--; CamPosY++;
	} else if (( -16 < CamRotZ) && ( 16 >= CamRotZ)){
		CamPosX--;
	} else if ((  16 < CamRotZ) && ( 48 >= CamRotZ)){
		CamPosX--; CamPosY--;
	} else if ((  48 < CamRotZ) && ( 80 >= CamRotZ)){
		CamPosY--;
	} else if ((  80 < CamRotZ) && (112 >= CamRotZ)){
		CamPosX++; CamPosY--;
	} else {
		CamPosX++;
	}

}
void shiftLeft() {
	if (-112 >= CamRotZ) {
		CamPosY--;
	} else if ((-112 < CamRotZ) && (-80 >= CamRotZ)){
		CamPosX++; CamPosY--;
	} else if (( -80 < CamRotZ) && (-48 >= CamRotZ)){
		CamPosX--;
	} else if (( -48 < CamRotZ) && (-16 >= CamRotZ)){
		CamPosX++; CamPosY++;
	} else if (( -16 < CamRotZ) && ( 16 >= CamRotZ)){
		CamPosY++;
	} else if ((  16 < CamRotZ) && ( 48 >= CamRotZ)){
		CamPosX--; CamPosY++;
	} else if ((  48 < CamRotZ) && ( 80 >= CamRotZ)){
		CamPosX--;
	} else if ((  80 < CamRotZ) && (112 >= CamRotZ)){
		CamPosX--; CamPosY--;
	} else {
		CamPosY--;
	}
}
void shiftRight() {
	if (-112 >= CamRotZ) {
		CamPosY++;
	} else if ((-112 < CamRotZ) && (-80 >= CamRotZ)){
		CamPosX--; CamPosY++;
	} else if (( -80 < CamRotZ) && (-48 >= CamRotZ)){
		CamPosX++;
	} else if (( -48 < CamRotZ) && (-16 >= CamRotZ)){
		CamPosX--; CamPosY--;
	} else if (( -16 < CamRotZ) && ( 16 >= CamRotZ)){
		CamPosY--;
	} else if ((  16 < CamRotZ) && ( 48 >= CamRotZ)){
		CamPosX++; CamPosY--;
	} else if ((  48 < CamRotZ) && ( 80 >= CamRotZ)){
		CamPosX++;
	} else if ((  80 < CamRotZ) && (112 >= CamRotZ)){
		CamPosX++; CamPosY++;
	} else {
		CamPosX++;
	}
}

void hrDrawSegments(){
	unsigned char ii = 0;
	unsigned char idxPt1, idxPt2;
	for (ii = 0; ii< nbSegments; ii++){

		idxPt1 =            segments[ii*SIZEOF_SEGMENT + 0];
		idxPt2 =            segments[ii*SIZEOF_SEGMENT + 1];
		char2Display =      segments[ii*SIZEOF_SEGMENT + 2];

        OtherPixelX=points2d[idxPt1*SIZEOF_2DPOINT + 0];
        OtherPixelY=points2d[idxPt1*SIZEOF_2DPOINT + 1];
        CurrentPixelX=points2d[idxPt2*SIZEOF_2DPOINT + 0];
        CurrentPixelY=points2d[idxPt2*SIZEOF_2DPOINT + 1];
		if ((OtherPixelX >0 ) && (OtherPixelX <240 ) && (CurrentPixelY>0) && (CurrentPixelY<200)) {
			DrawLine8();
		}
	}
}
void txtIntro (){
    int i;

    enterSC();

	CamPosX = -15;
	CamPosY = -85;
	CamPosZ = 2;

 	CamRotZ = 64 ;			// -128 -> -127 unit : 2PI/(2^8 - 1)
	CamRotX = -4;


    glProject (points2d, points3d, nbPts);
	clearScreen(); 

    drawSegments();
	
    for (i=0;i<40;i++,
			CamPosX=(i%4==0)?CamPosX+1:CamPosX,
			CamPosY+=2,
			CamRotZ-=1,
			CamRotX=(i%2==0)?CamRotX+1:CamRotX
		) {
        glProject (points2d, points3d, nbPts); 
        clearScreen();
		drawSegments();
    }

	CamPosX = -5;
	CamPosY = -5;
	CamPosZ = 2;
	CamRotZ = 24 ;			// -128 -> -127 unit : 2PI/(2^8 - 1)
	CamRotX = 16;

    for (i=0;i<72;i++,CamPosX++) {
        glProject (points2d, points3d, nbPts);
        clearScreen();
		drawSegments();             
    }

    for (i=0;i<40;i++,CamPosX=(i%4==0)?CamPosX-1:CamPosX, CamRotX=(i%4==0)?CamRotX-1:CamRotX , CamPosY=(i%4==0)?CamPosY-1:CamPosY,  CamRotZ++) {

        glProject (points2d, points3d, nbPts); 
        clearScreen();
		drawSegments();
    }
    forward ();
	glProject (points2d, points3d, nbPts); 
	clearScreen();
	drawSegments();

    for (i=0;i<25;i++, CamPosX-=2) {

        glProject (points2d, points3d, nbPts);
        clearScreen();
		drawSegments();
    }
	CamRotZ-=1;
    for (i=0;i<11;i++, CamPosY-=2, CamRotZ-=3) {

        glProject (points2d, points3d, nbPts);
        clearScreen();
		drawSegments();
    }
	CamRotZ-=3;
	glProject (points2d, points3d, nbPts); 
	clearScreen();
	drawSegments();

    leaveSC();
}

void txtGameLoop() {

	char key;
	//key=get();
	glProject (points2d, points3d, nbPts);

    while (1==1) {
		clearScreen();
		drawSegments();
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
	}
}


void textDemo(){
	
	lores0();

    //kernelInit();
	initBuffers();

 // Camera Position
	CamPosX = -14;
	CamPosY = -87;
	CamPosZ = 2;

 // Camera Orientation
	CamRotZ = 64 ;			// -128 -> -127 unit : 2PI/(2^8 - 1)
	CamRotX = 0;

    txtIntro ();

 	txtGameLoop();
}


void hiresIntro (){
    int i;

    enterSC();

	CamPosX = -24;
	CamPosY = 0;
	CamPosZ = 3;

 	CamRotZ = 64 ;			// -128 -> -127 unit : 2PI/(2^8 - 1)
	CamRotX = 2;

    for (i=0;i<120;) {
		CamPosX = traj[i++];
		CamPosY = traj[i++];
		CamRotZ = traj[i++];
		i = i % (NB_POINTS_TRAJ*SIZE_POINTS_TRAJ);
        glProject (points2d, points3d, nbPts);
        memset ( 0xa000, 64, 8000); // clear screen
		hrDrawSegments();
    }

	leaveSC();

}
void hiresGameLoop() {

	char key;
	unsigned char i=0;
	key=get();
	glProject (points2d, points3d, nbPts); 

    while (1==1) {
		memset ( 0xa000, 64, 8000); // clear screen
		hrDrawSegments();
		key=get();
		switch (key)	// key
		{
		case 8:	// gauche => tourne gauche
			i = (i+3)%(192);
			break;
		case 9:	// droite => tourne droite
			if (i == 0) i=192-3;
			i = (i-3);
			break;
		case 80: // P
			if (CamPosZ < 5) {
				CamPosZ += 1;
			}
			break;
		case 59: // ;
			if (CamPosZ > 0) {
				CamPosZ -= 1;
			}
			break;
		}
		CamPosX = traj[i+0];
		CamPosY = traj[i+1];
		CamRotZ = traj[i+2];

		glProject (points2d, points3d, nbPts);
	}
}

void hiresDemo(){
	GenerateTables();

    hires(); 

	nbPts =0 ;
	nbSegments =0 ;
	addCube(-4, -4, 2);
	addCube(4, 4, 10);
	
	hiresIntro();
	
	nbPts =0 ;
	nbSegments =0 ;
	addCube(0, 0, 2);
	
//	for (jj=0; jj < NB_POINTS_CUBE; jj++){
	points3d[(nbPts)* SIZEOF_3DPOINT + 0] = 0;  				// X coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 1] = 0;                // Y coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 2] = 6;                // Z coord
	nbPts ++;
	points3d[(nbPts)* SIZEOF_3DPOINT + 0] = -3;  				// X coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 1] = 0;                // Y coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 2] = 7;                // Z coord
	nbPts ++;
	points3d[(nbPts)* SIZEOF_3DPOINT + 0] = -1;  				// X coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 1] = 0;                // Y coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 2] = 9;                // Z coord
	nbPts ++;
	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-3; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-2; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;
	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-2; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-1; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;
	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-1; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-3; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;

	points3d[(nbPts)* SIZEOF_3DPOINT + 0] = 3;  				// X coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 1] = 0;                // Y coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 2] = 7;                // Z coord
	nbPts ++;
	points3d[(nbPts)* SIZEOF_3DPOINT + 0] = 1;  				// X coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 1] = 0;                // Y coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 2] = 9;                // Z coord
	nbPts ++;

	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-5; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-2; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;
	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-2; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-1; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;
	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-1; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-5; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;


	points3d[(nbPts)* SIZEOF_3DPOINT + 0] = -4;  				// X coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 1] = 0;                // Y coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 2] = 6;                // Z coord
	nbPts ++;
	points3d[(nbPts)* SIZEOF_3DPOINT + 0] = 4;  				// X coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 1] = 0;                // Y coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 2] = 6;                // Z coord
	nbPts ++;

	points3d[(nbPts)* SIZEOF_3DPOINT + 0] = 4;  				// X coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 1] = 0;                // Y coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 2] = -2;                // Z coord
	nbPts ++;
	points3d[(nbPts)* SIZEOF_3DPOINT + 0] = -4;  				// X coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 1] = 0;                // Y coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 2] = -2;                // Z coord
	nbPts ++;

	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-4; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-3; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;
	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-3; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-2; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;
	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-2; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-1; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;
	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-1; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-4; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;


	points3d[(nbPts)* SIZEOF_3DPOINT + 0] = 0;  				// X coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 1] = -4;                // Y coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 2] = 6;                // Z coord
	nbPts ++;
	points3d[(nbPts)* SIZEOF_3DPOINT + 0] = 0;  				// X coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 1] = 4;                // Y coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 2] = 6;                // Z coord
	nbPts ++;

	points3d[(nbPts)* SIZEOF_3DPOINT + 0] = 0;  				// X coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 1] = 4;                // Y coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 2] = -2;                // Z coord
	nbPts ++;
	points3d[(nbPts)* SIZEOF_3DPOINT + 0] = 0;  				// X coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 1] = -4;                // Y coord
	points3d[(nbPts)* SIZEOF_3DPOINT + 2] = -2;                // Z coord
	nbPts ++;

	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-4; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-3; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;
	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-3; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-2; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;
	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-2; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-1; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;
	segments[(nbSegments)* SIZEOF_SEGMENT + 0] = nbPts-1; // Index Point 1
	segments[(nbSegments)* SIZEOF_SEGMENT + 1] = nbPts-4; // Index Point 2
	segments[(nbSegments)* SIZEOF_SEGMENT + 2] = 65; // Character
	nbSegments ++;
	

	glProject (points2d, points3d, nbPts); //doFastProjection();
	memset ( 0xa000, 64, 8000);
	hrDrawSegments();

	hiresGameLoop();
}


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
