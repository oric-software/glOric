#include "config.h"


#ifdef USE_REWORKED_BUFFERS
extern signed char points3dX[];
extern signed char points3dY[];
extern signed char points3dZ[];
extern signed char points2aH[];
extern signed char points2aV[];
extern signed char points2dH[];
extern signed char points2dL[];
extern unsigned char nbPoints;

#ifdef USE_C_ARRAYSPROJECT
void glProjectArrays(){
    unsigned char ii;
    signed char x, y, z;
    signed char ah, av;
    unsigned int dist ;
    unsigned char options=0;

    for (ii = 0; ii < nbPoints; ii++){
        x = points3dX[ii];
        y = points3dY[ii];
        z = points3dZ[ii];

        projectPoint(x, y, z, options, &ah, &av, &dist);

        points2aH[ii] = ah;
        points2aV[ii] = av;
        points2dH[ii] = (signed char)((dist & 0xFF00)>>8) && 0x00FF;
        points2dL[ii] = (signed char) (dist & 0x00FF);

    }
}
#endif // USE_C_ARRAYSPROJECT
#endif // USE_REWORKED_BUFFERS
