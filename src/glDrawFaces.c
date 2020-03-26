#ifdef USE_C_GLDRAWFACES 

void glDrawFaces() {
    unsigned char ii = 0;

#ifdef USE_PROFILER
PROFILE_ENTER(ROUTINE_GLDRAWFACES);
#endif // USE_PROFILER
    // printf ("%d Points, %d Segments, %d Faces\n", nbPoints, nbSegments, nbFaces); get();
    for (ii = 0; ii < nbFaces; ii++) {

        idxPt1 = facesPt1[ii] ;
        idxPt2 = facesPt2[ii] ;
        idxPt3 = facesPt3[ii] ;
        ch2disp = facesChar[ii];

#ifdef USE_PROFILER
            PROFILE_ENTER(ROUTINE_RETRIEVEFACEDATA);
#endif
        retrieveFaceData();
#ifdef USE_PROFILER
            PROFILE_LEAVE(ROUTINE_RETRIEVEFACEDATA);
#endif

        // printf ("P1 [%d, %d], P2 [%d, %d], P3 [%d %d]\n", P1AH, P1AV, P2AH, P2AV,  P3AH, P3AV); get();

#ifdef USE_PROFILER
            PROFILE_ENTER(ROUTINE_SORTPOINTS);
#endif
        sortPoints();
#ifdef USE_PROFILER
            PROFILE_LEAVE(ROUTINE_SORTPOINTS);
#endif

        // printf ("AHs [%d, %d, %d] [%x, %x], %x], %x, %x, %x]\n", P1AH, P2AH, P3AH, m1, m2, m3, v1,v2,v3);get();
#ifdef USE_PROFILER
            PROFILE_ENTER(ROUTINE_GUESSIFFACEISVISIBE);
#endif
        guessIfFace2BeDrawn();
#ifdef USE_PROFILER
            PROFILE_LEAVE(ROUTINE_GUESSIFFACEISVISIBE);
#endif
        if (isFace2BeDrawn) {
#ifdef USE_PROFILER
            PROFILE_ENTER(ROUTINE_FILLFACE);
#endif
            fillFace();
#ifdef USE_PROFILER
            PROFILE_LEAVE(ROUTINE_FILLFACE);
#endif
        }
    }
#ifdef USE_PROFILER
PROFILE_LEAVE(ROUTINE_GLDRAWFACES);
#endif // USE_PROFILER

}

#endif // USE_C_GLDRAWFACES 
