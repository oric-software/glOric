#include "config.h"
//#include "glOric.h"

#ifdef TEXTDEMO

#include "glOric_h.h"

#include "data/alphabet.h"
// #include "data/geom.h"



// GEOMETRY BUFFERS
#ifdef USE_REWORKED_BUFFERS
extern char points3d[];
extern char points3d[];

extern unsigned char glNbVertices;
extern signed char glVerticesX[];
extern signed char glVerticesY[];
extern signed char glVerticesZ[];

extern unsigned char glSegmentsPt1[];
extern unsigned char glSegmentsPt2[];
extern unsigned char glSegmentsChar[];


#else
extern char                 points3d[]; // NB_MAX_VERTICES * SIZEOF_3DPOINT
extern char                 points2d[]; // NB_MAX_VERTICES * SIZEOF_2DPOINT
extern unsigned char        glNbVertices;
extern unsigned char segments[];
extern unsigned char glNbSegments;
#endif USE_REWORKED_BUFFER
// #include "geomHouse.c"
#include "logic_c.c"
#include "addGeom.c"

const char sentence[] = "MERCI RENE";

char status_string[50];

void dispInfo() {
    sprintf(status_string, "(X=%d Y=%d Z=%d) [%d %d]", glCamPosX, glCamPosY, glCamPosZ, glCamRotZ, glCamRotX);
    AdvancedPrint(3, 0, status_string);
}

#ifdef USE_COLLISION_DETECTION
unsigned char isAllowedPosition(signed char X, signed char Y, signed char Z) {
    return 1;
}
#endif

void initBuffers() {
    unsigned char ii;
    char          c;
    ii    = 0;
    glNbVertices = 0;
    while ((c = sentence[ii]) != 0) {
        switch (c) {
        case 'M':
            addGeom2(ii*8, 0, 0, 1, 1, 1, 0, (signed char *)geomLetterM);
            break;
        case 'C':
            addGeom2(ii*8, 0, 0, 1, 1, 1, 0, (signed char *)geomLetterC);
            break;
        case 'I':
            addGeom2(ii*8, 0, 0, 1, 1, 1, 0, (signed char *)geomLetterI);
            break;
        case 'R':
            addGeom2(ii*8, 0, 0, 1, 1, 1, 0, (signed char *)geomLetterR);
            break;
        case 'E':
            addGeom2(ii*8, 0, 0, 1, 1, 1, 0, (signed char *)geomLetterE);
            break;
        case 'N':
            addGeom2(ii*8, 0, 0, 1, 1, 1, 0, (signed char *)geomLetterN);
            break;
        default:
            break;
        }
        ii++;
    }
}

void txtIntro() {
    int i;

    enterSC();

    glCamPosX = -15;
    glCamPosY = -85;
    glCamPosZ = 2;

    glCamRotZ = 64;  // -128 -> -127 unit : 2PI/(2^8 - 1)
    glCamRotX = -4;

#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, glNbVertices, 0);
#endif // USE_REWORKED_BUFFERS

    clearScreen();

#ifdef USE_REWORKED_BUFFERS
    glDrawSegments();
#else
    drawSegments();
#endif // USE_REWORKED_BUFFERS

    for (i      = 0; i < 40; i++,
        glCamPosX = (i % 4 == 0) ? glCamPosX + 1 : glCamPosX,
        glCamPosY += 2,
        glCamRotZ -= 1,
        glCamRotX = (i % 2 == 0) ? glCamRotX + 1 : glCamRotX) {
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, glNbVertices, 0);
#endif // USE_REWORKED_BUFFERS

        clearScreen();

#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        drawSegments();
#endif // USE_REWORKED_BUFFERS
    }

    glCamPosX = -5;
    glCamPosY = -5;
    glCamPosZ = 2;
    glCamRotZ = 24;  // -128 -> -127 unit : 2PI/(2^8 - 1)
    glCamRotX = 16;

    for (i = 0; i < 72; i++, glCamPosX++) {
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, glNbVertices, 0);
#endif // USE_REWORKED_BUFFERS
        clearScreen();
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        drawSegments();
#endif // USE_REWORKED_BUFFERS
    }

    for (i = 0; i < 40; i++, glCamPosX = (i % 4 == 0) ? glCamPosX - 1 : glCamPosX, glCamRotX = (i % 4 == 0) ? glCamRotX - 1 : glCamRotX, glCamPosY = (i % 4 == 0) ? glCamPosY - 1 : glCamPosY, glCamRotZ++) {
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, glNbVertices, 0);
#endif // USE_REWORKED_BUFFERS
        clearScreen();
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        drawSegments();
#endif // USE_REWORKED_BUFFERS
    }
    forward();
#ifdef USE_REWORKED_BUFFERS
    glProjectArrays();
#else
    glProject(points2d, points3d, glNbVertices, 0);
#endif // USE_REWORKED_BUFFERS
    clearScreen();
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        drawSegments();
#endif // USE_REWORKED_BUFFERS

    for (i = 0; i < 25; i++, glCamPosX -= 2) {
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, glNbVertices, 0);
#endif // USE_REWORKED_BUFFERS
        clearScreen();
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        drawSegments();
#endif // USE_REWORKED_BUFFERS
    }
    glCamRotZ -= 1;
    for (i = 0; i < 11; i++, glCamPosY -= 2, glCamRotZ -= 3) {
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, glNbVertices, 0);
#endif // USE_REWORKED_BUFFERS
        clearScreen();
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        drawSegments();
#endif // USE_REWORKED_BUFFERS
    }
    glCamRotZ -= 3;
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, glNbVertices, 0);
#endif // USE_REWORKED_BUFFERS
    clearScreen();
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        drawSegments();
#endif // USE_REWORKED_BUFFERS

    leaveSC();
}

void txtGameLoop() {
    char key;
    //key=get();
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, glNbVertices, 0);
#endif // USE_REWORKED_BUFFERS

    while (1 == 1) {
        clearScreen();
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        drawSegments();
#endif // USE_REWORKED_BUFFERS
        dispInfo();
        key = get();
        switch (key)  // key
        {
        case 8:  // gauche => tourne gauche
            glCamRotZ += 4;
            break;
        case 9:  // droite => tourne droite
            glCamRotZ -= 4;
            break;
        case 10:  // bas => recule
            backward();
            break;
        case 11:  // haut => avance
            forward();
            break;
        case 80:  // P
            glCamPosZ += 1;
            break;
        case 59:  // ;
            glCamPosZ -= 1;
            break;
        case 81:  // Q
            glCamRotX += 2;
            break;
        case 65:  // A
            glCamRotX -= 2;
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
        glProject(points2d, points3d, glNbVertices, 0);
#endif // USE_REWORKED_BUFFERS
    }
}

void textDemo() {
    lores0();

    initBuffers();

    // Camera Position
    glCamPosX = -14;
    glCamPosY = -87;
    glCamPosZ = 2;

    // Camera Orientation
    glCamRotZ = 64;  // -128 -> -127 unit : 2PI/(2^8 - 1)
    glCamRotX = 0;

    txtIntro();

    txtGameLoop();
}
#endif