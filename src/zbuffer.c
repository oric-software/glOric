#include "config.h"
#include "glOric.h"

#ifdef TARGET_ORIX
#include <string.h>
#endif

#ifdef USE_COLOR
#include "render/colors.h"
#endif

#ifdef USE_ZBUFFER
#include "render\zbuffer.h"


//const int multi40[] = {0, 40, 80, 120, 160, 200, 240, 280, 320,
//                       360, 400, 440, 480, 520, 560, 600, 640, 680,
//                       720, 760, 800, 840, 880, 920, 960, 1000, 1040};
#include "initScreenBuffers.c"

#include "buffer2screen.c"

#include "zplot_c.c"

#ifdef USE_C_ZLINE

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

#endif //USE_C_ZLINE

#endif // USE_ZBUFFER