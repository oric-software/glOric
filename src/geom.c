
#include "config.h"
#include "glOric.h"

#include "data/geom.h"

#ifdef USE_COLOR
#define TEXTURE_1 'b'
#define TEXTURE_2 'g'
#define TEXTURE_3 'y'
#define TEXTURE_4 'c'
#define TEXTURE_5 'm'
#define TEXTURE_6 'r'
#define TEXTURE_7 'f'
#else
#define TEXTURE_1 ','
#define TEXTURE_2 '.'
#define TEXTURE_3 'u'
#define TEXTURE_4 '*'
#define TEXTURE_5 'o'
#define TEXTURE_6 '+'
#define TEXTURE_7 'x'

#endif // USE_COLOR


#ifdef USE_REWORKED_BUFFERS

extern unsigned char nbPoints;
extern unsigned char nbSegments;
extern unsigned char nbFaces;
extern unsigned char nbParticles;

extern signed char points3dX[];
extern signed char points3dY[];
extern signed char points3dZ[];

extern unsigned char segmentsPt1[];
extern unsigned char segmentsPt2[];
extern unsigned char segmentsChar[];

extern unsigned char particlesPt[];
extern unsigned char particlesChar[];

extern unsigned char facesPt1[];
extern unsigned char facesPt2[];
extern unsigned char facesPt3[];
extern unsigned char facesChar[];

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
        particlesPt[nbParticles] = nbPoints - (geom[0]-geom[4 + geom[0]*SIZEOF_3DPOINT + geom[1]*SIZEOF_FACE + geom[2]*SIZEOF_SEGMENT + kk*SIZEOF_PARTICLE + 0]);  // Index Point
        particlesChar[nbParticles] = geom[4 + geom[0]*SIZEOF_3DPOINT + geom[1]*SIZEOF_FACE + geom[2]*SIZEOF_SEGMENT + kk*SIZEOF_PARTICLE + 1]; // Character
        nbParticles++;
    }
}

#else


extern char          points3d[];
extern unsigned char nbPoints;
extern char          points2d[];
extern char          faces[];
extern unsigned char nbFaces;
extern unsigned char segments[];
extern unsigned char nbSegments;
extern unsigned char particles[];
extern unsigned char nbParticles;

void addGeom(
    signed char   X,
    signed char   Y,
    signed char   Z,
    unsigned char sizeX,
    unsigned char sizeY,
    unsigned char sizeZ,
    unsigned char orientation,
    char          geom[]) {
    // int ii, jj;
    int kk;
    // unsigned char oldNbPoints;
    // ii = (orientation == 0) ? 0 : -L;
    // jj = (orientation == 0) ? -L : 0;
    // oldNbPoints = nbPoints;

    for (kk=0; kk< geom[0]; kk++){
        points3d[nbPoints * SIZEOF_3DPOINT + 0] = X + ((orientation == 0) ? sizeX * geom[4+kk*SIZEOF_3DPOINT+0]: sizeY * geom[4+kk*SIZEOF_3DPOINT+1]);// X + ii;
        points3d[nbPoints * SIZEOF_3DPOINT + 1] = Y + ((orientation == 0) ? sizeY * geom[4+kk*SIZEOF_3DPOINT+1]: sizeX * geom[4+kk*SIZEOF_3DPOINT+0]);// Y + jj;
        points3d[nbPoints * SIZEOF_3DPOINT + 2] = Z + geom[4+kk*SIZEOF_3DPOINT+2]*sizeZ;// ;
        nbPoints++;
    }
    for (kk=0; kk< geom[1]; kk++){
        faces[nbFaces * SIZEOF_FACE + 0] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+0]);  // Index Point 1
        faces[nbFaces * SIZEOF_FACE + 1] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+1]);  // Index Point 2
        faces[nbFaces * SIZEOF_FACE + 2] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+2]);  // Index Point 3
        faces[nbFaces * SIZEOF_FACE + 3] = geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+3];  // Character
        nbFaces++;
    }
    for (kk=0; kk< geom[2]; kk++){
        segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 0]);  // Index Point 1
        segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 1]);  // Index Point 2
        segments[nbSegments * SIZEOF_SEGMENT + 2] = geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 2]; // Character
        nbSegments++;
    }
    for (kk=0; kk< geom[3]; kk++){
        particles[nbParticles * SIZEOF_PARTICLE + 0] = nbPoints - (geom[0]-geom[4 + geom[0]*SIZEOF_3DPOINT + geom[1]*SIZEOF_FACE + geom[2]*SIZEOF_SEGMENT + kk*SIZEOF_PARTICLE + 0]);  // Index Point
        particles[nbParticles * SIZEOF_PARTICLE + 1] = geom[4 + geom[0]*SIZEOF_3DPOINT + geom[1]*SIZEOF_FACE + geom[2]*SIZEOF_SEGMENT + kk*SIZEOF_PARTICLE + 1]; // Character
        nbParticles++;
    }
}
#endif
// char geomXXXX []= {
// /* Nb Coords = */ 3,
// /* Nb Faces = */ 
// /* Nb Segments = */
// /* Nb Particles = */
// // Coord List : X, Y, Z, unused
// // Face List : idxPoint1, idxPoint2, idxPoint3, character 
// // Segment List : idxPoint1, idxPoint2, idxPoint3, character 
// // Particle List : idxPoint1, character 

// }




#if defined(COLORDEMO) || defined(LRSDEMO)

