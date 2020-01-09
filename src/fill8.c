

signed char  A1X=0;
signed char  A1Y=0;
signed char  A1destX=0;
signed char  A1destY=0;
signed char  A1dX=0;
signed char  A1dY=0;
signed char  A1err=0;
signed char A1sX=0;
signed char A1sY=0;
char A1arrived=0;

signed char  A2X=0;
signed char  A2Y=0;
signed char  A2destX=0;
signed char  A2destY=0;
signed char  A2dX=0;
signed char  A2dY=0;
signed char  A2err=0;
signed char A2sX=0;
signed char A2sY=0;
char A2arrived=0;

void A1stepY(){
	signed char  nxtY, e2;
	nxtY = A1Y+A1sY;
	e2 = 2*A1err;
	//printf ("step nxtY = %d, e2 = %d\n",nxtY, e2);
	//printf ("step A1destX = %d, A1destY = %d\n",A1destX, A1destY);

	while ((A1arrived == 0) && ((e2>A1dX) || (A1Y!=nxtY))){
		if (e2 >= A1dY){
			A1err += A1dY;
			A1X += A1sX;
		}
		if (e2 <= A1dX){
			A1err += A1dX;
			A1Y += A1sY;
		}
		//printf ("step A1X = %d, A1Y = %d\n",A1X, A1Y);
		A1arrived=((A1X == A1destX) && ( A1Y == A1destY))?1:0;
		e2 = 2*A1err;
		//cgetc();
	}
}

void A2stepY(){
	signed char  nxtY, e2;
	nxtY = A2Y+A2sY	;
	e2 = 2*A2err;
	while ((A2arrived == 0) && ((e2>A2dX) || (A2Y!=nxtY))){
		if (e2 >= A2dY){
			A2err += A2dY;
			A2X += A2sX;
		}
		if (e2 <= A2dX){
			A2err += A2dX;
			A2Y += A2sY;
		}
		A2arrived=((A2X == A2destX) && ( A2Y == A2destY))?1:0;
		e2 = 2*A2err;
	}
}

