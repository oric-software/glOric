

#include "config.h"
#include "glOric.h"

#ifdef TARGET_ORIX
#include <conio.h>
#include <stdio.h>
#endif

#ifdef COLORDEMO

#include "data\geom.h"
#include "data\traj.h"
#include "render\lrsDrawing.h"
#include "render\zbuffer.h"
#include "util\util.h"

/*
  * GEOMETRY BUFFERS
  */
char                 points3d[NB_MAX_POINTS * SIZEOF_3DPOINT];
unsigned char        nbPts = 0;
char                 points2d[NB_MAX_POINTS * SIZEOF_2DPOINT];
unsigned char        faces[NB_MAX_FACES * SIZEOF_FACES];
unsigned char        nbFaces = 0;
extern unsigned char segments[];
extern unsigned char nbSegments;
extern unsigned char particules[];
extern unsigned char nbParticules;

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
    sprintf(status_string, "(x=%d y=%d z=%d) [%d %d]", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
#ifdef TARGET_ORIX
#else
    AdvancedPrint(2, 1, status_string);
#endif  // TARGET_ORIX
}

void colorDemo() {

    change_char(36, 0x80, 0x40, 020, 0x10, 0x08, 0x04, 0x02, 0x01);

    nbPts        = 0;
    nbSegments   = 0;
    nbFaces      = 0;
    nbParticules = 0;

    // addHouse(0, 0, 12, 8);
    addPlan(0, 6, 6, 64, 'r');
    addPlan(0, -6, 6, 64, 'b');
    addPlan(6, 0, 6, 0, 'y');
    addPlan(-6, 0, 6, 0, 'g');

    //printf ("%d Points, %d Particules, %d Segments, %d Faces\n", nbPts, nbParticules, nbSegments, nbFaces); get();

#ifdef TARGET_ORIX
#else
    text();
#endif  // TARGET_ORIX
    initColors();

    colorIntro();
    // TODO : Remove this
    CamPosX = 14;
    CamPosY = -4;
    CamPosZ = 6;
    CamRotZ = 97;
    CamRotX = 0;

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

    CamPosX = 0;
    CamPosY = 0;
    CamPosZ = 3;

    CamRotZ = 0;
    CamRotX = 0;
    i       = 0;

    for (j = 0; j < 64; j++) {
        CamPosX = traj[i++];
        CamPosY = traj[i++];
        CamRotZ = traj[i++];
        i       = i % (NB_POINTS_TRAJ * SIZE_POINTS_TRAJ);
        glProject(points2d, points3d, nbPts, 0);

        initScreenBuffers();
        lrDrawFaces(points2d, faces, nbFaces);
        lrDrawSegments(points2d, segments, nbSegments);
        lrDrawParticules(points2d, particules, nbParticules);

        buffer2screen((void*)ADR_BASE_SCREEN);
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
    glProject(points2d, points3d, nbPts, 0);

    // printf ("(x=%d y=%d z=%d) [%d %d]\n", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
    //     for (ii=0; ii< nbPts; ii++){
    //         printf ("[%d %d %d] => [%d %d] %d \n"
    //         , points3d [ii*SIZEOF_3DPOINT+0], points3d[ii*SIZEOF_3DPOINT+1], points3d[ii*SIZEOF_3DPOINT+2]
    //         , points2d [ii*SIZEOF_2DPOINT+0], points2d [ii*SIZEOF_2DPOINT+1], points2d[ii*SIZEOF_2DPOINT+2]
    //         );
    //     }
    //     get();

    initScreenBuffers();
    lrDrawFaces(points2d, faces, nbFaces);
    lrDrawSegments(points2d, segments, nbSegments);
    lrDrawParticules(points2d, particules, nbParticules);
    while (1 == 1) {
        buffer2screen((void*)ADR_BASE_SCREEN);
        dispInfo();
#ifdef TARGET_ORIX
        cgetc();
#else
        key = get();
#endif  // TARGET_ORIX
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
        glProject(points2d, points3d, nbPts, 0);
        initScreenBuffers();
        lrDrawFaces(points2d, faces, nbFaces);
        lrDrawSegments(points2d, segments, nbSegments);
        lrDrawParticules(points2d, particules, nbParticules);
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


#endif