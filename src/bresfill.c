
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
void fill8();

#ifdef USE_C_BRESFILL
void hfill();
#endif  // USE_C_BRESFILL

#ifdef USE_C_BRESFILL

void A1stepY() {
    signed char nxtY, e2;
    nxtY = A1Y + A1sY;
    //printf ("nxtY = %d\n", nxtY);
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
    //printf ("e2 = %d\n", e2);
    while ((A1arrived == 0) && ((e2 > A1dX) || (A1Y != nxtY))) {
        if (e2 >= A1dY) {
            A1err += A1dY;
            //printf ("A1err = %d\n", A1err);
            A1X += A1sX;
            //printf ("A1X = %d\n", A1X);
        }
        if (e2 <= A1dX) {
            A1err += A1dX;
            //printf ("A1err = %d\n", A1err);
            A1Y += A1sY;
            //printf ("A1Y = %d\n", A1Y);
        }
        A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;
        e2        = (A1err < 0) ? (
                               ((A1err & 0x40) == 0) ? (
                                                           0x80)
                                                     : (
                                                           A1err << 1))
                         : (
                               ((A1err & 0x40) != 0) ? (
                                                           0x7F)
                                                     : (
                                                           A1err << 1));
        //printf ("e2 = %d\n", e2);
    }
}

void A2stepY() {
    signed char nxtY, e2;
    nxtY = A2Y + A2sY;
    e2   = (A2err < 0) ? (
                           ((A2err & 0x40) == 0) ? (
                                                       0x80)
                                                 : (
                                                       A2err << 1))
                     : (
                           ((A2err & 0x40) != 0) ? (
                                                       0x7F)
                                                 : (
                                                       A2err << 1));
    while ((A2arrived == 0) && ((e2 > A2dX) || (A2Y != nxtY))) {
        if (e2 >= A2dY) {
            A2err += A2dY;
            A2X += A2sX;
        }
        if (e2 <= A2dX) {
            A2err += A2dX;
            A2Y += A2sY;
        }
        A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;
        e2        = (A2err < 0) ? (
                               ((A2err & 0x40) == 0) ? (
                                                           0x80)
                                                     : (
                                                           A2err << 1))
                         : (
                               ((A2err & 0x40) != 0) ? (
                                                           0x7F)
                                                     : (
                                                           A2err << 1));
    }
}
#endif  // USE_C_BRESFILL

// fillface
extern signed char   P1X, P1Y, P2X, P2Y, P3X, P3Y;
extern signed char   P1AH, P1AV, P2AH, P2AV, P3AH, P3AV;
extern unsigned char distface;
extern char          ch2disp;

#ifdef USE_C_ANGLE2SCREEN
void angle2screen() {
    P1X = (SCREEN_WIDTH - P1AH) >> 1;
    P1Y = (SCREEN_HEIGHT - P1AV) >> 1;
    P2X = (SCREEN_WIDTH - P2AH) >> 1;
    P2Y = (SCREEN_HEIGHT - P2AV) >> 1;
    P3X = (SCREEN_WIDTH - P3AH) >> 1;
    P3Y = (SCREEN_HEIGHT - P3AV) >> 1;
}
#endif  // USE_C_ANGLE2SCREEN

void fillFace() {
    angle2screen();

    // printf ("P1A: [%d, %d], P2A: [%d, %d], P3A [%d, %d]\n", P1AH, P1AV, P2AH, P2AV, P3AH, P3AV);
    // printf ("P1:[%d, %d], P2:[%d, %d], P3[%d, %d]\n", P1X, P1Y, P2X, P2Y, P3X, P3Y);get();
    // printf ("distface = %d char = %d\n",distface, ch2disp);
    // get();

// #ifdef USE_PROFILER
//             PROFILE_ENTER(ROUTINE_FILL8);
// #endif
    fill8();
// #ifdef USE_PROFILER
//             PROFILE_LEAVE(ROUTINE_FILL8);
// #endif
}

