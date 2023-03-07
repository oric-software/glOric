#include "glOric.h"

extern signed char glSpriteX[];
extern signed char glSpriteY[];
extern signed char glSpriteZ[];
extern signed char *glSprites[];
extern unsigned char idxStar;
extern unsigned char plotX, plotY,distpoint;
extern char ch2disp;
extern int PointX, PointY, PointZ, ResX, ResY;
extern unsigned int Norm;


extern unsigned char glSpriteNbCar;
extern unsigned char glSpriteCarIdx;
extern signed char *glTabSprite;

extern unsigned char glNbSprites;
// _glSpriteIdx    .dsb 1

// _glSpriteNbCar  .dsb 1
// _glSpriteCarIdx .dsb 1

extern signed char glSpriteX[];
extern signed char glSpriteY[];
extern signed char glSpriteZ[];
extern signed char *glSprites[];


#ifdef USE_C_GLDRAWSPRITES

void glAddSprite(signed char X, signed char Y, signed char Z, signed char *theSprite ) {
    glSpriteX[glNbSprites]   = X;
    glSpriteY[glNbSprites]   = Y;
    glSpriteZ[glNbSprites]   = Z;
    glSprites[glNbSprites]   = theSprite;
    glNbSprites              += 1;
}


void glDrawSprites(){
    
    for (idxStar = 0; idxStar < 16; idxStar++){
        PointX = glSpriteX[idxStar];
        PointY = glSpriteY[idxStar];
        PointZ = glSpriteZ[idxStar];
        glTabSprite = glSprites[idxStar];
        project_i8o8();

        // sX = (SCREEN_WIDTH - aH) >> 1;
        plotX = (SCREEN_WIDTH - (signed char)ResX) >> 1;
        // sY = (SCREEN_HEIGHT - aV) >> 1;
        plotY = (SCREEN_HEIGHT - (signed char)ResY) >> 1;

        distpoint = Norm;
        glSpriteCarIdx=0;
        for (glSpriteNbCar = glTabSprite[glSpriteCarIdx++]; glSpriteNbCar >0; glSpriteNbCar --){
            plotX += glTabSprite[glSpriteCarIdx++];
            plotY += glTabSprite[glSpriteCarIdx++];
            ch2disp = glTabSprite[glSpriteCarIdx++]; 
            fastzplot();
        }

    }

}
#endif // USE_C_GLDRAWSPRITES
