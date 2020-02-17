
#include "config.h"
#include "glOric.h"

#include "data/geom.h"

extern char          points3d[];
extern unsigned char nbPts;
extern char          points2d[];
extern char          faces[];
extern unsigned char nbFaces;
extern unsigned char segments[];
extern unsigned char nbSegments;

#ifdef LRSDEMO
/*
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
*/
#endif  // LRSDEMO

#if defined(COLORDEMO) || defined(LRSDEMO)

void addPlan(signed char X, signed char Y, unsigned char L, signed char orientation, char char2disp) {
    unsigned char ii, jj;
    ii = (orientation == 0) ? 0 : -L;
    jj = (orientation == 0) ? -L : 0;
    //printf ("plane [%d %d], l= %d, ori = %d, t = %c\n", X	, Y, L, orientation, char2disp); get();
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 8;
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
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 8;
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

/*
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
*/
#endif  // COLORDEMO

#ifdef HRSDEMO

const char ptsCube[] = {
    -CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE, 0,  // P0
    -CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE, 0,  // P1
    +CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE, 0,  // P2
    +CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE, 0,  // P3
    -CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE, 0,  // P4
    -CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE, 0,  // P5
    +CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE, 0,  // P6
    +CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE, 0   // P7
};

const char segCube[] = {
    0, 1, 124, 0,  //124, 0
    1, 2, 45, 0,   //92, 0
    2, 3, 124, 0,  //47, 0
    3, 0, 45, 0,   //124, 0
    4, 5, 124, 0,  //124, 0
    5, 6, 45, 0,   //124, 0
    6, 7, 124, 0,  //92, 0
    7, 4, 45, 0,   //47, 0
    0, 4, 45, 0,   //124, 0
    1, 5, 45, 0,   //124, 0
    2, 6, 45, 0,   //124, 0
    3, 7, 45, 0    //124, 0
};

const char facCube[] = {
    0, 1, 2, 77,  //124, 0
    0, 2, 3, 77,  //92, 0
    4, 5, 1, 78,  //47, 0
    4, 1, 0, 78,  //124, 0
    7, 6, 5, 79,  //124, 0
    7, 5, 4, 79,  //124, 0
    3, 2, 6, 80,  //92, 0
    3, 6, 7, 80,  //47, 0
    4, 0, 3, 81,  //124, 0
    4, 3, 7, 81,  //124, 0
    5, 1, 2, 82,  //124, 0
    5, 2, 6, 82   //124, 0
};
#endif
