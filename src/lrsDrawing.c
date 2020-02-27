/* lrsDrawing */

#include "config.h"
#include "glOric.h"

#include "raster\bresfill.h"
#include "render\zbuffer.h"
#include "util\util.h"
#ifdef USE_PROFILER
#include "profile.h"
#endif // USE_PROFILER

// signed char _brX;
// signed char _brY;
// signed char _brDx;
// signed char _brDy;
// signed char _brDestX;
// signed char _brDestY;
// signed char _brErr;
// signed char _brSx;
// signed char _brSy;

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

extern unsigned char distface;
extern unsigned char distseg;
extern char          ch2disp;
extern    signed char   P1X, P1Y, P2X, P2Y, P3X, P3Y;
extern     signed char   P1AH, P1AV, P2AH, P2AV, P3AH, P3AV;


void change_char(char c, unsigned char patt01, unsigned char patt02, unsigned char patt03, unsigned char patt04, unsigned char patt05, unsigned char patt06, unsigned char patt07, unsigned char patt08) {
    unsigned char* adr;
    adr      = (unsigned char*)(0xB400 + c * 8);
    *(adr++) = patt01;
    *(adr++) = patt02;
    *(adr++) = patt03;
    *(adr++) = patt04;
    *(adr++) = patt05;
    *(adr++) = patt06;
    *(adr++) = patt07;
    *(adr++) = patt08;
}


#ifdef USE_C_PLOT

void plot(signed char X,
           signed char Y,
           char          char2disp) {
    int            offset;
    char*          ptrScreen = (char*)ADR_BASE_LORES_SCREEN;


#ifdef USE_COLOR
    if ((Y <= 0) || (Y >= SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR) || (X <= 2) || (X >= SCREEN_WIDTH))
        return;
#else
    if ((Y <= 0) || (Y >= SCREEN_HEIGHT) || (X <= 0) || (X >= SCREEN_WIDTH))
        return;
#endif

#ifdef USE_MULTI40
    offset = multi40[Y] + X;  // 
#else
    offset = Y*SCREEN_WIDTH+X; 
#endif

    *(ptrScreen + offset) = char2disp;
}

#endif // USE_C_PLOT




#ifdef USE_C_DRAWLINE
void lrDrawLine() {

    signed char e2;
    char        ch2dsp;

    A1X     = P1X;
    A1Y     = P1Y;
    A1destX = P2X;
    A1destY = P2Y;
    A1dX    = abs(P2X - P1X);
    A1dY    = -abs(P2Y - P1Y);
    A1sX    = P1X < P2X ? 1 : -1;
    A1sY    = P1Y < P2Y ? 1 : -1;
    A1err   = A1dX + A1dY;

    if ((A1err > 64) || (A1err < -63))
        return;

    if ((ch2disp == '/') && (A1sX == -1)) {
        ch2dsp = DOLLAR;
    } else {
        ch2dsp = ch2disp;
    }

    while (1) {  // loop
        //printf ("plot [%d, %d] %d %d\n", _A1X, _A1Y, distseg, ch2disp);get ();          
#ifdef USE_ZBUFFER
        zplot(A1X, A1Y, distseg, ch2dsp);
#else
        plot(A1X, A1Y, ch2dsp);
#endif
        if ((A1X == A1destX) && (A1Y == A1destY))
            break;
        //e2 = 2*err;
        e2 = (A1err < 0) ? (
                ((A1err & 0x40) == 0) ? (
                                                0x80)
                                        : (
                                            A1err << 1))
            : (
                ((A1err & 0x40) != 0) ? (
                                                0x7F)
                                        : (
                                                A1err << 1));
        if (e2 >= A1dY) {
            A1err += A1dY;  // e_xy+e_x > 0
            A1X += A1sX;
        }
        if (e2 <= A1dX) {  // e_xy+e_y < 0
            A1err += A1dX;
            A1Y += A1sY;
        }
    }
}
#endif // USE_C_DRAWLINE

