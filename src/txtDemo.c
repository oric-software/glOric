
#include "alphabet.c"


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
