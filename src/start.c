
#include "config.h"

#ifdef TARGET_ORIX
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#else
#include "lib.h"
#endif // TARGET_ORIX

#include "glOric_h.h"

#include "data/traj.h"

#define TEXTURE_1 ','
#define TEXTURE_2 '.'
#define TEXTURE_3 'u'
#define TEXTURE_4 '*'
#define TEXTURE_5 'o'
#define TEXTURE_6 '+'
#define TEXTURE_7 'x'

signed char geomHouse []= {
/* Nb Coords = */ 10,
/* Nb Faces = */ 11,
/* Nb Segments = */ 14,
/* Nb Particules = */ 0,
// Coord List : X, Y, Z, unused
 1, 1, 0, 0, 
-1, 1, 0, 0,
-1,-1, 0, 0,
 1,-1, 0, 0,
 1, 1, 2, 0, 
-1, 1, 2, 0,
-1,-1, 2, 0,
 1,-1, 2, 0,
 1, 0, 3, 0,
-1, 0, 3, 0,
// Face List : idxPoint1, idxPoint2, idxPoint3, character 
 0, 1, 5, TEXTURE_6,
 0, 4, 5, TEXTURE_6,
 3, 2, 6, TEXTURE_6,
 6, 3, 7, TEXTURE_6,
 1, 2, 6, TEXTURE_5,
 1, 6, 5, TEXTURE_5,
 5, 6, 9, TEXTURE_5,
 4, 5, 9, TEXTURE_3,
 4, 9, 8, TEXTURE_3,
 7, 6, 9, TEXTURE_3,
 7, 9, 8, TEXTURE_3,
// Segment List : idxPoint1, idxPoint2, character , unused
0, 1, '-', 0,
1, 2, '-', 0,
2, 3, '-', 0,
4, 5, '-', 0,
6, 7, '-', 0,
0, 4,'|', 0,
1, 5,'|', 0,
2, 6,'|', 0,
3, 7,'|', 0,
4, 8,'/', 0,
7, 8,'/', 0,
5, 9,'/', 0,
6, 9,'/', 0,
9, 8,'-', 0,

// Particule List : idxPoint1, character 
};

// extern void waitkey();
void waitkey(){
#ifdef TARGET_ORIX
    cgetc();
#else
    get();
#endif
}


// extern void change_char(char c, unsigned char patt01, unsigned char patt02, unsigned char patt03, unsigned char patt04, unsigned char patt05, unsigned char patt06, unsigned char patt07, unsigned char patt08);


void change_char(char c, unsigned char patt01, unsigned char patt02, unsigned char patt03, unsigned char patt04, unsigned char patt05, unsigned char patt06, unsigned char patt07, unsigned char patt08) {
    unsigned char* adr;
    adr      = (unsigned char*)(0xB400 + c * 8);
    *(adr++) = patt01;
    *(adr++) = patt02;
    *(adr++) = patt03;
    *(adr++) = patt04;
    *(adr++) = patt05;
    *(adr++) = patt06;
    *(adr++) = patt07;
    *(adr++) = patt08;
}

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
    int i,j;
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

    change_char(36, 0x80, 0x40, 020, 0x10, 0x08, 0x04, 0x02, 0x01);
    addGeom2(0, 0, 0, 12, 8, 4, 0, geomHouse);
    // addGeom2(5, 2, 0, 6, 6, 6, 1, geomTriangle);
    printf ("%d Points, %d Particules, %d Segments, %d Faces\n", nbPoints, nbParticules, nbSegments, nbFaces); waitkey();
    // listPoints3D();

    i       = 0;

    for (j = 0; j < 64; j++) {
        CamPosX = traj[i++];
        CamPosY = traj[i++];
        CamRotZ = traj[i++];
        i       = i % (NB_POINTS_TRAJ * SIZE_POINTS_TRAJ);


        glProjectArrays();
        // // listPoints2D();

        initScreenBuffers();

        glDrawFaces();

        glDrawSegments();

        glDrawParticules();

        buffer2screen((char *)ADR_BASE_LORES_SCREEN);
    }
    printf ("Fin\n");

}