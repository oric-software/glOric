#ifdef USE_C_BUFFER2SCREEN
void glBuffer2Screen(char destAdr[]) {
    memcpy(destAdr, fbuffer, SCREEN_HEIGHT* SCREEN_WIDTH);
}
#endif
