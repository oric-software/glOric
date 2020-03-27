
#ifdef USE_C_ZPLOT

void zplot(signed char X,
           signed char Y,
           unsigned char dist,
           char          char2disp) {
    int            offset;
    char*          ptrFbuf;
    unsigned char* ptrZbuf;

#ifdef USE_COLOR
    if ((Y <= 0) || (Y >= SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR) || (X <= 2) || (X >= SCREEN_WIDTH))
        return;
#else
    if ((Y <= 0) || (Y >= SCREEN_HEIGHT) || (X <= 0) || (X >= SCREEN_WIDTH))
        return;
#endif

#ifdef USE_MULTI40
    offset = multi40[Y] + X;  // 
#else
    offset = Y*SCREEN_WIDTH+X; 
#endif

    ptrZbuf = zbuffer + offset;
    ptrFbuf = fbuffer + offset;

    // printf ("pl [%d %d] zbuff = %d , pointDist = %d\n", X, Y, *ptrZbuf, dist);
    if (dist < *ptrZbuf) {
        *ptrFbuf = char2disp;
        *ptrZbuf = dist;
    }
}

#endif

