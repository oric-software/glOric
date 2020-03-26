
#ifdef USE_C_HZFILL

void hzfill() {
//     signed char dx, fx;
//     signed char nbpoints;
    char*          ptrFbuf;
    unsigned char* ptrZbuf;

    //printf ("p1x=%d p2x=%d py=%d dist= %d, char2disp= %d\n", p1x, p2x, dist,  dist, char2disp);get();
    lineIndex = A1Y;
    if (A1Right != 0) {
#ifdef USE_SATURATION
        if (A2XSatur != 0){
#ifdef USE_COLOR
            departX = COLUMN_OF_COLOR_ATTRIBUTE;
#else
            departX = 0;
#endif // USE_COLOR

        }
#else // not USE_SATURATION	
#ifdef USE_COLOR
        departX = max(2, A2X);
#else
        departX = max(0, A2X);
#endif
#endif // USE_SATURATION

#ifdef USE_SATURATION
        if (A1XSatur != 0){
           finX = SCREEN_WIDTH - 1;     
        } else {
           finX = A1X;   
        }
#else // not USE_SATURATION	
        finX = min(A1X, SCREEN_WIDTH - 1);
#endif // USE_SATURATION

        
    } else {
#ifdef USE_SATURATION
        if (A1XSatur != 0) {
#ifdef USE_COLOR		
		departX = COLUMN_OF_COLOR_ATTRIBUTE;
#else
		departX = 0;
#endif // USE_COLOR
        }
#else // not USE_SATURATION
#ifdef USE_COLOR
        departX = max(COLUMN_OF_COLOR_ATTRIBUTE, A1X);
#else
        departX = max(0, A1X);
#endif
#endif // USE_SATURATION

#ifdef  USE_SATURATION
        if (A2XSatur !=0){
                finX = SCREEN_WIDTH - 1;
        } else {
                finX = A2X;
        }
#else // USE_SATURATION
        finX = min(A2X, SCREEN_WIDTH - 1);
#endif // USE_SATURATION
    }

hLineLength = finX - departX;
if (hLineLength < 0) return;

ptrZbuf = zbuffer + lineIndex * SCREEN_WIDTH + departX;
ptrFbuf = fbuffer + lineIndex * SCREEN_WIDTH + departX;


while (hLineLength > 0) {
        if (distface < ptrZbuf[hLineLength]) {
                ptrFbuf[hLineLength] = ch2disp;
                ptrZbuf[hLineLength] = distface;
        }
        hLineLength --;
}

}

#endif  // USE_C_HZFILL