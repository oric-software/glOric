
#include "config.h"
#include "glOric.h"

#include "geom.h"

extern char          points3d[];
extern unsigned char nbPts;
extern char          points2d[];
extern char          faces[];
extern unsigned char nbFaces;
extern unsigned char segments[];
extern unsigned char nbSegments;


#ifdef HRSMODE
#endif  // HRSMODE

#ifdef LRSMODE

void addTePee(signed char X, signed char Y, unsigned char L) {
    unsigned char ii, jj;
    ii = L;
    jj = L;

    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - 2 * jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X - 2 * ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 3 * ii;
    nbPts++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 4;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 3;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 3;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 2;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 2;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 4;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 4;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 1;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '/';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 3;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 1;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '/';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 2;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 1;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '/';
    nbSegments++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 4;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 3;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = ',';        // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 3;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 2;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = '.';        // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 4;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 2;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = '\'';       // Index Point 3
    nbFaces++;
}

#endif  // LRSMODE

#ifdef LRSMODE

void addPlan(signed char X, signed char Y, unsigned char L, signed char orientation, char char2disp) {
    unsigned char ii, jj;
    ii = (orientation == 0) ? 0 : -L;
    jj = (orientation == 0) ? -L : 0;
    //printf ("plane [%d %d], l= %d, ori = %d, t = %c\n", X	, Y, L, orientation, char2disp); get();
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 3;
    //printf ("p3d [%d %d %d]\n", points3d[nbPts* SIZEOF_3DPOINT + 0]	, points3d[nbPts* SIZEOF_3DPOINT + 1], points3d[nbPts* SIZEOF_3DPOINT + 2]); get();
    nbPts++;
    ii                                   = (orientation == 0) ? 0 : -L;
    jj                                   = (orientation == 0) ? -L : 0;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    //printf ("p3d [%d %d %d]\n", points3d[nbPts* SIZEOF_3DPOINT + 0]	, points3d[nbPts* SIZEOF_3DPOINT + 1], points3d[nbPts* SIZEOF_3DPOINT + 2]); get();
    nbPts++;
    ii                                   = (orientation == 0) ? (0) : L;
    jj                                   = (orientation == 0) ? (L) : 0;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    //printf ("p3d [%d %d %d]\n", points3d[nbPts* SIZEOF_3DPOINT + 0]	, points3d[nbPts* SIZEOF_3DPOINT + 1], points3d[nbPts* SIZEOF_3DPOINT + 2]); get();
    nbPts++;
    ii                                   = (orientation == 0) ? (0) : L;
    jj                                   = (orientation == 0) ? (L) : 0;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 3;
    //printf ("p3d [%d %d %d]\n", points3d[nbPts* SIZEOF_3DPOINT + 0]	, points3d[nbPts* SIZEOF_3DPOINT + 1], points3d[nbPts* SIZEOF_3DPOINT + 2]); get();
    nbPts++;
    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 4;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 3;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 2;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = char2disp;  // Index Point 3
    nbFaces++;
    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 4;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 2;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = char2disp;  // Index Point 3
    nbFaces++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 4;  // Index Point 1
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 3;  // Index Point 2
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '|';        // Character
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 3;  // Index Point 1
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 2;  // Index Point 2
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';        // Character
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 2;  // Index Point 1
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 1;  // Index Point 2
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '|';        // Character
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 4;  // Index Point 1
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 1;  // Index Point 2
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';        // Character
    nbSegments++;
    //printf ("%d Points, %d Segments, %d Faces\n", nbPts, nbSegments, nbFaces); get();
}

void addCube3(char X, char Y, char Z) {
    unsigned char ii, jj;
    for (jj = 0; jj < NB_POINTS_CUBE; jj++) {
        points3d[(nbPts + jj) * SIZEOF_3DPOINT + 0] = ptsCube[jj * SIZEOF_3DPOINT + 0] + X;  // X coord
        points3d[(nbPts + jj) * SIZEOF_3DPOINT + 1] = ptsCube[jj * SIZEOF_3DPOINT + 1] + Y;  // Y coord
        points3d[(nbPts + jj) * SIZEOF_3DPOINT + 2] = ptsCube[jj * SIZEOF_3DPOINT + 2] + Z;  // Z coord
    }
    for (jj = 0; jj < NB_SEGMENTS_CUBE; jj++) {
        segments[(nbSegments + jj) * SIZEOF_SEGMENT + 0] = segCube[jj * SIZEOF_SEGMENT + 0] + nbPts;  // Index Point 1
        segments[(nbSegments + jj) * SIZEOF_SEGMENT + 1] = segCube[jj * SIZEOF_SEGMENT + 1] + nbPts;  // Index Point 2
        segments[(nbSegments + jj) * SIZEOF_SEGMENT + 2] = segCube[jj * SIZEOF_SEGMENT + 2];          // Character
    }
    for (jj = 0; jj < NB_FACES_CUBE; jj++) {
        faces[(nbFaces + jj) * SIZEOF_FACES + 0] = facCube[jj * SIZEOF_FACES + 0] + nbPts;  // Index Point 1
        faces[(nbFaces + jj) * SIZEOF_FACES + 1] = facCube[jj * SIZEOF_FACES + 1] + nbPts;  // Index Point 2
        faces[(nbFaces + jj) * SIZEOF_FACES + 2] = facCube[jj * SIZEOF_FACES + 2] + nbPts;  // Index Point 3
        faces[(nbFaces + jj) * SIZEOF_FACES + 3] = facCube[jj * SIZEOF_FACES + 3];          // Character
    }

    nbPts += NB_POINTS_CUBE;
    nbSegments += NB_SEGMENTS_CUBE;
    nbFaces += NB_FACES_CUBE;
}

#endif  // LRSMODE