/*
def drawLine( x0,  y0,  x1,  y1):
    points2d = []

    dx =  abs(x1-x0);
    #sx = x0<x1 ? 1 : -1;
    if (x0<x1):
        sx = 1
    else:
        sx = -1

    dy = -abs(y1-y0);
    #sy = y0<y1 ? 1 : -1;
    if (y0<y1):
        sy = 1
    else:
        sy = -1

    err = dx+dy;  # error value e_xy
    print ("0. dx=%d sx=%d dy=%d sy=%d err=%d"%(dx, sx, dy, sy, err))
    while (True):   # loop
        points2d.append([x0 , y0])
        print (x0, y0)
        if ((x0==x1) and (y0==y1)): break
        e2 = 2*err;
        if (e2 >=127) or (e2 <= -128): print (e2)
        if (e2 >= dy):
            err += dy; # e_xy+e_x > 0
            x0 += sx;
        if (e2 <= dx): # e_xy+e_y < 0
            err += dx;
            y0 += sy;
*/
void lrDrawParticules(char points2d[], unsigned char particules[], unsigned char nbParticules){
    unsigned char ii = 0;
    unsigned char jj = 0;
    // unsigned char kk = 0;
    unsigned char idxPt, offPt, dchar;
    unsigned int  dist;
    for (ii = 0; ii < nbParticules; ii++) {
        jj = ii << 1;  // ii*SIZEOF_PARTICULES
        // kk = ii << 2;  // ii*SIZEOF_2DPOINT
        idxPt    = particules[jj++];  // ii*SIZEOF_SEGMENT +0
        ch2disp = particules[jj];    // ii*SIZEOF_SEGMENT +2
        offPt = idxPt << 2;
        
        dist = *((int*)(points2d + (offPt | 0x02))) - 2;   // points2d[offPt+2] FIXME : -2 to helps particule to be displayed
        dchar = (unsigned char)((dist)&0x00FF);
        P1X = (SCREEN_WIDTH -points2d[offPt++]) >> 1;
        P1Y = (SCREEN_HEIGHT - points2d[offPt++]) >> 1;
#ifdef USE_ZBUFFER
        zplot(P1X, P1Y, dchar, ch2disp);
#else
        plot(P1X, P1Y, ch2disp);
#endif

    }
}

void lrDrawSegments(char points2d[], unsigned char segments[], unsigned char nbSegments) {
    unsigned char ii = 0;
    unsigned char jj = 0;
    unsigned char idxPt1, idxPt2;
    unsigned char offPt1, offPt2;
    int           dmoy;

    for (ii = 0; ii < nbSegments; ii++) {
        jj = ii << 2;  // ii*SIZEOF_SEGMENT

        idxPt1    = segments[jj++];  // ii*SIZEOF_SEGMENT +0
        idxPt2    = segments[jj++];  // ii*SIZEOF_SEGMENT +1
        ch2disp = segments[jj];    // ii*SIZEOF_SEGMENT +2

        offPt1 = idxPt1 << 2;
        offPt2 = idxPt2 << 2;

        // dmoy = (d1+d2)/2;
        dmoy = *((int*)(points2d + (offPt1 | 0x02)));   // points2d[offPt1+2]
        dmoy += *((int*)(points2d + (offPt2 | 0x02)));  // points2d[offPt2+2]
        dmoy = dmoy >> 1;

        //if (dmoy >= 256) {
        if ((dmoy & 0xFF00) != 0)
            continue;
        distseg = (unsigned char)((dmoy)&0x00FF);
        distseg--;  // FIXME

#ifndef ANGLEONLY
        jj  = idxPt1 << 4;  // idxPt1*SIZEOF_2DPOINT
        P1X = points2d[jj++];
        P1Y = points2d[jj];
        jj  = idxPt2 << 4;  // idxPt2*SIZEOF_2DPOINT
        P2X = points2d[jj++];
        P2Y = points2d[jj];

        //printf ("dl ([%d, %d] %d, [%d, %d] %d =>  %d\n", P1X, P1Y, d1, P2X, P2Y, d2, distseg);get();
#else

        jj   = idxPt1 << 2;  // idxPt1*SIZEOF_2DPOINT
        P1AH = points2d[jj++];
        P1AV = points2d[jj];
        jj   = idxPt2 << 2;  // idxPt2*SIZEOF_2DPOINT
        P2AH = points2d[jj++];
        P2AV = points2d[jj];

        P1X = (SCREEN_WIDTH - P1AH) >> 1;
        P1Y = (SCREEN_HEIGHT - P1AV) >> 1;
        P2X = (SCREEN_WIDTH - P2AH) >> 1;
        P2Y = (SCREEN_HEIGHT - P2AV) >> 1;

        // printf ("dl ([%d, %d] , [%d, %d] => %d c=%d\n", P1X, P1Y, P2X, P2Y, distseg, char2disp); get();
        lrDrawLine();

#endif
    }
}

