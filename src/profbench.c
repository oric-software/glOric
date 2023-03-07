#include "config.h"
#include "profile.h"

#ifdef PROFBENCH

#include "glOric.h"
// #include "data\geom.h"
#include "util\keyboard.h"
#include "data\traj.h"
#include "geomHouse.c"
#include "geomPine.c"
#include "geomTower.c"
void profbench() {
    int ii;
    unsigned char state, kk;
    change_char(36, 0x80, 0x40, 020, 0x10, 0x08, 0x04, 0x02, 0x01);

    glNbVertices        = 0;
    glNbSegments   = 0;
    glNbFaces      = 0;
    glNbParticles = 0;

    glLoadShape(0, 0, 0,  0, geomHouse);
    glLoadShape(24, 12, 0, 0, geomPine);
    glLoadShape(24, -24, 0, 0, geomTower);
    
    // printf ("%d Points, %d Particles, %d Segments, %d Faces\n", glNbVertices, glNbParticles, glNbSegments, glNbFaces); get();

    text();

    initColors();


    glCamPosX = 74;
    glCamPosY = 0;
    glCamPosZ = 6;

    glCamRotZ = -128;
    glCamRotX = 0;



    kernelInit();

    ProfilerInitialize();

    ii = 74; 
    state = 0;

    while (state != 5) {

        ProfilerNextFrame();

        PROFILE_ENTER(ROUTINE_GLOBAL);
        switch (state) {
            case 0:
                if (ii > 0) {
                    glCamPosX -- ; 
                    ii--;
                } else {
                    ii = 32; 
                    state = 1;
                }
            break;
            case 1:
                if (ii > 0) {
                    glCamRotZ += 4 ; 
                    ii--;
                } else {
                    ii = 24; 
                    state = 2;
                }
            break;
            case 2:
                if (ii > 0) {
                    glCamPosX ++ ; 
                    ii--;
                } else {
                    ii = 32; 
                    state = 3;
                }
            break;
            case 3:
                if (ii > 0) {
                    glCamRotZ += 4 ; 
                    ii--;
                } else {
                    ii = 64; 
                    state = 4;
                    kk=0;
                }
            break;
            case 4:
                if (ii > 0) {
                    glCamPosX = traj[kk++];
                    glCamPosY = traj[kk++];
                    glCamRotZ = traj[kk++];
                    kk       = kk % (NB_POINTS_TRAJ * SIZE_POINTS_TRAJ);
                    ii--;
                } else {
                    ii = 64; 
                    state = 5;
                }
            break;
        }
         PROFILE_ENTER(ROUTINE_KEYEVENT);
        keyEvent();
        PROFILE_LEAVE(ROUTINE_KEYEVENT);

        PROFILE_ENTER(ROUTINE_GLPROJECTARRAYS);
        glProjectArrays();
        PROFILE_LEAVE(ROUTINE_GLPROJECTARRAYS);


        PROFILE_ENTER(ROUTINE_INITSCREENBUFFERS);
        glInitScreenBuffers();
        PROFILE_LEAVE(ROUTINE_INITSCREENBUFFERS);

        glDrawFaces();
        glDrawSegments();
        glDrawParticles();

        PROFILE_ENTER(ROUTINE_BUFFER2SCREEN);
        glBuffer2Screen();
        PROFILE_LEAVE(ROUTINE_BUFFER2SCREEN);

        PROFILE_LEAVE(ROUTINE_GLOBAL);

        ProfilerDisplay();

    }
    
    ProfilerTerminate();
    cls();
    kernelExit();
}
void move(char key) {
    switch (key) {
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
}

#endif // PROFBENCH