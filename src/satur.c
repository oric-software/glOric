#ifdef USE_SATURATION

// #define USE_C_INITSATUR_A1RIGHT
#ifdef USE_C_INITSATUR_A1RIGHT
void initSatur_A1Right() {
    if (A1X > SCREEN_WIDTH - 1) {
        A1XSatur = 1;
    } else if (A1X == SCREEN_WIDTH - 1) {
        if (A1sX == 1) {
            A1XSatur = 1;
        } else {
            A1XSatur = 0;
        }
    } else {
        A1XSatur = 0;
    }

#ifndef USE_COLOR
    if (A2X < 0) {
#else
    if (A2X < COLUMN_OF_COLOR_ATTRIBUTE) {
#endif             
        A2XSatur = 1;
    } 
#ifndef USE_COLOR
    else if (A2X == 0) {
        
#else
    else if (A2X == COLUMN_OF_COLOR_ATTRIBUTE) {
#endif
        if (A2sX == 1) {
            A2XSatur = 0;
        } else {
            A2XSatur = 1;
        }

    } else {
        A2XSatur = 0;
    }
}
#endif // USE_C_INITSATUR_A1RIGHT

#ifdef USE_C_INITSATUR_A1LEFT
void initSatur_A1Left() {
    if (A2X > SCREEN_WIDTH - 1) {
        A2XSatur = 1;
    } else if (A2X == SCREEN_WIDTH - 1) {
        if (A2sX == 1){
            A2XSatur = 1;
        } else {
            A2XSatur = 0;
        }
    } else {
        A2XSatur = 0;
    }

#ifndef USE_COLOR
    if (A1X < 0) {
#else
    if (A1X < COLUMN_OF_COLOR_ATTRIBUTE) {
#endif             
        A1XSatur = 1;
#ifndef USE_COLOR
    } else if (A1X == 0) {
#else
    } else if (A1X == COLUMN_OF_COLOR_ATTRIBUTE) {
#endif             
        if (A1sX == 1){
            A1XSatur = 0;
        } else {
            A1XSatur = 1;
        }
    } else {
        A1XSatur = 0;
    }
}
#endif // USE_C_INITSATUR_A1LEFT

#ifdef USE_C_SWITCH_A1XSATUR
void switch_A1XSatur(){
    if (A1XSatur == 0) {
        A1XSatur = 1;
    } else {
        A1XSatur = 0;
    }
}
#endif //USE_C_SWITCH_A1XSATUR

#ifdef USE_C_SWITCH_A2XSATUR
void switch_A2XSatur(){
    if (A2XSatur == 0) {
        A2XSatur = 1;
    } else {
        A2XSatur = 0;
    }
}
#endif //USE_C_SWITCH_A2XSATUR
#endif // USE_SATURATION
