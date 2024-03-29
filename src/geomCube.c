#define CUBE_SIZE 1
char geomCube []= {
/* Nb Coords = */ 8,
/* Nb Faces = */ 12,
/* Nb Segments = */ 12,
/* Nb Particles = */ 0,
// Coord List : X, Y, Z, unused
    -CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE, 0,  // P0
    -CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE, 0,  // P1
    +CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE, 0,  // P2
    +CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE, 0,  // P3
    -CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE, 0,  // P4
    -CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE, 0,  // P5
    +CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE, 0,  // P6
    +CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE, 0,   // P7

// Face List : idxPoint1, idxPoint2, idxPoint3, character 
    0, 1, 2, 77,  //124, 0
    0, 2, 3, 77,  //92, 0
    4, 5, 1, 78,  //47, 0
    4, 1, 0, 78,  //124, 0
    7, 6, 5, 79,  //124, 0
    7, 5, 4, 79,  //124, 0
    3, 2, 6, 80,  //92, 0
    3, 6, 7, 80,  //47, 0
    4, 0, 3, 81,  //124, 0
    4, 3, 7, 81,  //124, 0
    5, 1, 2, 82,  //124, 0
    5, 2, 6, 82,   //124, 0

// Segment List : idxPoint1, idxPoint2, idxPoint3, character 
    0, 1, 124, 0,  //124, 0
    1, 2, 45, 0,   //92, 0
    2, 3, 124, 0,  //47, 0
    3, 0, 45, 0,   //124, 0
    4, 5, 124, 0,  //124, 0
    5, 6, 45, 0,   //124, 0
    6, 7, 124, 0,  //92, 0
    7, 4, 45, 0,   //47, 0
    0, 4, 45, 0,   //124, 0
    1, 5, 45, 0,   //124, 0
    2, 6, 45, 0,   //124, 0
    3, 7, 45, 0    //124, 0

// Particle List : idxPoint1, character 
};
