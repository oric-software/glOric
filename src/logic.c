#include "config.h"
#include "glOric.h"

#include "util\util.h"

#ifdef USE_COLLISION_DETECTION
extern unsigned char isAllowedPosition(signed int X, signed int Y, signed int Z);
#endif

void forward() {
#ifdef USE_COLLISION_DETECTION
    signed int X, Y;
    X = CamPosX;
    Y = CamPosY;
#endif

    if (-112 >= CamRotZ) {
        CamPosX--;
    } else if ((-112 < CamRotZ) && (-80 >= CamRotZ)) {
        CamPosX--;
        CamPosY--;
    } else if ((-80 < CamRotZ) && (-48 >= CamRotZ)) {
        CamPosY--;
    } else if ((-48 < CamRotZ) && (-16 >= CamRotZ)) {
        CamPosX++;
        CamPosY--;
    } else if ((-16 < CamRotZ) && (16 >= CamRotZ)) {
        CamPosX++;
    } else if ((16 < CamRotZ) && (48 >= CamRotZ)) {
        CamPosX++;
        CamPosY++;
    } else if ((48 < CamRotZ) && (80 >= CamRotZ)) {
        CamPosY++;
    } else if ((80 < CamRotZ) && (112 >= CamRotZ)) {
        CamPosX--;
        CamPosY++;
    } else {
        CamPosX--;
    }
#ifdef USE_COLLISION_DETECTION
    if (!isAllowedPosition(CamPosX, CamPosY, CamPosZ)) {
        CamPosX = X;
        CamPosY = Y;
    }
#endif
}
void backward() {
#ifdef USE_COLLISION_DETECTION
    signed int X, Y;
    X = CamPosX;
    Y = CamPosY;
#endif
    if (-112 >= CamRotZ) {
        CamPosX++;
    } else if ((-112 < CamRotZ) && (-80 >= CamRotZ)) {
        CamPosX++;
        CamPosY++;
    } else if ((-80 < CamRotZ) && (-48 >= CamRotZ)) {
        CamPosY++;
    } else if ((-48 < CamRotZ) && (-16 >= CamRotZ)) {
        CamPosX--;
        CamPosY++;
    } else if ((-16 < CamRotZ) && (16 >= CamRotZ)) {
        CamPosX--;
    } else if ((16 < CamRotZ) && (48 >= CamRotZ)) {
        CamPosX--;
        CamPosY--;
    } else if ((48 < CamRotZ) && (80 >= CamRotZ)) {
        CamPosY--;
    } else if ((80 < CamRotZ) && (112 >= CamRotZ)) {
        CamPosX++;
        CamPosY--;
    } else {
        CamPosX++;
    }
#ifdef USE_COLLISION_DETECTION
    if (!isAllowedPosition(CamPosX, CamPosY, CamPosZ)) {
        CamPosX = X;
        CamPosY = Y;
    }
#endif
}
void shiftLeft() {
#ifdef USE_COLLISION_DETECTION
    signed int X, Y;
    X = CamPosX;
    Y = CamPosY;
#endif
    if (-112 >= CamRotZ) {
        CamPosY--;
    } else if ((-112 < CamRotZ) && (-80 >= CamRotZ)) {
        CamPosX++;
        CamPosY--;
    } else if ((-80 < CamRotZ) && (-48 >= CamRotZ)) {
        CamPosX--;
    } else if ((-48 < CamRotZ) && (-16 >= CamRotZ)) {
        CamPosX++;
        CamPosY++;
    } else if ((-16 < CamRotZ) && (16 >= CamRotZ)) {
        CamPosY++;
    } else if ((16 < CamRotZ) && (48 >= CamRotZ)) {
        CamPosX--;
        CamPosY++;
    } else if ((48 < CamRotZ) && (80 >= CamRotZ)) {
        CamPosX--;
    } else if ((80 < CamRotZ) && (112 >= CamRotZ)) {
        CamPosX--;
        CamPosY--;
    } else {
        CamPosY--;
    }
#ifdef USE_COLLISION_DETECTION
    if (!isAllowedPosition(CamPosX, CamPosY, CamPosZ)) {
        CamPosX = X;
        CamPosY = Y;
    }
#endif
}
void shiftRight() {
#ifdef USE_COLLISION_DETECTION
    signed int X, Y;
    X = CamPosX;
    Y = CamPosY;
#endif
    if (-112 >= CamRotZ) {
        CamPosY++;
    } else if ((-112 < CamRotZ) && (-80 >= CamRotZ)) {
        CamPosX--;
        CamPosY++;
    } else if ((-80 < CamRotZ) && (-48 >= CamRotZ)) {
        CamPosX++;
    } else if ((-48 < CamRotZ) && (-16 >= CamRotZ)) {
        CamPosX--;
        CamPosY--;
    } else if ((-16 < CamRotZ) && (16 >= CamRotZ)) {
        CamPosY--;
    } else if ((16 < CamRotZ) && (48 >= CamRotZ)) {
        CamPosX++;
        CamPosY--;
    } else if ((48 < CamRotZ) && (80 >= CamRotZ)) {
        CamPosX++;
    } else if ((80 < CamRotZ) && (112 >= CamRotZ)) {
        CamPosX++;
        CamPosY++;
    } else {
        CamPosX++;
    }
#ifdef USE_COLLISION_DETECTION
    if (!isAllowedPosition(CamPosX, CamPosY, CamPosZ)) {
        CamPosX = X;
        CamPosY = Y;
    }
#endif
}