void hfill8 (signed char p1x, signed char p2x, signed char py, unsigned char dist, char char2disp){

	/*Point1X = p1x;
	Point1Y = py;
	Point2X = p2x;
	Point2Y = py;
	char2Display = 42;
	drawLine ();*/
    signed char dx, fx;
    signed char ii;
    if ((py <= 0) || (py>=SCREEN_HEIGHT)) return;
	
    if (p1x < p2x) {
        dx = p1x;
        fx = p2x;
    } else {
        dx = p2x;
        fx = p1x;
    }
	//printf ("%d [%d -> %d] %d \n", py, dx, fx, dist);
    for (ii=dx; ii<=fx; ii++ ) {
        if ((ii >= 2) && (ii<=SCREEN_WIDTH)) {
            if (dist < zbuffer[py*SCREEN_WIDTH+ii]){
				//printf ("[%d, %d] <- %d (%d) \n", ii, py, char2disp, dist);
				zbuffer[py*SCREEN_WIDTH+ii] = dist;
				fbuffer[py*SCREEN_WIDTH+ii] = char2disp;
			}
        }
    }

}
void fill8(signed char p1x, signed char p1y, signed char p2x,signed char  p2y, signed char  p3x, signed char  p3y, unsigned char dist, char char2disp){
	signed char  pDepX;
	signed char  pDepY;
	signed char  pArr1X;
	signed char  pArr1Y;
	signed char  pArr2X;
	signed char  pArr2Y;

	//printf ("fill [%d %d] [%d %d] [%d %d] %d %d\n", p1x, p1y, p2x, p2y, p3x, p3y, dist, char2disp);


	if (p1y <= p2y) {
		if (p2y <= p3y) {
			pDepX = p3x;
			pDepY = p3y;
			pArr1X = p2x;
			pArr1Y = p2y;
			pArr2X = p1x;
			pArr2Y = p1y;
		} else {
			pDepX = p2x;
			pDepY = p2y;
			if (p1y <= p3y){
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
			pDepX = p3x;
			pDepY = p3y;
			pArr1X = p1x;
			pArr1Y = p1y;
			pArr2X = p2x;
			pArr2Y = p2y;
		} else {
			pDepX = p1x;
			pDepY = p1y;
			if (p2y <= p3y){
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

	if (pDepY != pArr1Y) {
        //a1 = bres_agent(pDep[0],pDep[1],pArr1[0],pArr1[1])
		A1X = pDepX;
		A1Y = pDepY;
		A1destX=pArr1X;
		A1destY=pArr1Y;
		A1dX=abs(A1destX-A1X);
		A1dY=-abs(A1destY-A1Y);
		A1err=A1dX+A1dY;
		A1sX=(A1X<A1destX)?1:-1;
		A1sY=(A1Y<A1destY)?1:-1;
		A1arrived=((A1X == A1destX) && ( A1Y == A1destY))?1:0;

        //a2 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
		A2X = pDepX;
		A2Y = pDepY;
		A2destX=pArr2X;
		A2destY=pArr2Y;
		A2dX=abs(A2destX-A2X);
		A2dY=-abs(A2destY-A2Y);
		A2err=A2dX+A2dY;
		A2sX=(A2X<A2destX)?1:-1;
		A2sY=(A2Y<A2destY)?1:-1;
		A2arrived=((A2X == A2destX) && ( A2Y == A2destY))?1:0;

		//printf ("0 [%d %d] [%d %d] \n", A1X, A1Y, A2X, A2Y);
		hfill8 (A1X, A2X, A1Y, dist, char2disp);
        //while (not (a1.arrived)):
        //    print (a1.stepY(), a2.stepY())
		while (A1arrived == 0){

			A1stepY();
			A2stepY();
			//printf ("1 [%d %d] [%d %d] \n", A1X, A1Y, A2X, A2Y);
			hfill8 (A1X, A2X, A1Y, dist, char2disp);

		}
		//printf ("step1\n");
        //a1 = bres_agent(pArr1[0],pArr1[1],pArr2[0],pArr2[1])
		A1X = pArr1X;
		A1Y = pArr1Y;
		A1destX=pArr2X;
		A1destY=pArr2Y;
		A1dX=abs(A1destX-A1X);
		A1dY=-abs(A1destY-A1Y);
		A1err=A1dX+A1dY;
		A1sX=(A1X<A1destX)?1:-1;
		A1sY=(A1Y<A1destY)?1:-1;
		A1arrived=((A1X == A1destX) && ( A1Y == A1destY))?1:0;
        //while (not (a1.arrived and a2.arrived)):
        //    print (a1.stepY(), a2.stepY())
		while ((A1arrived == 0) && (A2arrived == 0)){
			A1stepY();
			A2stepY();
			//printf ("2 [%d %d] [%d %d] \n", A1X, A1Y, A2X, A2Y);
			hfill8 (A1X, A2X, A1Y, dist, char2disp);

		}


	} else {
        // a1 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
		A1X = pDepX;
		A1Y = pDepY;
		A1destX=pArr2X;
		A1destY=pArr2Y;
		A1dX=abs(A1destX-A1X);
		A1dY=-abs(A1destY-A1Y);
		A1err=A1dX+A1dY;
		A1sX=(A1X<A1destX)?1:-1;
		A1sY=(A1Y<A1destY)?1:-1;
		A1arrived=((A1X == A1destX) && ( A1Y == A1destY))?1:0;

        // a2 = bres_agent(pArr1[0],pArr1[1],pArr2[0],pArr2[1])
		A2X = pArr1X;
		A2Y = pArr1Y;
		A2destX=pArr2X;
		A2destY=pArr2Y;
		A2dX=abs(A2destX-A2X);
		A2dY=-abs(A2destY-A2Y);
		A2err=A2dX+A2dY;
		A2sX=(A2X<A2destX)?1:-1;
		A2sY=(A2Y<A2destY)?1:-1;
		A2arrived=((A2X == A2destX) && ( A2Y == A2destY))?1:0;


        // print ([a1.X, a1.Y], [a2.X, a2.Y])
		//printf ("3 [%d %d] [%d %d] \n", A1X, A1Y, A2X, A2Y);
		hfill8 (A1X, A2X, A1Y, dist, char2disp);

        // while (not (a1.arrived and a2.arrived)):
        //    print (a1.stepY(), a2.stepY())
		while ((A1arrived == 0) && (A2arrived == 0)){
			A1stepY();
			A2stepY();
			//printf ("3 [%d %d] [%d %d] \n", A1X, A1Y, A2X, A2Y);
			hfill8 (A1X, A2X, A1Y, dist, char2disp);
		}
	}
}
