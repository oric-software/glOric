#ifdef USE_C_BUFFER2SCREEN
void glBuffer2Screen() {
    memcpy((void*)ADR_BASE_LORES_SCREEN, fbuffer, SCREEN_HEIGHT* SCREEN_WIDTH);
}
#endif
