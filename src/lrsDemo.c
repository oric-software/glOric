

#include "config.h"
//#include "glOric.h"

#ifdef TARGET_ORIX
#include <conio.h>
#include <stdio.h>
#endif

#ifdef LRSDEMO

#include "glOric_h.h"

// #include "data\geom.h"
#include "data\traj.h"
// #include "render\lrsDrawing.h"
//#include "render\zbuffer.h"
#include "util\util.h"

// GEOMETRY BUFFERS
#ifdef USE_REWORKED_BUFFERS

extern char points3d[];
extern char points3d[];

extern signed char points3dX[];
extern signed char points3dY[];
extern signed char points3dZ[];

extern unsigned char segmentsPt1[];
extern unsigned char segmentsPt2[];
extern unsigned char segmentsChar[];

extern unsigned char faces[];
extern unsigned char nbPoints;
extern unsigned char nbFaces;
extern unsigned char nbSegments;
extern unsigned char nbParticules;

#else
extern char                 points3d[]; // NB_MAX_POINTS * SIZEOF_3DPOINT
extern char                 points2d[]; // NB_MAX_POINTS * SIZEOF_2DPOINT

extern unsigned char segments[];
extern unsigned char particules[];
extern unsigned char faces[];
extern unsigned char nbPoints;
extern unsigned char nbFaces;
extern unsigned char nbSegments;
extern unsigned char nbParticules;

#endif USE_REWORKED_BUFFER


void lrsIntro();
void lrsGameLoop();

char status_string[50];

#ifdef TARGET_ORIX
extern void backward();
extern void forward();
extern void shiftLeft();
extern void shiftRight();
#endif

#include "geomHouse.c"
#include "logic_c.c"

#include "changeChar.c"

#include "addGeom.c"

void dispInfo() {
    sprintf(status_string, "(X=%d Y=%d Z=%d) [%d %d]", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
#ifdef TARGET_ORIX
#else
    AdvancedPrint(3, 0, status_string);
#endif  // TARGET_ORIX
}

void quickTest(){
    CamPosX = 17;
    CamPosY = -2;
    CamPosZ = 6;

    CamRotZ = 125;
    CamRotX = 0;
    glProjectArrays();
    initScreenBuffers();
    glDrawFaces();
    buffer2screen((void*)ADR_BASE_LORES_SCREEN);
    get();
}

void lrsDemo() {

    change_char(36, 0x80, 0x40, 020, 0x10, 0x08, 0x04, 0x02, 0x01);

    nbPoints        = 0;
    nbSegments   = 0;
    nbFaces      = 0;
    nbParticules = 0;

    // addPlan(0, 0, 12, 64, 'r');
    addGeom2(0, 0, 0, 12, 8, 4, 0, geomHouse);
    //printf ("%d Points, %d Particules, %d Segments, %d Faces\n", nbPoints, nbParticules, nbSegments, nbFaces); get();

#ifdef TARGET_ORIX
#else
    lores0();
#endif  // TARGET_ORIX

    // quickTest();

    lrsIntro();

    lrsGameLoop();
}

void lrsIntro() {
    int i, j;

#ifdef TARGET_ORIX
    // cgetc();
#else
    // get();
    enterSC();
#endif  // TARGET_ORIX

    CamPosX = 0;
    CamPosY = 0;
    CamPosZ = 6;

    CamRotZ = 0;
    CamRotX = 0;
    i       = 0;

    for (j = 0; j < 64; j++) {
        CamPosX = traj[i++];
        CamPosY = traj[i++];
        CamRotZ = traj[i++];
        i       = i % (NB_POINTS_TRAJ * SIZE_POINTS_TRAJ);


#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, nbPoints, 0);
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

        buffer2screen((void*)ADR_BASE_LORES_SCREEN);
    }
#ifdef TARGET_ORIX
#else
    leaveSC();
#endif  // TARGET_ORIX
}

void lrsGameLoop() {
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
    glProject(points2d, points3d, nbPoints, 0);
#endif
    

    // printf ("(x=%d y=%d z=%d) [%d %d]\n", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
    //     for (ii=0; ii< nbPts; ii++){
    //         printf ("[%d %d %d] => [%d %d] %d \n"
    //         , points3d [ii*SIZEOF_3DPOINT+0], points3d[ii*SIZEOF_3DPOINT+1], points3d[ii*SIZEOF_3DPOINT+2]
    //         , points2d [ii*SIZEOF_2DPOINT+0], points2d [ii*SIZEOF_2DPOINT+1], points2d[ii*SIZEOF_2DPOINT+2]
    //         );
    //     }
    //     get();

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

    while (1 == 1) {
        buffer2screen((void*)ADR_BASE_LORES_SCREEN);
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
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, nbPoints, 0);
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

#ifdef USE_COLLISION_DETECTION
unsigned char isAllowedPosition(signed int X, signed int Y, signed int Z) {
    unsigned int aX = abs(X);
    unsigned int aY = abs(Y);
    if ((aX <=13) && (aY <= 9)) {
        if ((aY <= 7) && (X > -7)) {
            return 1;
        } else {
            return 0;
        }
    }
    return 1;
}
#endif // USE_COLLISION_DETECTION


#endif