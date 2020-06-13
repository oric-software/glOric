/* 
    3D Walkthrough Template on ORIC with glOric

        by Jean-Baptiste PERIN


          |----------------                                                   
          |             //|                                                   
          |           //  |                                                   
          |         //    |                                                   
          |       //      |                                                   
 ---------------//        |                                                   
 |              |         |                       *\                          
 |              |         |                     //  \\\                       
 |              |         |                   //       \\                     
 |              |         |                  /           \\                   
 |              |         |                //            /|                   
 |              |         |               /            // |                   
 |              |         |             // \\       ///   |                   
 |              |         |           //     \    //      |          *        
 |              |         |          /        \\//        |         //\\      
 |              |         |         |       *   \        /         / /  \     
 |              |         |         |     //    |      //         / /    \    
 |              |         |         |   //      |    /            / /     \\  
 |              |         |         |  /        |  //            /  /       \ 
 |              |         |         |//         |//             --- /  ------\
 |              |         |         /           /                  /// |      
 |              |         |                                        /   |      
 |              |       //                                             |      
 |              |     //                                               |      
 |              |    /                                                 |      
 |              |  //                                                  *      
 |               //                                                           
 -------------- /                                                             
                                                                              
                                       
*/                                                                            


#include "lib.h"
#include "release\glOric.h"


#define abs(x)                 (((x)<0)?-(x):(x))

// Some objects for the game scene : Tree, House, Tower
signed char geomPine [],  geomHouse [],  geomTower [];

unsigned char running; // game state: 1 = Running, 0 = Leave.

