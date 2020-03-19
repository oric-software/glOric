#include "lib.h"
#include "release\glOric_v11.h"

#define abs(x) 				(((x)<0)?-(x):(x))

// Some objects for the game scene : Tree, House, Tower
char geomPine [],  geomHouse [],  geomTower [];

unsigned char running; // in game state: 1 = Running, 0 = Leave.

// Add a shape to the game scene
void addGeom(signed char X, signed char Y, signed char Z, unsigned char sizeX, unsigned char sizeY, unsigned char sizeZ, unsigned char orientation, char geom[]);
// Redefine a Character
void change_char(char c, unsigned char patt01, unsigned char patt02, unsigned char patt03, unsigned char patt04, unsigned char patt05, unsigned char patt06, unsigned char patt07, unsigned char patt08);
// Set video attributes for color
void initColors();
// Main game loop
void gameLoop();

/*                 _        
 *   /\/\    __ _ (_) _ __  
 *  /    \  / _` || || '_ \ 
 * / /\/\ \| (_| || || | | |
 * \/    \/ \__,_||_||_| |_|
 */                          

void main() {

    text();
    cls();

    /*
     *  Game Scene Building
     */
    nbPoints     = 0;
    nbSegments   = 0;
    nbFaces      = 0;
    nbParticules = 0;

    addGeom(0, 0, 0, 12, 8, 4, 0, geomHouse);
    addGeom(24, 12, 0, 9, 9, 9, 0, geomPine);
    addGeom(24, -24, 0, 6, 6, 12, 0, geomTower);

    /*
     *  Configure Drawing
     */
    initColors();
    // Change DOLLAR ($) sign into BACKSLASH (\) to draw oblic lines 
    change_char(36, 0x80, 0x40, 020, 0x10, 0x08, 0x04, 0x02, 0x01);

    /*
     *  Camera (player view) position and orientation 
     */
    CamPosX = 60;  
    CamPosY = 0; 
    CamPosZ = 6;
    CamRotZ = -127;
    CamRotX = 0;

    running = 1;
    gameLoop();
}

/*    ___                         
 *   / _ \  __ _  _ __ ___    ___ 
 *  / /_\/ / _` || '_ ` _ \  / _ \
 * / /_\\ | (_| || | | | | ||  __/
 * \____/  \__,_||_| |_| |_| \___|
 */                            
void player ();

void gameLoop() {
    
    while (running) {

        player ();

        glProjectArrays();

        initScreenBuffers();

        glDrawFaces();
        glDrawSegments();
        glDrawParticules();

        buffer2screen((void*)0);
        sprintf(ADR_BASE_SCREEN, "(X=%d Y=%d Z=%d) [%d %d]", CamPosX, CamPosY, CamPosZ, CamRotZ, CamRotX);
    }
}
/*    ___  _                           
 *   / _ \| |  __ _  _   _   ___  _ __ 
 *  / /_)/| | / _` || | | | / _ \| '__|
 * / ___/ | || (_| || |_| ||  __/| |   
 * \/     |_| \__,_| \__, | \___||_|   
 *                   |___/             
 */
void forward();
void shiftLeft();
void backward();
void shiftRight();

void player () {
    switch (key()) {
    case 8:  // left 
        CamRotZ += 4; break;
    case 9:  // right 
        CamRotZ -= 4; break;
    case 10:  // down
        backward(); break;
    case 11:  // up
        forward(); break;
    // case 80:  // P
    //     CamPosZ += 1; break;
    // case 59:  // ;
    //     CamPosZ -= 1; break;
    case 81:  // Q
        running = 0; break;
    // case 65:  // A
    //     CamRotX -= 2; break;
    case 90:  // Z
        shiftLeft(); break;
    case 88:  // X
        shiftRight(); break;
    default:
        break;
    }
}
/*                          
 *   /\/\    ___  __   __  ___ 
 *  /    \  / _ \ \ \ / / / _ \
 * / /\/\ \| (_) | \ V / |  __/
 * \/    \/ \___/   \_/   \___|
 *                            
 */
