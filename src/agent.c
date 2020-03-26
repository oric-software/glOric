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



#ifdef USE_SATURATION
#ifdef USE_C_AGENTSTEP

void A1stepY_A1Right() {
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
            if (A1X == SCREEN_WIDTH - 1){
                switch_A1XSatur();
            }
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

void A2stepY_A1Right() {
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
#ifdef USE_COLOR
            if (A2X == COLUMN_OF_COLOR_ATTRIBUTE){
#else
            if (A2X == 0){
#endif
                switch_A2XSatur();
            }
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

void A1stepY_A1Left() {
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
#ifdef USE_COLOR
            if (A1X == COLUMN_OF_COLOR_ATTRIBUTE){
#else
            if (A1X == 0){
#endif
                switch_A1XSatur();
            }
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

void A2stepY_A1Left() {
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
            if (A2X == SCREEN_WIDTH - 1){
                switch_A2XSatur();
            }
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


#endif // USE_C_AGENTSTEP

#endif // USE_SATURATION