// Add a shape to the game scene
void addGeom(signed char X, signed char Y, signed char Z, unsigned char sizeX, unsigned char sizeY, unsigned char sizeZ, unsigned char orientation, signed char geom[]);
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
    glNbVertices     = 0;
    glNbSegments   = 0;
    glNbFaces      = 0;
    glNbParticles = 0;

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
    glCamPosX = 60;  
    glCamPosY = 0; 
    glCamPosZ = 6;
    glCamRotZ = -127;
    glCamRotX = 0;

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
    signed char pX, pY, pZ, sX, sY, aH, aV;
    unsigned int distance;
    while (running) {

        player ();

        // project 3D points to 2D coordinates
        glProjectArrays();

        // empty buffer
        glInitScreenBuffers();

        // draw game scene's shapes in buffer
        glDrawFaces();
        glDrawSegments();
        glDrawParticles();

        // demonstrate use of glProjectPoint and glZPlot to interact with glOric inner functions
        // display a sprite at a given position
        pX=0; pY=0; pZ=24;
        glProjectPoint(pX, pY, pZ, 0, &aH, &aV , &distance);
        sX = (SCREEN_WIDTH -aH) >> 1;
        sY = (SCREEN_HEIGHT - aV) >> 1;
        glZPlot(sX  ,sY,distance,'H');
        glZPlot(sX+1,sY,distance,'O');
        glZPlot(sX+2,sY,distance,'U');
        glZPlot(sX+3,sY,distance,'S');
        glZPlot(sX+4,sY,distance,'E');
  
        // update display with buffer
        glBuffer2Screen();
        sprintf(ADR_BASE_SCREEN, "(X=%d Y=%d Z=%d) [%d %d]", glCamPosX, glCamPosY, glCamPosZ, glCamRotZ, glCamRotX);
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
        glCamRotZ += 4; break;
    case 9:  // right 
        glCamRotZ -= 4; break;
    case 10:  // down
        backward(); break;
    case 11:  // up
        forward(); break;
    // case 80:  // P        HEP !! DONT TOUCH THAT !!!
    //     glCamPosZ += 1; break;
    // case 59:  // ;       FORGET ABOUT IT !!
    //     glCamPosZ -= 1; break;
    case 81:  // Q
        running = 0; break;
    // case 65:  // A
    //     glCamRotX -= 2; break;
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
unsigned char isAllowedPosition(signed char X, signed char Y, signed char Z) {
    unsigned char aX = abs(X);
    unsigned char aY = abs(Y);
    // Walls of house
    if ((aX <=13) && (aY <= 9)) {
        if ((aY <= 7) && (X > -7)) {
            return 1;
        } else {
            return 0;
        }
    }
    // Walls of tower
    if ((X >=18) && (X <= 30) && (Y == -18)) return 0;
    if ((X ==18) && (Y >= -30) && (Y <= -18)) return 0;
    if ((X ==30) && (Y >= -30) && (Y <= -18)) return 0;
    return 1;
}
void forward() {
    signed int X, Y;
    X = glCamPosX; Y = glCamPosY;
    if (-112 >= glCamRotZ) {
        glCamPosX--;
    } else if ((-112 < glCamRotZ) && (-80 >= glCamRotZ)) {
        glCamPosX--; glCamPosY--;
    } else if ((-80 < glCamRotZ) && (-48 >= glCamRotZ)) {
        glCamPosY--;
    } else if ((-48 < glCamRotZ) && (-16 >= glCamRotZ)) {
        glCamPosX++; glCamPosY--;
    } else if ((-16 < glCamRotZ) && (16 >= glCamRotZ)) {
        glCamPosX++;
    } else if ((16 < glCamRotZ) && (48 >= glCamRotZ)) {
        glCamPosX++; glCamPosY++;
    } else if ((48 < glCamRotZ) && (80 >= glCamRotZ)) {
        glCamPosY++;
    } else if ((80 < glCamRotZ) && (112 >= glCamRotZ)) {
        glCamPosX--; glCamPosY++;
    } else {
        glCamPosX--;
    }
    if (!isAllowedPosition(glCamPosX, glCamPosY, glCamPosZ)) {
        glCamPosX = X; glCamPosY = Y;
    }
}
void backward() {
    signed int X, Y;
    X = glCamPosX; Y = glCamPosY;
    if (-112 >= glCamRotZ) {
        glCamPosX++;
    } else if ((-112 < glCamRotZ) && (-80 >= glCamRotZ)) {
        glCamPosX++; glCamPosY++;
    } else if ((-80 < glCamRotZ) && (-48 >= glCamRotZ)) {
        glCamPosY++;
    } else if ((-48 < glCamRotZ) && (-16 >= glCamRotZ)) {
        glCamPosX--; glCamPosY++;
    } else if ((-16 < glCamRotZ) && (16 >= glCamRotZ)) {
        glCamPosX--;
    } else if ((16 < glCamRotZ) && (48 >= glCamRotZ)) {
        glCamPosX--; glCamPosY--;
    } else if ((48 < glCamRotZ) && (80 >= glCamRotZ)) {
        glCamPosY--;
    } else if ((80 < glCamRotZ) && (112 >= glCamRotZ)) {
        glCamPosX++; glCamPosY--;
    } else {
        glCamPosX++;
    }
    if (!isAllowedPosition(glCamPosX, glCamPosY, glCamPosZ)) {
        glCamPosX = X; glCamPosY = Y;
    }
}
void shiftLeft() {
    signed int X, Y;
    X = glCamPosX; Y = glCamPosY;
    if (-112 >= glCamRotZ) {
        glCamPosY--;
    } else if ((-112 < glCamRotZ) && (-80 >= glCamRotZ)) {
        glCamPosX++; glCamPosY--;
    } else if ((-80 < glCamRotZ) && (-48 >= glCamRotZ)) {
        glCamPosX--;
    } else if ((-48 < glCamRotZ) && (-16 >= glCamRotZ)) {
        glCamPosX++; glCamPosY++;
    } else if ((-16 < glCamRotZ) && (16 >= glCamRotZ)) {
        glCamPosY++;
    } else if ((16 < glCamRotZ) && (48 >= glCamRotZ)) {
        glCamPosX--; glCamPosY++;
    } else if ((48 < glCamRotZ) && (80 >= glCamRotZ)) {
        glCamPosX--;
    } else if ((80 < glCamRotZ) && (112 >= glCamRotZ)) {
        glCamPosX--; glCamPosY--;
    } else {
        glCamPosY--;
    }
    if (!isAllowedPosition(glCamPosX, glCamPosY, glCamPosZ)) {
        glCamPosX = X; glCamPosY = Y;
    }
}
void shiftRight() {
    signed int X, Y;
    X = glCamPosX;
    Y = glCamPosY;
    if (-112 >= glCamRotZ) {
        glCamPosY++;
    } else if ((-112 < glCamRotZ) && (-80 >= glCamRotZ)) {
        glCamPosX--; glCamPosY++;
    } else if ((-80 < glCamRotZ) && (-48 >= glCamRotZ)) {
        glCamPosX++;
    } else if ((-48 < glCamRotZ) && (-16 >= glCamRotZ)) {
        glCamPosX--; glCamPosY--;
    } else if ((-16 < glCamRotZ) && (16 >= glCamRotZ)) {
        glCamPosY--;
    } else if ((16 < glCamRotZ) && (48 >= glCamRotZ)) {
        glCamPosX++; glCamPosY--;
    } else if ((48 < glCamRotZ) && (80 >= glCamRotZ)) {
        glCamPosX++;
    } else if ((80 < glCamRotZ) && (112 >= glCamRotZ)) {
        glCamPosX++; glCamPosY++;
    } else {
        glCamPosX++;
    }
    if (!isAllowedPosition(glCamPosX, glCamPosY, glCamPosZ)) {
        glCamPosX = X; glCamPosY = Y;
    }
}
/*    ___         _                   
 *   / __\  ___  | |  ___   _ __  ___ 
 *  / /    / _ \ | | / _ \ | '__|/ __|
 * / /___ | (_) || || (_) || |   \__ \
 * \____/  \___/ |_| \___/ |_|   |___/
 */                        

#define INK_BLACK    0
#define INK_RED      1
#define INK_GREEN    2
#define INK_YELLOW   3
#define INK_BLUE     4
#define INK_MAGENTA  5
#define INK_CYAN     6
#define INK_WHITE    7

#define HIRES_50Hz   30
#define TEXT_50Hz    26

#define TEXTURE_BLUE       'b'
#define TEXTURE_GREEN      'g'
#define TEXTURE_YELLOW     'y'
#define TEXTURE_CYAN       'c'
#define TEXTURE_MAGENTA    'm'
#define TEXTURE_RED        'r'
#define TEXTURE_GREENLIGHT 'f'


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
    //                              CYAN, YELLO, MAGE, BLUE GREEN, RED, CYAN, YELLO
    change_char(TEXTURE_CYAN,       0x7F, 0x00, 0x00, 0x7F, 0x00, 0x00, 0x7F, 0x00);
    change_char(TEXTURE_YELLOW,     0x00, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7F);
    change_char(TEXTURE_MAGENTA,    0x00, 0x00, 0x7F, 0x00, 0x00, 0x7F, 0x00, 0x00);
    change_char(TEXTURE_RED,        0x00, 0x55, 0x7F, 0x00, 0x55, 0x7F, 0x00, 0x00);
    change_char(TEXTURE_GREEN,      0x55, 0xAA, 0x00, 0x00, 0x7F, 0x00, 0x55, 0xAA);
    change_char(TEXTURE_BLUE,       0xAA, 0x00, 0x00, 0x7F, 0x00, 0x00, 0x55, 0x00);
    change_char(TEXTURE_GREENLIGHT, 0x00, 0xAA, 0x00, 0x55, 0x7F, 0x00, 0x00, 0xAA);
}
/*  __     _                          
 * / _\   | |__    __ _  _ __    ___  ___ 
 * \ \    | '_ \  / _` || '_ \  / _ \/ __|
 * _\ \   | | | || (_| || |_) ||  __/\__ \
 * \__/   |_| |_| \__,_|| .__/  \___||___/
 *                      |_|               
 */