// fill8
extern signed char pDepX;
extern signed char pDepY;
extern signed char pArr1X;
extern signed char pArr1Y;
extern signed char pArr2X;
extern signed char pArr2Y;

extern unsigned char log2_tab[];
extern signed char mDeltaY1, mDeltaX1, mDeltaY2, mDeltaX2;


#ifdef USE_C_BRESFILL
void prepare_bresrun() {
    if (P1Y <= P2Y) {
        if (P2Y <= P3Y) {
            pDepX  = P3X;
            pDepY  = P3Y;
            pArr1X = P2X;
            pArr1Y = P2Y;
            pArr2X = P1X;
            pArr2Y = P1Y;
        } else {
            pDepX = P2X;
            pDepY = P2Y;
            if (P1Y <= P3Y) {
                pArr1X = P3X;
                pArr1Y = P3Y;
                pArr2X = P1X;
                pArr2Y = P1Y;
            } else {
                pArr1X = P1X;
                pArr1Y = P1Y;
                pArr2X = P3X;
                pArr2Y = P3Y;
            }
        }
    } else {
        if (P1Y <= P3Y) {
            pDepX  = P3X;
            pDepY  = P3Y;
            pArr1X = P1X;
            pArr1Y = P1Y;
            pArr2X = P2X;
            pArr2Y = P2Y;
        } else {
            pDepX = P1X;
            pDepY = P1Y;
            if (P2Y <= P3Y) {
                pArr1X = P3X;
                pArr1Y = P3Y;
                pArr2X = P2X;
                pArr2Y = P2Y;
            } else {
                pArr1X = P2X;
                pArr1Y = P2Y;
                pArr2X = P3X;
                pArr2Y = P3Y;
            }
        }
    }
}
#endif  // USE_C_BRESFILL

#ifdef USE_C_REACHSCREEN
void reachScreen(){
#ifdef USE_COLOR
        while (A1Y >= SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR) {
#else
        while (A1Y >= SCREEN_HEIGHT) {
#endif
            A1stepY();
            A2stepY();
        }
}
#endif // USE_C_REACHSCREEN

#ifdef USE_C_BRESTYPE1

void bresStepType1() {
        // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
        reachScreen()   ;
        // A1Right = (A1X > A2X); 
        hzfill();
        while ((A1arrived == 0) && (A1Y > 1)){
            A1stepY();
            A2stepY();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            hzfill();

        }

}
#endif // USE_C_BRESTYPE1

#ifdef USE_C_BRESTYPE2
void bresStepType2() {
// #ifdef USE_PROFILER
//             PROFILE_ENTER(ROUTINE_BRESRUNTYPE2);
// #endif
       while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1)) {
            A1stepY();
            A2stepY();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            hzfill();
        }

}
#endif // USE_C_BRESTYPE2

#ifdef USE_C_BRESTYPE3

void bresStepType3() {
// #ifdef USE_PROFILER
//             PROFILE_ENTER(ROUTINE_BRESRUNTYPE3);
// #endif
        // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
        reachScreen()   ;

        // A1Right = (A1X > A2X); 
        hzfill();

        while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1) ) {
            A1stepY();
            A2stepY();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            hzfill();
        }
// #ifdef USE_PROFILER
//             PROFILE_LEAVE(ROUTINE_BRESRUNTYPE3);
// #endif
}

#endif // USE_C_BRESTYPE3