#define ANGLE_MAX 0xC0
#define ANGLE_VIEW 0xE0

void lrDrawFaces(char points2d[], unsigned char faces[], unsigned char nbFaces) {
    unsigned char ii = 0;
    unsigned char jj = 0;
    int           d1, d2, d3;
    int           dmoy;
 
    unsigned char offPt1, offPt2, offPt3;
#ifdef ANGLEONLY
    signed char   tmpH, tmpV;
    unsigned char m1, m2, m3;
    unsigned char v1, v2, v3;
#endif

    //printf ("%d Points, %d Segments, %d Faces\n", nbPts, nbSegments, nbFaces); get();
    for (ii = 0; ii < nbFaces; ii++) {
        jj = ii << 2;

        offPt1 = faces[jj++] << 2;
        offPt2 = faces[jj++] << 2;
        offPt3 = faces[jj++] << 2;
        ch2disp = faces[jj];

        //printf ("face %d : %d %d %d\n",ii, offPt1, offPt2, offPt3);get();
        d1 = *((int*)(points2d + offPt1 + 2));

        d2 = *((int*)(points2d + offPt2 + 2));

        d3 = *((int*)(points2d + offPt3 + 2));

        dmoy = (d1 + d2 + d3) / 3;
        if (dmoy >= 256) {
            dmoy = 256;
        }
        distface = (unsigned char)(dmoy & 0x00FF);

#ifndef ANGLEONLY
        P1X = points2d[offPt1 + 0];
        P1Y = points2d[offPt1 + 1];
        P2X = points2d[offPt2 + 0];
        P2Y = points2d[offPt2 + 1];
        P3X = points2d[offPt3 + 0];
        P3Y = points2d[offPt3 + 1];

        //printf ("[%d, %d], [%d, %d], [%d, %d]\n", P1X, P1Y, P2X, P2Y, P3X, P3Y);get();
        fill8(distface, faces[jj]);

#else
        P1AH = points2d[offPt1 + 0];
        P1AV = points2d[offPt1 + 1];
        P2AH = points2d[offPt2 + 0];
        P2AV = points2d[offPt2 + 1];
        P3AH = points2d[offPt3 + 0];
        P3AV = points2d[offPt3 + 1];

        //printf ("P1 [%d, %d], P2 [%d, %d], P3 [%d %d]\n", P1AH, P1AV, P2AH, P2AV,  P3AH, P3AV); get();

        if (abs(P2AH) < abs(P1AH)) {
            tmpH = P1AH;
            tmpV = P1AV;
            P1AH = P2AH;
            P1AV = P2AV;
            P2AH = tmpH;
            P2AV = tmpV;
        }
        if (abs(P3AH) < abs(P1AH)) {
            tmpH = P1AH;
            tmpV = P1AV;
            P1AH = P3AH;
            P1AV = P3AV;
            P3AH = tmpH;
            P3AV = tmpV;
        }
        if (abs(P3AH) < abs(P2AH)) {
            tmpH = P2AH;
            tmpV = P2AV;
            P2AH = P3AH;
            P2AV = P3AV;
            P3AH = tmpH;
            P3AV = tmpV;
        }

        m1 = P1AH & ANGLE_MAX;
        m2 = P2AH & ANGLE_MAX;
        m3 = P3AH & ANGLE_MAX;
        v1 = P1AH & ANGLE_VIEW;
        v2 = P2AH & ANGLE_VIEW;
        v3 = P3AH & ANGLE_VIEW;

        //printf ("AHs [%d, %d, %d] [%x, %x], %x], %x, %x, %x]\n", P1AH, P2AH, P3AH, m1, m2, m3, v1,v2,v3);get();

        if ((m1 == 0x00) || (m1 == ANGLE_MAX)) {
            if ((v1 == 0x00) || (v1 == ANGLE_VIEW)) {
                if (
                    (
                        (P1AH & 0x80) != (P2AH & 0x80)) ||
                    ((P1AH & 0x80) != (P3AH & 0x80))) {
                    if ((abs(P3AH) < 127 - abs(P1AH))) {
                        fillFace();
                    }
                } else {
                    fillFace();
                }
            } else {
                // P1 FRONT
                if ((m2 == 0x00) || (m2 == ANGLE_MAX)) {
                    // P2 FRONT
                    if ((m3 == 0x00) || (m3 == ANGLE_MAX)) {
                        // P3 FRONT
                        // _4_
                        if (((P1AH & 0x80) != (P2AH & 0x80)) || ((P1AH & 0x80) != (P3AH & 0x80))) {
                            fillFace();
                        } else {
                            // nothing to do
                        }
                    } else {
                        // P3 BACK
                        // _3_
                        if ((P1AH & 0x80) != (P2AH & 0x80)) {
                            if (abs(P2AH) < 127 - abs(P1AH)) {
                                fillFace();
                            }
                        } else {
                            if ((P1AH & 0x80) != (P3AH & 0x80)) {
                                if (abs(P3AH) < 127 - abs(P1AH)) {
                                    fillFace();
                                }
                            }
                        }

                        if ((P1AH & 0x80) != (P3AH & 0x80)) {
                            if (abs(P3AH) < 127 - abs(P1AH)) {
                                fillFace();
                            }
                        }
                    }
                } else {
                    // P2 BACK
                    // _2_ nothing to do
                    if ((P1AH & 0x80) != (P2AH & 0x80)) {
                        if (abs(P2AH) < 127 - abs(P1AH)) {
                            fillFace();
                        }
                    } else {
                        if ((P1AH & 0x80) != (P3AH & 0x80)) {
                            if (abs(P3AH) < 127 - abs(P1AH)) {
                                fillFace();
                            }
                        }
                    }

                    if ((P1AH & 0x80) != (P3AH & 0x80)) {
                        if (abs(P3AH) < 127 - abs(P1AH)) {
                            fillFace();
                        }
                    }
                }
            }
        } else {
            // P1 BACK
            // _1_ nothing to do
        }

#endif
    }
}

