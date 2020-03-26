
#include "config.h"
#include "glOric.h"

#include "render\zbuffer.h"
#include "util\util.h"


#ifdef USE_PROFILER
#include "profile.h"
#endif // USE_PROFILER


extern signed char A1X;
extern signed char A1Y;
extern signed char A1destX;
extern signed char A1destY;
extern signed char A1dX;
extern signed char A1dY;
extern signed char A1err;
extern signed char A1sX;
extern signed char A1sY;
extern char        A1arrived;

extern signed char A2X;
extern signed char A2Y;
extern signed char A2destX;
extern signed char A2destY;
extern signed char A2dX;
extern signed char A2dY;
extern signed char A2err;
extern signed char A2sX;
extern signed char A2sY;
extern char        A2arrived;
extern unsigned char A1Right;

#ifdef USE_SATURATION
extern unsigned char A1XSatur;
extern unsigned char A2XSatur;
#endif // USE_SATURATION

void fill8();

#ifdef USE_C_BRESFILL
void hfill();
#endif  // USE_C_BRESFILL

#include "agent.c"

// fillface
extern signed char   P1X, P1Y, P2X, P2Y, P3X, P3Y;
extern signed char   P1AH, P1AV, P2AH, P2AV, P3AH, P3AV;
extern unsigned char distface;
extern char          ch2disp;

#include "angle2screen.c"
#include "fillFace.c"
// fill8
extern signed char pDepX;
extern signed char pDepY;
extern signed char pArr1X;
extern signed char pArr1Y;
extern signed char pArr2X;
extern signed char pArr2Y;

extern unsigned char log2_tab[];
extern signed char mDeltaY1, mDeltaX1, mDeltaY2, mDeltaX2;


#include "prepareBresrun.c"

#include "reachScreen.c"

#include "satur.c"


#include "fill8_bis.c"
#include "isA1Right.c"

#include "fill8.c"

#ifdef USE_C_HFILL

void hfill() {
    signed char dx, fx;
    signed char nbpoints;

    //printf ("p1x=%d p2x=%d py=%d dist= %d, char2disp= %d\n", p1x, p2x, dist,  dist, char2disp);get();

#ifdef USE_COLOR
    if ((A1Y <= 0) || (A1Y >= SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR))
        return;
#else
    if ((A1Y <= 0) || (A1Y >= SCREEN_HEIGHT))
        return;
#endif
    if (A1X > A2X) {
#ifdef USE_COLOR
        dx = max(2, A2X);
#else
        dx = max(0, A2X);
#endif
        fx = min(A1X, SCREEN_WIDTH - 1);
    } else {
#ifdef USE_COLOR
        dx = max(2, A1X);
#else
        dx = max(0, A1X);
#endif
        fx = min(A2X, SCREEN_WIDTH - 1);
    }

    nbpoints = fx - dx;

    if (nbpoints < 0)
        return;

        // printf ("dx=%d py=%d nbpoints=%d dist= %d, char2disp= %d\n", dx, py, nbpoints,  dist, char2disp);get();

#ifdef USE_ZBUFFER
    zline(dx, A1Y, nbpoints, distface, ch2disp);
#else
        // TODO : draw a line whit no z-buffer
#endif
}

#endif  // USE_C_HFILL
