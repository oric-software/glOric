#include "config.h"
#include "glOric.h"

#ifdef TEXTDEMO

#include "data/alphabet.h"
#include "data/geom.h"

// GEOMETRY BUFFERS
#ifdef USE_REWORKED_BUFFERS
extern char points3d[];
extern char points3d[];

extern unsigned char nbPoints;
extern signed char points3dX[];
extern signed char points3dY[];
extern signed char points3dZ[];

extern unsigned char segmentsPt1[];
extern unsigned char segmentsPt2[];
extern unsigned char segmentsChar[];


#else
extern char                 points3d[]; // NB_MAX_POINTS * SIZEOF_3DPOINT
extern char                 points2d[]; // NB_MAX_POINTS * SIZEOF_2DPOINT
extern unsigned char        nbPoints;
extern unsigned char segments[];
extern unsigned char nbSegments;
#endif USE_REWORKED_BUFFER


const char sentence[] = "MERCI RENE";

char status_string[50];

void dispInfo() {
    sprintf(status_string, "(X=%d Y=%d Z=%d) [%d %d]", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
    AdvancedPrint(3, 0, status_string);
}

#ifdef USE_COLLISION_DETECTION
unsigned char isAllowedPosition(signed int X, signed int Y, signed int Z) {
    return 1;
}
#endif

void initBuffers() {
    unsigned char ii;
    char          c;
    ii    = 0;
    nbPoints = 0;
    while ((c = sentence[ii]) != 0) {
        switch (c) {
        case 'M':
            addGeom(ii*8, 0, 0, 1, 1, 1, 0, geomLetterM);
            break;
        case 'C':
            addGeom(ii*8, 0, 0, 1, 1, 1, 0, geomLetterC);
            break;
        case 'I':
            addGeom(ii*8, 0, 0, 1, 1, 1, 0, geomLetterI);
            break;
        case 'R':
            addGeom(ii*8, 0, 0, 1, 1, 1, 0, geomLetterR);
            break;
        case 'E':
            addGeom(ii*8, 0, 0, 1, 1, 1, 0, geomLetterE);
            break;
        case 'N':
            addGeom(ii*8, 0, 0, 1, 1, 1, 0, geomLetterN);
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

    CamPosX = -15;
    CamPosY = -85;
    CamPosZ = 2;

    CamRotZ = 64;  // -128 -> -127 unit : 2PI/(2^8 - 1)
    CamRotX = -4;

#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, nbPoints, 0);
#endif // USE_REWORKED_BUFFERS

    clearScreen();

#ifdef USE_REWORKED_BUFFERS
    glDrawSegments();
#else
    drawSegments();
#endif // USE_REWORKED_BUFFERS

    for (i      = 0; i < 40; i++,
        CamPosX = (i % 4 == 0) ? CamPosX + 1 : CamPosX,
        CamPosY += 2,
        CamRotZ -= 1,
        CamRotX = (i % 2 == 0) ? CamRotX + 1 : CamRotX) {
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, nbPoints, 0);
#endif // USE_REWORKED_BUFFERS

        clearScreen();

#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        drawSegments();
#endif // USE_REWORKED_BUFFERS
    }

    CamPosX = -5;
    CamPosY = -5;
    CamPosZ = 2;
    CamRotZ = 24;  // -128 -> -127 unit : 2PI/(2^8 - 1)
    CamRotX = 16;

    for (i = 0; i < 72; i++, CamPosX++) {
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, nbPoints, 0);
#endif // USE_REWORKED_BUFFERS
        clearScreen();
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        drawSegments();
#endif // USE_REWORKED_BUFFERS
    }

    for (i = 0; i < 40; i++, CamPosX = (i % 4 == 0) ? CamPosX - 1 : CamPosX, CamRotX = (i % 4 == 0) ? CamRotX - 1 : CamRotX, CamPosY = (i % 4 == 0) ? CamPosY - 1 : CamPosY, CamRotZ++) {
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, nbPoints, 0);
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
    glProject(points2d, points3d, nbPoints, 0);
#endif // USE_REWORKED_BUFFERS
    clearScreen();
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        drawSegments();
#endif // USE_REWORKED_BUFFERS

    for (i = 0; i < 25; i++, CamPosX -= 2) {
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, nbPoints, 0);
#endif // USE_REWORKED_BUFFERS
        clearScreen();
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        drawSegments();
#endif // USE_REWORKED_BUFFERS
    }
    CamRotZ -= 1;
    for (i = 0; i < 11; i++, CamPosY -= 2, CamRotZ -= 3) {
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, nbPoints, 0);
#endif // USE_REWORKED_BUFFERS
        clearScreen();
#ifdef USE_REWORKED_BUFFERS
        glDrawSegments();
#else
        drawSegments();
#endif // USE_REWORKED_BUFFERS
    }
    CamRotZ -= 3;
#ifdef USE_REWORKED_BUFFERS
        glProjectArrays();
#else
        glProject(points2d, points3d, nbPoints, 0);
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
        glProject(points2d, points3d, nbPoints, 0);
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
#endif // USE_REWORKED_BUFFERS
    }
}

void textDemo() {
    lores0();

    initBuffers();

    // Camera Position
    CamPosX = -14;
    CamPosY = -87;
    CamPosZ = 2;

    // Camera Orientation
    CamRotZ = 64;  // -128 -> -127 unit : 2PI/(2^8 - 1)
    CamRotX = 0;

    txtIntro();

    txtGameLoop();
}
#endif