// Collision Detection 
unsigned char isAllowedPosition(signed int X, signed int Y, signed int Z) {
    unsigned int aX = abs(X);
    unsigned int aY = abs(Y);
    if ((aX <=13) && (aY <= 9)) {
        if ((aY <= 7) && (X > -7)) {
            return 1;
        } else {
            return 0;
        }
    }
    if ((X >=18) && (X <= 30) && (Y == -18)) return 0;
    if ((X ==18) && (Y >= -30) && (Y <= -18)) return 0;
    if ((X ==30) && (Y >= -30) && (Y <= -18)) return 0;
    return 1;
}
void forward() {
    signed int X, Y;
    X = CamPosX; Y = CamPosY;

    if (-112 >= CamRotZ) {
        CamPosX--;
    } else if ((-112 < CamRotZ) && (-80 >= CamRotZ)) {
        CamPosX--; CamPosY--;
    } else if ((-80 < CamRotZ) && (-48 >= CamRotZ)) {
        CamPosY--;
    } else if ((-48 < CamRotZ) && (-16 >= CamRotZ)) {
        CamPosX++; CamPosY--;
    } else if ((-16 < CamRotZ) && (16 >= CamRotZ)) {
        CamPosX++;
    } else if ((16 < CamRotZ) && (48 >= CamRotZ)) {
        CamPosX++; CamPosY++;
    } else if ((48 < CamRotZ) && (80 >= CamRotZ)) {
        CamPosY++;
    } else if ((80 < CamRotZ) && (112 >= CamRotZ)) {
        CamPosX--; CamPosY++;
    } else {
        CamPosX--;
    }
    if (!isAllowedPosition(CamPosX, CamPosY, CamPosZ)) {
        CamPosX = X; CamPosY = Y;
    }
}
void backward() {
    signed int X, Y;
    X = CamPosX;
    Y = CamPosY;
    if (-112 >= CamRotZ) {
        CamPosX++;
    } else if ((-112 < CamRotZ) && (-80 >= CamRotZ)) {
        CamPosX++; CamPosY++;
    } else if ((-80 < CamRotZ) && (-48 >= CamRotZ)) {
        CamPosY++;
    } else if ((-48 < CamRotZ) && (-16 >= CamRotZ)) {
        CamPosX--; CamPosY++;
    } else if ((-16 < CamRotZ) && (16 >= CamRotZ)) {
        CamPosX--;
    } else if ((16 < CamRotZ) && (48 >= CamRotZ)) {
        CamPosX--; CamPosY--;
    } else if ((48 < CamRotZ) && (80 >= CamRotZ)) {
        CamPosY--;
    } else if ((80 < CamRotZ) && (112 >= CamRotZ)) {
        CamPosX++; CamPosY--;
    } else {
        CamPosX++;
    }
    if (!isAllowedPosition(CamPosX, CamPosY, CamPosZ)) {
        CamPosX = X; CamPosY = Y;
    }
}
void shiftLeft() {
    signed int X, Y;
    X = CamPosX; Y = CamPosY;
    if (-112 >= CamRotZ) {
        CamPosY--;
    } else if ((-112 < CamRotZ) && (-80 >= CamRotZ)) {
        CamPosX++; CamPosY--;
    } else if ((-80 < CamRotZ) && (-48 >= CamRotZ)) {
        CamPosX--;
    } else if ((-48 < CamRotZ) && (-16 >= CamRotZ)) {
        CamPosX++; CamPosY++;
    } else if ((-16 < CamRotZ) && (16 >= CamRotZ)) {
        CamPosY++;
    } else if ((16 < CamRotZ) && (48 >= CamRotZ)) {
        CamPosX--; CamPosY++;
    } else if ((48 < CamRotZ) && (80 >= CamRotZ)) {
        CamPosX--;
    } else if ((80 < CamRotZ) && (112 >= CamRotZ)) {
        CamPosX--; CamPosY--;
    } else {
        CamPosY--;
    }
    if (!isAllowedPosition(CamPosX, CamPosY, CamPosZ)) {
        CamPosX = X; CamPosY = Y;
    }
}
void shiftRight() {
    signed int X, Y;
    X = CamPosX;
    Y = CamPosY;
    if (-112 >= CamRotZ) {
        CamPosY++;
    } else if ((-112 < CamRotZ) && (-80 >= CamRotZ)) {
        CamPosX--; CamPosY++;
    } else if ((-80 < CamRotZ) && (-48 >= CamRotZ)) {
        CamPosX++;
    } else if ((-48 < CamRotZ) && (-16 >= CamRotZ)) {
        CamPosX--; CamPosY--;
    } else if ((-16 < CamRotZ) && (16 >= CamRotZ)) {
        CamPosY--;
    } else if ((16 < CamRotZ) && (48 >= CamRotZ)) {
        CamPosX++; CamPosY--;
    } else if ((48 < CamRotZ) && (80 >= CamRotZ)) {
        CamPosX++;
    } else if ((80 < CamRotZ) && (112 >= CamRotZ)) {
        CamPosX++; CamPosY++;
    } else {
        CamPosX++;
    }
    if (!isAllowedPosition(CamPosX, CamPosY, CamPosZ)) {
        CamPosX = X; CamPosY = Y;
    }
}
/*    ___         _                   
 *   / __\  ___  | |  ___   _ __  ___ 
 *  / /    / _ \ | | / _ \ | '__|/ __|
 * / /___ | (_) || || (_) || |   \__ \
 * \____/  \___/ |_| \___/ |_|   |___/
 */                                  
