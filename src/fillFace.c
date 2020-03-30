#ifdef USE_C_FILLFACE
void fillFace() {
    angle2screen();

    // printf ("P1A: [%d, %d], P2A: [%d, %d], P3A [%d, %d]\n", P1AH, P1AV, P2AH, P2AV, P3AH, P3AV);
    // printf ("P1:[%d, %d], P2:[%d, %d], P3[%d, %d]\n", P1X, P1Y, P2X, P2Y, P3X, P3Y);waitkey();
    // printf ("distface = %d char = %d\n",distface, ch2disp);
    // get();

// #ifdef USE_PROFILER
//             PROFILE_ENTER(ROUTINE_FILL8);
// #endif
    fill8();
// #ifdef USE_PROFILER
//             PROFILE_LEAVE(ROUTINE_FILL8);
// #endif
}
#endif // USE_C_FILLFACE