#define TRUNC_HEIGHT 1
#define PINE_WIDTH 1
#define PINE_HEIGHT 3
                                             //          6
signed char geomPine []= {                   //          /\       
                                             //         /| \      
/* Nb Coords = */ 7,                         //        //   \\    
/* Nb Faces = */ 2,                          //       //    \ \3   
/* Nb Segments = */ 1,                       //      / /     \/   
/* Nb Particles = */ 0,                     //     / /       \   
                                             //    /  /        \  
// Coord List : X, Y, Z, unused              //   /  /         \  
0,          0,          0,              0,   //  4---/   1------2 
0,          0,          TRUNC_HEIGHT,   1,   //     /  //|        
PINE_WIDTH, 0,          TRUNC_HEIGHT,   2,   //     / /  |        
0,          PINE_WIDTH, TRUNC_HEIGHT,   3,   //    ///   |        
-PINE_WIDTH, 0,         TRUNC_HEIGHT,   4,   //    /     |        
0,          -PINE_WIDTH,TRUNC_HEIGHT,   5,   //   5      |        
0,          0,          PINE_HEIGHT,    6,   //          |        
                                             //          0        
// Face List : idxPoint1, idxPoint2, idxPoint3, character 
3, 5, 6, TEXTURE_GREEN,
2, 4, 6, TEXTURE_GREEN,
// Segment List : idxPoint1, idxPoint2, character , unused
0, 1, '|', 0,
// Particle List : idxPoint1, character 
};

