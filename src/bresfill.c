
#include "config.h"
#include "glOric.h"

#include "render\zbuffer.h"
#include "util\util.h"

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

void fillFace(signed char   P1AH,
              signed char   P1AV,
              signed char   P2AH,
              signed char   P2AV,
              signed char   P3AH,
              signed char   P3AV,
              unsigned char distface,
              char          ch2disp) {
    signed char P1X, P1Y, P2X, P2Y, P3X, P3Y;

    P1X = (SCREEN_WIDTH - P1AH) >> 1;
    P1Y = (SCREEN_HEIGHT - P1AV) >> 1;
    P2X = (SCREEN_WIDTH - P2AH) >> 1;
    P2Y = (SCREEN_HEIGHT - P2AV) >> 1;
    P3X = (SCREEN_WIDTH - P3AH) >> 1;
    P3Y = (SCREEN_HEIGHT - P3AV) >> 1;

    // printf ("P1A: [%d, %d], P2A: [%d, %d], P3A [%d, %d]\n", P1AH, P1AV, P2AH, P2AV, P3AH, P3AV);
    // printf ("P1:[%d, %d], P2:[%d, %d], P3[%d, %d]\n", P1X, P1Y, P2X, P2Y, P3X, P3Y);
    // get();

    fill8(P1X, P1Y, P2X, P2Y, P3X, P3Y, distface, ch2disp);
}

void fill8(signed char   p1x,
           signed char   p1y,
           signed char   p2x,
           signed char   p2y,
           signed char   p3x,
           signed char   p3y,
           unsigned char dist,
           char          char2disp) {
    signed char pDepX;
    signed char pDepY;
    signed char pArr1X;
    signed char pArr1Y;
    signed char pArr2X;
    signed char pArr2Y;

    //printf ("fill [%d %d] [%d %d] [%d %d] %d %d\n", p1x, p1y, p2x, p2y, p3x, p3y, dist, char2disp); get();
    if (p1y <= p2y) {
        if (p2y <= p3y) {
            pDepX  = p3x;
            pDepY  = p3y;
            pArr1X = p2x;
            pArr1Y = p2y;
            pArr2X = p1x;
            pArr2Y = p1y;
        } else {
            pDepX = p2x;
            pDepY = p2y;
            if (p1y <= p3y) {
                pArr1X = p3x;
                pArr1Y = p3y;
                pArr2X = p1x;
                pArr2Y = p1y;
            } else {
                pArr1X = p1x;
                pArr1Y = p1y;
                pArr2X = p3x;
                pArr2Y = p3y;
            }
        }
    } else {
        if (p1y <= p3y) {
            pDepX  = p3x;
            pDepY  = p3y;
            pArr1X = p1x;
            pArr1Y = p1y;
            pArr2X = p2x;
            pArr2Y = p2y;
        } else {
            pDepX = p1x;
            pDepY = p1y;
            if (p2y <= p3y) {
                pArr1X = p3x;
                pArr1Y = p3y;
                pArr2X = p2x;
                pArr2Y = p2y;
            } else {
                pArr1X = p2x;
                pArr1Y = p2y;
                pArr2X = p3x;
                pArr2Y = p3y;
            }
        }
    }

    //printf ("Dep = [%d, %d], Arr1 = [%d, %d], Arr2= [%d, %d]\n", pDepX,pDepY, pArr1X, pArr1Y, pArr2X, pArr2Y);
    if (pDepY != pArr1Y) {
        //a1 = bres_agent(pDep[0],pDep[1],pArr1[0],pArr1[1])
        A1X     = pDepX;
        A1Y     = pDepY;
        A1destX = pArr1X;
        A1destY = pArr1Y;
        A1dX    = abs(A1destX - A1X);
        A1dY    = -abs(A1destY - A1Y);
        A1err   = A1dX + A1dY;
        if ((A1err > 64) || (A1err < -63))
            return;
        A1sX      = (A1X < A1destX) ? 1 : -1;
        A1sY      = (A1Y < A1destY) ? 1 : -1;
        A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;

        //a2 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
        A2X     = pDepX;
        A2Y     = pDepY;
        A2destX = pArr2X;
        A2destY = pArr2Y;
        A2dX    = abs(A2destX - A2X);
        A2dY    = -abs(A2destY - A2Y);
        A2err   = A2dX + A2dY;
        if ((A2err > 64) || (A2err < -63)) return;

        A2sX      = (A2X < A2destX) ? 1 : -1;
        A2sY      = (A2Y < A2destY) ? 1 : -1;
        A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;

        hfill8(A1X, A2X, A1Y, dist, char2disp);
        while (A1arrived == 0) {
            A1stepY();
            A2stepY();
            hfill8(A1X, A2X, A1Y, dist, char2disp);
        }

        A1X       = pArr1X;
        A1Y       = pArr1Y;
        A1destX   = pArr2X;
        A1destY   = pArr2Y;
        A1dX      = abs(A1destX - A1X);
        A1dY      = -abs(A1destY - A1Y);
        A1err     = A1dX + A1dY;
        A1sX      = (A1X < A1destX) ? 1 : -1;
        A1sY      = (A1Y < A1destY) ? 1 : -1;
        A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;

        while ((A1arrived == 0) && (A2arrived == 0)) {
            A1stepY();
            A2stepY();
            hfill8(A1X, A2X, A1Y, dist, char2disp);
        }
    } else {
        // a1 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
        A1X     = pDepX;
        A1Y     = pDepY;
        A1destX = pArr2X;
        A1destY = pArr2Y;
        A1dX    = abs(A1destX - A1X);
        A1dY    = -abs(A1destY - A1Y);
        A1err   = A1dX + A1dY;

        if ((A1err > 64) || (A1err < -63)) return;

        A1sX = (A1X < A1destX) ? 1 : -1;
        A1sY = (A1Y < A1destY) ? 1 : -1;

        A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;

        // a2 = bres_agent(pArr1[0],pArr1[1],pArr2[0],pArr2[1])
        A2X     = pArr1X;
        A2Y     = pArr1Y;
        A2destX = pArr2X;
        A2destY = pArr2Y;
        A2dX    = abs(A2destX - A2X);
        A2dY    = -abs(A2destY - A2Y);
        A2err   = A2dX + A2dY;

        if ((A2err > 64) || (A2err < -63)) return;

        A2sX      = (A2X < A2destX) ? 1 : -1;
        A2sY      = (A2Y < A2destY) ? 1 : -1;
        A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;

        hfill8(A1X, A2X, A1Y, dist, char2disp);

        while ((A1arrived == 0) && (A2arrived == 0)) {
            A1stepY();
            A2stepY();
            hfill8(A1X, A2X, A1Y, dist, char2disp);
        }
    }
}

