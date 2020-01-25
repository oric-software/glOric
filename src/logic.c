void forward() {
	if (-112 >= CamRotZ) {
		CamPosX--;
	} else if ((-112 < CamRotZ) && (-80 >= CamRotZ)){
		CamPosX--; CamPosY--;
	} else if (( -80 < CamRotZ) && (-48 >= CamRotZ)){
		CamPosY--;
	} else if (( -48 < CamRotZ) && (-16 >= CamRotZ)){
		CamPosX++; CamPosY--;
	} else if (( -16 < CamRotZ) && ( 16 >= CamRotZ)){
		CamPosX++;
	} else if ((  16 < CamRotZ) && ( 48 >= CamRotZ)){
		CamPosX++; CamPosY++;
	} else if ((  48 < CamRotZ) && ( 80 >= CamRotZ)){
		CamPosY++;
	} else if ((  80 < CamRotZ) && (112 >= CamRotZ)){
		CamPosX--; CamPosY++;
	} else {
		CamPosX--;
	}
}
void backward() {
	if (-112 >= CamRotZ) {
		CamPosX++;
	} else if ((-112 < CamRotZ) && (-80 >= CamRotZ)){
		CamPosX++; CamPosY++;
	} else if (( -80 < CamRotZ) && (-48 >= CamRotZ)){
		CamPosY++;
	} else if (( -48 < CamRotZ) && (-16 >= CamRotZ)){
		CamPosX--; CamPosY++;
	} else if (( -16 < CamRotZ) && ( 16 >= CamRotZ)){
		CamPosX--;
	} else if ((  16 < CamRotZ) && ( 48 >= CamRotZ)){
		CamPosX--; CamPosY--;
	} else if ((  48 < CamRotZ) && ( 80 >= CamRotZ)){
		CamPosY--;
	} else if ((  80 < CamRotZ) && (112 >= CamRotZ)){
		CamPosX++; CamPosY--;
	} else {
		CamPosX++;
	}

}
void shiftLeft() {
	if (-112 >= CamRotZ) {
		CamPosY--;
	} else if ((-112 < CamRotZ) && (-80 >= CamRotZ)){
		CamPosX++; CamPosY--;
	} else if (( -80 < CamRotZ) && (-48 >= CamRotZ)){
		CamPosX--;
	} else if (( -48 < CamRotZ) && (-16 >= CamRotZ)){
		CamPosX++; CamPosY++;
	} else if (( -16 < CamRotZ) && ( 16 >= CamRotZ)){
		CamPosY++;
	} else if ((  16 < CamRotZ) && ( 48 >= CamRotZ)){
		CamPosX--; CamPosY++;
	} else if ((  48 < CamRotZ) && ( 80 >= CamRotZ)){
		CamPosX--;
	} else if ((  80 < CamRotZ) && (112 >= CamRotZ)){
		CamPosX--; CamPosY--;
	} else {
		CamPosY--;
	}
}
void shiftRight() {
	if (-112 >= CamRotZ) {
		CamPosY++;
	} else if ((-112 < CamRotZ) && (-80 >= CamRotZ)){
		CamPosX--; CamPosY++;
	} else if (( -80 < CamRotZ) && (-48 >= CamRotZ)){
		CamPosX++;
	} else if (( -48 < CamRotZ) && (-16 >= CamRotZ)){
		CamPosX--; CamPosY--;
	} else if (( -16 < CamRotZ) && ( 16 >= CamRotZ)){
		CamPosY--;
	} else if ((  16 < CamRotZ) && ( 48 >= CamRotZ)){
		CamPosX++; CamPosY--;
	} else if ((  48 < CamRotZ) && ( 80 >= CamRotZ)){
		CamPosX++;
	} else if ((  80 < CamRotZ) && (112 >= CamRotZ)){
		CamPosX++; CamPosY++;
	} else {
		CamPosX++;
	}
}