#define TOWER_HEIGHT 3       
signed char geomTower []= {    //           7---------------6
/* Nb Coords = */ 8,           //           |             //|
/* Nb Faces = */ 6,            //           |           //  |
/* Nb Segments = */ 4,         //           |         //    |
/* Nb Particles = */ 0,       //           |       //      |
// Coord List : X, Y, Z, Id    //  4--------------5/        |
-1, -1,             0, 0,      //  |        .     |         |
-1,  1,             0, 1,      //  |        .     |         |
 1,  1,             0, 2,      //  |        .     |         |
 1, -1,             0, 3,      //  |        .     |         |
-1, -1,  TOWER_HEIGHT, 4,      //  |        .     |         |
-1,  1,  TOWER_HEIGHT, 5,      //  |        .     |         |
 1,  1,  TOWER_HEIGHT, 6,      //  |              |         |
 1, -1,  TOWER_HEIGHT, 7,      //  |        3.....|........ 2
// Face List                   //  |              |       // 
0, 1, 4, TEXTURE_CYAN,         //  |              |     //   
1, 4, 5, TEXTURE_CYAN,         //  |              |    /     
1, 2, 5, TEXTURE_BLUE,         //  |              |  //      
2, 5, 6, TEXTURE_BLUE,         //  |               //        
3, 2, 7, TEXTURE_CYAN,         //  0------------- 1          
2, 7, 6, TEXTURE_CYAN,
// Segment List : idxPoint1, idxPoint2, character, unused 
0, 4, '|',       0,
3, 7, '|',       0,
2, 6, '|',       0,
1, 5, '|',       0,
};
                                   //               9
