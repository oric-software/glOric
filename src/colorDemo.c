

#include "config.h"
// #include "glOric.h"

#ifdef TARGET_ORIX
#include <conio.h>
#include <stdio.h>
#endif

#ifdef COLORDEMO
#include "glOric_h.h"
// #include "data\geom.h"
#include "data\traj.h"
// #include "render\lrsDrawing.h"
// #include "render\zbuffer.h"
#include "util\util.h"

/*
  * GEOMETRY BUFFERS
  */
 #ifdef USE_REWORKED_BUFFERS

extern signed char glVerticesX[];
extern signed char glVerticesY[];
extern signed char glVerticesZ[];

extern unsigned char glSegmentsPt1[];
extern unsigned char glSegmentsPt2[];
extern unsigned char glSegmentsChar[];

extern unsigned char faces[];
extern unsigned char glNbVertices;
extern unsigned char glNbFaces;
extern unsigned char glNbSegments;
extern unsigned char glNbParticles;

#else

extern char points3d[];
extern char points2d[];


extern unsigned char segments[];
extern unsigned char particles[];
extern unsigned char faces[];
extern unsigned char glNbVertices;
extern unsigned char glNbFaces;
extern unsigned char glNbSegments;
extern unsigned char glNbParticles;

#endif USE_REWORKED_BUFFER

void colorIntro();
void colorGameLoop();

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
#include "geomHouse.c"
#include "geomPine.c"
#include "geomTower.c"
#include "addGeom.c"
#include "logic_c.c"
#include "changeChar.c"
#include "colors_c.c"

void colorDemo() {

    change_char(36, 0x80, 0x40, 020, 0x10, 0x08, 0x04, 0x02, 0x01);

    glNbVertices        = 0;
    glNbSegments   = 0;
    glNbFaces      = 0;
    glNbParticles = 0;

    // addHouse(0, 0, 12, 8);
    // addPlan(0, 6, 6, 64, 'r');
    // addPlan(0, -6, 6, 64, 'b');
    // addPlan(6, 0, 6, 0, 'y');
    // addPlan(-6, 0, 6, 0, 'g');
    addGeom2(0, 0, 0, 12, 8, 4, 0, geomHouse);
    addGeom2(24, 12, 0, 9, 9, 9, 0, (signed char *)geomPine);
    addGeom2(24, -24, 0, 6, 6, 12, 0, (signed char *)geomTower);
    // addGeom(4, 4, 3, 3, 3, 3, 0, geomRectangle);
    
    // printf ("%d Points, %d Particles, %d Segments, %d Faces\n", nbPts, glNbParticles, glNbSegments, glNbFaces); get();

#ifdef TARGET_ORIX
#else
    text();
#endif  // TARGET_ORIX
#ifdef USE_COLOR
    initColors();
    // memcpy(fbuffer, (void*)ADR_BASE_LORES_SCREEN , SCREEN_HEIGHT* SCREEN_WIDTH);
#endif
    colorIntro();
    colorGameLoop();
}

void colorIntro() {
    int i, j;

#ifdef TARGET_ORIX
    // cgetc();
#else
    // get();
    enterSC();
#endif  // TARGET_ORIX

    glCamPosX = 74;
    glCamPosY = 0;
    glCamPosZ = 6;

    glCamRotZ = -127;
    glCamRotX = 0;
    i       = 0;


    for (j = 0; j < 50; j++) {
        glCamPosX -- ; // forward();
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

        glBuffer2Screen();
        dispInfo();
    }



    for (j = 0; j < 64; j++) {
        glCamPosX = traj[i++];
        glCamPosY = traj[i++];
        glCamRotZ = traj[i++];
        i       = i % (NB_POINTS_TRAJ * SIZE_POINTS_TRAJ);

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

        glBuffer2Screen();
        dispInfo();
    }

    for (j = 0; j < 32; j++) {
        glCamPosX ++ ; // backward();
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

        glBuffer2Screen();
        dispInfo();
    }

#ifdef TARGET_ORIX
#else
    leaveSC();
#endif  // TARGET_ORIX
}

void colorGameLoop() {
    char          key;
    unsigned char ii;
#ifdef TARGET_ORIX
    cgetc();
#else
    key = get();
#endif

#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, glNbVertices, 0);
#endif

    // printf ("(x=%d y=%d z=%d) [%d %d]\n", glCamPosX, glCamPosY, glCamPosZ, glCamRotZ, glCamRotX);
    //     for (ii=0; ii< nbPts; ii++){
    //         printf ("[%d %d %d] => [%d %d] %d \n"
    //         , points3d [ii*SIZEOF_3DPOINT+0], points3d[ii*SIZEOF_3DPOINT+1], points3d[ii*SIZEOF_3DPOINT+2]
    //         , points2d [ii*SIZEOF_2DPOINT+0], points2d [ii*SIZEOF_2DPOINT+1], points2d[ii*SIZEOF_2DPOINT+2]
    //         );
    //     }
    //     get();

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

    while (1 == 1) {
        glBuffer2Screen();
        dispInfo();
#ifdef TARGET_ORIX
        cgetc();
#else
        key = get();
#endif  // TARGET_ORIX
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
    if ((X >=18) && (X <= 30) && (Y == -18)) return 0;
    if ((X ==18) && (Y >= -30) && (Y <= -18)) return 0;
    if ((X ==30) && (Y >= -30) && (Y <= -18)) return 0;
    
    return 1;
}
#endif


#endif