#ifndef USE_REWORKED_BUFFERS
void addPlan(signed char X, signed char Y, unsigned char L, signed char orientation, char char2disp) {
    unsigned char ii, jj;
    ii = (orientation == 0) ? 0 : -L;
    jj = (orientation == 0) ? -L : 0;
    //printf ("plane [%d %d], l= %d, ori = %d, t = %c\n", X	, Y, L, orientation, char2disp); get();
    points3d[nbPoints * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPoints * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPoints * SIZEOF_3DPOINT + 2] = 8;
    //printf ("p3d [%d %d %d]\n", points3d[nbPoints* SIZEOF_3DPOINT + 0]	, points3d[nbPoints* SIZEOF_3DPOINT + 1], points3d[nbPoints* SIZEOF_3DPOINT + 2]); get();
    nbPoints++;
    ii                                   = (orientation == 0) ? 0 : -L;
    jj                                   = (orientation == 0) ? -L : 0;
    points3d[nbPoints * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPoints * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPoints * SIZEOF_3DPOINT + 2] = 0;
    //printf ("p3d [%d %d %d]\n", points3d[nbPoints* SIZEOF_3DPOINT + 0]	, points3d[nbPoints* SIZEOF_3DPOINT + 1], points3d[nbPoints* SIZEOF_3DPOINT + 2]); get();
    nbPoints++;
    ii                                   = (orientation == 0) ? (0) : L;
    jj                                   = (orientation == 0) ? (L) : 0;
    points3d[nbPoints * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPoints * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPoints * SIZEOF_3DPOINT + 2] = 0;
    //printf ("p3d [%d %d %d]\n", points3d[nbPoints* SIZEOF_3DPOINT + 0]	, points3d[nbPoints* SIZEOF_3DPOINT + 1], points3d[nbPoints* SIZEOF_3DPOINT + 2]); get();
    nbPoints++;
    ii                                   = (orientation == 0) ? (0) : L;
    jj                                   = (orientation == 0) ? (L) : 0;
    points3d[nbPoints * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPoints * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPoints * SIZEOF_3DPOINT + 2] = 8;
    //printf ("p3d [%d %d %d]\n", points3d[nbPoints* SIZEOF_3DPOINT + 0]	, points3d[nbPoints* SIZEOF_3DPOINT + 1], points3d[nbPoints* SIZEOF_3DPOINT + 2]); get();
    nbPoints++;
    faces[nbFaces * SIZEOF_FACE + 0] = nbPoints - 4;  // Index Point 1
    faces[nbFaces * SIZEOF_FACE + 1] = nbPoints - 3;  // Index Point 2
    faces[nbFaces * SIZEOF_FACE + 2] = nbPoints - 2;  // Index Point 3
    faces[nbFaces * SIZEOF_FACE + 3] = char2disp;  // Index Point 3
    nbFaces++;
    faces[nbFaces * SIZEOF_FACE + 0] = nbPoints - 4;  // Index Point 1
    faces[nbFaces * SIZEOF_FACE + 1] = nbPoints - 2;  // Index Point 2
    faces[nbFaces * SIZEOF_FACE + 2] = nbPoints - 1;  // Index Point 3
    faces[nbFaces * SIZEOF_FACE + 3] = char2disp;  // Index Point 3
    nbFaces++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPoints - 4;  // Index Point 1
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPoints - 3;  // Index Point 2
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '|';        // Character
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPoints - 3;  // Index Point 1
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPoints - 2;  // Index Point 2
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';        // Character
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPoints - 2;  // Index Point 1
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPoints - 1;  // Index Point 2
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '|';        // Character
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPoints - 4;  // Index Point 1
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPoints - 1;  // Index Point 2
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';        // Character
    nbSegments++;
    //printf ("%d Points, %d Segments, %d Faces\n", nbPoints, nbSegments, nbFaces); get();
}
#endif // USE_REWORKED_BUFFERS
#endif  // COLORDEMO



char geomTriangle []= {
/* Nb Coords = */ 3,
/* Nb Faces = */ 1,
/* Nb Segments = */ 3,
/* Nb Particles = */ 0,
// Coord List : X, Y, Z, unused
-1, 0, 0, 0, 
 1, 0, 0, 0,
 0, 0, 2, 0,
// Face List : idxPoint1, idxPoint2, idxPoint3, character 
 0, 1, 2, '.',
// Segment List : idxPoint1, idxPoint2, idxPoint3, character 
0, 2, '/', 0,
1, 2, '/', 0,
0, 1, '-', 0,
// Particle List : idxPoint1, character 
};

char geomRectangle []= {
/* Nb Coords = */ 4,
/* Nb Faces = */ 2,
/* Nb Segments = */ 4,
/* Nb Particles = */ 0,
// Coord List : X, Y, Z, unused
-1, 0, 0, 0, 
 1, 0, 0, 0,
-1, 0, 2, 0,
 1, 0, 2, 0,
// Face List : idxPoint1, idxPoint2, idxPoint3, character 
 0, 1, 2, TEXTURE_4,
 1, 2, 3, TEXTURE_4,
// Segment List : idxPoint1, idxPoint2, idxPoint3, character 
0, 2, '|', 0,
2, 3, '-', 0,
3, 1, '|', 0,
1, 0, '-', 0,
// Particle List : idxPoint1, character 
};

#ifdef HRSDEMO

#include "geomCube.c"
#endif // HRSDEMO

#if defined(COLORDEMO) || defined(LRSDEMO) || defined(RTDEMO) || defined(PROFBENCH)


#include "geomPine.c"

#include "geomTower.c"

char geomHouse []= {
/* Nb Coords = */ 10,
/* Nb Faces = */ 11,
/* Nb Segments = */ 14,
/* Nb Particles = */ 0,
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

// Particle List : idxPoint1, character 
};
#endif // LRSDEMO
