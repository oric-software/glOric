
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