void hfill8(signed char   p1x,
            signed char   p2x,
            signed char   py,
            unsigned char dist,
            char          char2disp) {
    signed char dx, fx;
    signed char nbpoints;

    //printf ("p1x=%d p2x=%d py=%d dist= %d, char2disp= %d\n", p1x, p2x, dist,  dist, char2disp);get();

    if ((py <= 0) || (py >= SCREEN_HEIGHT)) return;

    if (p1x > p2x) {
        dx = max(0, p2x);
        fx = min(p1x, SCREEN_WIDTH - 1);
    } else {
        dx = max(0, p1x);
        fx = min(p2x, SCREEN_WIDTH - 1);
    }

    nbpoints = fx - dx;

    if (nbpoints < 0) return;

    //printf ("dx=%d py=%d nbpoints=%d dist= %d, char2disp= %d\n", dx, py, nbpoints,  dist, char2disp);get();

#ifdef USE_ZBUFFER
    zline(dx, py, nbpoints, dist, char2disp);
#else
    // TODO : draw a line whit no z-buffer
#endif
}

/*
void A1reachY(signed char  nxtY){

	signed char  e2;

	//printf ("nxtY = %d\n", nxtY);
	e2 = (A1err < 0) ? (
			((A1err & 0x40) == 0)?(
				0x80
			):(
				A1err << 1
			)
		):(
			((A1err & 0x40) != 0)?(
				0x7F
			):(
				A1err << 1
			)
		);

	//printf ("e2 = %d\n", e2);
	while (A1arrived != 0){
		if (e2 >= A1dY){
			A1err += A1dY;
			//printf ("A1err = %d\n", A1err);
			A1X += A1sX;
			//printf ("A1X = %d\n", A1X);
		}
		if (e2 <= A1dX){
			A1err += A1dX;
			//printf ("A1err = %d\n", A1err);
			A1Y += A1sY;
			//printf ("A1Y = %d\n", A1Y);
		}
		A1arrived=( A1Y == nxtY)?1:0;
		e2 = (A1err < 0) ? (
				((A1err & 0x40) == 0)?(
					0x80
				):(
					A1err << 1
				)
			):(
				((A1err & 0x40) != 0)?(
					0x7F
				):(
					A1err << 1
				)
			);
		//printf ("e2 = %d\n", e2);
	}
}

void A2reachY(signed char  nxtY){

	signed char  e2;

	//printf ("nxtY = %d\n", nxtY);
	e2 = (A2err < 0) ? (
			((A2err & 0x40) == 0)?(
				0x80
			):(
				A2err << 1
			)
		):(
			((A2err & 0x40) != 0)?(
				0x7F
			):(
				A2err << 1
			)
		);

	//printf ("e2 = %d\n", e2);
	while (A2arrived!=0){
		if (e2 >= A2dY){
			A2err += A2dY;
			//printf ("A2err = %d\n", A2err);
			A2X += A2sX;
			//printf ("A2X = %d\n", A2X);
		}
		if (e2 <= A2dX){
			A2err += A2dX;
			//printf ("A2err = %d\n", A2err);
			A2Y += A2sY;
			//printf ("A2Y = %d\n", A2Y);
		}
		A2arrived=( A2Y == nxtY)?1:0;
		e2 = (A2err < 0) ? (
				((A2err & 0x40) == 0)?(
					0x80
				):(
					A2err << 1
				)
			):(
				((A2err & 0x40) != 0)?(
					0x7F
				):(
					A2err << 1
				)
			);
		//printf ("e2 = %d\n", e2);
	}
}
*/

/*
void hfill8 (signed char p1x, signed char p2x, signed char py, unsigned char dist, char char2disp){

    signed char dx, fx;
    signed char ii;
    int offset;
    if ((py <= 0) || (py>=SCREEN_HEIGHT)) return;
    if (p1x < p2x) {
        dx = p1x;
        fx = p2x;
    } else {
        dx = p2x;
        fx = p1x;
    }

    for (ii=dx; ii<=fx; ii++ ) {
        if ((ii >= 1) && (ii<SCREEN_WIDTH)) {
            offset = py*SCREEN_WIDTH+ii;
            if (dist < zbuffer[offset]){
				zbuffer[offset] = dist;
				fbuffer[offset] = char2disp;
			}
        }
    }
}
*/
