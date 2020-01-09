


void AddTriangle(unsigned char x0,unsigned char y0,unsigned char x1,unsigned char y1,unsigned char x2,unsigned char y2,unsigned char pattern)
{
    X0=x0;
    Y0=y0;
    X1=x1;
    Y1=y1;
    AddLineASM();
    X0=x0;
    Y0=y0;
    X1=x2;
    Y1=y2;
    AddLineASM();
    X0=x2;
    Y0=y2;
    X1=x1;
    Y1=y1;
    AddLineASM();

    CurrentPattern=pattern<<3;
    FillTablesASM();
}


void addCube(char X, char Y, char Z){
	unsigned char ii, jj;
	for (jj=0; jj < NB_POINTS_CUBE; jj++){
		points3d[(nbPts+jj)* SIZEOF_3DPOINT + 0] = ptsCube[jj*SIZEOF_3DPOINT + 0] + X;  				// X coord
		points3d[(nbPts+jj)* SIZEOF_3DPOINT + 1] = ptsCube[jj*SIZEOF_3DPOINT + 1] + Y;                // Y coord
		points3d[(nbPts+jj)* SIZEOF_3DPOINT + 2] = ptsCube[jj*SIZEOF_3DPOINT + 2] + Z;                // Z coord
	}
	for (jj=0; jj < NB_SEGMENTS_CUBE; jj++){
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 0] = segCube[jj*SIZEOF_SEGMENT + 0]+nbPts; // Index Point 1
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 1] = segCube[jj*SIZEOF_SEGMENT + 1]+nbPts; // Index Point 2
		segments[(nbSegments+jj)* SIZEOF_SEGMENT + 2] = segCube[jj*SIZEOF_SEGMENT + 2]; // Character
	}
	nbPts += NB_POINTS_CUBE;
	nbSegments += NB_SEGMENTS_CUBE;
}


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
void hiresIntro (){
    int i;

    enterSC();

	CamPosX = -24;
	CamPosY = 0;
	CamPosZ = 3;

 	CamRotZ = 64 ;			// -128 -> -127 unit : 2PI/(2^8 - 1)
	CamRotX = 2;

    for (i=0;i<120;) {
		CamPosX = traj[i++];
		CamPosY = traj[i++];
		CamRotZ = traj[i++];
		i = i % (NB_POINTS_TRAJ*SIZE_POINTS_TRAJ);
        glProject (points2d, points3d, nbPts);
        memset ( 0xa000, 64, 8000); // clear screen
		hrDrawSegments();
		hrDrawFaces();
    }

	leaveSC();

}
void hiresGameLoop() {

	char key;
	unsigned char i=0;
	key=get();
	glProject (points2d, points3d, nbPts); 

    while (1==1) {
		memset ( 0xa000, 64, 8000); // clear screen
		hrDrawSegments();
		hrDrawFaces();
		key=get();
		switch (key)	// key
		{
		case 8:	// gauche => tourne gauche
			i = (i+3)%(192);
			break;
		case 9:	// droite => tourne droite
			if (i == 0) i=192-3;
			i = (i-3);
			break;
		case 80: // P
			if (CamPosZ < 5) {
				CamPosZ += 1;
			}
			break;
		case 59: // ;
			if (CamPosZ > 0) {
				CamPosZ -= 1;
			}
			break;
		}
		CamPosX = traj[i+0];
		CamPosY = traj[i+1];
		CamRotZ = traj[i+2];

		glProject (points2d, points3d, nbPts);
	}
}

void hiresDemo(){
	GenerateTables(); // for line8
    ComputeDivMod(); // for filler
    InitTables();	//for filler

    hires(); 

	nbPts =0 ;
	nbSegments =0 ;
	addCube(-4, -4, 2);
	addCube(4, 4, 10);
	
	hiresIntro();
	
	hiresGameLoop();
}
