
#ifdef USE_C_INITFRAMEBUFFER
void initScreenBuffers() {
#ifdef USE_COLOR
    int ii, jj;
#endif
    memset(zbuffer, 0xFF, SCREEN_WIDTH * SCREEN_HEIGHT);
    
#ifdef USE_COLOR
    for (ii=0; ii< SCREEN_HEIGHT; ii++){
        for (jj=3; jj< SCREEN_WIDTH; jj++){
            fbuffer[ii*SCREEN_WIDTH+jj] = 0x20;
        }
    }
#else
    memset(fbuffer, 0x20, SCREEN_WIDTH * SCREEN_HEIGHT);  // Space
#endif
}
#endif // USE_C_INITFRAMEBUFFER
