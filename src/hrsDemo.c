
#include "config.h"
#include "glOric.h"

#ifdef HRSMODE


 // GEOMETRY BUFFERS
//extern char points3d[];
char points3d[NB_MAX_POINTS*SIZEOF_3DPOINT];
//extern unsigned char nbPts;
unsigned char nbPts=0;

extern unsigned char segments[];
extern unsigned char nbSegments;

//extern char points2d[];
char points2d [NB_MAX_POINTS*SIZEOF_2DPOINT];


char faces[NB_MAX_FACES*SIZEOF_FACES];
unsigned char nbFaces=0;

void hiresIntro ();


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

void hrDrawFaces(){
	hrDrawFace(points2d, 0, 1, 2, 2);
	hrDrawFace(points2d, 0, 2, 3, 2);
	//hrDrawFace(points2d, 0, 1, 5, 1);
	//hrDrawFace(points2d, 0, 5, 4, 1);
	hrDrawFace(points2d, 4, 5, 6, 0);
	hrDrawFace(points2d, 4, 6, 7, 0);
	
}


void hiresDemo(){
	GenerateTables(); // for line8
    ComputeDivMod(); // for filler
    InitTables();	//for filler

    hires(); 

	nbPts =0 ;
	nbSegments =0 ;
	addCube(-4, -4, 2);
	addCube(4, 4, 10);
	
	hiresIntro();
	
	hiresGameLoop();
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
        glProject (points2d, points3d, nbPts, 0);
        memset ( 0xa000, 64, 8000); // clear screen
		hrDrawSegments(points2d, segments, nbSegments);
		hrDrawFaces();
    }

	leaveSC();

}
void hiresGameLoop() {

	char key;
	unsigned char i=0;
	key=get();
	glProject (points2d, points3d, nbPts, 0); 

    while (1==1) {
		memset ( 0xa000, 64, 8000); // clear screen
		hrDrawSegments(points2d, segments, nbSegments);
		hrDrawFaces();
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

		glProject (points2d, points3d, nbPts, 0);
	}
}

#endif