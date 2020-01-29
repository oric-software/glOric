


 // Point 3D Coordinates
extern int PointX;
extern int PointY;
extern int PointZ;

 // Point 2D Projected Coordinates
extern char ResX;			// -128 -> -127
extern char ResY;

 // Intermediary Computation
extern int DeltaX;
extern int DeltaY;


extern char Norm;
extern char AngleH;
extern char AngleV;


extern int square;
extern int thesqrt;

extern char Numberl;
extern char Numberh;

extern char Squarel;
extern char Squareh;

extern char Square1;
extern char Square2;
extern char Square3;
extern char Square4;

// extern char N;

// ATAN on 1 octant
extern char ArcTang;
extern char Angle;
extern char Index;

// ATAN2
extern int TanX;
extern int TanY;
extern char Arctan8;
extern int TmpX;
extern int TmpY;
//extern char Octant;
extern char NegIt;
extern char Ratio;

// ATAN2_8
extern char octant8;
extern char x1;
extern char x2;
extern char y1;
extern char y2;
extern char atanres;

// My ATAN2_8
/*
extern char tx;
extern char ty;
extern char res;
*/
// LINE
extern char Point1X;
extern char Point1Y;
extern char Point2X;
extern char Point2Y;
extern int PosPrint;
extern char char2Display;

//
// ===== Display.s =====
//
extern unsigned char CurrentPixelX;             // Coordinate X of edited pixel/byte
extern unsigned char CurrentPixelY;             // Coordinate Y of edited pixel/byte

extern unsigned char OtherPixelX;               // Coordinate X of other edited pixel/byte
extern unsigned char OtherPixelY;               // Coordinate Y of other edited pixel/byte

#ifdef USE_HIRES_RASTER
//
// ====== Filler.s ==========

unsigned int	CurrentPattern=0;
extern	unsigned char	X0;
extern	unsigned char	Y0;
extern	unsigned char	X1;
extern	unsigned char	Y1;
#endif