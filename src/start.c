
#include "config.h"

#ifdef TARGET_ORIX
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#else
#include "lib.h"
#endif // TARGET_ORIX

#include "glOric_h.h"


signed char geomTriangle []= {
/* Nb Coords = */ 3,
/* Nb Faces = */ 1,
/* Nb Segments = */ 3,
/* Nb Particules = */ 0,
// Coord List : X, Y, Z, unused
1, 0, 0, 0, 
3, 0, 0, 0,
 2, 0, 2, 0,
// Face List : idxPoint1, idxPoint2, idxPoint3, character 
 0, 1, 2, '.',
// Segment List : idxPoint1, idxPoint2, idxPoint3, character 
0, 2, '/', 0,
1, 2, '/', 0,
0, 1, '-', 0,
// Particule List : idxPoint1, character 
};

signed char geomLetterI[] = {
    /* Nb Coords = */ 6,
    /* Nb Faces = */ 0,
    /* Nb Segments = */ 3,
    /* Nb Particules = */ 0,
    // Coord List : X, Y, Z, unused
    1, 0, 1, 0,   // P0
    3, 0, 1, 0,   // P1
    1, 0, 7, 0,   // P2
    3, 0, 7, 0,   // P3
    2, 0, 1, 0,   // P4
    2, 0, 7, 0,   // P5
    // Face List : idxPoint1, idxPoint2, idxPoint3, character
    // Segment List : idxPoint1, idxPoint2, idxPoint3, character
    0, 1, 73, 0,  // 45, 0
    2, 3, 73, 0,  // 45, 0
    4, 5, 73, 0   // 124, 0
    // Particule List : idxPoint1, character
};

extern void waitkey();
void addGeom2(
    signed char   X,
    signed char   Y,
    signed char   Z,
    unsigned char sizeX,
    unsigned char sizeY,
    unsigned char sizeZ,
    unsigned char orientation,
    signed char          geom[]) {

    int kk=0;
    int ii;
    int npt,nfa, nseg, npart;
    npt = geom[kk++];
    nfa = geom[kk++];
    nseg = geom[kk++];
    npart = geom[kk++];
    for (ii = 0; ii < npt; ii++){
        if (orientation == 0) {
            points3dX[nbPoints] = X + sizeX * geom[kk++];
            points3dY[nbPoints] = Y + sizeY * geom[kk++];
        } else {
            points3dY[nbPoints] = X + sizeY * geom[kk++];
            points3dX[nbPoints] = Y + sizeX * geom[kk++];
        }
        points3dZ[nbPoints] = Z + sizeZ * geom[kk++];
        nbPoints ++;
        kk++; // skip unused byte
    }
    for (ii = 0; ii < nfa; ii++){
        facesPt1[nbFaces] = nbPoints - (npt-geom[kk++]);  // Index Point 1
        facesPt2[nbFaces] = nbPoints - (npt-geom[kk++]);  // Index Point 2
        facesPt3[nbFaces] = nbPoints - (npt-geom[kk++]);  // Index Point 3
        facesChar[nbFaces] = geom[kk++];  // Character
        nbFaces++;
    }
    for (ii = 0; ii < nseg; ii++){
        segmentsPt1[nbSegments] = nbPoints - (npt-geom[kk++]);  // Index Point 1
        segmentsPt2[nbSegments] = nbPoints - (npt-geom[kk++]);  // Index Point 2
        segmentsChar[nbSegments] = geom[kk++]; // Character
        nbSegments++;
        kk++; // skip unused byte
    }
    for (ii = 0; ii < npart; ii++){
        particulesPt[nbParticules] = nbPoints - (npt-geom[kk++]);  // Index Point
        particulesChar[nbParticules] = geom[kk++]; // Character
        nbParticules++;        
    }
}    


void addGeom(
    signed char   X,
    signed char   Y,
    signed char   Z,
    unsigned char sizeX,
    unsigned char sizeY,
    unsigned char sizeZ,
    unsigned char orientation,
    char          geom[]) {

    int kk;

    for (kk=0; kk< geom[0]; kk++){
        points3dX[nbPoints] = X + ((orientation == 0) ? sizeX * geom[4+kk*SIZEOF_3DPOINT+0]: sizeY * geom[4+kk*SIZEOF_3DPOINT+1]);// X + ii;
        points3dY[nbPoints] = Y + ((orientation == 0) ? sizeY * geom[4+kk*SIZEOF_3DPOINT+1]: sizeX * geom[4+kk*SIZEOF_3DPOINT+0]);// Y + jj;
        points3dZ[nbPoints] = Z + geom[4+kk*SIZEOF_3DPOINT+2]*sizeZ;// ;
        nbPoints++;
    }
    for (kk=0; kk< geom[1]; kk++){
        facesPt1[nbFaces] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+0]);  // Index Point 1
        facesPt2[nbFaces] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+1]);  // Index Point 2
        facesPt3[nbFaces] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+2]);  // Index Point 3
        facesChar[nbFaces] = geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+3];  // Character
        nbFaces++;
    }
    for (kk=0; kk< geom[2]; kk++){
        segmentsPt1[nbSegments] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 0]);  // Index Point 1
        segmentsPt2[nbSegments] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 1]);  // Index Point 2
        segmentsChar[nbSegments] = geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 2]; // Character
        nbSegments++;
    }
    for (kk=0; kk< geom[3]; kk++){
        particulesPt[nbParticules] = nbPoints - (geom[0]-geom[4 + geom[0]*SIZEOF_3DPOINT + geom[1]*SIZEOF_FACE + geom[2]*SIZEOF_SEGMENT + kk*SIZEOF_PARTICULE + 0]);  // Index Point
        particulesChar[nbParticules] = geom[4 + geom[0]*SIZEOF_3DPOINT + geom[1]*SIZEOF_FACE + geom[2]*SIZEOF_SEGMENT + kk*SIZEOF_PARTICULE + 1]; // Character
        nbParticules++;
    }
}

void listPoints3D(){
    int ii;
    for (ii=0; ii< nbPoints; ii++){
        printf ("Pt %d (%d %d %d)\n", ii, points3dX[ii],points3dY[ii],points3dZ[ii]);
    }
}
void listPoints2D(){
    int ii;
    for (ii=0; ii< nbPoints; ii++){
        printf ("Pt %d (%d %d) dist = %d\n", ii, points2aH[ii],points2aV[ii],points2dL[ii]);
    }
}
void main (){
    // printf ("coucou \n");

    CamPosX = -20;
    CamPosY = 16;
    CamPosZ = 6;

    CamRotZ = -23;
    CamRotX = 0;
    
    nbPoints     = 0;
    nbSegments   = 0;
    nbFaces      = 0;
    nbParticules = 0;


    addGeom2(1, 2, 0, 1, 1, 1, 0, geomLetterI);
    addGeom2(5, 2, 0, 6, 6, 6, 1, geomTriangle);
    // printf ("%d Points, %d Particules, %d Segments, %d Faces\n", nbPoints, nbParticules, nbSegments, nbFaces); waitkey();
    // listPoints3D();

    glProjectArrays();
    // listPoints2D();

    initScreenBuffers();

    glDrawFaces();

    glDrawSegments();

    glDrawParticules();

    buffer2screen((char *)ADR_BASE_LORES_SCREEN);

    printf ("Fin\n");

}