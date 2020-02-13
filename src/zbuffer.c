#include "config.h"
#include "glOric.h"

#ifdef TARGET_ORIX
#include <string.h>
#endif

#ifdef USE_ZBUFFER

#ifdef TARGET_ORIX
char fbuffer [SCREEN_WIDTH*SCREEN_HEIGHT];
unsigned char zbuffer [SCREEN_WIDTH*SCREEN_HEIGHT];
#else
extern unsigned char zbuffer[];  // z-depth buffer SCREEN_WIDTH * SCREEN_HEIGHT
extern char          fbuffer[];  // frame buffer SCREEN_WIDTH * SCREEN_HEIGHT
#endif

//const int multi40[] = {0, 40, 80, 120, 160, 200, 240, 280, 320,
//                       360, 400, 440, 480, 520, 560, 600, 640, 680,
//                       720, 760, 800, 840, 880, 920, 960, 1000, 1040};

void initScreenBuffers() { // FIXME : ASM version of initScreenBuffers prevents dispinfo from working
    memset(zbuffer, 0xFF, SCREEN_WIDTH * SCREEN_HEIGHT);
    memset(fbuffer, 0x20, SCREEN_WIDTH * SCREEN_HEIGHT);  // Space
}


#ifdef USE_C_BUFFER2SCREEN
void buffer2screen(char destAdr[]) {
    memcpy(destAdr, fbuffer, SCREEN_HEIGHT * SCREEN_WIDTH);
#ifdef USE_COLOR
    // prepare_colors();
#endif
}
#endif


#ifdef USE_C_ZBUFFER

void zplot(signed char X,
           signed char Y,
           unsigned char dist,
           char          char2disp) {
    int            offset;
    char*          ptrFbuf;
    unsigned char* ptrZbuf;

    if ((Y <= 0) || (Y >= SCREEN_HEIGHT) || (X <= 0) || (X >= SCREEN_WIDTH))
        return;

#ifdef USE_MULTI40
    offset = multi40[Y] + X;  // 
#else
    offset = Y*SCREEN_WIDTH+X; 
#endif

    ptrZbuf = zbuffer + offset;
    ptrFbuf = fbuffer + offset;

    // printf ("pl [%d %d] zbuff = %d , pointDist = %d\n", X, Y, *ptrZbuf, dist);
    if (dist < *ptrZbuf) {
        *ptrFbuf = char2disp;
        *ptrZbuf = dist;
    }
}


void zline(signed char   dx,
           signed char   py,
           signed char   nbpoints,
           unsigned char dist,
           char          char2disp) {
    int            offset;   // offset os starting point
    char*          ptrFbuf;  // pointer to the frame buffer
    unsigned char* ptrZbuf;  // pointer to z-buffer
    signed char    nbp;

    nbp     = nbpoints;
#ifdef USE_MULTI40
    offset  = multi40[py] + dx; 
#else
    offset  = py * SCREEN_WIDTH + dx;
#endif // USE_MULTI40

    ptrZbuf = zbuffer + offset;
    ptrFbuf = fbuffer + offset;

    // printf ("zline from [%d %d] . %d points at dist %d \n", dx, py, nbpoints,dist);

    while (nbp > 0) {
        if (dist < ptrZbuf[nbp]) {
            // printf ("p [%d %d] <- %d. was %d \n", dx+nbpoints, py, dist, ptrZbuf[nbpoints]);
            ptrFbuf[nbp] = char2disp;
            ptrZbuf[nbp] = dist;
        }
        nbp--;
    }
}

#endif //USE_C_ZBUFFER
#endif // USE_ZBUFFER