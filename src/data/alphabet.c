
#define CUBE_SIZE	4
#define NB_POINTS_CUBE		8
#define NB_SEGMENTS_CUBE 	12
const char ptsCube[]={
	 -CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE, 0 // P0
	,-CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE, 0 // P1
	,+CUBE_SIZE, -CUBE_SIZE, -CUBE_SIZE, 0 // P2
	,+CUBE_SIZE, -CUBE_SIZE, +CUBE_SIZE, 0 // P3
	,-CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE, 0 // P4
	,-CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE, 0 // P5
	,+CUBE_SIZE, +CUBE_SIZE, -CUBE_SIZE, 0 // P6
	,+CUBE_SIZE, +CUBE_SIZE, +CUBE_SIZE, 0 // P7
};
const char segCube[]={		
	  0, 1, 124, 0 //124, 0
	, 1, 2, 45 , 0 //92, 0
	, 2, 3, 124, 0 //47, 0
	, 3, 0, 45 , 0 //124, 0
	, 4, 5, 124, 0 //124, 0
	, 5, 6, 45 , 0 //124, 0
	, 6, 7, 124, 0 //92, 0
	, 7, 4, 45 , 0 //47, 0
	, 0, 4, 45 , 0 //124, 0
	, 1, 5, 45 , 0 //124, 0
	, 2, 6, 45 , 0 //124, 0
	, 3, 7, 45 , 0 //124, 0
};


#define NB_POINTS_M		5
#define NB_SEGMENTS_M 	4
const char ptsM[]={
	 0, 0, 1, 0 // P0
	,0, 0, 7, 0 // P1
	,2, 0, 4, 0 // P2
	,4, 0, 7, 0 // P3
	,4, 0, 1, 0 // P4
};
const char segM[]={		// chr 77
	  0, 1, 77, 0 //124, 0
	, 1, 2, 77, 0 //92, 0
	, 2, 3, 77, 0 //47, 0
	, 3, 4, 77, 0 //124, 0
};
#define NB_POINTS_C		8
#define NB_SEGMENTS_C	7
const char ptsC[]={
	 4, 0, 2, 0 // P0
	,3, 0, 1, 0 // P1
	,1, 0, 1, 0 // P2
	,0, 0, 2, 0 // P3
	,0, 0, 6, 0 // P4
	,1, 0, 7, 0 // P5
	,3, 0, 7, 0 // P6
	,4, 0, 6, 0 // P7	
};
const char segC[]={			// 67
	  0, 1, 67, 0 // 47, 0
	, 1, 2, 67, 0 // 45, 0
	, 2, 3, 67, 0 // 92, 0
	, 3, 4, 67, 0 // 124, 0
	, 4, 5, 67, 0 // 47, 0
	, 5, 6, 67, 0 // 45, 0
	, 6, 7, 67, 0 // 92, 0
};
#define NB_POINTS_I		6
#define NB_SEGMENTS_I 	3
const char ptsI[]={
	 1, 0, 1, 0 // P0
	,3, 0, 1, 0 // P1
	,1, 0, 7, 0 // P2
	,3, 0, 7, 0 // P3
	,2, 0, 1, 0 // P4
	,2, 0, 7, 0 // P5

};
const char segI[]={		// chr 73
	  0, 1, 73, 0 // 45, 0
	, 2, 3, 73, 0 // 45, 0
	, 4, 5, 73, 0 // 124, 0
};
#define NB_POINTS_R		9
#define NB_SEGMENTS_R 	7
const char ptsR[]={
	 0, 0, 1, 0 // P0
	,0, 0, 7, 0 // P1
	,3, 0, 7, 0 // P2
	,4, 0, 6, 0 // P3
	,4, 0, 5, 0 // P4
	,3, 0, 4, 0 // P5
	,0, 0, 4, 0 // P6
	,1, 0, 4, 0 // P7
	,4, 0, 1, 0 // P8
};
const char segR[]={		// chr 82
	  0, 1, 82, 0 // 124, 0
	, 1, 2, 82, 0 // 45, 0
	, 2, 3, 82, 0 // 92, 0
	, 3, 4, 82, 0 // 124, 0
	, 4, 5, 82, 0 // 47, 0
	, 5, 6, 82, 0 // 45, 0
	, 7, 8, 82, 0 // 92, 0	
};
#define NB_POINTS_E		6
#define NB_SEGMENTS_E 	4
const char ptsE[]={	 
	 0, 0, 7, 0 // P0
	,4, 0, 7, 0 // P1
	,0, 0, 1, 0 // P2
	,4, 0, 1, 0 // P3
	,4, 0, 4, 0 // P4
	,0, 0, 4, 0 // P5
};
const char segE[]={	   // chr 69
	  0, 1, 69, 0 // 45, 0
	, 0, 2, 69, 0 // 124, 0
	, 2, 3, 69, 0 // 45, 0
	, 5, 4, 69, 0 // 45, 0
};
#define NB_POINTS_N		4
#define NB_SEGMENTS_N 	3
const char ptsN[]={
	 0, 0, 1, 0 // P0
	,0, 0, 7, 0 // P1
	,4, 0, 1, 0 // P2
	,4, 0, 7, 0 // P3
	
};
const char segN[]={		// chr 78
	  0, 1, 78, 0 //124, 0
	, 1, 2, 78, 0 //92 , 0
	, 2, 3, 78, 0 //124, 0
};
