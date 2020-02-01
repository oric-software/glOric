/* lrsDrawing */

#include "config.h"
#include "glOric.h"

#include "raster\bresfill.h"
#include "render\zbuffer.h"
#include "util\util.h"

signed char _brX;
signed char _brY;
signed char _brDx;
signed char _brDy;
signed char _brDestX;
signed char _brDestY;
signed char _brErr;
signed char _brSx;
signed char _brSy;

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

#define DOLLAR 36

void lrDrawLine(signed char x0, signed char y0, signed char x1, signed char y1, unsigned char distseg, char ch2disp) {
    signed char e2;
    char        char2disp;

    _brX     = x0;
    _brY     = y0;
    _brDestX = x1;
    _brDestY = y1;
    _brDx    = abs(x1 - x0);
    _brDy    = -abs(y1 - y0);
    _brSx    = x0 < x1 ? 1 : -1;
    _brSy    = y0 < y1 ? 1 : -1;
    _brErr   = _brDx + _brDy;
    if ((_brErr > 64) || (_brErr < -63))
        return;

    if ((ch2disp == '/') && (_brSx == -1)) {
        char2disp = DOLLAR;
    } else {
        char2disp = ch2disp;
    }

    while (1) {  // loop
                 // plot (brX, brY, distseg, ch2disp)
                 //printf ("plot [%d, %d] %d %s\n", _brX, _brY, distseg, ch2disp);
#ifdef USE_ZBUFFER
        zplot(_brX, _brY, distseg, char2disp);
#else
        // TODO : plot a point with no z-buffer
#endif
        if ((_brX == _brDestX) && (_brY == _brDestY))
            break;
        //e2 = 2*err;
        e2 = (_brErr < 0) ? (
                                ((_brErr & 0x40) == 0) ? (
                                                             0x80)
                                                       : (
                                                             _brErr << 1))
                          : (
                                ((_brErr & 0x40) != 0) ? (
                                                             0x7F)
                                                       : (
                                                             _brErr << 1));
        if (e2 >= _brDy) {
            _brErr += _brDy;  // e_xy+e_x > 0
            _brX += _brSx;
        }
        if (e2 <= _brDx) {  // e_xy+e_y < 0
            _brErr += _brDx;
            _brY += _brSy;
        }
    }
}

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

void lrDrawSegments(char points2d[], unsigned char segments[], unsigned char nbSegments) {
    unsigned char ii = 0;
    unsigned char jj = 0;
    unsigned char idxPt1, idxPt2;
    unsigned char offPt1, offPt2;
    int           dmoy;
    unsigned char distseg;
    char          char2disp;

    signed char P1X;
    signed char P1Y;
    signed char P2X;
    signed char P2Y;

#ifdef ANGLEONLY
    signed char P1AH, P1AV, P2AH, P2AV;
#endif

    for (ii = 0; ii < nbSegments; ii++) {
        jj = ii << 2;  // ii*SIZEOF_SEGMENT

        idxPt1    = segments[jj++];  // ii*SIZEOF_SEGMENT +0
        idxPt2    = segments[jj++];  // ii*SIZEOF_SEGMENT +1
        char2disp = segments[jj];    // ii*SIZEOF_SEGMENT +2

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

        //printf ("dl ([%d, %d] %d, [%d, %d] %d =>  %d\n", P1X, P1Y, d1, P2X, P2Y, d2, distseg);
        //get();
#else

        // P1AH = points2d[idxPt1*SIZEOF_2DPOINT + 0];
        // P1AV = points2d[idxPt1*SIZEOF_2DPOINT + 1];
        // P2AH = points2d[idxPt2*SIZEOF_2DPOINT + 0];
        // P2AV = points2d[idxPt2*SIZEOF_2DPOINT + 1];

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

        //printf ("dl ([%d, %d] %d, [%d, %d] %d => %d c=%d\n", P1X, P1Y, d1, P2X, P2Y, d2, distseg, 0);
        //get();
        lrDrawLine(P1X, P1Y, P2X, P2Y, distseg, char2disp);

#endif
    }
}

#define ANGLE_MAX 0xC0
#define ANGLE_VIEW 0xE0

