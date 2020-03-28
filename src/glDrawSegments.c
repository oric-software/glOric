#ifdef USE_C_GLDRAWSEGMENTS
void glDrawSegments() {
    unsigned char ii = 0;
 
#ifdef USE_PROFILER
PROFILE_ENTER(ROUTINE_GLDRAWSEGMENTS);
#endif // USE_PROFILER

    for (ii = 0; ii < nbSegments; ii++) {

        idxPt1    = segmentsPt1[ii];
        idxPt2    = segmentsPt2[ii];
        ch2disp = segmentsChar[ii];

        // dmoy = (d1+d2)/2;

#ifdef ANGLEONLY
        P1AH = points2aH[idxPt1];
        P1AV = points2aV[idxPt1];
#else 
        P1X = points2aH[idxPt1];
        P1Y = points2aV[idxPt1];
#endif
        dmoy = points2dL[idxPt1];


#ifdef ANGLEONLY
        P2AH = points2aH[idxPt2];
        P2AV = points2aV[idxPt2];
#else 
        P2X = points2aH[idxPt2];
        P2Y = points2aV[idxPt2];
#endif        
        dmoy += points2dL[idxPt2];

        dmoy = dmoy >> 1;
        

        //if (dmoy >= 256) {
        if ((dmoy & 0xFF00) != 0)
            continue;
        distseg = (unsigned char)((dmoy)&0x00FF);
        distseg--;  // FIXME

#ifdef ANGLEONLY
        P1X = (SCREEN_WIDTH - P1AH) >> 1;
        P1Y = (SCREEN_HEIGHT - P1AV) >> 1;
        P2X = (SCREEN_WIDTH - P2AH) >> 1;
        P2Y = (SCREEN_HEIGHT - P2AV) >> 1;
#endif
        // printf ("dl ([%d, %d] , [%d, %d] => %d c=%d\n", P1X, P1Y, P2X, P2Y, distseg, ch2disp); waitkey();
        lrDrawLine();
    }
#ifdef USE_PROFILER
PROFILE_LEAVE(ROUTINE_GLDRAWSEGMENTS);
#endif // USE_PROFILER
}

#endif // USE_C_GLDRAWSEGMENTS
