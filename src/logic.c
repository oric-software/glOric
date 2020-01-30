#include "config.h"
#include "glOric.h"

#include "util\util.h"
extern unsigned char isAllowedPosition(signed int X, signed int Y, signed int Z);

void forward() {
	
	signed int X, Y;
	X = CamPosX;
	Y = CamPosY;
	
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
	if (! isAllowedPosition(CamPosX, CamPosY, CamPosZ)){
		CamPosX = X;
		CamPosY = Y;
	}
}
void backward() {
	signed int X, Y;
	X = CamPosX;
	Y = CamPosY;

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
	if (! isAllowedPosition(CamPosX, CamPosY, CamPosZ)){
		CamPosX = X;
		CamPosY = Y;
	}

}
void shiftLeft() {
	signed int X, Y;
	X = CamPosX;
	Y = CamPosY;

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
	if (! isAllowedPosition(CamPosX, CamPosY, CamPosZ)){
		CamPosX = X;
		CamPosY = Y;
	}
}
void shiftRight() {
	signed int X, Y;
	X = CamPosX;
	Y = CamPosY;

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
	if (! isAllowedPosition(CamPosX, CamPosY, CamPosZ)){
		CamPosX = X;
		CamPosY = Y;
	}
}
