
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



//char points3d[NB_MAX_POINTS*SIZEOF_3DPOINT];
//.dsb 256-(*&255)
//_points3d       .dsb NB_MAX_POINTS*SIZEOF_3DPOINT
_points3d:
_points3dX          .dsb NB_MAX_POINTS
_points3dY          .dsb NB_MAX_POINTS
_points3dZ          .dsb NB_MAX_POINTS
#ifndef USE_REWORKED_BUFFERS
_points3unused      .dsb NB_MAX_POINTS
#endif // USE_REWORKED_BUFFERS

//char segments[NB_MAX_SEGMENTS*SIZEOF_SEGMENT];
; .dsb 256-(*&255)
; _segments       .dsb NB_MAX_SEGMENTS*SIZEOF_SEGMENT
_segments:
_segmentsPt1        .dsb NB_MAX_SEGMENTS
_segmentsPt2        .dsb NB_MAX_SEGMENTS
_segmentsChar       .dsb NB_MAX_SEGMENTS
#ifndef USE_REWORKED_BUFFERS
_segmentsUnused     .dsb NB_MAX_SEGMENTS
#endif // USE_REWORKED_BUFFERS

//char points2d [NB_MAX_POINTS*SIZEOF_2DPOINT];
//.dsb 256-(*&255)
//_points2d       .dsb NB_MAX_POINTS*SIZEOF_2DPOINT

//char points2d [NB_MAX_COORDS*SIZEOF_2DPOINT];
//.dsb 256-(*&255)
//_points2d       .dsb NB_MAX_COORDS*SIZEOF_2DPOINT
_points2d:
_points2aH          .dsb NB_MAX_POINTS
_points2aV          .dsb NB_MAX_POINTS
_points2dH          .dsb NB_MAX_POINTS
_points2dL          .dsb NB_MAX_POINTS

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


_plotX		.dsb 1
_plotY		.dsb 1


; int           d1, d2, d3;
_d1         .dsb 2
_d2         .dsb 2
_d3         .dsb 2
; int           dmoy;
_dmoy         .dsb 2

; unsigned char idxPt1, idxPt2, idxPt3;
_idxPt1         .dsb 1
_idxPt2         .dsb 1
_idxPt3         .dsb 1

; signed char   tmpH, tmpV;
_tmpH           .dsb 1
_tmpV           .dsb 1


; unsigned char m1, m2, m3;
_m1         .dsb 1
_m2         .dsb 1
_m3         .dsb 1
; unsigned char v1, v2, v3;
_v1         .dsb 1
_v2         .dsb 1
_v3         .dsb 1

;unsigned char isFace2BeDrawn;
_isFace2BeDrawn  .dsb 1

.zero

ptrpt3:
ptrpt3L .dsb 1
ptrpt3H .dsb 1
ptrpt2:
ptrpt2L .dsb 1
ptrpt2H .dsb 1

.text

#ifndef USE_REWORKED_BUFFERS


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
#endif  // USE_REWORKED_BUFFERS

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

// FIXME : why do we use Opcode of non zero page instruction ??
#define OPCODE_DEC_NONZERO $CE
#define OPCODE_INC_NONZERO $EE