#ifdef USE_REWORKED_BUFFERS
extern unsigned char nbPoints;
extern unsigned char nbSegments;
extern unsigned char nbParticules;
extern unsigned char nbFaces;
extern unsigned char facesPt1[];
extern unsigned char facesPt2[];
extern unsigned char facesPt3[];
extern unsigned char facesChar[];
extern signed char points2aH[];
extern signed char points2aV[];
extern signed char points2dH[];
extern signed char points2dL[];
extern unsigned char segmentsPt1[];
extern unsigned char segmentsPt2[];
extern unsigned char segmentsChar[];
extern unsigned char particulesPt[];
extern unsigned char particulesChar[];
#endif

#ifdef USE_REWORKED_BUFFERS
void glDrawFaces() {
    unsigned char ii = 0;
    unsigned char jj = 0;
    int           d1, d2, d3;
    int           dmoy;
 
    unsigned char offPt1, offPt2, offPt3;

    signed char   tmpH, tmpV;
    unsigned char m1, m2, m3;
    unsigned char v1, v2, v3;

#ifdef USE_PROFILER
PROFILE_ENTER(ROUTINE_GLDRAWFACES);
#endif // USE_PROFILER
    // printf ("%d Points, %d Segments, %d Faces\n", nbPoints, nbSegments, nbFaces); get();
    for (ii = 0; ii < nbFaces; ii++) {

        offPt1 = facesPt1[ii] ;
        offPt2 = facesPt2[ii] ;
        offPt3 = facesPt3[ii] ;
        ch2disp = facesChar[ii];

        // printf ("face %d : %d %d %d\n",ii, offPt1, offPt2, offPt3);get();
        d1 = points2dL[offPt1]; //*((int*)(points2d + offPt1 + 2));

        d2 = points2dL[offPt2]; //*((int*)(points2d + offPt2 + 2));

        d3 = points2dL[offPt3]; //*((int*)(points2d + offPt3 + 2));
        // printf ("dis %d %d %d\n",d1, d2, d3);get();
        dmoy = (d1 + d2 + d3) / 3;
        if (dmoy >= 256) {
            dmoy = 256;
        }
        distface = (unsigned char)(dmoy & 0x00FF);

        // printf ("disface %d %d\n",dmoy, distface);get();
        P1AH = points2aH[offPt1];
        P1AV = points2aV[offPt1];
        P2AH = points2aH[offPt2];
        P2AV = points2aV[offPt2];
        P3AH = points2aH[offPt3];
        P3AV = points2aV[offPt3];

        // printf ("P1 [%d, %d], P2 [%d, %d], P3 [%d %d]\n", P1AH, P1AV, P2AH, P2AV,  P3AH, P3AV); get();

        if (abs(P2AH) < abs(P1AH)) {
            tmpH = P1AH;
            tmpV = P1AV;
            P1AH = P2AH;
            P1AV = P2AV;
            P2AH = tmpH;
            P2AV = tmpV;
        }
        if (abs(P3AH) < abs(P1AH)) {
            tmpH = P1AH;
            tmpV = P1AV;
            P1AH = P3AH;
            P1AV = P3AV;
            P3AH = tmpH;
            P3AV = tmpV;
        }
        if (abs(P3AH) < abs(P2AH)) {
            tmpH = P2AH;
            tmpV = P2AV;
            P2AH = P3AH;
            P2AV = P3AV;
            P3AH = tmpH;
            P3AV = tmpV;
        }

        m1 = P1AH & ANGLE_MAX;
        m2 = P2AH & ANGLE_MAX;
        m3 = P3AH & ANGLE_MAX;
        v1 = P1AH & ANGLE_VIEW;
        v2 = P2AH & ANGLE_VIEW;
        v3 = P3AH & ANGLE_VIEW;

        // printf ("AHs [%d, %d, %d] [%x, %x], %x], %x, %x, %x]\n", P1AH, P2AH, P3AH, m1, m2, m3, v1,v2,v3);get();

        if ((m1 == 0x00) || (m1 == ANGLE_MAX)) {
            if ((v1 == 0x00) || (v1 == ANGLE_VIEW)) {
                if (
                    (
                        (P1AH & 0x80) != (P2AH & 0x80)) ||
                    ((P1AH & 0x80) != (P3AH & 0x80))) {
                    if ((abs(P3AH) < 127 - abs(P1AH))) {
                        fillFace();
                    }
                } else {
                    fillFace();
                }
            } else {
                // P1 FRONT
                if ((m2 == 0x00) || (m2 == ANGLE_MAX)) {
                    // P2 FRONT
                    if ((m3 == 0x00) || (m3 == ANGLE_MAX)) {
                        // P3 FRONT
                        // _4_
                        if (((P1AH & 0x80) != (P2AH & 0x80)) || ((P1AH & 0x80) != (P3AH & 0x80))) {
                            fillFace();
                        } else {
                            // nothing to do
                        }
                    } else {
                        // P3 BACK
                        // _3_
                        if ((P1AH & 0x80) != (P2AH & 0x80)) {
                            if (abs(P2AH) < 127 - abs(P1AH)) {
                                fillFace();
                            }
                        } else {
                            if ((P1AH & 0x80) != (P3AH & 0x80)) {
                                if (abs(P3AH) < 127 - abs(P1AH)) {
                                    fillFace();
                                }
                            }
                        }

                        if ((P1AH & 0x80) != (P3AH & 0x80)) {
                            if (abs(P3AH) < 127 - abs(P1AH)) {
                                fillFace();
                            }
                        }
                    }
                } else {
                    // P2 BACK
                    // _2_ nothing to do
                    if ((P1AH & 0x80) != (P2AH & 0x80)) {
                        if (abs(P2AH) < 127 - abs(P1AH)) {
                            fillFace();
                        }
                    } else {
                        if ((P1AH & 0x80) != (P3AH & 0x80)) {
                            if (abs(P3AH) < 127 - abs(P1AH)) {
                                fillFace();
                            }
                        }
                    }

                    if ((P1AH & 0x80) != (P3AH & 0x80)) {
                        if (abs(P3AH) < 127 - abs(P1AH)) {
                            fillFace();
                        }
                    }
                }
            }
        } else {
            // P1 BACK
            // _1_ nothing to do
        }
    }
#ifdef USE_PROFILER
PROFILE_LEAVE(ROUTINE_GLDRAWFACES);
#endif // USE_PROFILER

}
void glDrawSegments() {
    unsigned char ii = 0;
    unsigned char jj = 0;
    unsigned char idxPt1, idxPt2;
    unsigned char offPt1, offPt2;
    int           dmoy;

#ifdef USE_PROFILER
PROFILE_ENTER(ROUTINE_GLDRAWSEGMENTS);
#endif // USE_PROFILER

    for (ii = 0; ii < nbSegments; ii++) {

        idxPt1    = segmentsPt1[ii];
        idxPt2    = segmentsPt2[ii];
        ch2disp = segmentsChar[ii];

        // dmoy = (d1+d2)/2;

        dmoy = points2dL[idxPt1];
        dmoy += points2dL[idxPt2];
        dmoy = dmoy >> 1;
        

        //if (dmoy >= 256) {
        if ((dmoy & 0xFF00) != 0)
            continue;
        distseg = (unsigned char)((dmoy)&0x00FF);
        distseg--;  // FIXME

#ifdef ANGLEONLY
        P1AH = points2aH[idxPt1];
        P1AV = points2aV[idxPt1];

        P2AH = points2aH[idxPt2];
        P2AV = points2aV[idxPt2];

        P1X = (SCREEN_WIDTH - P1AH) >> 1;
        P1Y = (SCREEN_HEIGHT - P1AV) >> 1;
        P2X = (SCREEN_WIDTH - P2AH) >> 1;
        P2Y = (SCREEN_HEIGHT - P2AV) >> 1;
#else 
        P1X = points2aH[idxPt1];
        P1Y = points2aV[idxPt1];
        P2X = points2aH[idxPt2];
        P2Y = points2aV[idxPt2];

#endif
        // printf ("dl ([%d, %d] , [%d, %d] => %d c=%d\n", P1X, P1Y, P2X, P2Y, distseg, char2disp); get();
        lrDrawLine();
    }
#ifdef USE_PROFILER
PROFILE_LEAVE(ROUTINE_GLDRAWSEGMENTS);
#endif // USE_PROFILER


}
void glDrawParticules(){
    unsigned char ii = 0;

    unsigned char idxPt, offPt, dchar;
    unsigned int  dist;

#ifdef USE_PROFILER
PROFILE_ENTER(ROUTINE_GLDRAWPARTICULES);
#endif // USE_PROFILER

    for (ii = 0; ii < nbParticules; ii++) {
        idxPt    = particulesPt[ii];  // ii*SIZEOF_SEGMENT +0
        ch2disp = particulesChar[ii];    // ii*SIZEOF_SEGMENT +2
        printf ("particules : %d %d\n ", idxPt, ch2disp);
        dchar = points2dL[idxPt]-2 ; //FIXME : -2 to helps particule to be displayed
        P1X = (SCREEN_WIDTH -points2aH[idxPt]) >> 1;
        P1Y = (SCREEN_HEIGHT - points2aV[idxPt]) >> 1;
#ifdef USE_ZBUFFER
        zplot(P1X, P1Y, dchar, ch2disp);
#else
        // TODO : plot a point with no z-buffer
        plot(A1X, A1Y, ch2disp);
#endif

    }
#ifdef USE_PROFILER
PROFILE_LEAVE(ROUTINE_GLDRAWPARTICULES);
#endif // USE_PROFILER

}

#endif