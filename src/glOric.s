
#include "config.h"

.text

 // Camera Position
_CamPosX:		.dsb 2
_CamPosY:		.dsb 2
_CamPosZ:		.dsb 2

 // Camera Orientation
_CamRotZ:		.dsb 1			// -128 -> -127 unit : 2PI/(2^8 - 1)
_CamRotX:		.dsb 1


//unsigned char projOptions=0;
_projOptions            .dsb 1

; #ifdef USE_REWORKED_BUFFERS
; //unsigned char nbCoords=0;
; _nbCoords           .dsb 1
; #else
//unsigned char nbPoints=0;
_nbPoints               .dsb 1
; #endif

//unsigned char nbSegments=0;
_nbSegments     .dsb 1
//unsigned char nbParticules=0;
_nbParticules .dsb 1;
//unsigned char nbFaces=0;
_nbFaces .dsb 1;


#ifdef USE_REWORKED_BUFFERS

//char points3d[NB_MAX_POINTS*SIZEOF_3DPOINT];
//.dsb 256-(*&255)
//_points3d       .dsb NB_MAX_POINTS*SIZEOF_3DPOINT
_points3d:
_points3dX          .dsb NB_MAX_POINTS
_points3dY          .dsb NB_MAX_POINTS
_points3dZ          .dsb NB_MAX_POINTS
_points3unused      .dsb NB_MAX_POINTS
#endif // USE_REWORKED_BUFFERS

//char segments[NB_MAX_SEGMENTS*SIZEOF_SEGMENT];
; .dsb 256-(*&255)
; _segments       .dsb NB_MAX_SEGMENTS*SIZEOF_SEGMENT
_segments:
_segmentsPt1        .dsb NB_MAX_SEGMENTS
_segmentsPt2        .dsb NB_MAX_SEGMENTS
_segmentsChar       .dsb NB_MAX_SEGMENTS
_segmentsUnused     .dsb NB_MAX_SEGMENTS

//char points2d [NB_MAX_POINTS*SIZEOF_2DPOINT];
//.dsb 256-(*&255)
//_points2d       .dsb NB_MAX_POINTS*SIZEOF_2DPOINT

#ifdef USE_REWORKED_BUFFERS
//char points2d [NB_MAX_COORDS*SIZEOF_2DPOINT];
//.dsb 256-(*&255)
//_points2d       .dsb NB_MAX_COORDS*SIZEOF_2DPOINT
_points2d:
_points2aH          .dsb NB_MAX_POINTS
_points2aV          .dsb NB_MAX_POINTS
_points2dH          .dsb NB_MAX_POINTS
_points2dL          .dsb NB_MAX_POINTS
#endif //USE_REWORKED_BUFFERS

//char particules[NB_MAX_SEGMENTS*SIZEOF_PARTICULE];
; _particules       .dsb NB_MAX_PARTICULES*SIZEOF_PARTICULE
_particules:
_particulesPt       .dsb NB_MAX_PARTICULES
_particulesChar     .dsb NB_MAX_PARTICULES



; _faces       .dsb NB_MAX_FACES*SIZEOF_FACE
_faces:
_facesPt1           .dsb NB_MAX_FACES
_facesPt2           .dsb NB_MAX_FACES
_facesPt3           .dsb NB_MAX_FACES
_facesChar          .dsb NB_MAX_FACES

.zero

ptrpt3:
ptrpt3L .dsb 1
ptrpt3H .dsb 1
ptrpt2:
ptrpt2L .dsb 1
ptrpt2H .dsb 1

.text

