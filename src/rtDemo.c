

#include "config.h"
// #include "glOric.h"

#ifdef TARGET_ORIX
#include <conio.h>
#include <stdio.h>
#endif

#ifdef RTDEMO

#include "glOric_h.h"
// #include "data\geom.h"
#include "data\traj.h"
// #include "render\lrsDrawing.h"
// #include "render\zbuffer.h"
#include "util\util.h"
// #include "util\keyboard.h"
/*
  * GEOMETRY BUFFERS
  */

#ifdef USE_REWORKED_BUFFERS

extern signed char glVerticesX[];
extern signed char glVerticesY[];
extern signed char glVerticesZ[];

extern signed char points2aH[];
extern signed char points2aV[];
// extern signed char points2dH[];
// extern signed char points2dL[];
#else
extern char                 points3d[]; // NB_MAX_VERTICES * SIZEOF_3DPOINT
extern char                 points2d[]; // NB_MAX_VERTICES * SIZEOF_2DPOINT
#endif // USE_REWORKED_BUFFERS

extern unsigned char glNbVertices;
extern unsigned char faces[];
extern unsigned char glNbFaces ;
extern unsigned char segments[];
extern unsigned char glNbSegments;
extern unsigned char particles[];
extern unsigned char glNbParticles;

#include "geomHouse.c"
// #include "addGeom.c"
#include "loadShape.c"
#include "logic_c.c"
#include "changeChar.c"
#include "colors_c.c"

#ifdef USE_RT_KEYBOARD
#include "keyboard.c"
#endif //USE_RT_KEYBOARD

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
    sprintf(status_string, "(X=%d Y=%d Z=%d) [%d %d]", glCamPosX, glCamPosY, glCamPosZ, glCamRotZ, glCamRotX);
#ifdef TARGET_ORIX
#else
    AdvancedPrint(3, 0, status_string);
#endif  // TARGET_ORIX
}


void quickTest(){
    glCamPosX = -20;
    glCamPosY = 16;
    glCamPosZ = 6;

    glCamRotZ = -23;
    glCamRotX = 0;
    glProjectArrays();
    glInitScreenBuffers();
    glDrawFaces();
    glBuffer2Screen();
    get();
}

void rtDemo() {

    change_char(36, 0x80, 0x40, 020, 0x10, 0x08, 0x04, 0x02, 0x01);

    glNbVertices     = 0;
    glNbSegments   = 0;
    glNbFaces      = 0;
    glNbParticles = 0;

    // addHouse(0, 0, 12, 8);
    // addPlan(0, 6, 6, 64, 'r');
    // addPlan(0, -6, 6, 64, 'b');
    // addPlan(6, 0, 6, 0, 'y');
    // addPlan(-6, 0, 6, 0, 'g');
    // addGeom(0, 0, 0, 3, 3, 3, 1, geomTriangle);
    // addGeom(4, 4, 3, 3, 3, 3, 0, geomRectangle);
    glLoadShape(0, 0, 0, 0, geomHouse);
    // printf ("%d Points, %d Particles, %d Segments, %d Faces\n", nbPts, glNbParticles, glNbSegments, glNbFaces); get();

    memset (oldKeyBank,0,8);
    memset (KeyBank,0,8);

#ifdef TARGET_ORIX
#else
    text();
#endif  // TARGET_ORIX
#ifdef USE_COLOR
    initColors();
#endif
    // quickTest();
    rtIntro();
    rtGameLoop();
}

