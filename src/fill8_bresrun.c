
#ifdef USE_SATURATION
#ifdef USE_C_BRESTYPE1
void bresStepType1() {
    // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
    reachScreen ();
    // A1Right = (A1X > A2X); 

    
    if (A1Right == 0) {
        initSatur_A1Left ();
        // printf ("bt1 A1L (%d: %d, %d) = A1XSatur=%d A2XSatur=%d\n", A1X, A2X, A1Y, A1XSatur, A2XSatur); get();
        hzfill();
        while ((A1arrived == 0) && (A1Y > 1)){
            A1stepY_A1Left();
            A2stepY_A1Left();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            // printf ("bt1 A1L (%d: %d, %d) = A1XSatur=%d A2XSatur=%d\n", A1X, A2X, A1Y, A1XSatur, A2XSatur); get();
            hzfill();
        }
    } else {
        initSatur_A1Right ();
        // printf ("bt1 A1R (%d: %d, %d) = A1XSatur=%d A2XSatur=%d\n", A1X, A2X, A1Y, A1XSatur, A2XSatur); get();
        hzfill();
        while ((A1arrived == 0) && (A1Y > 1)){
            A1stepY_A1Right();
            A2stepY_A1Right();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            // printf ("bt1 A1R (%d: %d, %d) = A1XSatur=%d A2XSatur=%d\n", A1X, A2X, A1Y, A1XSatur, A2XSatur); get();
            hzfill();
        }
    }
}
#endif // USE_C_BRESTYPE1


#ifdef USE_C_BRESTYPE2
void bresStepType2() {

    if (A1Right == 0) {
        initSatur_A1Left ();
        while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1)) {
            A1stepY_A1Left();
            A2stepY_A1Left();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            // printf ("bt2 A1L (%d: %d, %d) = A1XSatur=%d A2XSatur=%d\n", A1X, A2X, A1Y, A1XSatur, A2XSatur); get();
            hzfill();
        }
    } else {
        initSatur_A1Right ();
        while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1)){
            A1stepY_A1Right();
            A2stepY_A1Right();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            // printf ("bt2 A1R (%d: %d, %d) = A1XSatur=%d A2XSatur=%d\n", A1X, A2X, A1Y, A1XSatur, A2XSatur); get();
            hzfill();
        }
    }

}
#endif // USE_C_BRESTYPE2

#ifdef USE_C_BRESTYPE3
void bresStepType3() {

        // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); waitkey();

    reachScreen ();

    // A1Right = (A1X > A2X); 
    if (A1Right == 0) {
        initSatur_A1Left ();
        hzfill();
        while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1) ) {
            A1stepY_A1Left();
            A2stepY_A1Left();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); waitkey();
            // A1Right = (A1X > A2X); 
            hzfill();
        }
    } else {
        initSatur_A1Right ();
        hzfill();
        while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1) ) {
            A1stepY_A1Right();
            A2stepY_A1Right();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            hzfill();
        }
    }
}
#endif // USE_C_BRESTYPE3

#else // USE_SATURATION



#ifdef USE_C_BRESTYPE1

void bresStepType1() {
        // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
        reachScreen()   ;
        // A1Right = (A1X > A2X); 
        hzfill();
        while ((A1arrived == 0) && (A1Y > 1)){
            A1stepY();
            A2stepY();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            hzfill();

        }

}
#endif // USE_C_BRESTYPE1

#ifdef USE_C_BRESTYPE2
void bresStepType2() {
// #ifdef USE_PROFILER
//             PROFILE_ENTER(ROUTINE_BRESRUNTYPE2);
// #endif
       while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1)) {
            A1stepY();
            A2stepY();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            hzfill();
        }

}
#endif // USE_C_BRESTYPE2

#ifdef USE_C_BRESTYPE3

void bresStepType3() {
// #ifdef USE_PROFILER
//             PROFILE_ENTER(ROUTINE_BRESRUNTYPE3);
// #endif
        // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
        reachScreen()   ;

        // A1Right = (A1X > A2X); 
        hzfill();

        while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1) ) {
            A1stepY();
            A2stepY();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            hzfill();
        }
// #ifdef USE_PROFILER
//             PROFILE_LEAVE(ROUTINE_BRESRUNTYPE3);
// #endif
}

#endif // USE_C_BRESTYPE3

#endif // USE_SATURATION
