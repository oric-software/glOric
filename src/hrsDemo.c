





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
        glProject (points2d, points3d, nbPts, 0);
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
	glProject (points2d, points3d, nbPts, 0); 

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

		glProject (points2d, points3d, nbPts, 0);
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
