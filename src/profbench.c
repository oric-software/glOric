#include "config.h"
#include "profile.h"

#ifdef PROFBENCH

#include "glOric.h"
#include "data\geom.h"
#include "util\keyboard.h"



void profbench() {

    change_char(36, 0x80, 0x40, 020, 0x10, 0x08, 0x04, 0x02, 0x01);

    nbPoints        = 0;
    nbSegments   = 0;
    nbFaces      = 0;
    nbParticules = 0;

    addGeom(0, 0, 0, 12, 8, 4, 0, geomHouse);
    addGeom(24, 12, 0, 9, 9, 9, 0, geomPine);
    addGeom(24, -24, 0, 6, 6, 12, 0, geomTower);
    
    // printf ("%d Points, %d Particules, %d Segments, %d Faces\n", nbPts, nbParticules, nbSegments, nbFaces); get();

    text();

    initColors();


    CamPosX = 74;
    CamPosY = 0;
    CamPosZ = 6;

    CamRotZ = -127;
    CamRotX = 0;



    kernelInit();

    
    while (1 == 1) {
        keyEvent();
        glProjectArrays();
        initScreenBuffers();
        glDrawFaces();
        glDrawSegments();
        glDrawParticules();
        // printf ("coucou\n");
        buffer2screen((void*)ADR_BASE_LORES_SCREEN);

    }
    
}
void move(char key) {
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
}

#endif // PROFBENCH