#ifdef USE_ASM_DRAWLINE
_lrDrawLine:
.(

	; ldx #6 : lda #6 : jsr enter :

	// save context
    pha
	lda reg0:pha

//     A1X     = P1X;
	lda 	_P1X
	sta		_A1X
//     A1Y     = P1Y;
	lda 	_P1Y
	sta		_A1Y
//     A1destX = P2X;
	lda 	_P2X
	sta		_A1destX
//     A1destY = P2Y;
	lda 	_P2Y
	sta		_A1destY
//     A1dX    = abs(P2X - P1X);
//     A1sX    = P1X < P2X ? 1 : -1;
; a = P1X-P2X
    sec
    lda _P1X
    sbc _P2X
; if a >= 0 :
    bmi lrDrawLine_p2xoverp1x
;   dx = a
    sta _A1dX
;   sx = -1
    lda #$FF
    sta _A1sX
    lda #OPCODE_DEC_NONZERO
    sta patch_lrDrawLine_incdec_A1X
    jmp lrDrawLine_computeDy
; else
lrDrawLine_p2xoverp1x:
;   dx = -a
    eor #$FF
    sec
    adc #$00
    sta _A1dX
;   sx =1
    lda #$01
    sta _A1sX
    lda #OPCODE_INC_NONZERO
    sta patch_lrDrawLine_incdec_A1X
; endif


lrDrawLine_computeDy:
//     A1dY    = -abs(P2Y - P1Y);
//     A1sY    = P1Y < P2Y ? 1 : -1;
; a = P1Y-P2Y
    lda _P1Y
    sec
    sbc _P2Y
; if a >= 0 :
    bmi lrDrawLine_p2yoverp1y
;   dy = -a
    eor #$FF
    sec
    adc #$00
    sta _A1dY
;   sy = -1
    lda #$FF
    sta _A1sY
    lda #OPCODE_DEC_NONZERO
    sta patch_lrDrawLine_incdec_A1Y
    jmp lrDrawLine_computeErr
; else
lrDrawLine_p2yoverp1y:
;   dy = a
    sta _A1dY
;   sy = 1
    lda #$01
    sta _A1sY
    lda #OPCODE_INC_NONZERO
    sta patch_lrDrawLine_incdec_A1Y
; endif


lrDrawLine_computeErr:
//     A1err   = A1dX + A1dY;
; a = A1dX
    lda		_A1dX
; a = a + dy
    clc
    adc		_A1dY
; err = a
    sta		_A1err

//     if ((A1err > 64) || (A1err < -63)) return;
    sec
    sbc #$40
    bvc *+4
    eor #$80
    bmi lrDrawLine_goon01
	jmp lrDrawLine_endloop
lrDrawLine_goon01:
    lda _A1err
    sec
    sbc #$C0
    bvc *+4
    eor #$80
    bpl lrDrawLine_goon02:
	jmp lrDrawLine_endloop
lrDrawLine_goon02:

//     if ((ch2disp == '/') && (A1sX == -1)) {
//         ch2dsp = DOLLAR;
//     } else {
//         ch2dsp = ch2disp;
//     }
	lda _ch2disp 
	cmp #47
	bne lrDrawLine_loop
	lda _A1sX
	cmp #$FF
	bne  lrDrawLine_loop
	lda #DOLLAR
	sta _ch2disp 

//     while (1) {  // loop
lrDrawLine_loop:

//         //printf ("plot [%d, %d] %d %d\n", _A1X, _A1Y, distseg, ch2disp);get ();          


// #ifdef USE_ZBUFFER
//         zplot(A1X, A1Y, distseg, ch2dsp);
// #else
//         // TODO : plot a point with no z-buffer
// #endif
#ifdef USE_ZBUFFER
			
		lda _A1X : sta _plotX :
		lda _A1Y : sta _plotY :
		lda _distseg: sta _distpoint:
		jsr _fastzplot
#else
		lda _A1X : sta _plotX :
		lda _A1Y : sta _plotY :
		jsr _asmplot
#endif

//         if ((A1X == A1destX) && (A1Y == A1destY)) break;
;       a = A1X
        lda _A1X
;       if a != A1destX goto continue
        cmp _A1destX
        bne lrDrawLine_continue
;       a = A1Y
        lda _A1Y
;       if a != A1destY goto continue
        cmp _A1destY
        bne lrDrawLine_continue
;       goto endloop
        jmp lrDrawLine_endloop
;continue:
lrDrawLine_continue:

//      e2 = 2*A1err;
//         e2 = (A1err < 0) ? (
//                 ((A1err & 0x40) == 0) ? (
//                                                 0x80)
//                                         : (
//                                             A1err << 1))
//             : (
//                 ((A1err & 0x40) != 0) ? (
//                                                 0x7F)
//                                         : (
//                                                 A1err << 1));
		lda _A1err
		bpl lrDrawLine_errpositiv_01
		asl
		bmi lrDrawLine_errdone_01
		lda #$80
		jmp lrDrawLine_errdone_01
	
lrDrawLine_errpositiv_01:	
		asl
		bpl lrDrawLine_errdone_01
		lda #$7F
lrDrawLine_errdone_01:	
		sta reg0

//         if (e2 >= A1dY) {
        sec
        sbc _A1dY
        bvc *+4
        eor #$80
        bmi lrDrawLine_dyovera

//             A1err += A1dY;  // e_xy+e_x > 0
			lda _A1err
			clc
			adc _A1dY
			sta _A1err
//             A1X += A1sX;
patch_lrDrawLine_incdec_A1X:
            inc _A1X
			; lda _A1X
			; clc
			; adc _A1sX
			; sta _A1X
lrDrawLine_dyovera:
//         }
//         if (e2 <= A1dX) {  // e_xy+e_y < 0
		lda _A1dX
		sec
		sbc reg0
		bvc *+4
		eor #$80
		bmi lrDrawLine_e2overdx
//             A1err += A1dX;
			lda _A1err
			clc
			adc _A1dX
			sta _A1err
//             A1Y += A1sY;
patch_lrDrawLine_incdec_A1Y:
            inc _A1Y
			; lda _A1Y
			; clc
			; adc _A1sY
			; sta _A1Y
lrDrawLine_e2overdx
//         }
	jmp lrDrawLine_loop
//     }


lrDrawLine_endloop:
lrDrawLine_done:

	// restore context
	pla: sta reg0
	pla

	; jmp leave :

.)
	rts
#endif // USE_ASM_DRAWLINE