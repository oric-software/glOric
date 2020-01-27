


void hrDrawSegments(){
	unsigned char ii = 0;
	unsigned char idxPt1, idxPt2;
	for (ii = 0; ii< nbSegments; ii++){

		idxPt1 =            segments[ii*SIZEOF_SEGMENT + 0];
		idxPt2 =            segments[ii*SIZEOF_SEGMENT + 1];
		char2Display =      segments[ii*SIZEOF_SEGMENT + 2];

        OtherPixelX=points2d[idxPt1*SIZEOF_2DPOINT + 0];
        OtherPixelY=points2d[idxPt1*SIZEOF_2DPOINT + 2];
        CurrentPixelX=points2d[idxPt2*SIZEOF_2DPOINT + 0];
        CurrentPixelY=points2d[idxPt2*SIZEOF_2DPOINT + 2];
		if ((OtherPixelX >0 ) && (OtherPixelX <240 ) && (CurrentPixelY>0) && (CurrentPixelY<200)) {
			DrawLine8();
		}
	}
}
void hrDrawFace(char p2d[], unsigned char idxPt1, unsigned char idxPt2, unsigned char idxPt3, unsigned char pattern){
	AddTriangle(
		p2d[idxPt1*SIZEOF_2DPOINT + 0],p2d[idxPt1*SIZEOF_2DPOINT + 2],
		p2d[idxPt2*SIZEOF_2DPOINT + 0],p2d[idxPt2*SIZEOF_2DPOINT + 2],
		p2d[idxPt3*SIZEOF_2DPOINT + 0],p2d[idxPt3*SIZEOF_2DPOINT + 2],
		(pattern&3));
}

void hrDrawFaces(){
	hrDrawFace(points2d, 0, 1, 2, 2);
	hrDrawFace(points2d, 0, 2, 3, 2);
	//hrDrawFace(points2d, 0, 1, 5, 1);
	//hrDrawFace(points2d, 0, 5, 4, 1);
	hrDrawFace(points2d, 4, 5, 6, 0);
	hrDrawFace(points2d, 4, 6, 7, 0);
	
}
/*
void hrDrawSegments2(){
	unsigned char ii = 0;
	unsigned char idxPt1, idxPt2;
	int OtherPixelX, OtherPixelY, CurrentPixelX, CurrentPixelY;
	for (ii = 0; ii< nbSegments; ii++){

		idxPt1 =            segments[ii*SIZEOF_SEGMENT + 0];
		idxPt2 =            segments[ii*SIZEOF_SEGMENT + 1];

        //OtherPixelX= (int)points2d[idxPt1*SIZEOF_2DPOINT + 0];
		OtherPixelX=((int *)points2d)[idxPt1*2];
        //OtherPixelY= (int)points2d[idxPt1*SIZEOF_2DPOINT + 2];
		OtherPixelY=((int *)points2d)[idxPt1*2+1];

        //CurrentPixelX=(int)points2d[idxPt2*SIZEOF_2DPOINT + 0];
		CurrentPixelX=((int *)points2d)[idxPt2*2];
        //CurrentPixelY=(int)points2d[idxPt2*SIZEOF_2DPOINT + 2];
		CurrentPixelY=((int *)points2d)[idxPt2*2+1];
		printf("%d %d %d %d \n",
		OtherPixelX, OtherPixelY, CurrentPixelX, CurrentPixelY);
		//cgetc();
		//tgi_line(OtherPixelX,OtherPixelY,CurrentPixelX,CurrentPixelY);
	}
}


void debugHiresIntro (){
    int i;
    //hires();

	CamPosX = -24;
	CamPosY = 0;
	CamPosZ = 3;

 	CamRotZ = 64 ;
	CamRotX = 2;

    for (i=0;i<2;) {
		CamPosX = traj[i++];
		CamPosY = traj[i++];
		CamRotZ = traj[i++];
		i = i % (NB_POINTS_TRAJ*SIZE_POINTS_TRAJ);
        glProject (points2d, points3d, nbPts);
        //memset ( 0xa000, 64, 8000); // clear screen
		hrDrawSegments2();
		//hrDrawFaces();
    }

	//leaveSC();

}
*/
