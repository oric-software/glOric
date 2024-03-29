#define TOWER_HEIGHT 3
#define TOWER_SIZE_X 6
#define TOWER_SIZE_Y 6
#define TOWER_SIZE_Z 12
char geomTower []= {
/* Nb Coords = */ 9,
/* Nb Faces = */ 6, //12,
/* Nb Segments = */ 8,
/* Nb Particles = */ 0,
// Coord List : X, Y, Z, unused
-TOWER_SIZE_X, -TOWER_SIZE_Y,             0, 0,
-TOWER_SIZE_X,  TOWER_SIZE_Y,             0, 0,
 TOWER_SIZE_X,  TOWER_SIZE_Y,             0, 0,
 TOWER_SIZE_X, -TOWER_SIZE_Y,             0, 0,
-TOWER_SIZE_X, -TOWER_SIZE_Y, TOWER_SIZE_Z*TOWER_HEIGHT, 0,
-TOWER_SIZE_X,  TOWER_SIZE_Y, TOWER_SIZE_Z*TOWER_HEIGHT, 0,
 TOWER_SIZE_X,  TOWER_SIZE_Y, TOWER_SIZE_Z*TOWER_HEIGHT, 0,
 TOWER_SIZE_X, -TOWER_SIZE_Y, TOWER_SIZE_Z*TOWER_HEIGHT, 0,
  0,            0,            TOWER_SIZE_Z*(TOWER_HEIGHT+2), 0,
// Face List : idxPoint1, idxPoint2, idxPoint3, character 
// 0, 3, 4, TEXTURE_1,
// 3, 4, 7, TEXTURE_1,
0, 1, 4, TEXTURE_4,
1, 4, 5, TEXTURE_4,
1, 2, 5, TEXTURE_1,
2, 5, 6, TEXTURE_1, 
3, 2, 7, TEXTURE_4,
2, 7, 6, TEXTURE_4,
// 4, 5, 8, TEXTURE_6, 
// 5, 6, 8, TEXTURE_6, 
// 6, 7, 8, TEXTURE_6, 
// 7, 4, 8, TEXTURE_6, 
// Segment List : idxPoint1, idxPoint2, character, unused 
0, 4, '|', 0,
3, 7, '|', 0,
2, 6, '|', 0,
1, 5, '|', 0,
4, 8, TEXTURE_6, 0,
5, 8, TEXTURE_6, 0,
6, 8, TEXTURE_6, 0,
7, 8, TEXTURE_6, 0,
// Particle List : idxPoint1, character 

};
