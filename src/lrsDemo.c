
#include "config.h"
#include "glOric.h"



#ifdef LRSMODE

#include "data\traj.h"
#include "render\zbuffer.h"

 // GEOMETRY BUFFERS
//extern char points3d[];
char points3d[NB_MAX_POINTS*SIZEOF_3DPOINT];
//extern unsigned char nbPts;
unsigned char nbPts=0;

extern unsigned char segments[];
extern unsigned char nbSegments;

//extern char points2d[];
char points2d [NB_MAX_POINTS*SIZEOF_2DPOINT];


unsigned char faces[NB_MAX_FACES*SIZEOF_FACES];
unsigned char nbFaces=0;



void addHouse(signed char X, signed char Y, unsigned char L, unsigned char l){

	unsigned char ii, jj;
	ii = L;
	jj = l;

	points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
	points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
	points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
	nbPts ++;
	points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
	points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
	points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
	nbPts ++;
	points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
	points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - jj;
	points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
	nbPts ++;
	points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
	points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - jj;
	points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
	nbPts ++;

	points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
	points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
	points3d[nbPts * SIZEOF_3DPOINT + 2] = 3;
	nbPts ++;
	points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
	points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
	points3d[nbPts * SIZEOF_3DPOINT + 2] = 3;
	nbPts ++;
	points3d[nbPts* SIZEOF_3DPOINT + 0] = X - ii;
	points3d[nbPts* SIZEOF_3DPOINT + 1] = Y - jj;
	points3d[nbPts* SIZEOF_3DPOINT + 2] = 3;
	nbPts ++;
	points3d[nbPts* SIZEOF_3DPOINT + 0] = X + ii;
	points3d[nbPts* SIZEOF_3DPOINT + 1] = Y - jj;
	points3d[nbPts* SIZEOF_3DPOINT + 2] = 3;
	nbPts ++;

	points3d[nbPts* SIZEOF_3DPOINT + 0] = X + ii;
	points3d[nbPts* SIZEOF_3DPOINT + 1] = Y ;
	points3d[nbPts* SIZEOF_3DPOINT + 2] = 5;
	nbPts ++;
	points3d[nbPts* SIZEOF_3DPOINT + 0] = X - ii;
	points3d[nbPts* SIZEOF_3DPOINT + 1] = Y ;
	points3d[nbPts* SIZEOF_3DPOINT + 2] = 5;
	nbPts ++;

	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-10;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-9;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '-';
	nbSegments ++;

	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-9;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-8;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '-';
	nbSegments ++;

	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-8;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-7;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '-';
	nbSegments ++;


	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-6;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-5;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '-';
	nbSegments ++;


	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-4;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-3;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '-';
	nbSegments ++;


	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-10;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-6;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '|';
	nbSegments ++;


	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-9;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-5;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '|';
	nbSegments ++;

	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-8;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-4;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '|';
	nbSegments ++;

	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-7;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-3;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '|';
	nbSegments ++;

	// ROOF
	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-6;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-2;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '/';
	nbSegments ++;

	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-3;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-2;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '/';
	nbSegments ++;

	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-5;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-1;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '/';
	nbSegments ++;

	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-4;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-1;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '/';
	nbSegments ++;

	segments[nbSegments* SIZEOF_SEGMENT + 0] = nbPts-1;
	segments[nbSegments* SIZEOF_SEGMENT + 1] = nbPts-2;
	segments[nbSegments* SIZEOF_SEGMENT + 2] = '-';
	nbSegments ++;


	faces[nbFaces* SIZEOF_FACES + 0] = nbPts-10; // Index Point 1
	faces[nbFaces* SIZEOF_FACES + 1] = nbPts-9; // Index Point 2
	faces[nbFaces* SIZEOF_FACES + 2] = nbPts-5; // Index Point 3
	faces[nbFaces* SIZEOF_FACES + 3] = ','; // Index Point 3
	nbFaces ++;

	faces[nbFaces* SIZEOF_FACES + 0] = nbPts-10; // Index Point 1
	faces[nbFaces* SIZEOF_FACES + 1] = nbPts-6; // Index Point 2
	faces[nbFaces* SIZEOF_FACES + 2] = nbPts-5; // Index Point 3
	faces[nbFaces* SIZEOF_FACES + 3] = ','; // Index Point 3
	nbFaces ++;


	faces[nbFaces* SIZEOF_FACES + 0] = nbPts-7; // Index Point 1
	faces[nbFaces* SIZEOF_FACES + 1] = nbPts-8; // Index Point 2
	faces[nbFaces* SIZEOF_FACES + 2] = nbPts-4; // Index Point 3
	faces[nbFaces* SIZEOF_FACES + 3] = ','; // Index Point 3
	nbFaces ++;

	faces[nbFaces* SIZEOF_FACES + 0] = nbPts-4; // Index Point 1
	faces[nbFaces* SIZEOF_FACES + 1] = nbPts-7; // Index Point 2
	faces[nbFaces* SIZEOF_FACES + 2] = nbPts-3; // Index Point 3
	faces[nbFaces* SIZEOF_FACES + 3] = ','; // Index Point 3
	nbFaces ++;


		faces[nbFaces* SIZEOF_FACES + 0] = nbPts-9; // Index Point 1
		faces[nbFaces* SIZEOF_FACES + 1] = nbPts-8; // Index Point 2
		faces[nbFaces* SIZEOF_FACES + 2] = nbPts-4; // Index Point 3
		faces[nbFaces* SIZEOF_FACES + 3] = '.'; // Index Point 3
		nbFaces ++;

		faces[nbFaces* SIZEOF_FACES + 0] = nbPts-9; // Index Point 1
		faces[nbFaces* SIZEOF_FACES + 1] = nbPts-4; // Index Point 2
		faces[nbFaces* SIZEOF_FACES + 2] = nbPts-5; // Index Point 3
		faces[nbFaces* SIZEOF_FACES + 3] = '.'; // Index Point 3
		nbFaces ++;


	faces[nbFaces* SIZEOF_FACES + 0] = nbPts-5; // Index Point 1
	faces[nbFaces* SIZEOF_FACES + 1] = nbPts-4; // Index Point 2
	faces[nbFaces* SIZEOF_FACES + 2] = nbPts-1; // Index Point 3
	faces[nbFaces* SIZEOF_FACES + 3] = '.'; // Index Point 3
	nbFaces ++;


	faces[nbFaces* SIZEOF_FACES + 0] = nbPts-6; // Index Point 1
	faces[nbFaces* SIZEOF_FACES + 1] = nbPts-5; // Index Point 2
	faces[nbFaces* SIZEOF_FACES + 2] = nbPts-1; // Index Point 3
	faces[nbFaces* SIZEOF_FACES + 3] = 'u'; // Index Point 3
	nbFaces ++;

	faces[nbFaces* SIZEOF_FACES + 0] = nbPts-6; // Index Point 1
	faces[nbFaces* SIZEOF_FACES + 1] = nbPts-1; // Index Point 2
	faces[nbFaces* SIZEOF_FACES + 2] = nbPts-2; // Index Point 3
	faces[nbFaces* SIZEOF_FACES + 3] = 'u'; // Index Point 3
	nbFaces ++;

	faces[nbFaces* SIZEOF_FACES + 0] = nbPts-3; // Index Point 1
	faces[nbFaces* SIZEOF_FACES + 1] = nbPts-4; // Index Point 2
	faces[nbFaces* SIZEOF_FACES + 2] = nbPts-1; // Index Point 3
	faces[nbFaces* SIZEOF_FACES + 3] = 'u'; // Index Point 3
	nbFaces ++;

	faces[nbFaces* SIZEOF_FACES + 0] = nbPts-3; // Index Point 1
	faces[nbFaces* SIZEOF_FACES + 1] = nbPts-1; // Index Point 2
	faces[nbFaces* SIZEOF_FACES + 2] = nbPts-2; // Index Point 3
	faces[nbFaces* SIZEOF_FACES + 3] = 'u'; // Index Point 3
	nbFaces ++;

//printf ("%d Points, %d Segments, %d Faces\n", nbPts, nbSegments, nbFaces); get();
}



