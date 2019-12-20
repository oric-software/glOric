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
extern char points3d[];
extern unsigned char nbPoints;

extern char segments[];
extern unsigned char nbSegments;

extern char points2d[];


const char sentence[] = "MERCI RENE";

void addData(const char *tPoint, unsigned char nPoint, const char *tSeg, unsigned char nSeg, char offsetPos){
	unsigned char jj;
	for (jj=0; jj < nPoint; jj++){
		points3d[(nbPoints+jj)* SIZEOF_3DPOINT + 0] = tPoint[jj*SIZEOF_3DPOINT + 0] + offsetPos*8;  // X coord
		points3d[(nbPoints+jj)* SIZEOF_3DPOINT + 1] = tPoint[jj*SIZEOF_3DPOINT + 1];                // Y coord
		points3d[(nbPoints+jj)* SIZEOF_3DPOINT + 2] = tPoint[jj*SIZEOF_3DPOINT + 2];                // Z coord
	}
	for (jj=0; jj < nSeg; jj++){
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 0] = tSeg[jj*SIZEOF_SEGMENT + 0]+nbPoints; // Index Point 1
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 1] = tSeg[jj*SIZEOF_SEGMENT + 1]+nbPoints; // Index Point 2
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 2] = tSeg[jj*SIZEOF_SEGMENT + 2]; // Character
	}
	nbPoints += nPoint;
	nbSegments += nSeg;

}

void initBuffers(){
	unsigned char ii, jj;
	char c;
	unsigned char nPoint, nSeg;
	const char *tPoint, *tSeg;
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
		points3d[(nbPoints+jj)* SIZEOF_3DPOINT + 0] = ptsCube[jj*SIZEOF_3DPOINT + 0] + X;  				// X coord
		points3d[(nbPoints+jj)* SIZEOF_3DPOINT + 1] = ptsCube[jj*SIZEOF_3DPOINT + 1] + Y;                // Y coord
		points3d[(nbPoints+jj)* SIZEOF_3DPOINT + 2] = ptsCube[jj*SIZEOF_3DPOINT + 2] + Z;                // Z coord
	}
	for (jj=0; jj < NB_SEGMENTS_CUBE; jj++){
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 0] = segCube[jj*SIZEOF_SEGMENT + 0]+nbPoints; // Index Point 1
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 1] = segCube[jj*SIZEOF_SEGMENT + 1]+nbPoints; // Index Point 2
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 2] = segCube[jj*SIZEOF_SEGMENT + 2]; // Character
	}
	nbPoints += NB_POINTS_CUBE;
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
	for (ii = 0; ii< nbPoints; ii++){
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

void gameLoop() {

	char key;
	key=get();
	doFastProjection();

    while (1==1) {
#ifdef TEXTMODE
		cls(); gotoxy(26, 40);//clearScreen();
		drawSegments();
		dispInfo();
#else
		hires(); // memset de 8000 octets en a000 avec la valeur 64
		hrDrawSegments();
#endif

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
		doFastProjection();
	}
}


void intro (){
    int i;

    enterSC();


	CamPosX = -15;
	CamPosY = -85;
	CamPosZ = 2;

 	CamRotZ = 64 ;			// -128 -> -127 unit : 2PI/(2^8 - 1)
	CamRotX = -4;


    doFastProjection();
    cls() ; //gotoxy(26, 40);
    drawSegments();

    for (i=0;i<40;i++,
			CamPosX=(i%4==0)?CamPosX+1:CamPosX,
			CamPosY+=2,
			CamRotZ-=1,
			CamRotX=(i%2==0)?CamRotX+1:CamRotX
		) {

        doFastProjection();
        cls() ; //gotoxy(26, 40);
		drawSegments();
 		//dispInfo();
    }

	CamPosX = -5;
	CamPosY = -5;
	CamPosZ = 2;
	CamRotZ = 24 ;			// -128 -> -127 unit : 2PI/(2^8 - 1)
	CamRotX = 16;

    for (i=0;i<72;i++,CamPosX++) {

        doFastProjection();             // 25  s => 20s         => 15s
        cls (); // gotoxy(26, 40);// clearScreen();   //  1.51 s => 23s (3s)
		drawSegments();             // 11.5 s  => 34s (11s)
		//dispInfo();
    }

    for (i=0;i<40;i++,CamPosX=(i%4==0)?CamPosX-1:CamPosX, CamRotX=(i%4==0)?CamRotX-1:CamRotX , CamPosY=(i%4==0)?CamPosY-1:CamPosY,  CamRotZ++) {

        doFastProjection();
        cls() ; //gotoxy(26, 40);
		drawSegments();
 		//dispInfo();
    }
    forward ();
	doFastProjection();
	cls() ; //gotoxy(26, 40);
	drawSegments();
	// dispInfo();


    for (i=0;i<25;i++, CamPosX-=2) {

        doFastProjection();
        cls() ; //gotoxy(26, 40);
		drawSegments();
 		//dispInfo();
    }
	CamRotZ-=1;
    for (i=0;i<11;i++, CamPosY-=2, CamRotZ-=3) {

        doFastProjection();
        cls() ; //gotoxy(26, 40);
		drawSegments();
 		// dispInfo();
    }
	CamRotZ-=3;
	doFastProjection();
	cls() ; // gotoxy(26, 40);
	drawSegments();
	//dispInfo();
    leaveSC();
}


void textDemo(){
	text();
    //kernelInit();
	initBuffers();

 // Camera Position
	CamPosX = -14;
	CamPosY = -87;
	CamPosZ = 2;

 // Camera Orientation
	CamRotZ = 64 ;			// -128 -> -127 unit : 2PI/(2^8 - 1)
	CamRotX = 0;

	//get ();

    clearScreen();
    //curset(36, 40, 0);
	gotoxy(26, 40);


    get ();
    intro ();

 	gameLoop();


}



void hrIntro (){
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
        doFastProjection();
        hires(); //memset de 8000 octets en a000 avec la valeur 64
		hrDrawSegments();
 		//dispInfo();
    }



	leaveSC();

}
void hiresDemo(){
	GenerateTables();
	nbPoints =0 ;

    hires(); // memset de 8000 octets en a000 avec la valeur 64


	nbSegments =0 ;
	addCube(-4, -4, 2);
	addCube(4, 4, 10);

	hrIntro();

	CamPosX = -20;
	CamPosY = -20;
	CamPosZ = 2;
	CamRotZ = 32 ;			// -128 -> -127 unit : 2PI/(2^8 - 1)
	CamRotX = 3;
	shiftRight();
	shiftRight();
	doFastProjection();
	hires(); //memset de 8000 octets en a000 avec la valeur 64
	hrDrawSegments();

	gameLoop();
}

