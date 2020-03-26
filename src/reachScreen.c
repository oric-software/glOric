#ifdef USE_C_REACHSCREEN
void reachScreen(){
#ifdef USE_COLOR
        while ((A1Y >= SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR) && (A1arrived == 0)){ 
#else
        while ((A1Y >= SCREEN_HEIGHT)  && (A1arrived == 0)){ 
#endif
            A1stepY();
            A2stepY();
        }
}
#endif // USE_C_REACHSCREEN