void fillFaces(char points2d[], unsigned char faces[], unsigned char nbFaces) {
    unsigned char ii = 0;
    unsigned char jj = 0;
    int           d1, d2, d3;
    int           dmoy;
    unsigned char idxPt1, idxPt2, idxPt3, distface;
    unsigned char offPt1, offPt2, offPt3;
    signed char   P1X, P1Y, P2X, P2Y, P3X, P3Y;
#ifdef ANGLEONLY
    signed char   tmpH, tmpV;
    signed char   P1AH, P1AV, P2AH, P2AV, P3AH, P3AV;
    unsigned char m1, m2, m3;
    unsigned char v1, v2, v3;
#endif

    //printf ("%d Points, %d Segments, %d Faces\n", nbPts, nbSegments, nbFaces); get();
    for (ii = 0; ii < nbFaces; ii++) {
        jj = ii << 2;
        // idxPt1 = faces[ii*SIZEOF_FACES+0];
        // idxPt2 = faces[ii*SIZEOF_FACES+1];
        // idxPt3 = faces[ii*SIZEOF_FACES+2];

        // idxPt1 = faces[jj++];
        // idxPt2 = faces[jj++];
        // idxPt3 = faces[jj++];

        offPt1 = faces[jj++] << 2;
        offPt2 = faces[jj++] << 2;
        offPt3 = faces[jj++] << 2;
        //printf ("face %d : %d %d %d\n",ii, offPt1, offPt2, offPt3);get();
        d1 = *((int*)(points2d + offPt1 + 2));

        d2 = *((int*)(points2d + offPt2 + 2));

        d3 = *((int*)(points2d + offPt3 + 2));

        //dmoy = (d1+d2+d3)/3;
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
        fill8(P1X, P1Y,
              P2X, P2Y,
              P3X, P3Y,
              distface, faces[jj]);

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
        //printf ("AHs [%d, %d, %d] [%x, %x], %x], %x, %x, %x]\n", P1AH, P2AH, P3AH, m1, m2, m3, v1,v2,v3);
        //get();

        if ((m1 == 0x00) || (m1 == ANGLE_MAX)) {
            if ((v1 == 0x00) || (v1 == ANGLE_VIEW)) {
                if (
                    (
                        (P1AH & 0x80) != (P2AH & 0x80)) ||
                    ((P1AH & 0x80) != (P3AH & 0x80))) {
                    if ((abs(P3AH) < 127 - abs(P1AH))) {
                        fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                    }
                } else {
                    fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                }
            } else {
                // P1 FRONT
                if ((m2 == 0x00) || (m2 == ANGLE_MAX)) {
                    // P2 FRONT
                    if ((m3 == 0x00) || (m3 == ANGLE_MAX)) {
                        // P3 FRONT
                        // _4_
                        if (((P1AH & 0x80) != (P2AH & 0x80)) || ((P1AH & 0x80) != (P3AH & 0x80))) {
                            fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                        } else {
                            // nothing to do
                        }
                    } else {
                        // P3 BACK
                        // _3_
                        if ((P1AH & 0x80) != (P2AH & 0x80)) {
                            if (abs(P2AH) < 127 - abs(P1AH)) {
                                fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                            }
                        } else {
                            if ((P1AH & 0x80) != (P3AH & 0x80)) {
                                if (abs(P3AH) < 127 - abs(P1AH)) {
                                    fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                                }
                            }
                        }

                        if ((P1AH & 0x80) != (P3AH & 0x80)) {
                            if (abs(P3AH) < 127 - abs(P1AH)) {
                                fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                            }
                        }
                    }
                } else {
                    // P2 BACK
                    // _2_ nothing to do
                    if ((P1AH & 0x80) != (P2AH & 0x80)) {
                        if (abs(P2AH) < 127 - abs(P1AH)) {
                            fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                        }
                    } else {
                        if ((P1AH & 0x80) != (P3AH & 0x80)) {
                            if (abs(P3AH) < 127 - abs(P1AH)) {
                                fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
                            }
                        }
                    }

                    if ((P1AH & 0x80) != (P3AH & 0x80)) {
                        if (abs(P3AH) < 127 - abs(P1AH)) {
                            fillFace(P1AH, P1AV, P2AH, P2AV, P3AH, P3AV, distface, faces[jj]);
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
