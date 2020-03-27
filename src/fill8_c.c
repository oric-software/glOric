
#ifdef USE_C_FILL8
void fill8() {

    prepare_bresrun();

    // printf ("Dep = [%d, %d], Arr1 = [%d, %d], Arr2= [%d, %d]\n", pDepX,pDepY, pArr1X, pArr1Y, pArr2X, pArr2Y);get();
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