//  void doFastProjection(){
_doFastProjection:
.(
//  	unsigned char ii = 0;

//  	for (ii = nbPoints-1; ii< 0; ii--){

    ldx _nbPoints
    dex
    txa ; ii = nbPoints - 1
    asl
    asl ; ii * SIZEOF_3DPOINT (4)
    clc
    adc #$03
    tay

    ldx _nbPoints
    dex
    txa ; ii = nbPoints - 1
    asl
    asl ; ii * SIZEOF_2DPOINT (4)
    clc
    adc #$03
    tax

dofastprojloop:
//          Status = points3d[ii*SIZEOF_3DPOINT + 3]
        dey
//  		PointZ = points3d[ii*SIZEOF_3DPOINT + 2];
        lda (ptrpt3),y
        sta _PointZ
        dey
//  		PointY = points3d[ii*SIZEOF_3DPOINT + 1];
        lda (ptrpt3),y
        sta _PointY
        dey
//  		PointX = points3d[ii*SIZEOF_3DPOINT + 0];
        lda (ptrpt3),y
        sta _PointX
        dey

//  		project_i16();
        ; jsr _project_i16
		jsr _project_i8o8

        tya
        pha
        txa
        tay

#ifndef HRSDEMO
 //  		points2d[ii*SIZEOF_2DPOINT + 1] = ResY;

        lda _Norm+1
        sta (ptrpt2), y
        dey

        lda _Norm
        sta (ptrpt2), y
        dey

        lda _ResY
        sta (ptrpt2), y
//  		points2d[ii*SIZEOF_2DPOINT + 0] = ResX;
        dey
        lda _ResX
        sta (ptrpt2), y

#else
        lda _ResY+1
        sta (ptrpt2), y
        dey

        lda _ResY
        sta (ptrpt2), y
        dey

        lda _ResX+1
        sta (ptrpt2), y
//  		points2d[ii*SIZEOF_2DPOINT + 0] = ResX;
        dey
        lda _ResX
        sta (ptrpt2), y

#endif
        tya
        tax
        pla
        tay
//  	}
    dex
    txa
    cmp #$FF
    bne dofastprojloop   ;; FIXME : does not allows more than 127 points
dofastprojdone:
//  }
.)
    rts




// void glProject (char *tabpoint2D, char *tabpoint3D, unsigned char nbPoints, unsigned char options);
_glProject
.(
	ldx #6 : lda #4 : jsr enter :
	ldy #0 : lda (ap),y : sta reg0 : sta ptrpt2L : iny : lda (ap),y : sta reg0+1 : sta ptrpt2H :
	ldy #2 : lda (ap),y : sta reg0 : sta ptrpt3L : iny : lda (ap),y : sta reg0+1 : sta ptrpt3H :
	ldy #4 : lda (ap),y : sta tmp0 : sta _nbPoints ; iny : lda (ap),y : sta tmp0+1 :
	ldy #6 : lda (ap),y : sta tmp0 : sta _projOptions ; iny : lda (ap),y : sta tmp0+1 :

	jsr _doFastProjection
	jmp leave :
.)

#ifdef USE_REWORKED_BUFFERS
#ifdef USE_ASM_ARRAYSPROJECT
_glProjectArrays:
.(
    // for (ii = 0; ii < nbPoints; ii++){
	ldy		_nbPoints
glProjectArrays_loop:
	dey
	bmi		glProjectArrays_done
		//     x = points3dX[ii];
		lda 	_points3dX, y
		sta		_PointX
		//     y = points3dY[ii];
		lda 	_points3dY, y
		sta		_PointY
		//     z = points3dZ[ii];
		lda 	_points3dZ, y
		sta		_PointZ

    //     projectPoint(x, y, z, options, &ah, &av, &dist);
		jsr 	_project_i8o8 :

    //     points2aH[ii] = ah;
		lda 	_ResX
		sta		_points2aH, y
    //     points2aV[ii] = av;
		lda 	_ResY
		sta		_points2aV, y
    //     points2dH[ii] = (signed char)((dist & 0xFF00)>>8) && 0x00FF;
		lda		_Norm+1
		sta		_points2dH, y
    //     points2dL[ii] = (signed char) (dist & 0x00FF);
		lda		_Norm
		sta		_points2dL, y

    // }
	jmp glProjectArrays_loop
glProjectArrays_done:
.)
	rts
#endif // USE_ASM_ARRAYSPROJECT
#endif // USE_REWORKED_BUFFERS