#define INK_BLACK	0
#define INK_RED		1
#define INK_GREEN	2
#define INK_YELLOW	3
#define INK_BLUE	4
#define INK_MAGENTA	5
#define INK_CYAN	6
#define INK_WHITE	7
#define HIRES_50Hz	30
#define TEXT_50Hz	26

unsigned char tab_color [] = {INK_CYAN, INK_YELLOW, INK_MAGENTA, INK_BLUE, INK_GREEN, INK_RED, INK_CYAN, INK_YELLOW} ;

void prepare_colors() {
    int ii, jj;

	for (ii = 0; ii<=SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR ; ii++){
		poke (ADR_BASE_SCREEN+(ii*SCREEN_WIDTH)+0,HIRES_50Hz);
		fbuffer[ii*SCREEN_WIDTH]=HIRES_50Hz;
		for (jj = 0; jj < 8; jj++) {
			poke (HIRES_SCREEN_ADDRESS+((ii*8+jj)*SCREEN_WIDTH)+1, tab_color[jj]);
			poke (HIRES_SCREEN_ADDRESS+((ii*8+jj)*SCREEN_WIDTH)+2, TEXT_50Hz);
		}
	}
}
void initColors(){

    prepare_colors();
    //              CYAN, YELLO, MAGE, BLUE GREEN, RED, CYAN, YELLO
    change_char('c', 0x7F, 0x00, 0x00, 0x7F, 0x00, 0x00, 0x7F, 0x00); // cyan
	change_char('y', 0x00, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7F); // yellow
	change_char('m', 0x00, 0x00, 0x7F, 0x00, 0x00, 0x7F, 0x00, 0x00); // magenta
	change_char('r', 0x00, 0x55, 0x7F, 0x00, 0x55, 0x7F, 0x00, 0x00); // red
	change_char('g', 0x55, 0xAA, 0x00, 0x00, 0x7F, 0x00, 0x55, 0xAA); // green
	change_char('b', 0xAA, 0x00, 0x00, 0x7F, 0x00, 0x00, 0x55, 0x00); // blue
	change_char('f', 0x00, 0xAA, 0x00, 0x55, 0x7F, 0x00, 0x00, 0xAA); // light green
}
/*  __     _                          
 * / _\   | |__    __ _  _ __    ___  ___ 
 * \ \    | '_ \  / _` || '_ \  / _ \/ __|
 * _\ \   | | | || (_| || |_) ||  __/\__ \
 * \__/   |_| |_| \__,_|| .__/  \___||___/
 *                      |_|               
 */
