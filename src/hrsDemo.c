
#include "config.h"
#include "glOric.h"

#ifdef HRSDEMO

#include "data\geom.h"
#include "data\traj.h"

/*
 *  GEOMETRY BUFFERS
 */

extern char                 points3d[]; // NB_MAX_POINTS * SIZEOF_3DPOINT
unsigned char        nbPts = 0;
extern char                 points2d[]; // NB_MAX_POINTS * SIZEOF_2DPOINT
extern char          faces[];
extern unsigned char nbFaces;
extern unsigned char segments[];
extern unsigned char nbSegments;

void                 hiresIntro();
void                 hiresGameLoop();
void                 hrDrawFaces();

void hiresDemo() {
    GenerateTables();  // for line8
    ComputeDivMod();   // for filler
    InitTables();      //for filler

    hires();

    nbPts      = 0;
    nbSegments = 0;

    addGeom(-4, -4, 2, 4, 4, 4, 0, geomCube);
    addGeom(4, 4, 10, 4, 4, 4, 0, geomCube);

    hiresIntro();

    hiresGameLoop();
}

void hiresIntro() {
    int i;

    enterSC();

    CamPosX = -24;
    CamPosY = 0;
    CamPosZ = 3;

    CamRotZ = 64;  // -128 -> -127 unit : 2PI/(2^8 - 1)
    CamRotX = 2;

    for (i = 0; i < 120;) {
        CamPosX = traj[i++];
        CamPosY = traj[i++];
        CamRotZ = traj[i++];
        i       = i % (NB_POINTS_TRAJ * SIZE_POINTS_TRAJ);
        glProject(points2d, points3d, nbPts, 0);
        memset(0xa000, 64, 8000);  // clear screen
        hrDrawSegments(points2d, segments, nbSegments);
        hrDrawFaces();
    }

    leaveSC();
}

void hiresGameLoop() {
    char          key;
    unsigned char i = 0;
    key             = get();
    glProject(points2d, points3d, nbPts, 0);

    while (1 == 1) {
        memset(0xa000, 64, 8000);  // clear screen
        hrDrawSegments(points2d, segments, nbSegments);
        hrDrawFaces();
        key = get();
        switch (key)  // key
        {
        case 8:  // gauche => tourne gauche
            i = (i + 3) % (192);
            break;
        case 9:  // droite => tourne droite
            if (i == 0)
                i = 192 - 3;
            i = (i - 3);
            break;
        case 80:  // P
            if (CamPosZ < 5) {
                CamPosZ += 1;
            }
            break;
        case 59:  // ;
            if (CamPosZ > 0) {
                CamPosZ -= 1;
            }
            break;
        }
        CamPosX = traj[i + 0];
        CamPosY = traj[i + 1];
        CamRotZ = traj[i + 2];

        glProject(points2d, points3d, nbPts, 0);
    }
}

void hrDrawFaces() {
    hrDrawFace(points2d, 0, 1, 2, 2);
    hrDrawFace(points2d, 0, 2, 3, 2);
    //hrDrawFace(points2d, 0, 1, 5, 1);
    //hrDrawFace(points2d, 0, 5, 4, 1);
    hrDrawFace(points2d, 4, 5, 6, 0);
    hrDrawFace(points2d, 4, 6, 7, 0);
}


#endif