int proto (unsigned char nbPoints, char *tabpoint3D, char *tabpoint2D){
	int local_var;
	local_var = nbPoints+1;

	return local_var;
}
char tab1[]={1, 2};

char tab2[]={3, 4};

void main()
{

	char * adrN, *adrSquare;
    int i, j;
	
	get ();
	
	
/*	
#ifdef TEXTMODE
	textDemo();
#else
	hiresDemo();
#endif
*/
	//i=12;
	//j= proto(i, tab1, tab2);


	DeltaX = 3;
	DeltaY = 4;
	hyperfastnorm();
	printf ("norm (%d, %d) = %d ",DeltaX, DeltaY, Norm);

    // TEST OF FAST ATAN2
	/*
	tx=-16; ty=-1; res=0; fastatan2(); printf("ERR atan(%d, %d)= %d\n",tx,ty,res);
*/
    // TEST OF DRAWLINE
    /*
	get();
	Point1X = -10;
    Point1Y = -10;
    Point2X = 30;
    Point2Y = 20;
    drawLine ();
    */
    // TEST OF PROJECT

	/* CamPosX = 0;
	CamPosY = 0;
	CamPosZ = 1;

	CamRotZ = 0;
	CamRotX = 0;

	PointX = 4;
	PointY = -2;
	PointZ = 0;


	printf("PointX %d - %d CamX\n", PointX, CamPosX);
	printf("PointY %d - %d CamY\n", PointY, CamPosY);
	printf("PointZ %d - %d CamZ\n", PointZ, CamPosZ);


	project();
	printf("DeltaX = %d, %d =DeltaY\n", DeltaX, DeltaY);
	printf(" AngleH = %d, Norm = %d, AngleV =%d\n", AngleH, Norm, AngleV);
	printf(" ResX = %d, ResY = %d\n", ResX, ResY);
    */


 /*
    // TEST OF SQUARE 8
	Numberl = 0x04;
	Numberh = 0x00;

    Squarel = 0;
    Squareh = 0;

	Square8 ();
	printf("square of  = %d is %d \n", Numberh *256  + Numberl, Squareh*256 +Squarel);

    adrSquare = (char*)&square;

    *(adrSquare+0) = Squarel;
    *(adrSquare+1) = Squareh;
    sqrt_16 ();

	printf("root of  %d is %d \n", square, thesqrt);
*/


/*
    // TEST OF SQUARE ROOT 24

	square = 16;
	sqrt24();
	printf("square root of  = %d is %d \n", square, thesqrt);

    // TEST OF SQUARE 16
	Numberl = 4;
	Numberh = 2;

    Square1 = 0;
    Square2 = 0;
    Square3 = 0;
    Square4 = 0;

	Square16 ();
	printf("square of  = %d is %d  %d %d %d\n", Numberh *256  + Numberl, Square1, Square2, Square3, Square4);


    // TEST OF DIV 32 BY 16
	adrN = &N;
	*(adrN+0) = 4; // Divisor LO
	*(adrN+1) = 0; // Divisor HI
	*(adrN+2) = 1; // Dividend HIL ==> REMAINDER LO
	*(adrN+3) = 0; // Divisor HIH ==> REMAINDER HI
	*(adrN+4) = 0; // Divisor LOL ==> QUOTIENT LO
	*(adrN+5) = 0; // Divisor LOH ==> QUOTIENT HI
	printf("[%d, %d, %d, %d] divided by [%d,  %d]", *(adrN+3), *(adrN+2), *(adrN+5), *(adrN+4), *(adrN+1), *(adrN+0));
	div32by16();
	printf(" is [%d, %d] remaining [%d, %d]\n", *(adrN+5), *(adrN+4), *(adrN+3), *(adrN+2));

    */
}
