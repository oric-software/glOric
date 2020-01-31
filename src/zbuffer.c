#include "config.h"
#include "glOric.h"

#ifdef USE_ZBUFFER

const int multi40[] = {0, 40, 80, 120, 160, 200, 240, 280, 320,
                       360, 400, 440, 480, 520, 560, 600, 640, 680,
                       720, 760, 800, 840, 880, 920, 960, 1000, 1040};

/*
 * TEXT SCREEN TEMPORARY BUFFERS
 */

unsigned char zbuffer[SCREEN_WIDTH * SCREEN_HEIGHT];  // z-depth buffer
char          fbuffer[SCREEN_WIDTH * SCREEN_HEIGHT];  // frame buffer

void initScreenBuffers() {
    memset(zbuffer, 0xFF, SCREEN_WIDTH * SCREEN_HEIGHT);
    memset(fbuffer, 0x20, SCREEN_WIDTH * SCREEN_HEIGHT);  // Space
}

void buffer2screen(char destAdr[]) {
    memcpy(destAdr, fbuffer, SCREEN_HEIGHT * SCREEN_WIDTH);
}

void zplot(unsigned char X,
           unsigned char Y,
           unsigned char dist,
           char          char2disp) {
    int            offset;
    char*          ptrFbuf;
    unsigned char* ptrZbuf;

    if ((Y <= 0) || (Y >= SCREEN_HEIGHT) || (X <= 0) || (X >= SCREEN_WIDTH))
        return;

    offset  = multi40[Y] + X;  // Y*SCREEN_WIDTH+X; //
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
    offset  = py * SCREEN_WIDTH + dx;  // multi40[py] + dx; //
    ptrZbuf = zbuffer + offset;
    ptrFbuf = fbuffer + offset;

    // printf ("zline from [%d %d] . %d points at dist %d \n", dx, py, nbpoints,
    // dist);

    while (nbp > 0) {
        if (dist < ptrZbuf[nbp]) {
            // printf ("p [%d %d] <- %d. was %d \n", dx+nbpoints, py, dist, ptrZbuf
            // [nbpoints]);
            ptrFbuf[nbp] = char2disp;
            ptrZbuf[nbp] = dist;
        }
        nbp--;
    }
}

#endif