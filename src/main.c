#include "lib.h"

#include "config.h"
#include "glOric.h"


#ifndef HRSMODE
char status_string[50];

void dispInfo(){
	sprintf(status_string,"(x=%d y=%d z=%d) [%d %d]", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
	AdvancedPrint(2,1,status_string);

}
#endif


void main()
{


#ifdef TEXTMODE
	textDemo();
#endif
#ifdef HRSMODE
	hiresDemo();
#endif
#ifdef LRSMODE
	faceDemo();
#endif

}