#ifdef USE_C_ISA1RIGHT1
void isA1Right1 (){
    
    A1Right = 0;
//  log2_tab[];
    if ((mDeltaX1 & 0x80) == 0){
        
        if ((mDeltaX2 & 0x80) == 0){
            // printf ("%d*%d  %d*%d ", mDeltaY1, mDeltaX2, mDeltaY2,mDeltaX1);get ();
            A1Right = ((log2_tab[mDeltaX2] + log2_tab[mDeltaY1])/2) > ((log2_tab[mDeltaX1] + log2_tab[mDeltaY2])/2);
            // A1Right = mDeltaY1*mDeltaX2 > mDeltaY2*mDeltaX1;
        } else {
            A1Right = 0 ; // (mDeltaX1 < 0) 
        }
    } else {
        if ((mDeltaX2 & 0x80) == 0){
            A1Right = 1 ; // (mDeltaX1 < 0)
        } else {
            // printf ("%d*%d  %d*%d ", mDeltaY1, -mDeltaX2, mDeltaY2,-mDeltaX1);get ();
            A1Right = ((log2_tab[abs(mDeltaX2)] + log2_tab[mDeltaY1])/2) < ((log2_tab[abs(mDeltaX1)] + log2_tab[mDeltaY2])/2);
        }
    }
    // if (((mDeltaX1 & 0x80) ^ (mDeltaX2 & 0x80)) == 0) {
    //     A1Right = mDeltaY1*mDeltaX2 > mDeltaY2*mDeltaX1; // (DeltaY1/DeltaX1) > (DeltaY2/DeltaX2) ;
    // }else {
    //     A1Right = (mDeltaX1 < 0) ;
    // }
    
    // A1Right = mDeltaY1*mDeltaX2 > mDeltaY2*mDeltaX1;


//  if (DeltaX1 == 0) {
//     A1Right = (DeltaX2 < 0);
//  } else {
//     if (DeltaX2 == 0){
//         A1Right = (DeltaX1 > 0);
//     } else {
//         if (((DeltaX1 & 0x80) ^ (DeltaX2 & 0x80)) == 0) {
//             A1Right = DeltaY1*DeltaX2 > DeltaY2*DeltaX1; // (DeltaY1/DeltaX1) > (DeltaY2/DeltaX2) ;
//         }else {
//             A1Right = (DeltaX1 > 0) ;
//         }
        
//     }
//  }
}
#endif // USE_C_ISA1RIGHT1

#ifdef USE_C_ISA1RIGHT3

void isA1Right3 (){
 A1Right = (A1X > A2X);
}
#endif // USE_C_ISA1RIGHT3

#ifdef USE_C_FILL8


void fill8() {
    //printf ("fill [%d %d] [%d %d] [%d %d] %d %d\n", p1x, p1y, p2x, p2y, p3x, p3y, dist, char2disp); get();
    prepare_bresrun();

    //printf ("Dep = [%d, %d], Arr1 = [%d, %d], Arr2= [%d, %d]\n", pDepX,pDepY, pArr1X, pArr1Y, pArr2X, pArr2Y);
    if (pDepY != pArr1Y) {
        //a1 = bres_agent(pDep[0],pDep[1],pArr1[0],pArr1[1])
        //a2 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
        A1X     = pDepX;
        A2X     = pDepX;
        A1Y     = pDepY;
        A2Y     = pDepY;

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

        A2destX = pArr2X;
        A2destY = pArr2Y;
        A2dX    = abs(A2destX - A2X);
        A2dY    = -abs(A2destY - A2Y);
        A2err   = A2dX + A2dY;
        if ((A2err > 64) || (A2err < -63))
            return;

        A2sX      = (A2X < A2destX) ? 1 : -1;
        A2sY      = (A2Y < A2destY) ? 1 : -1;
        A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;

        mDeltaY1 = (A1Y - A1destY);
        mDeltaX1 = (A1X - A1destX );
        mDeltaY2= (A2Y - A2destY);
        mDeltaX2 = (A2X - A2destX);

        isA1Right1 ();

        bresStepType1();

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

        bresStepType2();
    } else {
        // a1 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
        A1X     = pDepX;
        A1Y     = pDepY;
        A1destX = pArr2X;
        A1destY = pArr2Y;
        A1dX    = abs(A1destX - A1X);
        A1dY    = -abs(A1destY - A1Y);
        A1err   = A1dX + A1dY;

        if ((A1err > 64) || (A1err < -63))
            return;

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

        if ((A2err > 64) || (A2err < -63))
            return;

        A2sX      = (A2X < A2destX) ? 1 : -1;
        A2sY      = (A2Y < A2destY) ? 1 : -1;
        A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;

        isA1Right3();
        bresStepType3() ;
    }
}
#endif // USE_C_FILL8

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