#define TEXTURE_1 'b'
#define TEXTURE_2 'g'
#define TEXTURE_3 'y'
#define TEXTURE_4 'c'
#define TEXTURE_5 'm'
#define TEXTURE_6 'r'
#define TEXTURE_7 'f'

#define TRUNC_HEIGHT 1
#define PINE_WIDTH 1
#define PINE_HEIGHT 3

char geomPine []= {
/* Nb Coords = */ 7,
/* Nb Faces = */ 2,
/* Nb Segments = */ 1,
/* Nb Particules = */ 0,
// Coord List : X, Y, Z, unused
0,          0,          0,              0,
0,          0,          TRUNC_HEIGHT,   0,
PINE_WIDTH, 0,          TRUNC_HEIGHT,   0,
0,          PINE_WIDTH, TRUNC_HEIGHT,   0,
-PINE_WIDTH, 0,         TRUNC_HEIGHT,   0,
0,          -PINE_WIDTH,TRUNC_HEIGHT,   0,
0,          0,          PINE_HEIGHT,    0,
// Face List : idxPoint1, idxPoint2, idxPoint3, character 
3, 5, 6, TEXTURE_2,
2, 4, 6, TEXTURE_2,
// Segment List : idxPoint1, idxPoint2, character , unused
0, 1, '|', 0,
// Particule List : idxPoint1, character 
};

#define TOWER_HEIGHT 3
char geomTower []= {
/* Nb Coords = */ 8,
/* Nb Faces = */ 6, //12,
/* Nb Segments = */ 4,
/* Nb Particules = */ 0,
// Coord List : X, Y, Z, unused
-1, -1,             0, 0,
-1,  1,             0, 0,
 1,  1,             0, 0,
 1, -1,             0, 0,
-1, -1, TOWER_HEIGHT, 0,
-1,  1, TOWER_HEIGHT, 0,
 1,  1, TOWER_HEIGHT, 0,
 1, -1, TOWER_HEIGHT, 0,
// Face List : idxPoint1, idxPoint2, idxPoint3, character 
0, 1, 4, TEXTURE_4,
1, 4, 5, TEXTURE_4,
1, 2, 5, TEXTURE_1,
2, 5, 6, TEXTURE_1, 
3, 2, 7, TEXTURE_4,
2, 7, 6, TEXTURE_4,
// Segment List : idxPoint1, idxPoint2, character, unused 
0, 4, '|',       0,
3, 7, '|',       0,
2, 6, '|',       0,
1, 5, '|',       0,
};

char geomHouse []= {
/* Nb Coords = */ 10,
/* Nb Faces = */ 11,
/* Nb Segments = */ 14,
/* Nb Particules = */ 0,
// Coord List : X, Y, Z, unused
 1, 1, 0, 0, 
-1, 1, 0, 0,
-1,-1, 0, 0,
 1,-1, 0, 0,
 1, 1, 2, 0, 
-1, 1, 2, 0,
-1,-1, 2, 0,
 1,-1, 2, 0,
 1, 0, 3, 0,
-1, 0, 3, 0,
// Face List : idxPoint1, idxPoint2, idxPoint3, character 
 0, 1, 5, TEXTURE_6,
 0, 4, 5, TEXTURE_6,
 3, 2, 6, TEXTURE_6,
 6, 3, 7, TEXTURE_6,
 1, 2, 6, TEXTURE_5,
 1, 6, 5, TEXTURE_5,
 5, 6, 9, TEXTURE_5,
 4, 5, 9, TEXTURE_3,
 4, 9, 8, TEXTURE_3,
 7, 6, 9, TEXTURE_3,
 7, 9, 8, TEXTURE_3,
// Segment List : idxPoint1, idxPoint2, character , unused
0, 1, '-', 0,
1, 2, '-', 0,
2, 3, '-', 0,
4, 5, '-', 0,
6, 7, '-', 0,
0, 4,'|', 0,
1, 5,'|', 0,
2, 6,'|', 0,
3, 7,'|', 0,
4, 8,'/', 0,
7, 8,'/', 0,
5, 9,'/', 0,
6, 9,'/', 0,
9, 8,'-', 0,
};