void rtIntro() {
    int i, j;
    int dur;
#ifdef TARGET_ORIX
    // cgetc();
#else
    // get();
    // enterSC();
#endif  // TARGET_ORIX

    glCamPosX = 0;
    glCamPosY = 0;
    glCamPosZ = 6;

    glCamRotZ = 0;
    glCamRotX = 0;
    i       = 0;
    
    for (j = 0; j < 32; j++) {
        glCamPosX = traj[i++];
        glCamPosY = traj[i++];
        glCamRotZ = traj[i++];
        i       = i % (NB_POINTS_TRAJ * SIZE_POINTS_TRAJ);

        // dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, glNbVertices, 0);
#endif
        // dur = dur - deek(0x276); printf ("dur glProject = %d \n", dur); get();

        // dur = deek(0x276);
        glInitScreenBuffers();
        // dur = dur - deek(0x276); printf ("dur glInitScreenBuffers = %d \n", dur); get ();

        // dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glDrawFaces();
#else
        lrDrawFaces(points2d, faces, glNbFaces);
#endif //USE_REWORKED_BUFFERS
        // dur = dur - deek(0x276); printf ("dur lrDrawFaces = %d \n", dur); get ();

        // dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        lrDrawSegments(points2d, segments, glNbSegments);
#endif //USE_REWORKED_BUFFERS
        // dur = dur - deek(0x276); printf ("dur lrDrawSegments = %d \n", dur); get();

        // dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glDrawParticles();
#else
        lrDrawParticles(points2d, particles, glNbParticles);
#endif //USE_REWORKED_BUFFERS
        // dur = dur - deek(0x276); printf ("dur lrDrawParticles = %d \n", dur); get();

        // dur = deek(0x276);
        glBuffer2Screen();
        // dur = dur - deek(0x276); printf ("dur glBuffer2Screen = %d \n", dur); get();
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
        glProject(points2d, points3d, glNbVertices, 0);
#endif
    // dur = dur - deek(0x276);printf ("dur glProject = %d \n", dur);dur = deek(0x276);

    // printf ("(x=%d y=%d z=%d) [%d %d]\n", glCamPosX, glCamPosY, glCamPosZ, glCamRotZ, glCamRotX);
    //     for (ii=0; ii< nbPts; ii++){
    //         printf ("[%d %d %d] => [%d %d] %d \n"
    //         , points3d [ii*SIZEOF_3DPOINT+0], points3d[ii*SIZEOF_3DPOINT+1], points3d[ii*SIZEOF_3DPOINT+2]
    //         , points2d [ii*SIZEOF_2DPOINT+0], points2d [ii*SIZEOF_2DPOINT+1], points2d[ii*SIZEOF_2DPOINT+2]
    //         );
    //     }
    //     get();

    glInitScreenBuffers();
    // dur = dur - deek(0x276);printf ("dur glInitScreenBuffers = %d \n", dur);dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glDrawFaces();
#else
        lrDrawFaces(points2d, faces, glNbFaces);
#endif //USE_REWORKED_BUFFERS
    // dur = dur - deek(0x276);printf ("dur lrDrawFaces = %d \n", dur);dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        lrDrawSegments(points2d, segments, glNbSegments);
#endif //USE_REWORKED_BUFFERS
    // dur = dur - deek(0x276);printf ("dur lrDrawSegments = %d \n", dur);dur = deek(0x276);
#ifdef USE_REWORKED_BUFFERS
        glDrawParticles();
#else
        lrDrawParticles(points2d, particles, glNbParticles);
#endif //USE_REWORKED_BUFFERS
    // dur = dur - deek(0x276);printf ("dur lrDrawParticles = %d \n", dur);dur = deek(0x276);
    // get();
    while (1 == 1) {
        keyEvent();
        // dur = deek(0x276);
        glBuffer2Screen((void*)ADR_BASE_LORES_SCREEN);
        // dur = dur - deek(0x276);printf ("dur glBuffer2Screen = %d \n", dur);dur = deek(0x276);
        dispInfo();
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, glNbVertices, 0);
#endif
        glInitScreenBuffers();
#ifdef USE_REWORKED_BUFFERS
        glDrawFaces();
        glDrawSegments();
        glDrawParticles();
#else
        lrDrawFaces(points2d, faces, glNbFaces);
        lrDrawSegments(points2d, segments, glNbSegments);
        lrDrawParticles(points2d, particles, glNbParticles);
 #endif //USE_REWORKED_BUFFERS
       
    }
}

void move(char key) {
    switch (key) {
        case 8:  // gauche => tourne gauche
            glCamRotZ += 4;
            break;
        case 9:  // droite => tourne droite
            glCamRotZ -= 4;
            break;
        case 10:  // bas => recule
            backward();
            break;
        case 11:  // haut => avance
            forward();
            break;
        case 80:  // P
            glCamPosZ += 1;
            break;
        case 59:  // ;
            glCamPosZ -= 1;
            break;
        case 81:  // Q
            glCamRotX += 2;
            break;
        case 65:  // A
            glCamRotX -= 2;
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



#ifdef USE_COLLISION_DETECTION
unsigned char isAllowedPosition(signed char X, signed char Y, signed char Z) {
    unsigned char aX = abs(X);
    unsigned char aY = abs(Y);
    if ((aX <=13) && (aY <= 9)) {
        if ((aY <= 7) && (X > -7)) {
            return 1;
        } else {
            return 0;
        }
    }
    return 1;
}
#endif


#endif // RTDEMO