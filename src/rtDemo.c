

#include "config.h"
#include "glOric.h"

#ifdef TARGET_ORIX
#include <conio.h>
#include <stdio.h>
#endif

#ifdef RTDEMO

#include "data\geom.h"
#include "data\traj.h"
#include "render\lrsDrawing.h"
#include "render\zbuffer.h"
#include "util\util.h"

/*
  * GEOMETRY BUFFERS
  */

#ifdef USE_REWORKED_BUFFERS
extern unsigned char nbPoints;
extern signed char points3dX[];
extern signed char points3dY[];
extern signed char points3dZ[];

extern signed char points2aH[];
extern signed char points2aV[];
extern signed char points2dH[];
extern signed char points2dL[];
#else
char                 points3d[NB_MAX_POINTS * SIZEOF_3DPOINT];
unsigned char        nbPts = 0;
char                 points2d[NB_MAX_POINTS * SIZEOF_2DPOINT];

#endif // USE_REWORKED_BUFFERS

extern unsigned char faces[];
extern unsigned char nbFaces ;
extern unsigned char segments[];
extern unsigned char nbSegments;
extern unsigned char particules[];
extern unsigned char nbParticules;

extern char KeyBank[8];
extern char oldKeyBank[8];

void rtIntro();
void rtGameLoop();

char status_string[50];

#ifdef TARGET_ORIX
extern void backward();
extern void forward();
extern void shiftLeft();
extern void shiftRight();
#endif



void dispInfo() {
    sprintf(status_string, "(X=%d Y=%d Z=%d) [%d %d]", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
#ifdef TARGET_ORIX
#else
    AdvancedPrint(3, 0, status_string);
#endif  // TARGET_ORIX
}


#ifdef USE_REWORKED_BUFFERS
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
#endif // USE_REWORKED_BUFFERS

void rtDemo() {

    change_char(36, 0x80, 0x40, 020, 0x10, 0x08, 0x04, 0x02, 0x01);

#ifdef USE_REWORKED_BUFFERS
    nbPoints     = 0;
#else
    nbPts        = 0;
#endif
    nbSegments   = 0;
    nbFaces      = 0;
    nbParticules = 0;

    // addHouse(0, 0, 12, 8);
    // addPlan(0, 6, 6, 64, 'r');
    // addPlan(0, -6, 6, 64, 'b');
    // addPlan(6, 0, 6, 0, 'y');
    // addPlan(-6, 0, 6, 0, 'g');
    // addGeom(0, 0, 0, 3, 3, 3, 1, geomTriangle);
    // addGeom(4, 4, 3, 3, 3, 3, 0, geomRectangle);
    addGeom(0, 0, 0, 12, 8, 4, 0, geomHouse);
    // printf ("%d Points, %d Particules, %d Segments, %d Faces\n", nbPts, nbParticules, nbSegments, nbFaces); get();

    memset (oldKeyBank,0,8);
    memset (KeyBank,0,8);

#ifdef TARGET_ORIX
#else
    text();
#endif  // TARGET_ORIX
#ifdef USE_COLOR
    initColors();
    // memcpy(fbuffer, (void*)ADR_BASE_LORES_SCREEN , SCREEN_HEIGHT* SCREEN_WIDTH);
#endif
    rtIntro();
    // CamPosX = -7;
    // CamPosY = 4;
    // CamPosZ = 3;

    // CamRotZ = -127;
    // CamRotX = 0;

    rtGameLoop();
}

void rtIntro() {
    int i, j;
    int dur;
#ifdef TARGET_ORIX
    // cgetc();
#else
    //get();
    // enterSC();
#endif  // TARGET_ORIX

    CamPosX = 0;
    CamPosY = 0;
    CamPosZ = 3;

    CamRotZ = 0;
    CamRotX = 0;
    i       = 0;
    
    for (j = 0; j < 32; j++) {
        CamPosX = traj[i++];
        CamPosY = traj[i++];
        CamRotZ = traj[i++];
        i       = i % (NB_POINTS_TRAJ * SIZE_POINTS_TRAJ);

        // dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, nbPts, 0);
#endif
        // dur = dur - deek(0x276); printf ("dur glProject = %d \n", dur); get();

        // dur = deek(0x276);
        initScreenBuffers();
        // dur = dur - deek(0x276);
        // printf ("dur initScreenBuffers = %d \n", dur);

        // dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glDrawFaces();
#else
        lrDrawFaces(points2d, faces, nbFaces);
#endif //USE_REWORKED_BUFFERS
        // dur = dur - deek(0x276);
        // printf ("dur lrDrawFaces = %d \n", dur);

        // dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        lrDrawSegments(points2d, segments, nbSegments);
#endif //USE_REWORKED_BUFFERS
        // dur = dur - deek(0x276);
        // printf ("dur lrDrawSegments = %d \n", dur);

        // dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glDrawParticules();
#else
        lrDrawParticules(points2d, particules, nbParticules);
#endif //USE_REWORKED_BUFFERS

        // dur = dur - deek(0x276);
        // printf ("dur lrDrawParticules = %d \n", dur);
        // get();
        // dur = deek(0x276);
        buffer2screen((void*)ADR_BASE_LORES_SCREEN);
        // dur = dur - deek(0x276);
        // printf ("dur buffer2screen = %d \n", dur);
        // get();
    }
#ifdef TARGET_ORIX
#else
    // leaveSC();
#endif  // TARGET_ORIX
}


void rtGameLoop() {
    char          key;
    unsigned char ii;
    int dur;

    kernelInit();

    // dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, nbPts, 0);
#endif
    // dur = dur - deek(0x276);printf ("dur glProject = %d \n", dur);dur = deek(0x276);

    // printf ("(x=%d y=%d z=%d) [%d %d]\n", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
    //     for (ii=0; ii< nbPts; ii++){
    //         printf ("[%d %d %d] => [%d %d] %d \n"
    //         , points3d [ii*SIZEOF_3DPOINT+0], points3d[ii*SIZEOF_3DPOINT+1], points3d[ii*SIZEOF_3DPOINT+2]
    //         , points2d [ii*SIZEOF_2DPOINT+0], points2d [ii*SIZEOF_2DPOINT+1], points2d[ii*SIZEOF_2DPOINT+2]
    //         );
    //     }
    //     get();

    initScreenBuffers();
    // dur = dur - deek(0x276);printf ("dur initScreenBuffers = %d \n", dur);dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glDrawFaces();
#else
        lrDrawFaces(points2d, faces, nbFaces);
#endif //USE_REWORKED_BUFFERS
    // dur = dur - deek(0x276);printf ("dur lrDrawFaces = %d \n", dur);dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        lrDrawSegments(points2d, segments, nbSegments);
#endif //USE_REWORKED_BUFFERS
    // dur = dur - deek(0x276);printf ("dur lrDrawSegments = %d \n", dur);dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glDrawParticules();
#else
        lrDrawParticules(points2d, particules, nbParticules);
#endif //USE_REWORKED_BUFFERS
    // dur = dur - deek(0x276);printf ("dur lrDrawParticules = %d \n", dur);dur = deek(0x276);
    // get();
    while (1 == 1) {
        keyEvent();
        // dur = deek(0x276);
        buffer2screen((void*)ADR_BASE_LORES_SCREEN);
        // dur = dur - deek(0x276);printf ("dur buffer2screen = %d \n", dur);dur = deek(0x276);
        dispInfo();
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, nbPts, 0);
#endif
        initScreenBuffers();
#ifdef USE_REWORKED_BUFFERS
        glDrawFaces();
        glDrawSegments();
        glDrawParticules();
#else
        lrDrawFaces(points2d, faces, nbFaces);
        lrDrawSegments(points2d, segments, nbSegments);
        lrDrawParticules(points2d, particules, nbParticules);
 #endif //USE_REWORKED_BUFFERS
       
    }
}