/*void glProject2 (char *tabpoint2D, char *tabpoint3D, unsigned char nbPoints, unsigned char options){
	 int local_var;
	 for (local_var = 0; local_var< nbPoints; local_var++) {
		 tabpoint2D[local_var] = options;
	 }
}*/


void faceIntro() {
    int i;
    int j;
    //get();
    //enterSC();

	CamPosX = 0;
	CamPosY = 0;
	CamPosZ = 2;

 	CamRotZ = 0;
	CamRotX = 0;
  i=0;
  for (j=0;j<64;j++) {
		CamPosX = traj[i++];
		CamPosY = traj[i++];
		CamRotZ = traj[i++];
		i = i % (NB_POINTS_TRAJ*SIZE_POINTS_TRAJ);
		
		glProject (points2d, points3d, nbPts, 0);
		
        initScreenBuffers();
		fillFaces(points2d, faces, nbFaces);
        lrDrawSegments(points2d, segments, nbSegments);
        buffer2screen((void*)ADR_BASE_SCREEN);
		
    }
	//leaveSC();
}

/*
void txtGameLoop2() {

	char key;
    unsigned char ii;
	//key=get();
	glProject (points2d, points3d, nbPts, 0);


    // printf ("(x=%d y=%d z=%d) [%d %d]\n", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
    //     for (ii=0; ii< nbPts; ii++){
    //         printf ("[%d %d %d] => [%d %d] %d \n"
    //         , points3d [ii*SIZEOF_3DPOINT+0], points3d[ii*SIZEOF_3DPOINT+1], points3d[ii*SIZEOF_3DPOINT+2]
    //         , points2d [ii*SIZEOF_2DPOINT+0], points2d [ii*SIZEOF_2DPOINT+1], points2d[ii*SIZEOF_2DPOINT+2]
    //         );
    //     }
    //     get();
    
	initScreenBuffers();
	fillFaces(points2d, faces, nbFaces);
    lrDrawSegments(points2d, segments, nbSegments);
    while (1==1) {
		//clearScreen();
		//drawSegments();
		buffer2screen((void*)ADR_BASE_SCREEN);
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
		glProject (points2d, points3d, nbPts, 0);
		initScreenBuffers();
		fillFaces(points2d, faces, nbFaces);
        lrDrawSegments(points2d, segments, nbSegments);
	}
}
*/
void faceDemo(){
	nbPts =0 ;
	nbSegments =0 ;
    nbFaces =0 ;
	//addCube3(-12, -12, 0);
    //addCube3(0, 0, 0);
    //addPlan();
    //change_char(36, 0x80, 0x40, 020, 0x10, 0x08, 0x04, 0x02, 0x01);
    //addPlan(0, 2, 2, 64, '.');
    //addPlan(2, 0, 2, 0, ':');
    //addPlan(0, -2, 2, 64, ';');
    //addPlan(-2, 0, 2, 0, '\'');

    //addTePee(0, 0, 3);
    addHouse(0, 0, 3, 2);
    //printf ("%d Points, %d Segments, %d Faces\n", nbPts, nbSegments, nbFaces); get();

	lores0();
	faceIntro();

	//txtGameLoop2();

}
#endif