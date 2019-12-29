#include <stdio.h>
#include <conio.h>
#include <tgi.h>

#include "glOric.h"
#include "config.h"

extern unsigned char une_fonction();
extern void glProject2 (char *tabpoint2D, char *tabpoint3D, unsigned char nbPoints, unsigned char opts);


unsigned char nbPts;
char points3d[NB_MAX_POINTS*SIZEOF_3DPOINT];
char points2d [NB_MAX_POINTS*SIZEOF_2DPOINT];



int main ()
{

unsigned char val;

tgi_install (tgi_static_stddrv);

tgi_init ();
tgi_clear ();

/*
blit_picture(1,1,william_pic[0]/6,william_pic[1], william_pic);

tgi_outtextxy (50,50,"hello");
tgi_setpixel(200,100);
tgi_line(1,1,100,100);
*/

val = une_fonction();
glProject2 (points2d, points3d, 1, 0);
printf("Press a key to return to basic \n");
cgetc();

tgi_done();

return 0;
}
