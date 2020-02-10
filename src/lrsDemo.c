

#include "config.h"
#include "glOric.h"

#ifdef TARGET_ORIX
#include <conio.h>
#endif 

#ifdef LRSMODE

#ifdef TARGET_ORIX
#include <stdio.h>
#endif

#include "data\traj.h"
#include "data\geom.h"
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

void faceIntro();
void txtGameLoop2();
void addHouse(signed char X, signed char Y, unsigned char L, unsigned char l);

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
#endif // TARGET_ORIX
}



void faceDemo() {
    nbPts      = 0;
    nbSegments = 0;
    nbFaces    = 0;
    //addCube3(-12, -12, 0);
    //addCube3(0, 0, 0);
    //addPlan();
    change_char(36, 0x80, 0x40, 020, 0x10, 0x08, 0x04, 0x02, 0x01);
    // addPlan(0, 2, 8, 64, '.');
    // addPlan(2, 0, 2, 0, ':');
    // addPlan(0, -2, 2, 64, ';');
    // addPlan(-2, 0, 2, 0, '\'');

    // addTePee(0, 0, 3);
    //addHouse(0, 0, 12, 8);
    addTower(0, 0, 12, 12);
    //addPyramid(8, 8, 2, 4);
    //addPyramid(0, 0, 2, 4);
    //printf ("%d Points, %d Segments, %d Faces\n", nbPts, nbSegments, nbFaces); get();

#ifdef TARGET_ORIX
#else
    lores0();
#endif // TARGET_ORIX
    faceIntro();
    // CamPosX = 10;
    // CamPosY = -3;
    // CamPosZ = 2;

    // CamRotZ = 93;
    // CamRotX = 0;
   
    txtGameLoop2();
}

void faceIntro() {
    int i;
    int j;
    // get();
#ifdef TARGET_ORIX
#else
    enterSC();
#endif // TARGET_ORIX

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
        glProject(points2d, points3d, nbPts, 0);

        initScreenBuffers();
        fillFaces(points2d, faces, nbFaces);
        lrDrawSegments(points2d, segments, nbSegments);

        buffer2screen((void*)ADR_BASE_SCREEN);
    }
#ifdef TARGET_ORIX
#else
    leaveSC();
#endif // TARGET_ORIX
    
}

void txtGameLoop2() {
    char          key;
    unsigned char ii;
#ifdef TARGET_ORIX
    cgetc();
#else
    key=get();
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
    fillFaces(points2d, faces, nbFaces);
    lrDrawSegments(points2d, segments, nbSegments);
    while (1 == 1) {
        buffer2screen((void*)ADR_BASE_SCREEN);
        dispInfo();
#ifdef TARGET_ORIX
        cgetc();
#else
        key = get();
#endif // TARGET_ORIX
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
        fillFaces(points2d, faces, nbFaces);
        lrDrawSegments(points2d, segments, nbSegments);
    }
}

#ifdef USE_COLLISION_DETECTION
unsigned char isAllowedPosition(signed int X, signed int Y, signed int Z) {
    /*unsigned int aX = abs(X);
    unsigned int aY = abs(Y);
    if ((aX <= 4) && (aY <= 3)) {
        if ((aY <= 1) && (X >= -1)) {
            return 1;
        } else {
            return 0;
        }
    }*/
    return 1;
}
#endif


void addPyramid(signed char X, signed char Y, unsigned char L, unsigned char H) {
    unsigned char ii;
    ii = L;

    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;

    points3d[nbPts * SIZEOF_3DPOINT + 0] = X ;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y ;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = H;
    nbPts++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 5;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 4;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'u';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 4;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 3;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = ',';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 3;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 2;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'u';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 5;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 2;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = ',';         // Index Point 3
    nbFaces++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 5;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 4;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 4;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 3;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 3;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 2;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 2;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 5;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 5;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 1;
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

}

void addTower(signed char X, signed char Y, unsigned char L, unsigned char H) {
    unsigned char ii;
    ii = L;

    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;

    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = H;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = H;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = H;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = H;
    nbPts++;

    points3d[nbPts * SIZEOF_3DPOINT + 0] = X ;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y ;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = H + L;
    nbPts++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 9;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 8;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 4;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'b';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 9;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 4;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 5;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'c';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 8;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 7;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 3;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'd';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 8;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 3;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 4;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'e';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 6;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 7;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 3;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'g';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 6;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 3;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 2;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'h';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 9;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 6;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 2;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'i';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 9;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 2;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 5;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'j';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 5;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 4;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'k';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 4;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 3;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'l';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 3;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 2;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'm';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 2;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 5;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'n';         // Index Point 3
    nbFaces++;


    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 5;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 9;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '|';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 4;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 8;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '|';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 3;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 7;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '|';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 2;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 6;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '|';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 9;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 8;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 8;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 7;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 7;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 6;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 5;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 4;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 4;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 3;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 3;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 2;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 2;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 5;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 6;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 9;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 5;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 1;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '/';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 4;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 1;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '/';
    nbSegments++;
    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 3;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 2;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '/';
    nbSegments++;
    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 2;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 1;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '/';
    nbSegments++;
}



/*
void addHouse(signed char X, signed char Y, unsigned char L, unsigned char l) {
    unsigned char ii, jj;
    ii = L;
    jj = l;

    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 0;
    nbPts++;

    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 8;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y + jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 8;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 8;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y - jj;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 8;
    nbPts++;

    points3d[nbPts * SIZEOF_3DPOINT + 0] = X + ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 12;
    nbPts++;
    points3d[nbPts * SIZEOF_3DPOINT + 0] = X - ii;
    points3d[nbPts * SIZEOF_3DPOINT + 1] = Y;
    points3d[nbPts * SIZEOF_3DPOINT + 2] = 12;
    nbPts++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 10;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 9;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 9;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 8;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 8;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 7;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 6;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 5;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 4;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 3;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 10;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 6;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '|';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 9;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 5;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '|';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 8;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 4;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '|';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 7;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 3;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '|';
    nbSegments++;

    // ROOF
    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 6;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 2;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '/';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 3;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 2;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '/';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 5;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 1;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '/';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 4;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 1;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '/';
    nbSegments++;

    segments[nbSegments * SIZEOF_SEGMENT + 0] = nbPts - 1;
    segments[nbSegments * SIZEOF_SEGMENT + 1] = nbPts - 2;
    segments[nbSegments * SIZEOF_SEGMENT + 2] = '-';
    nbSegments++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 10;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 9;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 5;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = ',';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 10;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 6;   // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 5;   // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = ',';         // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 7;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 8;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 4;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = ',';        // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 4;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 7;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 3;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = ',';        // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 9;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 8;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 4;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = '.';        // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 9;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 4;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 5;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = '.';        // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 5;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 4;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = '.';        // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 6;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 5;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'u';        // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 6;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 1;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 2;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'u';        // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 3;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 4;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 1;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'u';        // Index Point 3
    nbFaces++;

    faces[nbFaces * SIZEOF_FACES + 0] = nbPts - 3;  // Index Point 1
    faces[nbFaces * SIZEOF_FACES + 1] = nbPts - 1;  // Index Point 2
    faces[nbFaces * SIZEOF_FACES + 2] = nbPts - 2;  // Index Point 3
    faces[nbFaces * SIZEOF_FACES + 3] = 'u';        // Index Point 3
    nbFaces++;

    //printf ("%d Points, %d Segments, %d Faces\n", nbPts, nbSegments, nbFaces); get();
}
*/
#endif