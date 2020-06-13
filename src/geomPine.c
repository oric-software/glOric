#define TRUNC_HEIGHT 1
#define PINE_WIDTH 1
#define PINE_HEIGHT 3

char geomPine []= {
/* Nb Coords = */ 7,
/* Nb Faces = */ 2,
/* Nb Segments = */ 1,
/* Nb Particles = */ 0,
// Coord List : X, Y, Z, unused
0, 0, 0, 0,
0, 0, TRUNC_HEIGHT, 0,
PINE_WIDTH, 0, TRUNC_HEIGHT, 0,
0, PINE_WIDTH, TRUNC_HEIGHT, 0,
-PINE_WIDTH, 0, TRUNC_HEIGHT, 0,
0, -PINE_WIDTH, TRUNC_HEIGHT, 0,
0, 0, PINE_HEIGHT, 0,

// Face List : idxPoint1, idxPoint2, idxPoint3, character 
3, 5, 6, TEXTURE_2,
2, 4, 6, TEXTURE_2,
// Segment List : idxPoint1, idxPoint2, character , unused
0, 1, '|', 0,
// Particle List : idxPoint1, character 

};