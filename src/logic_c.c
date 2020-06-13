#ifdef USE_COLLISION_DETECTION
extern unsigned char isAllowedPosition(signed char X, signed char Y, signed char Z);
#endif

void forward() {
#ifdef USE_COLLISION_DETECTION
    signed int X, Y;
    X = glCamPosX;
    Y = glCamPosY;
#endif

    if (-112 >= glCamRotZ) {
        glCamPosX--;
    } else if ((-112 < glCamRotZ) && (-80 >= glCamRotZ)) {
        glCamPosX--;
        glCamPosY--;
    } else if ((-80 < glCamRotZ) && (-48 >= glCamRotZ)) {
        glCamPosY--;
    } else if ((-48 < glCamRotZ) && (-16 >= glCamRotZ)) {
        glCamPosX++;
        glCamPosY--;
    } else if ((-16 < glCamRotZ) && (16 >= glCamRotZ)) {
        glCamPosX++;
    } else if ((16 < glCamRotZ) && (48 >= glCamRotZ)) {
        glCamPosX++;
        glCamPosY++;
    } else if ((48 < glCamRotZ) && (80 >= glCamRotZ)) {
        glCamPosY++;
    } else if ((80 < glCamRotZ) && (112 >= glCamRotZ)) {
        glCamPosX--;
        glCamPosY++;
    } else {
        glCamPosX--;
    }
#ifdef USE_COLLISION_DETECTION
    if (!isAllowedPosition(glCamPosX, glCamPosY, glCamPosZ)) {
        glCamPosX = X;
        glCamPosY = Y;
    }
#endif
}
void backward() {
#ifdef USE_COLLISION_DETECTION
    signed int X, Y;
    X = glCamPosX;
    Y = glCamPosY;
#endif
    if (-112 >= glCamRotZ) {
        glCamPosX++;
    } else if ((-112 < glCamRotZ) && (-80 >= glCamRotZ)) {
        glCamPosX++;
        glCamPosY++;
    } else if ((-80 < glCamRotZ) && (-48 >= glCamRotZ)) {
        glCamPosY++;
    } else if ((-48 < glCamRotZ) && (-16 >= glCamRotZ)) {
        glCamPosX--;
        glCamPosY++;
    } else if ((-16 < glCamRotZ) && (16 >= glCamRotZ)) {
        glCamPosX--;
    } else if ((16 < glCamRotZ) && (48 >= glCamRotZ)) {
        glCamPosX--;
        glCamPosY--;
    } else if ((48 < glCamRotZ) && (80 >= glCamRotZ)) {
        glCamPosY--;
    } else if ((80 < glCamRotZ) && (112 >= glCamRotZ)) {
        glCamPosX++;
        glCamPosY--;
    } else {
        glCamPosX++;
    }
#ifdef USE_COLLISION_DETECTION
    if (!isAllowedPosition(glCamPosX, glCamPosY, glCamPosZ)) {
        glCamPosX = X;
        glCamPosY = Y;
    }
#endif
}
void shiftLeft() {
#ifdef USE_COLLISION_DETECTION
    signed int X, Y;
    X = glCamPosX;
    Y = glCamPosY;
#endif
    if (-112 >= glCamRotZ) {
        glCamPosY--;
    } else if ((-112 < glCamRotZ) && (-80 >= glCamRotZ)) {
        glCamPosX++;
        glCamPosY--;
    } else if ((-80 < glCamRotZ) && (-48 >= glCamRotZ)) {
        glCamPosX--;
    } else if ((-48 < glCamRotZ) && (-16 >= glCamRotZ)) {
        glCamPosX++;
        glCamPosY++;
    } else if ((-16 < glCamRotZ) && (16 >= glCamRotZ)) {
        glCamPosY++;
    } else if ((16 < glCamRotZ) && (48 >= glCamRotZ)) {
        glCamPosX--;
        glCamPosY++;
    } else if ((48 < glCamRotZ) && (80 >= glCamRotZ)) {
        glCamPosX--;
    } else if ((80 < glCamRotZ) && (112 >= glCamRotZ)) {
        glCamPosX--;
        glCamPosY--;
    } else {
        glCamPosY--;
    }
#ifdef USE_COLLISION_DETECTION
    if (!isAllowedPosition(glCamPosX, glCamPosY, glCamPosZ)) {
        glCamPosX = X;
        glCamPosY = Y;
    }
#endif
}
void shiftRight() {
#ifdef USE_COLLISION_DETECTION
    signed int X, Y;
    X = glCamPosX;
    Y = glCamPosY;
#endif
    if (-112 >= glCamRotZ) {
        glCamPosY++;
    } else if ((-112 < glCamRotZ) && (-80 >= glCamRotZ)) {
        glCamPosX--;
        glCamPosY++;
    } else if ((-80 < glCamRotZ) && (-48 >= glCamRotZ)) {
        glCamPosX++;
    } else if ((-48 < glCamRotZ) && (-16 >= glCamRotZ)) {
        glCamPosX--;
        glCamPosY--;
    } else if ((-16 < glCamRotZ) && (16 >= glCamRotZ)) {
        glCamPosY--;
    } else if ((16 < glCamRotZ) && (48 >= glCamRotZ)) {
        glCamPosX++;
        glCamPosY--;
    } else if ((48 < glCamRotZ) && (80 >= glCamRotZ)) {
        glCamPosX++;
    } else if ((80 < glCamRotZ) && (112 >= glCamRotZ)) {
        glCamPosX++;
        glCamPosY++;
    } else {
        glCamPosX++;
    }
#ifdef USE_COLLISION_DETECTION
    if (!isAllowedPosition(glCamPosX, glCamPosY, glCamPosZ)) {
        glCamPosX = X;
        glCamPosY = Y;
    }
#endif
}