#ifdef USE_ASM_DRAWLINE
_lrDrawLine:
.(
	ldx #6 : lda #6 : jsr enter :
	lda _P1X : sta tmp0 :
	lda tmp0 : sta _A1X :
	lda _P1Y : sta tmp0 :
	lda tmp0 : sta _A1Y :
	lda _P2X : sta tmp0 :
	lda tmp0 : sta _A1destX :
	lda _P2Y : sta tmp0 :
	lda tmp0 : sta _A1destY :
	lda _P2X : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P1X : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp lrDrawLine_LlrsDrawing130 : :
	lda _P2X : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P1X : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta reg2 : lda tmp0+1 : sta reg2+1 :
	jmp lrDrawLine_LlrsDrawing131 :
lrDrawLine_LlrsDrawing130
	lda _P2X : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P1X : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta reg2 : lda tmp0+1 : sta reg2+1 :
lrDrawLine_LlrsDrawing131
	lda reg2 : sta tmp0 : lda reg2+1 : sta tmp0+1 :
	lda tmp0 : sta _A1dX :
	lda _P2Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P1Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp lrDrawLine_LlrsDrawing132 : :
	lda _P2Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P1Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta reg2 : lda tmp0+1 : sta reg2+1 :
	jmp lrDrawLine_LlrsDrawing133 :
lrDrawLine_LlrsDrawing132
	lda _P2Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P1Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	sec : lda tmp0 : sbc tmp1 : sta tmp0 : lda tmp0+1 : sbc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta reg2 : lda tmp0+1 : sta reg2+1 :
lrDrawLine_LlrsDrawing133
	lda reg2 : sta tmp0 : lda reg2+1 : sta tmp0+1 :
	lda #0 : sec : sbc tmp0 : sta tmp0 : lda #0 : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta _A1dY :
	lda _P1X : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P2X : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp lrDrawLine_LlrsDrawing134 : :
	lda #<(1) : sta reg2 : lda #>(1) : sta reg2+1 :
	jmp lrDrawLine_LlrsDrawing135 :
lrDrawLine_LlrsDrawing134
	lda #<(-1) : sta reg2 : lda #>(-1) : sta reg2+1 :
lrDrawLine_LlrsDrawing135
	lda reg2 : sta tmp0 : lda reg2+1 : sta tmp0+1 :
	lda tmp0 : sta _A1sX :
	lda _P1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P2Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : bvc *+4 : eor #$80 : bmi *+5 : jmp lrDrawLine_LlrsDrawing136 : :
	lda #<(1) : sta reg2 : lda #>(1) : sta reg2+1 :
	jmp lrDrawLine_LlrsDrawing137 :
lrDrawLine_LlrsDrawing136
	lda #<(-1) : sta reg2 : lda #>(-1) : sta reg2+1 :
lrDrawLine_LlrsDrawing137
	lda reg2 : sta tmp0 : lda reg2+1 : sta tmp0+1 :
	lda tmp0 : sta _A1sY :
	lda _A1dX : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _A1dY : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A1err :
	lda _A1err : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(64) : cmp tmp0 : lda #>(64) : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp lrDrawLine_LlrsDrawing140 :skip : .) : : :
	lda tmp0 : cmp #<(-63) : lda tmp0+1 : sbc #>(-63) : bvc *+4 : eor #$80 : bmi *+5 : jmp lrDrawLine_LlrsDrawing138 : :
lrDrawLine_LlrsDrawing140
	jmp leave :
lrDrawLine_LlrsDrawing138
	lda _ch2disp : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(47) : eor tmp0 : sta tmp : lda #>(47) : eor tmp0+1 : ora tmp : beq *+5 : jmp lrDrawLine_LlrsDrawing141 :
	lda _A1sX : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(-1) : eor tmp0 : sta tmp : lda #>(-1) : eor tmp0+1 : ora tmp : beq *+5 : jmp lrDrawLine_LlrsDrawing141 :
	lda #<(36) : sta reg1 :
	jmp lrDrawLine_LlrsDrawing142 :
lrDrawLine_LlrsDrawing141
	lda _ch2disp : sta tmp0 :
	lda tmp0 : sta reg1 :
lrDrawLine_LlrsDrawing142
lrDrawLine_LlrsDrawing143
lrDrawLine_LlrsDrawing144
	lda _A1X : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #0 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda _A1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #2 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda _distseg : sta tmp0 :
	lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
	lda tmp0 : ldy #4 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	lda reg1 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ldy #6 : sta (sp),y : iny : lda tmp0+1 : sta (sp),y :
	ldy #8 : jsr _zplot :
	lda _A1X : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _A1destX : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp lrDrawLine_LlrsDrawing146 :
	lda _A1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _A1destY : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : eor tmp1 : sta tmp : lda tmp0+1 : eor tmp1+1 : ora tmp : beq *+5 : jmp lrDrawLine_LlrsDrawing146 :
	jmp lrDrawLine_LlrsDrawing145 :
lrDrawLine_LlrsDrawing146
	lda _A1err : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : cmp #<(0) : lda tmp0+1 : sbc #>(0) : bvc *+4 : eor #$80 : bmi *+5 : jmp lrDrawLine_LlrsDrawing151 : :
	lda _A1err : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(64) : and tmp0 : sta tmp0 : lda #>(64) : and tmp0+1 : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp lrDrawLine_LlrsDrawing153 :
	lda #<(128) : sta reg4 : lda #>(128) : sta reg4+1 :
	jmp lrDrawLine_LlrsDrawing154 :
lrDrawLine_LlrsDrawing153
	lda _A1err : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : asl : sta tmp0 : lda tmp0+1 : rol : sta tmp0+1 :
	lda tmp0 : sta reg4 : lda tmp0+1 : sta reg4+1 :
lrDrawLine_LlrsDrawing154
	lda reg4 : sta tmp0 : lda reg4+1 : sta tmp0+1 :
	lda tmp0 : sta reg3 : lda tmp0+1 : sta reg3+1 :
	jmp lrDrawLine_LlrsDrawing152 :
lrDrawLine_LlrsDrawing151
	lda _A1err : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(64) : and tmp0 : sta tmp0 : lda #>(64) : and tmp0+1 : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : bne *+5 : jmp lrDrawLine_LlrsDrawing155 :
	lda #<(127) : sta reg5 : lda #>(127) : sta reg5+1 :
	jmp lrDrawLine_LlrsDrawing156 :
lrDrawLine_LlrsDrawing155
	lda _A1err : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : asl : sta tmp0 : lda tmp0+1 : rol : sta tmp0+1 :
	lda tmp0 : sta reg5 : lda tmp0+1 : sta reg5+1 :
lrDrawLine_LlrsDrawing156
	lda reg5 : sta tmp0 : lda reg5+1 : sta tmp0+1 :
	lda tmp0 : sta reg3 : lda tmp0+1 : sta reg3+1 :
lrDrawLine_LlrsDrawing152
	lda reg3 : sta tmp0 : lda reg3+1 : sta tmp0+1 :
	lda tmp0 : sta reg0 :
	lda reg0 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _A1dY : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp0 : cmp tmp1 : lda tmp0+1 : sbc tmp1+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp lrDrawLine_LlrsDrawing157 :skip : .) : :
	lda _A1err : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _A1dY : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A1err :
	lda _A1X : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _A1sX : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A1X :
