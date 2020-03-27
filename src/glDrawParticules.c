#ifdef USE_C_GLDRAWPARTICULES
void glDrawParticules(){
    unsigned char ii = 0;

    unsigned char idxPt, offPt, dchar;
    unsigned int  dist;

#ifdef USE_PROFILER
PROFILE_ENTER(ROUTINE_GLDRAWPARTICULES);
#endif // USE_PROFILER

    for (ii = 0; ii < nbParticules; ii++) {
        idxPt    = particulesPt[ii];  // ii*SIZEOF_SEGMENT +0
        ch2disp = particulesChar[ii];    // ii*SIZEOF_SEGMENT +2
        // printf ("particules : %d %d\n ", idxPt, ch2disp);
        dchar = points2dL[idxPt]-2 ; //FIXME : -2 to helps particule to be displayed
        P1X = (SCREEN_WIDTH -points2aH[idxPt]) >> 1;
        P1Y = (SCREEN_HEIGHT - points2aV[idxPt]) >> 1;
#ifdef USE_ZBUFFER
        zplot(P1X, P1Y, dchar, ch2disp);
#else
        // TODO : plot a point with no z-buffer
        plot(A1X, A1Y, ch2disp);
#endif

    }
#ifdef USE_PROFILER
PROFILE_LEAVE(ROUTINE_GLDRAWPARTICULES);
#endif // USE_PROFILER

}
#endif // USE_C_GLDRAWPARTICULES
