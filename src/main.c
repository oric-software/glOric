#include "lib.h"

#include "config.h"
#include "glOric.h"

//#include "externs.c"
//#include "data/geom.c"




#ifndef HRSMODE
char status_string[50];

void dispInfo(){
	sprintf(status_string,"(x=%d y=%d z=%d) [%d %d]", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
	AdvancedPrint(2,1,status_string);

}
#endif
/*
#ifdef TEXTMODE
#include "logic.c"
#include "txtDemo.c"
#endif

#ifdef HRSMODE
#include "render\hrsDrawing.c"
#include "hrsDemo.c"
#endif

#ifdef LRSMODE
//#include "raster\bresfill.c"
//#include "render\lrsDrawing.c"
//#include "logic.c"
//#include "lrsDemo.c"
#endif
*/

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