void addGeom(
    signed char   X,
    signed char   Y,
    signed char   Z,
    unsigned char sizeX,
    unsigned char sizeY,
    unsigned char sizeZ,
    unsigned char orientation,
    char          geom[]) {

    int kk;

    for (kk=0; kk< geom[0]; kk++){
        points3dX[nbPoints] = X + ((orientation == 0) ? sizeX * geom[4+kk*SIZEOF_3DPOINT+0]: sizeY * geom[4+kk*SIZEOF_3DPOINT+1]);// X + ii;
        points3dY[nbPoints] = Y + ((orientation == 0) ? sizeY * geom[4+kk*SIZEOF_3DPOINT+1]: sizeX * geom[4+kk*SIZEOF_3DPOINT+0]);// Y + jj;
        points3dZ[nbPoints] = Z + geom[4+kk*SIZEOF_3DPOINT+2]*sizeZ;// ;
        nbPoints++;
    }
    for (kk=0; kk< geom[1]; kk++){
        facesPt1[nbFaces] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+0]);  // Index Point 1
        facesPt2[nbFaces] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+1]);  // Index Point 2
        facesPt3[nbFaces] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+2]);  // Index Point 3
        facesChar[nbFaces] = geom[4+geom[0]*SIZEOF_3DPOINT+kk*SIZEOF_FACE+3];  // Character
        nbFaces++;
    }
    for (kk=0; kk< geom[2]; kk++){
        segmentsPt1[nbSegments] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 0]);  // Index Point 1
        segmentsPt2[nbSegments] = nbPoints - (geom[0]-geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 1]);  // Index Point 2
        segmentsChar[nbSegments] = geom[4+geom[0]*SIZEOF_3DPOINT+geom[1]*SIZEOF_FACE+kk*SIZEOF_SEGMENT + 2]; // Character
        nbSegments++;
    }
    for (kk=0; kk< geom[3]; kk++){
        particulesPt[nbParticules] = nbPoints - (geom[0]-geom[4 + geom[0]*SIZEOF_3DPOINT + geom[1]*SIZEOF_FACE + geom[2]*SIZEOF_SEGMENT + kk*SIZEOF_PARTICULE + 0]);  // Index Point
        particulesChar[nbParticules] = geom[4 + geom[0]*SIZEOF_3DPOINT + geom[1]*SIZEOF_FACE + geom[2]*SIZEOF_SEGMENT + kk*SIZEOF_PARTICULE + 1]; // Character
        nbParticules++;
    }
}
/*     ___                         _               
 *    /   \ _ __   __ _ __      __(_) _ __    __ _ 
 *   / /\ /| '__| / _` |\ \ /\ / /| || '_ \  / _` |
 *  / /_// | |   | (_| | \ V  V / | || | | || (_| |
 * /___,'  |_|    \__,_|  \_/\_/  |_||_| |_| \__, |
 *                                          |___/ 
 */
void change_char(char c, unsigned char patt01, unsigned char patt02, unsigned char patt03, unsigned char patt04, unsigned char patt05, unsigned char patt06, unsigned char patt07, unsigned char patt08) {
    unsigned char* adr;
    adr      = (unsigned char*)(0xB400 + c * 8);
    *(adr++) = patt01;
    *(adr++) = patt02;
    *(adr++) = patt03;
    *(adr++) = patt04;
    *(adr++) = patt05;
    *(adr++) = patt06;
    *(adr++) = patt07;
    *(adr++) = patt08;
}

extern signed char   P1X, P1Y;
extern signed char points2aH[];
extern signed char points2aV[];
extern unsigned char points2dL[];

void glDrawParticules(){
    unsigned char ii;
    unsigned char idxPt;

    for (ii = 0; ii < nbParticules; ii++) {
        idxPt    = particulesPt[ii];
        zplot(
            (SCREEN_WIDTH -points2aH[idxPt]) >> 1,      // PX
            (SCREEN_HEIGHT - points2aV[idxPt]) >> 1,    // PY
            points2dL[idxPt]-2,                         // distance
            particulesChar[ii]                          // character 2 display
        );
    }
}