lrDrawLine_LlrsDrawing157
	lda reg0 : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _A1dX : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp lrDrawLine_LlrsDrawing143 :skip : .) : : :
	lda _A1err : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _A1dX : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A1err :
	lda _A1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _A1sY : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	clc : lda tmp0 : adc tmp1 : sta tmp0 : lda tmp0+1 : adc tmp1+1 : sta tmp0+1 :
	lda tmp0 : sta _A1Y :
	jmp lrDrawLine_LlrsDrawing143 :
lrDrawLine_LlrsDrawing145
	jmp leave :

; 	ldx #6 : lda #6 : jsr enter :

; //     A1X     = P1X;
; 	lda 	_P1X
; 	sta		_A1X
; //     A1Y     = P1Y;
; 	lda 	_P1Y
; 	sta		_A1Y
; //     A1destX = P2X;
; 	lda 	_P2X
; 	sta		_A1destX
; //     A1destY = P2Y;
; 	lda 	_P2Y
; 	sta		_A1destY
; //     A1dX    = abs(P2X - P1X);
; //     A1dY    = -abs(P2Y - P1Y);
; //     A1sX    = P1X < P2X ? 1 : -1;
; //     A1sY    = P1Y < P2Y ? 1 : -1;
; //     A1err   = A1dX + A1dY;

; //     if ((A1err > 64) || (A1err < -63))
; //         return;

; //     if ((ch2disp == '/') && (A1sX == -1)) {
; //         ch2dsp = DOLLAR;
; //     } else {
; //         ch2dsp = ch2disp;
; //     }

; //     while (1) {  // loop
; //         //printf ("plot [%d, %d] %d %d\n", _A1X, _A1Y, distseg, ch2disp);get ();          
; // #ifdef USE_ZBUFFER
; //         zplot(A1X, A1Y, distseg, ch2dsp);
; // #else
; //         // TODO : plot a point with no z-buffer
; // #endif
; //         if ((A1X == A1destX) && (A1Y == A1destY))
; //             break;
; //         //e2 = 2*err;
; //         e2 = (A1err < 0) ? (
; //                 ((A1err & 0x40) == 0) ? (
; //                                                 0x80)
; //                                         : (
; //                                             A1err << 1))
; //             : (
; //                 ((A1err & 0x40) != 0) ? (
; //                                                 0x7F)
; //                                         : (
; //                                                 A1err << 1));
; //         if (e2 >= A1dY) {
; //             A1err += A1dY;  // e_xy+e_x > 0
; //             A1X += A1sX;
; //         }
; //         if (e2 <= A1dX) {  // e_xy+e_y < 0
; //             A1err += A1dX;
; //             A1Y += A1sY;
; //         }
; //     }



; lrDrawLine_done:
; 	jmp leave :

.)
#endif // USE_ASM_DRAWLINE