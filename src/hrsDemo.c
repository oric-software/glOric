
#include "config.h"
//#include "glOric.h"
#include "glOric_h.h"

#ifdef HRSDEMO

// #include "data\geom.h"
#include "data\traj.h"

/*
 *  GEOMETRY BUFFERS
 */

extern char                 points3d[]; // NB_MAX_VERTICES * SIZEOF_3DPOINT
unsigned char        nbPts = 0;
extern char                 points2d[]; // NB_MAX_VERTICES * SIZEOF_2DPOINT
extern char          faces[];
extern unsigned char glNbFaces;
extern unsigned char segments[];
extern unsigned char glNbSegments;
extern unsigned char particles[];
extern unsigned char glNbParticles;

void                 hiresIntro();
void                 hiresGameLoop();
void                 hrDrawFaces();


#include "addGeom.c"
#include "geomCube.c"

void hiresDemo() {
    GenerateTables();  // for line8
    ComputeDivMod();   // for filler
    InitTables();      //for filler

    hires();

    nbPts      = 0;
    glNbSegments = 0;

    addGeom2(-4, -4, 2, 4, 4, 4, 0, geomCube);
    addGeom2(4, 4, 10, 4, 4, 4, 0, geomCube);
    // printf ("%d Points, %d Particles, %d Segments, %d Faces\n", glNbVertices, glNbParticles, glNbSegments, glNbFaces); get();
    hiresIntro();

    hiresGameLoop();
}

void hiresIntro() {
    int i, jj;

    //enterSC();

    glCamPosX = -24;
    glCamPosY = 0;
    glCamPosZ = 3;

    glCamRotZ = 64;  // -128 -> -127 unit : 2PI/(2^8 - 1)
    glCamRotX = 2;

    for (i = 0; i < 120;) {
        glCamPosX = traj[i++];
        glCamPosY = traj[i++];
        glCamRotZ = traj[i++];
        i       = i % (NB_POINTS_TRAJ * SIZE_POINTS_TRAJ);
        glProject(points2d, points3d, glNbVertices, 0);
        // for (jj=0; jj< glNbVertices; jj++){
        //     printf ("%d %d %d => %d %d \n", points3d[jj*SIZEOF_3DPOINT], points3d[jj*SIZEOF_3DPOINT+1], points3d[jj*SIZEOF_3DPOINT+2], points2d[jj*SIZEOF_2DPOINT], points2d[jj*SIZEOF_2DPOINT+1]);get();
        // }

        memset(0xa000, 64, 8000);  // clear screen
        hrDrawSegments(points2d, segments, glNbSegments);
        hrDrawFaces();
    }

    // leaveSC();
}

void hiresGameLoop() {
    char          key;
    unsigned char i = 0;
    key             = get();
    glProject(points2d, points3d, nbPts, 0);

    while (1 == 1) {
        memset(0xa000, 64, 8000);  // clear screen
        hrDrawSegments(points2d, segments, glNbSegments);
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
            if (glCamPosZ < 5) {
                glCamPosZ += 1;
            }
            break;
        case 59:  // ;
            if (glCamPosZ > 0) {
                glCamPosZ -= 1;
            }
            break;
        }
        glCamPosX = traj[i + 0];
        glCamPosY = traj[i + 1];
        glCamRotZ = traj[i + 2];

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