void move(char key) {
    switch (key) {
        case 8:  // gauche => tourne gauche
            CamRotZ += 4;
            break;
        case 9:  // droite => tourne droite
            CamRotZ -= 4;
            break;
        case 10:  // bas => recule
            backward();
            break;
        case 11:  // haut => avance
            forward();
            break;
        case 80:  // P
            CamPosZ += 1;
            break;
        case 59:  // ;
            CamPosZ -= 1;
            break;
        case 81:  // Q
            CamRotX += 2;
            break;
        case 65:  // A
            CamRotX -= 2;
            break;
        case 90:  // Z
            shiftLeft();
            break;
        case 88:  // X
            shiftRight();
            break;
        }
}

void task_100Hz (){
	// sprintf (status_string, "%d", deek(0x276));
	
	// AdvancedPrint(3,2,status_string);
}

void keyPressed (char dif, char v){

	sprintf (status_string, "key pressed: %d %d   ", dif, v);
	AdvancedPrint(3,6 ,status_string);
    switch (v) {
    case 4 :
        switch (dif) {
        case 8:
            // KEY UP
            move(11);
            break;
        case 64:
            // KEY DOWN
            move(10);
            break;
        case 32:
            // KEY LEFT
            move(8);
            break;
        case -128:
            // KEY RIGHT
            move(9);
            break;
        }
    break;
    case 5:
        switch (dif) {
        case 8:
            // KEY P
            move(80);
            break;
        }
    break;
    case 3:
        switch (dif) {
        case 4:
            // KEY M
            move(59);
            break;
        }
    case 6:
        switch (dif) {
        case 32:
            // KEY Q
            move(81);
            break;
        }
    case 2:
        switch (dif) {
        case 32:
            // KEY W
            move(90);
            break;
        }
    case 1:
        switch (dif) {
        case 64:
            // KEY A
            move(65);
            break;
        }
    case 0:
        switch (dif) {
        case 64:
            // KEY X
            move(88);
            break;
        }
    }
}
void keyReleased (char dif, char v){
	// sprintf (status_string, "   key released: %d %d    ", dif, v);
	// AdvancedPrint(3, 6,status_string);
}


void keyEvent()
{
    char i,j;
    char mask=1;
	char diff;
     
    for (j=0;j<8;j++)
    {
		if ((diff = (oldKeyBank[j] ^ KeyBank [j])) != 0){
			// printf ("diff = %d\n");
			if ((KeyBank [j] & diff) == 0) {
				keyReleased (diff, j);
			} else {
				keyPressed (diff, j);
			}
		}
		oldKeyBank[j] = KeyBank [j];
	}
}


#ifdef USE_COLLISION_DETECTION
unsigned char isAllowedPosition(signed int X, signed int Y, signed int Z) {
    // unsigned int aX = abs(X);
    // unsigned int aY = abs(Y);
    // if ((aX <=13) && (aY <= 9)) {
    //     if ((aY <= 7) && (X > -7)) {
    //         return 1;
    //     } else {
    //         return 0;
    //     }
    // }
    return 1;
}
#endif


#endif // RTDEMO