signed char geomHouse []= {        //              /  \          
                                   //             /    \    
/* Nb Coords = */ 10,              //            /      \   
/* Nb Faces = */ 11,               //           /        \   
/* Nb Segments = */ 14,            //          5         4  
/* Nb Particles = */ 0,           //         /.        /|  
                                   //        8 .       / |  
// Coord List : X, Y, Z, unused    //       / \.      /  |  
 1, 1, 0, 0,                       //      /   \     /   |                            
-1, 1, 0, 1,                       //     /    1\.. /. . 0                           
-1,-1, 0, 2,                       //    /     / \ /    /                            
 1,-1, 0, 3,                       //   6     /   7    /                             
 1, 1, 2, 4,                       //   |    /    |   /                               
-1, 1, 2, 5,                       //   |   /     |  /                               
-1,-1, 2, 6,                       //   |  /      | /                                
 1,-1, 2, 7,                       //   | /       |/                                 
 1, 0, 3, 8,                       //   |/________|                                  
-1, 0, 3, 9,                       //   2         3
// Face List : idxPoint1, idxPoint2, idxPoint3, character 
 0, 1, 5, TEXTURE_RED,      // side
 0, 4, 5, TEXTURE_RED,
 3, 2, 6, TEXTURE_RED,
 6, 3, 7, TEXTURE_RED,
 1, 2, 6, TEXTURE_MAGENTA, // back
 1, 6, 5, TEXTURE_MAGENTA,
 5, 6, 9, TEXTURE_MAGENTA,
 4, 5, 9, TEXTURE_YELLOW,  // roof
 4, 9, 8, TEXTURE_YELLOW,
 7, 6, 9, TEXTURE_YELLOW,
 7, 9, 8, TEXTURE_YELLOW,
// Segment List : idxPoint1, idxPoint2, character , unused
0, 1, '-', 0,
1, 2, '-', 0,
2, 3, '-', 0,
4, 5, '-', 0,
6, 7, '-', 0,
0, 4, '|', 0,
1, 5, '|', 0,
2, 6, '|', 0,
3, 7, '|', 0,
4, 8, '/', 0,
7, 8, '/', 0,
5, 9, '/', 0,
6, 9, '/', 0,
9, 8, '-', 0,
}; 

void addGeom(
    signed char   X,
    signed char   Y,
    signed char   Z,
    unsigned char sizeX,
    unsigned char sizeY,
    unsigned char sizeZ,
    unsigned char orientation,
    signed char          geom[]) {

    int kk=0;
    int ii;
    int npt,nfa, nseg, npart;
    npt = geom[kk++];
    nfa = geom[kk++];
    nseg = geom[kk++];
    npart = geom[kk++];
    for (ii = 0; ii < npt; ii++){
        if (orientation == 0) {
            glVerticesX[glNbVertices] = X + sizeX * geom[kk++];
            glVerticesY[glNbVertices] = Y + sizeY * geom[kk++];
        } else {
            glVerticesY[glNbVertices] = X + sizeY * geom[kk++];
            glVerticesX[glNbVertices] = Y + sizeX * geom[kk++];
        }
        glVerticesZ[glNbVertices] = Z + sizeZ * geom[kk++];
        glNbVertices ++;
        kk++; // skip unused byte
    }
    for (ii = 0; ii < nfa; ii++){
        glFacesPt1[glNbFaces] = glNbVertices - (npt-geom[kk++]);  // Index Point 1
        glFacesPt2[glNbFaces] = glNbVertices - (npt-geom[kk++]);  // Index Point 2
        glFacesPt3[glNbFaces] = glNbVertices - (npt-geom[kk++]);  // Index Point 3
        glFacesChar[glNbFaces] = geom[kk++];  // Character
        glNbFaces++;
    }
    for (ii = 0; ii < nseg; ii++){
        glSegmentsPt1[glNbSegments] = glNbVertices - (npt-geom[kk++]);  // Index Point 1
        glSegmentsPt2[glNbSegments] = glNbVertices - (npt-geom[kk++]);  // Index Point 2
        glSegmentsChar[glNbSegments] = geom[kk++]; // Character
        glNbSegments++;
        kk++; // skip unused byte
    }
    for (ii = 0; ii < npart; ii++){
        glParticlesPt[glNbParticles] = glNbVertices - (npt-geom[kk++]);  // Index Point
        glParticlesChar[glNbParticles] = geom[kk++]; // Character
        glNbParticles++;        
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
