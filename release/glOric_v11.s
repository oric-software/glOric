;; =======================================
;; 	       glOric 3D 
;;     graphic library for Oric 
;; =======================================
;; 
;; Website: https://github.com/oric-software/glOric
;; 
;; Version 1.1
;; February 2020
;; 
;; Copyright 2020 Jean-Baptiste PERIN
;; Email: jbperin@gmail.com
;;

#define ANGLEONLY
#define USE_ZBUFFER
#define USE_COLOR
#define USE_COLLISION_DETECTION
#define USE_REWORKED_BUFFERS
#define USE_HORIZON

#define USE_ASM_HFILL
#define USE_ASM_INITFRAMEBUFFER
#define  USE_ASM_ZPLOT
#define USE_ASM_ZLINE
#define USE_ASM_BRESFILL
#define USE_ASM_ZBUFFER
#define USE_ASM_BUFFER2SCREEN
#define  USE_ASM_ARRAYSPROJECT
#define USE_ASM_DRAWLINE
#define USE_ASM_PLOT
#define USE_ASM_GUESSIFFACE2BEDRAWN
#define USE_ASM_SORTPOINTS
#define USE_ASM_ANGLE2SCREEN
#define USE_ASM_FILL8
#define USE_ASM_RETRIEVEFACEDATA
#define USE_ASM_GLDRAWFACES
#define USE_ASM_GLDRAWSEGMENTS
#define USE_ASM_ISA1RIGHT1
#define USE_ASM_ISA1RIGHT3
// #define USE_C_GLDRAWPARTICULES
// #undef USE_ASM_GLDRAWPARTICULES

#define USE_ASM_BRESTYPE1
#define USE_ASM_BRESTYPE2
#define USE_ASM_BRESTYPE3

#define USE_ASM_REACHSCREEN
#define USE_ASM_FILLFACE

#define USE_8BITS_PROJECTION

#define SCREEN_WIDTH 40
#define SCREEN_HEIGHT 26
#define NB_MAX_POINTS 64
#define NB_MAX_SEGMENTS 64
#define NB_MAX_FACES 64
#define NB_MAX_PARTICULES 64
#define ADR_BASE_SCREEN 48000  
#define ADR_BASE_LORES_SCREEN 48040  
#define HIRES_SCREEN_ADDRESS 0xA000

#define SIZEOF_3DPOINT 4
#define SIZEOF_SEGMENT 4
#define SIZEOF_PARTICULE 2
#define SIZEOF_2DPOINT 4
#define SIZEOF_FACE 4

#define COLUMN_OF_COLOR_ATTRIBUTE 2
#define NB_LESS_LINES_4_COLOR 4

/*
 * VISIBILITY LIMITS
 */
#define ANGLE_MAX 0xC0
#define ANGLE_VIEW 0xE0
#define ASM_ANGLE_MAX $C0
#define ASM_ANGLE_VIEW $E0



/*
 * ASCII TABLE
 */
#define DOLLAR 36


.zero

#ifdef SAVE_ZERO_PAGE
.text
#endif

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

#ifndef SAVE_ZERO_PAGE
.text
#endif

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
		; lda _A1X : sta _plotX : FIXME !!
		; lda _A1Y : sta _plotY :
		; jsr _asmplot
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



.zero
#ifdef SAVE_ZERO_PAGE
.text
#endif

 // Point 3D Coordinates
_PointX:		.dsb 2
_PointY:		.dsb 2
_PointZ:		.dsb 2

 // Point 2D Projected Coordinates
_ResX:			.dsb 2			// -128 -> 127
_ResY:			.dsb 2			// -128 -> 127

 // Intermediary Computation
_DeltaX:		.dsb 2
_DeltaY:		.dsb 2
_DeltaZ:		.dsb 2

_Norm:          .dsb 2
_AngleH:        .dsb 1
_AngleV:        .dsb 1


AnglePH .dsb 1 ; horizontal angle of point from player pov
AnglePV .dsb 1 ; vertical angle of point from player pov

HAngleOverflow .dsb 1
VAngleOverflow .dsb 1

.text


#ifdef USE_8BITS_PROJECTION
_project_i8o8:
.(
	// save context
	pha:txa:pha:tya:pha ; FIXME : txa and tya should be useless but it fails when they are not done

	lda #0
	sta HAngleOverflow
	sta VAngleOverflow

	// DeltaX = CamPosX - PointX
	// Divisor = DeltaX
	sec
	lda _PointX
	sbc _CamPosX
	sta _DeltaX
    sta _tx

	// DeltaY = CamPosY - PointY
	sec
	lda _PointY
	sbc _CamPosY
	sta _DeltaY
    sta _ty

	// AngleH = atan2 (DeltaY, DeltaX)
	jsr _atan2_8
	lda _res
	sta _AngleH

	// Norm = norm (DeltaX, DeltaY)
	jsr _norm_8

	// DeltaZ = CamPosZ - PointZ
	sec
	lda _PointZ
	sbc _CamPosZ
	sta _DeltaZ

	// AngleV = atan2 (DeltaZ, Norm)
	lda _DeltaZ
	sta _ty
	lda _Norm
	sta _tx
	jsr _atan2_8
	lda _res
	sta _AngleV

	// AnglePH = AngleH - CamRotZ
	sec
	lda _AngleH
	sbc _CamRotZ
	sta AnglePH
	bvc project_i8o8_noHAngleOverflow
	lda #$80
	sta HAngleOverflow

project_i8o8_noHAngleOverflow:
	// AnglePV = AngleV - CamRotX
	sec
	lda     _AngleV
	sbc     _CamRotX
	sta     AnglePV
	bvc     project_i8o8_noVAngleOverflow
	lda     #$80
	sta     VAngleOverflow

project_i8o8_noVAngleOverflow:
#ifndef ANGLEONLY
#ifdef TEXTDEMO
	// Quick Disgusting Hack:  X = (-AnglePH //2 ) + LE / 2
	lda AnglePH
	cmp #$80
	ror
    ora HAngleOverflow

	eor #$FF
	sec
	adc #$00
	clc
    adc #SCREEN_WIDTH/2
	sta _ResX

	lda AnglePV
	cmp #$80
	ror
    ora VAngleOverflow

	eor #$FF
	sec
	adc #$00
	clc
    adc #SCREEN_HEIGHT/2
	sta _ResY
#else // not TEXTDEMO
	;; lda AnglePH
	;; eor #$FF
	;; sec
	;; adc #$00
	;; asl
	;; asl
	;; clc
    ;; adc #120 ; 240/2 = WIDTH/2
	;; sta _ResX
	// Extend AnglePH on 16 bits
	lda #$00
	sta _ResX+1
	lda AnglePH
	sta _ResX
	bpl project_i8o8_angHpositiv
	lda #$FF
	sta _ResX+1
project_i8o8_angHpositiv:
	// Invert AnglePH on 16 bits
	sec
	lda #$00
	sbc _ResX
	sta _ResX
	lda #$00
	sbc _ResX+1
	sta _ResX+1
	// Multiply by 4
	asl _ResX
	rol _ResX+1
	asl _ResX
	rol _ResX+1
	// Add offset of screen center
	clc
	lda _ResX
	adc #120
	sta _ResX
	lda _ResX+1
	adc #$00
	sta _ResX+1

	;; lda AnglePV
	;; eor #$FF
	;; sec
	;; adc #$00
	;; asl
	;; asl
	;; adc #100 ; = 200 /2 SCREEN_HEIGHT/2
	;; sta _ResY

	// Extend AnglePV on 16 bits
	lda #$00
	sta _ResY+1
	lda AnglePV
	sta _ResY
	bpl project_i8o8_angVpositiv
	lda #$FF
	sta _ResY+1
project_i8o8_angVpositiv:
	// Invert AnglePV on 16 bits
	sec
	lda #$00
	sbc _ResY
	sta _ResY
	lda #$00
	sbc _ResY+1
	sta _ResY+1
	// Multiply by 4
	asl _ResY
	rol _ResY+1
	asl _ResY
	rol _ResY+1
	// Add offset of screen center
	clc
	lda _ResY
	adc #100
	sta _ResY
	lda _ResY+1
	adc #$00
	sta _ResY+1

#endif // TEXTDEMO
#else
	lda AnglePH
	sta _ResX
	lda AnglePV
	sta _ResY
#endif // ANGLEONLY

project_i8o8_done:
	// restore context
	pla:tay:pla:tax:pla
.)
	rts
#endif // USE_8BITS_PROJECTION



#ifdef USE_16BITS_PROJECTION
_project_i16:
.(
	// save context
	pha:txa:pha:tya:pha

	lda #0
	sta HAngleOverflow
	sta VAngleOverflow

	// DeltaX = CamPosX - PointX
	// Divisor = DeltaX
	sec
	lda _PointX
	sbc _CamPosX
	sta _DeltaX
	lda _PointX+1
	sbc _CamPosX+1
	sta _DeltaX+1

	// DeltaY = CamPosY - PointY
	sec
	lda _PointY
	sbc _CamPosY
	sta _DeltaY
	lda _PointY+1
	sbc _CamPosY+1
	sta _DeltaY+1

	// AngleH = atan2 (DeltaY, DeltaX)
	lda _DeltaY
	sta _ty
	lda _DeltaX
	sta _tx
	jsr _atan2_8
	lda _res
	sta _AngleH

	// Norm = norm (DeltaX, DeltaY)
	jsr _norm_8

	// DeltaZ = CamPosZ - PointZ
	sec
	lda _PointZ
	sbc _CamPosZ
	sta _DeltaZ
	lda _PointZ+1
	sbc _CamPosZ+1
	sta _DeltaZ+1

	// AngleV = atan2 (DeltaZ, Norm)
	lda _DeltaZ
	sta _ty
	lda _Norm
	sta _tx
	jsr _atan2_8
	lda _res
	sta _AngleV

	// AnglePH = AngleH - CamRotZ
	sec
	lda _AngleH
	sbc _CamRotZ
	sta AnglePH
	bvc project_i16_noHAngleOverflow
	lda #$80
	sta HAngleOverflow

project_i16_noHAngleOverflow:
	// AnglePV = AngleV - CamRotX
	sec
	lda _AngleV
	sbc _CamRotX
	sta AnglePV
	bvc project_i16_noVAngleOverflow
	lda #$80
	sta VAngleOverflow

project_i16_noVAngleOverflow:
#ifndef ANGLEONLY
#ifdef TEXTDEMO
	// Quick Disgusting Hack:  X = (-AnglePH //2 ) + LE / 2
	lda AnglePH
	cmp #$80
	ror
    ora HAngleOverflow

	eor #$FF
	sec
	adc #$00
	clc
    adc #SCREEN_WIDTH/2
	sta _ResX

	lda AnglePV
	cmp #$80
	ror
    ora VAngleOverflow

	eor #$FF
	sec
	adc #$00
	clc
    adc #SCREEN_HEIGHT/2
	sta _ResY
#else
	;; lda AnglePH
	;; eor #$FF
	;; sec
	;; adc #$00
	;; asl
	;; asl
	;; clc
    ;; adc #120 ; 240/2 = WIDTH/2
	;; sta _ResX
	// Extend AnglePH on 16 bits
	lda #$00
	sta _ResX+1
	lda AnglePH
	sta _ResX
	bpl angHpositiv
	lda #$FF
	sta _ResX+1
angHpositiv:
	// Invert AnglePH on 16 bits
	sec
	lda #$00
	sbc _ResX
	sta _ResX
	lda #$00
	sbc _ResX+1
	sta _ResX+1
	// Multiply by 4
	asl _ResX
	rol _ResX+1
	asl _ResX
	rol _ResX+1
	// Add offset of screen center
	clc
	lda _ResX
	adc #120
	sta _ResX
	lda _ResX+1
	adc #$00
	sta _ResX+1

	;; lda AnglePV
	;; eor #$FF
	;; sec
	;; adc #$00
	;; asl
	;; asl
	;; adc #100 ; = 200 /2 SCREEN_HEIGHT/2
	;; sta _ResY

	// Extend AnglePV on 16 bits
	lda #$00
	sta _ResY+1
	lda AnglePV
	sta _ResY
	bpl angVpositiv
	lda #$FF
	sta _ResY+1
angVpositiv:
	// Invert AnglePV on 16 bits
	sec
	lda #$00
	sbc _ResY
	sta _ResY
	lda #$00
	sbc _ResY+1
	sta _ResY+1
	// Multiply by 4
	asl _ResY
	rol _ResY+1
	asl _ResY
	rol _ResY+1
	// Add offset of screen center
	clc
	lda _ResY
	adc #100
	sta _ResY
	lda _ResY+1
	adc #$00
	sta _ResY+1

#endif
#else
	lda AnglePH
	sta _ResX
	lda AnglePV
	sta _ResY
#endif

prodone:
	// restore context
	pla:tay:pla:tax:pla
.)
	rts

#endif // USE_16BITS_PROJECTION


_projectPoint
	ldx #6 : lda #0 : jsr enter :

	ldy #0 : lda (ap),y : sta _PointX 
	ldy #2 : lda (ap),y : sta _PointY 
	ldy #4 : lda (ap),y : sta _PointZ 
	ldy #6: lda (ap),y : sta _projOptions 

	jsr _project_i8o8

	ldy #8 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	ldy #0 : lda _ResX : sta (tmp0),y :
	ldy #10 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	ldy #0 : lda _ResY : sta (tmp0),y :
	ldy #12 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	ldy #0 : lda _Norm : sta (tmp0),y : iny : lda #0 : sta (tmp0),y :

	jmp leave :


#define OPCODE_DEC_ZERO $C6
#define OPCODE_INC_ZERO $E6


.zero

_A1X .dsb 1
_A1Y .dsb 1
_A1destX .dsb 1
_A1destY .dsb 1
_A1dX .dsb 1
_A1dY .dsb 1
_A1err .dsb 1
_A1sX .dsb 1
_A1sY .dsb 1
_A1arrived .dsb 1
_A2X .dsb 1
_A2Y .dsb 1
_A2destX .dsb 1
_A2destY .dsb 1
_A2dX .dsb 1
_A2dY .dsb 1
_A2err .dsb 1
_A2sX .dsb 1
_A2sY .dsb 1
_A2arrived .dsb 1

_A1Right .dsb 1

_mDeltaY1 .dsb 1
_mDeltaX1 .dsb 1
_mDeltaY2 .dsb 1
_mDeltaX2 .dsb 1

#ifdef SAVE_ZERO_PAGE
.text
#endif

_P1X .byt 0
_P1Y .byt 0
_P2X .byt 0
_P2Y .byt 0
_P3X .byt 0
_P3Y .byt 0

_P1AH .byt 0
_P1AV .byt 0
_P2AH .byt 0
_P2AV .byt 0
_P3AH .byt 0
_P3AV .byt 0


_pDepX  .byt 0
_pDepY  .byt 0
_pArr1X .byt 0
_pArr1Y .byt 0
_pArr2X .byt 0
_pArr2Y .byt 0

_distface .byt 0
_distseg .byt 0
_distpoint .byt 0
_ch2disp .byt 0

#ifndef SAVE_ZERO_PAGE
.text
#endif

/*
void A1stepY(){
	signed char  nxtY, e2;
	nxtY = A1Y+A1sY;
	printf ("nxtY = %d\n", nxtY);
	e2 = (A1err < 0) ? (
			((A1err & 0x40) == 0)?(
				0x80
			):(
				A1err << 1
			)
		):(
			((A1err & 0x40) != 0)?(
				0x7F
			):(
				A1err << 1
			)
		);
	printf ("e2 = %d\n", e2);
	while ((A1arrived == 0) && ((e2>A1dX) || (A1Y!=nxtY))){
		if (e2 >= A1dY){
			A1err += A1dY;
			printf ("A1err = %d\n", A1err);
			A1X += A1sX;
			printf ("A1X = %d\n", A1X);
		}
		if (e2 <= A1dX){
			A1err += A1dX;
			printf ("A1err = %d\n", A1err);
			A1Y += A1sY;
			printf ("A1Y = %d\n", A1Y);
		}
		A1arrived=((A1X == A1destX) && ( A1Y == A1destY))?1:0;
		e2 = (A1err < 0) ? (
				((A1err & 0x40) == 0)?(
					0x80
				):(
					A1err << 1
				)
			):(
				((A1err & 0x40) != 0)?(
					0x7F
				):(
					A1err << 1
				)
			);
		printf ("e2 = %d\n", e2);

		}
}
*/

#ifdef USE_ASM_BRESFILL
_A1stepY

	// save context
    pha
	lda reg0: pha: lda reg1 : pha 

	;; nxtY = A1Y+A1sY;
	clc
	lda _A1Y
	adc _A1sY
	sta reg1
	
	;; e2 = A1err << 1; // 2*A1err;
	lda _A1err
	bpl A1stepY_errpositiv_01
	asl
	bmi A1stepY_errdone_01
	lda #$80
	jmp A1stepY_errdone_01
	
A1stepY_errpositiv_01:	
	asl
	bpl A1stepY_errdone_01
	lda #$7F
A1stepY_errdone_01:	
	sta reg0
	
	;; while ((A1arrived == 0) && ((e2>A1dX) || (A1Y!=nxtY))){
A1stepY_loop:
	lda _A1arrived ;; (A1arrived == 0)
	beq A1stepY_notarrived
	jmp A1stepYdone

A1stepY_notarrived:	
	lda _A1dX 		;; (e2>A1dX)
    sec
	sbc reg0
    bvc *+4
    eor #$80
	bmi A1stepY_doloop

	lda reg1 		;; (A1Y!=nxtY)
	cmp _A1Y
	bne A1stepY_doloop
	
	jmp A1stepYdone
A1stepY_doloop:
	
		;; if (e2 >= A1dY){
		lda reg0 ; e2
        sec
        sbc _A1dY
        bvc *+4
        eor #$80
		bmi A1stepY_A1Xdone
		;; 	A1err += A1dY;
			clc
			lda _A1err
			adc _A1dY
			bvc A1stepY_debug_moi_la
			jmp A1stepYdone
A1stepY_debug_moi_la:			
			sta _A1err
		;; 	A1X += A1sX;
_patch_A1stepY_incdec_A1X
			inc _A1X 
			; clc
			; lda _A1X
			; adc _A1sX
			; sta _A1X
		;; }
A1stepY_A1Xdone:
		;; if (e2 <= A1dX){
		lda _A1dX
        sec
		sbc reg0
        bvc *+4
        eor #$80
		bmi A1stepY_A1Ydone
		;; 	A1err += A1dX;
			clc
			lda _A1err
			adc _A1dX
			sta _A1err
		;; 	A1Y += A1sY; // Optim:  substraction by dec _A1Y
			dec _A1Y
			;clc
			;lda _A1Y
			;adc _A1sY
			;sta _A1Y
			
		;; }
A1stepY_A1Ydone:
		;; A1arrived=((A1X == A1destX) && ( A1Y == A1destY))?1:0;
		lda #0
		sta _A1arrived
		
		lda _A1X
		cmp _A1destX
		bne A1stepY_computeE2
		
		lda _A1Y
		cmp _A1destY
		bne A1stepY_computeE2
	
		lda #1
		sta _A1arrived
A1stepY_computeE2:
		;; e2 = A1err << 1; // 2*A1err;
		lda _A1err
		bpl A1stepY_errpositiv_02
		asl
		bmi A1stepY_errdone_02
		lda #$80
		jmp A1stepY_errdone_02
		
A1stepY_errpositiv_02:	
		asl
		bpl A1stepY_errdone_02
		lda #$7F
A1stepY_errdone_02:	
		sta reg0
	
	jmp A1stepY_loop
A1stepYdone:	

	// restore context
	pla: sta reg1: pla: sta reg0
	pla


	rts
#endif


/*
void A2stepY(){
	signed char  nxtY, e2;
	nxtY = A2Y+A2sY	;
	e2 = (A2err < 0) ? (
			((A2err & 0x40) == 0)?(
				0x80
			):(
				A2err << 1
			)
		):(
			((A2err & 0x40) != 0)?(
				0x7F
			):(
				A2err << 1
			)
		);
	while ((A2arrived == 0) && ((e2>A2dX) || (A2Y!=nxtY))){
		if (e2 >= A2dY){
			A2err += A2dY;
			A2X += A2sX;
		}
		if (e2 <= A2dX){
			A2err += A2dX;
			A2Y += A2sY;
		}
		A2arrived=((A2X == A2destX) && ( A2Y == A2destY))?1:0;
		e2 = (A2err < 0) ? (
				((A2err & 0x40) == 0)?(
					0x80
				):(
					A2err << 1
				)
			):(
				((A2err & 0x40) != 0)?(
					0x7F
				):(
					A2err << 1
				)
			);
	}
}
*/
	
#ifdef USE_ASM_BRESFILL
_A2stepY

	// save context
    pha
	lda reg0: pha: lda reg1 : pha 

	;; nxtY = A2Y+A2sY;
	clc
	lda _A2Y
	adc _A2sY
	sta reg1
	
	;; e2 = A2err << 1; // 2*A2err;
	lda _A2err
	bpl A2stepY_errpositiv_01
	asl
	bmi A2stepY_errdone_01
	lda #$80
	jmp A2stepY_errdone_01
	
A2stepY_errpositiv_01:	
	asl
	bpl A2stepY_errdone_01
	lda #$7F
A2stepY_errdone_01:	
	sta reg0
	
	;; while ((A2arrived == 0) && ((e2>A2dX) || (A2Y!=nxtY))){
A2stepY_loop:
	lda _A2arrived ;; (A2arrived == 0)
	beq A2stepY_notarrived
	jmp A2stepYdone

A2stepY_notarrived:	
	lda _A2dX 		;; (e2>A2dX)
    sec
    sbc reg0
    bvc *+4
    eor #$80
	bmi A2stepY_doloop

	lda reg1 		;; (A2Y!=nxtY)
	cmp _A2Y
	bne A2stepY_doloop
	
	jmp A2stepYdone
A2stepY_doloop:
	
		;; if (e2 >= A2dY){
		lda reg0 ; e2
        sec
        sbc _A2dY
        bvc *+4
        eor #$80
		bmi A2stepY_A2Xdone
		;; 	A2err += A2dY;
			clc
			lda _A2err
			adc _A2dY
			sta _A2err
		;; 	A2X += A2sX;
patch_A2stepY_incdec_A2X:
			inc _A2X
			; clc
			; lda _A2X
			; adc _A2sX
			; sta _A2X
		;; }
A2stepY_A2Xdone:
		;; if (e2 <= A2dX){
		lda _A2dX
        sec
        sbc reg0
        bvc *+4
        eor #$80
		bmi A2stepY_A2Ydone
		;; 	A2err += A2dX;
			clc
			lda _A2err
			adc _A2dX
			sta _A2err
		;; 	A2Y += A2sY; // // Optim:  substraction dec _A2Y
			dec _A2Y
			;clc
			;lda _A2Y
			;adc _A2sY
			;sta _A2Y
			
		;; }
A2stepY_A2Ydone:
		;; A2arrived=((A2X == A2destX) && ( A2Y == A2destY))?1:0;
		lda #0
		sta _A2arrived
		
		lda _A2X
		cmp _A2destX
		bne A2stepY_computeE2
		
		lda _A2Y
		cmp _A2destY
		bne A2stepY_computeE2
	
		lda #1
		sta _A2arrived
A2stepY_computeE2:
		;; e2 = A2err << 1; // 2*A2err;
		lda _A2err
		bpl A2stepY_errpositiv_02
		asl
		bmi A2stepY_errdone_02
		lda #$80
		jmp A2stepY_errdone_02
		
A2stepY_errpositiv_02:	
		asl
		bpl A2stepY_errdone_02
		lda #$7F
A2stepY_errdone_02:	
		sta reg0
	
	jmp A2stepY_loop
A2stepYdone:	

	// restore context
	pla: sta reg1: pla: sta reg0
	pla


	rts
#endif //  USE_ASM_BRESFILL

#ifdef USE_ASM_HFILL


// void hfill() {
_hfill:
.(
; #ifdef USE_PROFILER
; PROFILE_ENTER(ROUTINE_HFILL)
; #endif
	// save context
    pha:txa:pha:tya:pha
	lda reg0: pha ;; p1x 
    lda reg1: pha ;; p2x
	lda reg2: pha ;; pY
    lda reg3: pha ;; dist
    lda reg4: pha ;; char2disp
	lda tmp0: pha ;; dx
	lda tmp1: pha ;; fx
	lda tmp2: pha ;; nbpoints
	lda tmp3: pha: lda tmp3+1: pha  ;; save stack pointer

//     signed char dx, fx;
//     signed char nbpoints;

//     //printf ("p1x=%d p2x=%d py=%d dist= %d, char2disp= %d\n", p1x, p2x, dist,  dist, char2disp);get();

//     if ((A1Y <= 0) || (A1Y >= SCREEN_HEIGHT)) return;
	lda _A1Y				; Access Y coordinate
    bpl *+5
    jmp hfill_done
#ifdef USE_COLOR
    cmp #SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR
#else
    cmp #SCREEN_HEIGHT
#endif
    bcc *+5
	jmp hfill_done
    sta reg2 ; A1Y

//     if (A1X > A2X) {
	lda _A1X				
	sta reg0
	sec
	sbc _A2X				; signed cmp to p2x
	bvc *+4
	eor #$80
	bmi hfill_A2xOverOrEqualA1x
#ifdef USE_COLOR
//		dx = max(2, A2X);
		lda _A2X
		sec
		sbc #COLUMN_OF_COLOR_ATTRIBUTE
		bvc *+4
		eor #$80
		bmi hfill_A2xLowerThan3
		lda _A2X
		jmp hfill_A2xPositiv
hfill_A2xLowerThan3:
		lda #COLUMN_OF_COLOR_ATTRIBUTE
#else
//      dx = max(0, A2X);
		lda _A2X
		bpl hfill_A2xPositiv
		lda #0
#endif
hfill_A2xPositiv:
		sta tmp0 ; dx
//         fx = min(A1X, SCREEN_WIDTH - 1);
		lda _A1X
		sta tmp1
		sec
		sbc #SCREEN_WIDTH - 1
		bvc *+4
		eor #$80
		bmi hfill_A1xOverScreenWidth
		lda #SCREEN_WIDTH - 1
		sta tmp1
hfill_A1xOverScreenWidth:
		jmp hfill_computeNbPoints
hfill_A2xOverOrEqualA1x:
//     } else {
#ifdef USE_COLOR
//		dx = max(2, A1X);
		lda _A1X
		sec
		sbc #COLUMN_OF_COLOR_ATTRIBUTE
		bvc *+4
		eor #$80
		bmi hfill_A1xLowerThan3
		lda _A1X
		jmp hfill_A1xPositiv
hfill_A1xLowerThan3:
		lda #COLUMN_OF_COLOR_ATTRIBUTE
#else
//      dx = max(0, A1X);
		lda _A1X
		bpl hfill_A1xPositiv
		lda #0
#endif
hfill_A1xPositiv:
		sta tmp0
//         fx = min(A2X, SCREEN_WIDTH - 1);
		lda _A2X ; p2x
		sta tmp1
		sec
		sbc #SCREEN_WIDTH - 1
		bvc *+4
		eor $80
		bmi hfill_A2xOverScreenWidth
		lda #SCREEN_WIDTH - 1
		sta tmp1
hfill_A2xOverScreenWidth:
//     }
hfill_computeNbPoints:
//     nbpoints = fx - dx;
//     if (nbpoints < 0) return;
	sec
	lda tmp1
	sbc tmp0
	bmi hfill_done
	sta tmp2

//     // printf ("dx=%d py=%d nbpoints=%d dist= %d, char2disp= %d\n", dx, py, nbpoints,  dist, char2disp);get();

// #ifdef USE_ZBUFFER
//     zline(dx, A1Y, nbpoints, distface, ch2disp);
	clc
	lda sp
	sta tmp3
	adc #10
	sta sp
	lda sp+1
	sta tmp3+1
	adc #0
	sta sp+1
	lda tmp0 : ldy #0 : sta (sp),y ;; dx
	lda reg2 : ldy #2 : sta (sp),y ;; py
	lda tmp2 : ldy #4 : sta (sp),y ;; nbpoints
	lda _distface : ldy #6 : sta (sp),y ;; dist
	lda _ch2disp : ldy #8 : sta (sp),y ;; char2disp
	ldy #10 : jsr _zline
	lda tmp3
	sta sp
	lda tmp3+1
	sta sp+1
// #else
//     // TODO : draw a line whit no z-buffer
// #endif
hfill_done:
	// restore context
	pla: sta tmp3+1
	pla: sta tmp3
	pla: sta tmp2
	pla: sta tmp1
	pla: sta tmp0
    pla: sta reg4
	pla: sta reg3
    pla: sta reg2
	pla: sta reg1
    pla: sta reg0
	pla:tay:pla:tax:pla
// }
; #ifdef USE_PROFILER
; PROFILE_LEAVE(ROUTINE_HFILL)
; #endif
.)
	rts

#endif // USE_ASM_HFILL

#ifdef USE_ASM_ANGLE2SCREEN


// void angle2screen() {
_angle2screen:
.(

	// save context
    pha

//     P1X = (SCREEN_WIDTH - P1AH) >> 1;
//     P1Y = (SCREEN_HEIGHT - P1AV) >> 1;
//     P2X = (SCREEN_WIDTH - P2AH) >> 1;
//     P2Y = (SCREEN_HEIGHT - P2AV) >> 1;
//     P3X = (SCREEN_WIDTH - P3AH) >> 1;
//     P3Y = (SCREEN_HEIGHT - P3AV) >> 1;

	lda _P1AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	sec : lda #<(40) : sbc tmp0 : sta tmp0 : lda #>(40) : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta tmp : lda tmp0+1 : ldx #1 : beq *+8 : lsr : ror tmp : dex : bne *-4 : ldx tmp : : stx tmp0 : sta tmp0+1 :
	lda tmp0 : sta _P1X :
	lda _P1AV : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	sec : lda #<(26) : sbc tmp0 : sta tmp0 : lda #>(26) : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta tmp : lda tmp0+1 : ldx #1 : beq *+8 : lsr : ror tmp : dex : bne *-4 : ldx tmp : : stx tmp0 : sta tmp0+1 :
	lda tmp0 : sta _P1Y :
	lda _P2AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	sec : lda #<(40) : sbc tmp0 : sta tmp0 : lda #>(40) : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta tmp : lda tmp0+1 : ldx #1 : beq *+8 : lsr : ror tmp : dex : bne *-4 : ldx tmp : : stx tmp0 : sta tmp0+1 :
	lda tmp0 : sta _P2X :
	lda _P2AV : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	sec : lda #<(26) : sbc tmp0 : sta tmp0 : lda #>(26) : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta tmp : lda tmp0+1 : ldx #1 : beq *+8 : lsr : ror tmp : dex : bne *-4 : ldx tmp : : stx tmp0 : sta tmp0+1 :
	lda tmp0 : sta _P2Y :
	lda _P3AH : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	sec : lda #<(40) : sbc tmp0 : sta tmp0 : lda #>(40) : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta tmp : lda tmp0+1 : ldx #1 : beq *+8 : lsr : ror tmp : dex : bne *-4 : ldx tmp : : stx tmp0 : sta tmp0+1 :
	lda tmp0 : sta _P3X :
	lda _P3AV : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	sec : lda #<(26) : sbc tmp0 : sta tmp0 : lda #>(26) : sbc tmp0+1 : sta tmp0+1 :
	lda tmp0 : sta tmp : lda tmp0+1 : ldx #1 : beq *+8 : lsr : ror tmp : dex : bne *-4 : ldx tmp : : stx tmp0 : sta tmp0+1 :
	lda tmp0 : sta _P3Y :

	// restore context
	pla
// }
.)
	rts

#endif // USE_ASM_ANGLE2SCREEN

#ifdef USE_ASM_BRESFILL

;; void prepare_bresrun() {

    ; if (P1Y <= P2Y) {
    ;     if (P2Y <= P3Y) {
    ;         pDepX  = P3X;
    ;         pDepY  = P3Y;
    ;         pArr1X = P2X;
    ;         pArr1Y = P2Y;
    ;         pArr2X = P1X;
    ;         pArr2Y = P1Y;
    ;     } else {
    ;         pDepX = P2X;
    ;         pDepY = P2Y;
    ;         if (P1Y <= P3Y) {
    ;             pArr1X = P3X;
    ;             pArr1Y = P3Y;
    ;             pArr2X = P1X;
    ;             pArr2Y = P1Y;
    ;         } else {
    ;             pArr1X = P1X;
    ;             pArr1Y = P1Y;
    ;             pArr2X = P3X;
    ;             pArr2Y = P3Y;
    ;         }
    ;     }
    ; } else {
    ;     if (P1Y <= P3Y) {
    ;         pDepX  = P3X;
    ;         pDepY  = P3Y;
    ;         pArr1X = P1X;
    ;         pArr1Y = P1Y;
    ;         pArr2X = P2X;
    ;         pArr2Y = P2Y;
    ;     } else {
    ;         pDepX = P1X;
    ;         pDepY = P1Y;
    ;         if (P2Y <= P3Y) {
    ;             pArr1X = P3X;
    ;             pArr1Y = P3Y;
    ;             pArr2X = P2X;
    ;             pArr2Y = P2Y;
    ;         } else {
    ;             pArr1X = P2X;
    ;             pArr1Y = P2Y;
    ;             pArr2X = P3X;
    ;             pArr2Y = P3Y;
    ;         }
    ;     }
    ; }

;;}

_prepare_bresrun:
.(
; #ifdef USE_PROFILER
; PROFILE_ENTER(ROUTINE_PREPAREBRESRUN)
; #endif
	lda _P1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P2Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill129 :skip : .) : : :
	lda _P2Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P3Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill131 :skip : .) : : :
	lda _P3X : sta _pDepX :
	lda _P3Y : sta _pDepY :
	lda _P2X : sta _pArr1X :
	lda _P2Y : sta _pArr1Y :
	lda _P1X : sta _pArr2X :
	lda _P1Y : sta _pArr2Y :
	jmp prepare_bresrun_Lbresfill130 :
prepare_bresrun_Lbresfill131
	lda _P2X : sta _pDepX :
	lda _P2Y : sta _pDepY :
	lda _P1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P3Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill133 :skip : .) : : :
	lda _P3X : sta _pArr1X :
	lda _P3Y : sta _pArr1Y :
	lda _P1X : sta _pArr2X :
	lda _P1Y : sta _pArr2Y :
	jmp prepare_bresrun_Lbresfill130 :
prepare_bresrun_Lbresfill133
	lda _P1X : sta _pArr1X :
	lda _P1Y : sta _pArr1Y :
	lda _P3X : sta _pArr2X :
	lda _P3Y : sta _pArr2Y :
	jmp prepare_bresrun_Lbresfill130 :
prepare_bresrun_Lbresfill129
	lda _P1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P3Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill135 :skip : .) : : :
	lda _P3X : sta _pDepX :
	lda _P3Y : sta _pDepY :
	lda _P1X : sta _pArr1X :
	lda _P1Y : sta _pArr1Y :
	lda _P2X : sta _pArr2X :
	lda _P2Y : sta _pArr2Y :
	jmp prepare_bresrun_Lbresfill136 :
prepare_bresrun_Lbresfill135
	lda _P1X : sta _pDepX :
	lda _P1Y : sta _pDepY :
	lda _P2Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda _P3Y : sta tmp1 :
	lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill137 :skip : .) : : :
	lda _P3X : sta _pArr1X :
	lda _P3Y : sta _pArr1Y :
	lda _P2X : sta _pArr2X :
	lda _P2Y : sta _pArr2Y :
	jmp prepare_bresrun_Lbresfill138 :
prepare_bresrun_Lbresfill137
	lda _P2X : sta _pArr1X :
	lda _P2Y : sta _pArr1Y :
	lda _P3X : sta _pArr2X :
	lda _P3Y : sta _pArr2Y :
prepare_bresrun_Lbresfill138
prepare_bresrun_Lbresfill136
prepare_bresrun_Lbresfill130
; #ifdef USE_PROFILER
; PROFILE_LEAVE(ROUTINE_PREPAREBRESRUN)
; #endif
.)
	rts :
#endif

#ifdef USE_ASM_ISA1RIGHT1
// void isA1Right1 ()
_isA1Right1:
.(
	// save context
    pha
	lda tmp0 : pha
	lda tmp1 : pha
	lda reg6 : pha
	lda reg7 : pha

    // if ((mDeltaX1 & 0x80) == 0){
	lda #$00 : sta _A1Right
	lda _mDeltaX1
	bmi isA1Right1_mDeltaX1_negativ:
        
    // 	  if ((mDeltaX2 & 0x80) == 0){
		lda _mDeltaX2
		bmi isA1Right1_mDeltaX2_negativ_01
    //         // printf ("%d*%d  %d*%d ", mDeltaY1, mDeltaX2, mDeltaY2,mDeltaX1);get ();
    //         A1Right = (log2_tab[mDeltaX2] + log2_tab[mDeltaY1]) > (log2_tab[mDeltaX1] + log2_tab[mDeltaY2]);
    //         // A1Right = mDeltaY1*mDeltaX2 > mDeltaY2*mDeltaX1;

			ldx _mDeltaY1
			ldy _mDeltaX2
			clc
			lda _log2_tab,x
			adc _log2_tab,y
			ror						; to avoid modulo by overflow
			sta tmp0

			ldx _mDeltaX1			; abs(mDeltaX1)
			ldy _mDeltaY2
			clc
			lda _log2_tab,x
			adc _log2_tab,y
			ror						; to avoid modulo by overflow
			sta tmp1			; (log2_tab[abs(mDeltaX1)] + log2_tab[mDeltaY2])

			cmp tmp0

			bcs isA1Right1_done

			lda #$01 : sta _A1Right

			jmp isA1Right1_done
isA1Right1_mDeltaX2_negativ_01:
    //     } else {
			lda #$00 : sta _A1Right
    //         A1Right = 0 ; // (mDeltaX1 < 0) 
    //     }
	jmp isA1Right1_done
isA1Right1_mDeltaX1_negativ:
    // } else {
		eor #$ff: sec: adc #$00: sta reg6 ; reg6 = abs(mDeltaX1)
 
    //     if ((mDeltaX2 & 0x80) == 0){
		lda _mDeltaX2
		bmi isA1Right1_mDeltaX2_negativ_02
    //         A1Right = 1 ; // (mDeltaX1 < 0)
			lda #$01 : sta _A1Right
			jmp isA1Right1_done
 isA1Right1_mDeltaX2_negativ_02;
    //     } else {
    //         // printf ("%d*%d  %d*%d ", mDeltaY1, -mDeltaX2, mDeltaY2,-mDeltaX1);get ();
			eor #$ff: sec: adc #$00: sta reg7 ; reg7 = abs(mDeltaX2)
    //         A1Right = (log2_tab[abs(mDeltaX2)] + log2_tab[mDeltaY1]) < (log2_tab[abs(mDeltaX1)] + log2_tab[mDeltaY2]);

			ldx reg7			; abs(mDeltaX2)
			ldy _mDeltaY1
			clc
			lda _log2_tab,x
			adc _log2_tab,y
			ror					; to avoid modulo by overflow
			sta tmp0			; log2_tab[abs(mDeltaX2)] + log2_tab[mDeltaY1]

			ldx reg6			; abs(mDeltaX1)
			ldy _mDeltaY2
			clc
			lda _log2_tab,x
			adc _log2_tab,y
			ror					; to avoid modulo by overflow
			sta tmp1			; (log2_tab[abs(mDeltaX1)] + log2_tab[mDeltaY2])

			cmp tmp0 

			bcc isA1Right1_done

			lda #$01 : sta _A1Right

    //     }
    // }

isA1Right1_done:
	// restore context
	pla : sta reg7 : 
	pla : sta reg6 : 
	pla : sta tmp1 : 
	pla : sta tmp0 : 
	pla
.)
	rts
#endif // USE_ASM_ISA1RIGHT1

#ifdef USE_ASM_ISA1RIGHT3
// void isA1Right3 ()
_isA1Right3:
.(
	lda #$00 : sta _A1Right

	// A1Right = (A1X > A2X);
	lda _A2X
	sec
	sbc _A1X
	bvc *+4
	eor #$80
	bpl isA1Right3_done

	lda #$01 : sta _A1Right
isA1Right3_done:
.)
	rts
#endif // USE_ASM_ISA1RIGHT3

#ifdef USE_ASM_FILL8
_fill8:


	// save context
    ;pha
	;lda reg0: pha: lda reg1 : pha 

    // prepare_bresrun();
	ldy #0 : jsr _prepare_bresrun :

    // if (pDepY != pArr1Y) {
	lda _pDepY
	cmp _pArr1Y
	bne fill8_DepYDiffArr1Y
	jmp fill8_DepYEqualsArr1Y
fill8_DepYDiffArr1Y:
    //     A1X     = pDepX;
    //     A2X     = pDepX;
    //     A1Y     = pDepY;
    //     A2Y     = pDepY;
		lda _pDepX: sta _A1X: sta _A2X
		lda _pDepY: sta _A1Y: sta _A2Y

    //     A1destX = pArr1X;
    //     A1destY = pArr1Y;
		lda _pArr1X : sta _A1destX
		lda _pArr1Y : sta _A1destY

    //     A1dX    = abs(A1destX - A1X);
    //     A1sX      = (A1X < A1destX) ? 1 : -1;
		sec
		lda _A1X
		sbc _A1destX

		sta _mDeltaX1

		bmi fill8_01_negativ_02
		sta _A1dX
		lda #$FF
		sta _A1sX
    	lda #OPCODE_DEC_ZERO
    	sta _patch_A1stepY_incdec_A1X
		jmp fill8_computeDy_01
	fill8_01_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A1dX
		lda #$01
		sta _A1sX
    	lda #OPCODE_INC_ZERO
    	sta _patch_A1stepY_incdec_A1X


fill8_computeDy_01:		
    //     A1dY    = -abs(A1destY - A1Y);
    //     A1sY      = (A1Y < A1destY) ? 1 : -1;
		sec
		lda _A1Y
		sbc _A1destY
		sta _mDeltaY1
.(
		bmi fill8_02_negativ_02
		eor #$FF
		sec
		adc #0
		sta _A1dY
		lda #$FF 
		sta _A1sY
    	; lda #OPCODE_DEC_ZERO
    	; sta patch_A1StepY_incdec_A1Y
		jmp fill8_computeErr_01
	fill8_02_negativ_02:
		sta _A1dY
    	lda #$01
    	sta _A1sY
    	; lda #OPCODE_INC_ZERO
    	; sta patch_A1StepY_incdec_A1Y
.)

fill8_computeErr_01:
    //     A1err   = A1dX + A1dY;
		clc
		lda _A1dX
		adc _A1dY
		sta _A1err

    //     if ((A1err > 64) || (A1err < -63))
    //         return;

	    sec
		sbc #$40
		bvc *+4
		eor #$80
		bmi fill8_goon_01
		jmp fill8_done
fill8_goon_01:
		lda _A1err
		sec
		sbc #$C0
		bvc *+4
		eor #$80
		bpl fill8_goon_02
		jmp fill8_done
fill8_goon_02:
    //     A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;
		lda #0
		sta _A1arrived
		
		lda _A1X
		cmp _A1destX
		bne fill8_computeA2
		
		lda _A1Y
		cmp _A1destY
		bne fill8_computeA2
	
		lda #1
		sta _A1arrived

fill8_computeA2:
    //     A2destX = pArr2X;
	lda _pArr2X : sta _A2destX
    //     A2destY = pArr2Y;
	lda _pArr2Y : sta _A2destY
    //     A2dX    = abs(A2destX - A2X);
    //     A2sX      = (A2X < A2destX) ? 1 : -1;
		sec
		lda _A2X
		sbc _A2destX

		sta _mDeltaX2

		bmi fill8_03_negativ_02
		sta _A2dX
		lda #$FF
		sta _A2sX
		lda #OPCODE_DEC_ZERO
		sta patch_A2stepY_incdec_A2X
		jmp fill8_computeDy_02
	fill8_03_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A2dX
		lda #$01
		sta _A2sX
		lda #OPCODE_INC_ZERO
		sta patch_A2stepY_incdec_A2X

fill8_computeDy_02:
    //     A2dY    = -abs(A2destY - A2Y);
    //     A2sY      = (A2Y < A2destY) ? 1 : -1;
		sec
		lda _A2Y
		sbc _A2destY
		sta _mDeltaY2
.(
		bmi fill8_04_negativ_02
		eor #$FF
		sec
		adc #0
		sta _A2dY
		lda #$FF 
		sta _A2sY
		jmp fill8_computeErr_02
	fill8_04_negativ_02:
		sta _A2dY
    	lda #$01
    	sta _A2sY
.)

fill8_computeErr_02:

    //     A2err   = A2dX + A2dY;
		clc
		lda _A2dX
		adc _A2dY
		sta _A2err

    //     if ((A2err > 64) || (A2err < -63))
    //         return;
.(
	    sec
		sbc #$40
		bvc *+4
		eor #$80
		bmi fill8_tmp02
		jmp fill8_done
fill8_tmp02:
		lda _A2err
		sec
		sbc #$C0
		bvc *+4
		eor #$80
		bpl fill8_tmp03
		jmp fill8_done
fill8_tmp03:
.)
    //     A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;
		lda #0
		sta _A2arrived
		
		lda _A2X
		cmp _A2destX
		bne fill8_brestep1
		
		lda _A2Y
		cmp _A2destY
		bne fill8_brestep1
	
		lda #1
		sta _A2arrived

fill8_brestep1:
   //     isA1Right1();
		ldy #0 : jsr _isA1Right1
    //     bresStepType1();
		ldy #0 : jsr _bresStepType1

    //     A1X       = pArr1X;
	lda _pArr1X: sta _A1X
    //     A1Y       = pArr1Y;
	lda _pArr1Y: sta _A1Y
    //     A1destX   = pArr2X;
	lda _pArr2X : sta _A1destX
    //     A1destY   = pArr2Y;
	lda _pArr2Y : sta _A1destY

    //     A1dX    = abs(A1destX - A1X);
    //     A1sX      = (A1X < A1destX) ? 1 : -1;
		sec
		lda _A1X
		sbc _A1destX
.(
		bmi fill8_05_negativ_02
		sta _A1dX
		lda #$FF
		sta _A1sX
    	lda #OPCODE_DEC_ZERO
    	sta _patch_A1stepY_incdec_A1X
		jmp fill8_computeDy_03
	fill8_05_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A1dX
		lda #$01
		sta _A1sX
    	lda #OPCODE_INC_ZERO
    	sta _patch_A1stepY_incdec_A1X
.)

fill8_computeDy_03:		

    //     A1dY      = -abs(A1destY - A1Y);
    //     A1sY      = (A1Y < A1destY) ? 1 : -1;
		sec
		lda _A1Y
		sbc _A1destY
.(
		bmi fill8_06_negativ_02
		eor #$FF
		sec
		adc #0
		sta _A1dY
		lda #$FF 
		sta _A1sY
    	; lda #OPCODE_DEC_ZERO
    	; sta patch_A1StepY_incdec_A1Y
		jmp fill8_computeErr_03
	fill8_06_negativ_02:
		sta _A1dY
    	lda #$01
    	sta _A1sY
    	; lda #OPCODE_INC_ZERO
    	; sta patch_A1StepY_incdec_A1Y
.)

fill8_computeErr_03:

    //     A1err     = A1dX + A1dY;
		clc
		lda _A1dX
		adc _A1dY
		sta _A1err

    //     A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;
		lda #0
		sta _A1arrived
		
		lda _A1X
		cmp _A1destX
		bne fill8_brestep2
		
		lda _A1Y
		cmp _A1destY
		bne fill8_brestep2
	
		lda #1
		sta _A1arrived

fill8_brestep2:
    //     bresStepType2();
		ldy #0 : jsr _bresStepType2

		jmp fill8_done

fill8_DepYEqualsArr1Y:
    // } else {
    //     // a1 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
    //     A1X     = pDepX;
		lda _pDepX: sta _A1X
    //     A1Y     = pDepY;
		lda _pDepY: sta _A1Y
    //     A1destX = pArr2X;
		lda _pArr2X : sta _A1destX
    //     A1destY = pArr2Y;
		lda _pArr2Y : sta _A1destY

    //     A1dX    = abs(A1destX - A1X);
    //     A1sX = (A1X < A1destX) ? 1 : -1;
		sec
		lda _A1X
		sbc _A1destX
.(
		bmi fill8_07_negativ_02
		sta _A1dX
		lda #$FF
		sta _A1sX
    	lda #OPCODE_DEC_ZERO
    	sta _patch_A1stepY_incdec_A1X
		jmp fill8_computeDy_04
	fill8_07_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A1dX
		lda #$01
		sta _A1sX
    	lda #OPCODE_INC_ZERO
    	sta _patch_A1stepY_incdec_A1X
.)
fill8_computeDy_04:
    //     A1dY    = -abs(A1destY - A1Y);
    //     A1sY = (A1Y < A1destY) ? 1 : -1;
		sec
		lda _A1Y
		sbc _A1destY
.(
		bmi fill8_08_negativ_02
		eor #$FF
		sec
		adc #0
		sta _A1dY
		lda #$FF 
		sta _A1sY
    	; lda #OPCODE_DEC_ZERO
    	; sta patch_A1StepY_incdec_A1Y
		jmp fill8_computeErr_05
	fill8_08_negativ_02:
		sta _A1dY
    	lda #$01
    	sta _A1sY
    	; lda #OPCODE_INC_ZERO
    	; sta patch_A1StepY_incdec_A1Y
.)

fill8_computeErr_05:

    //     A1err   = A1dX + A1dY;
		clc
		lda _A1dX
		adc _A1dY
		sta _A1err

    //     if ((A1err > 64) || (A1err < -63))
    //         return;
	    sec
		sbc #$40
		bvc *+4
		eor #$80
		bmi fill8_goon_05
		jmp fill8_done
fill8_goon_05:
		lda _A1err
		sec
		sbc #$C0
		bvc *+4
		eor #$80
		bpl fill8_goon_06
		jmp fill8_done
fill8_goon_06

    //     A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;
		lda #0
		sta _A1arrived
		
		lda _A1X
		cmp _A1destX
		bne fill8_computeA2_ter
		
		lda _A1Y
		cmp _A1destY
		bne fill8_computeA2_ter
	
		lda #1
		sta _A1arrived

fill8_computeA2_ter:
    //     A2X     = pArr1X;
		lda _pArr1X : sta _A2X
    //     A2Y     = pArr1Y;
		lda _pArr1Y : sta _A2Y
    //     A2destX = pArr2X;
		lda _pArr2X : sta _A2destX
    //     A2destY = pArr2Y;
		lda _pArr2Y : sta _A2destY

    //     A2dX    = abs(A2destX - A2X);
    //     A2sX      = (A2X < A2destX) ? 1 : -1;
		sec
		lda _A2X
		sbc _A2destX

		bmi fill8_09_negativ_02
		sta _A2dX
		lda #$FF
		sta _A2sX
		lda #OPCODE_DEC_ZERO
		sta patch_A2stepY_incdec_A2X
		jmp fill8_computeDy_08
	fill8_09_negativ_02:
		eor #$FF
		sec
		adc #0
		sta _A2dX
		lda #$01
		sta _A2sX
		lda #OPCODE_INC_ZERO
		sta patch_A2stepY_incdec_A2X

fill8_computeDy_08:
    //     A2dY    = -abs(A2destY - A2Y);
    //     A2sY      = (A2Y < A2destY) ? 1 : -1;
		sec
		lda _A2Y
		sbc _A2destY
.(
		bmi fill8_10_negativ_02
		eor #$FF
		sec
		adc #0
		sta _A2dY
		lda #$FF 
		sta _A2sY
		jmp fill8_computeErr_09
	fill8_10_negativ_02:
		sta _A2dY
    	lda #$01
    	sta _A2sY
.)

fill8_computeErr_09:
    //     A2err   = A2dX + A2dY;
		clc
		lda _A2dX
		adc _A2dY
		sta _A2err

    //     if ((A2err > 64) || (A2err < -63))
    //         return;
	    sec
		sbc #$40
		bvc *+4
		eor #$80
		bmi fill8_tmp07
		jmp fill8_done
fill8_tmp07:
		lda _A2err
		sec
		sbc #$C0
		bvc *+4
		eor #$80
		bpl fill8_tmp08
		jmp fill8_done
fill8_tmp08:

    //     A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;
		lda #0
		sta _A2arrived
		
		lda _A2X
		cmp _A2destX
		bne fill8_brestep3
		
		lda _A2Y
		cmp _A2destY
		bne fill8_brestep3
	
		lda #1
		sta _A2arrived

fill8_brestep3:
   //     isA1Right3();
		ldy #0 : jsr _isA1Right3
    //     bresStepType3() ;
		ldy #0 : jsr _bresStepType3
    // }

fill8_done:
	// restore context
	;pla: sta reg1: pla: sta reg0
	;pla


	rts
#endif USE_ASM_FILL8




#ifdef USE_ASM_BRESTYPE1
;; void bresStepType1()
_bresStepType1:
.(
	ldy #0 : jsr _reachScreen :
	ldy #0 : jsr _hzfill :
	jmp bresStepType1_Lbresfill133 :
bresStepType1_Lbresfill132
	ldy #0 : jsr _A1stepY :
	ldy #0 : jsr _A2stepY :
	ldy #0 : jsr _hzfill :
bresStepType1_Lbresfill133
	lda _A1arrived : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp bresStepType1_Lbresfill135 :
	lda _A1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(1) : cmp tmp0 : lda #>(1) : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp bresStepType1_Lbresfill132 :skip : .) : : :
bresStepType1_Lbresfill135
.)
	rts
#endif // USE_ASM_BRESTYPE1

#ifdef USE_ASM_BRESTYPE2
;; void bresStepType2()
_bresStepType2:
.(
	jmp bresStepType2_Lbresfill137 :
bresStepType2_Lbresfill136
	ldy #0 : jsr _A1stepY :
	ldy #0 : jsr _A2stepY :
	ldy #0 : jsr _hzfill :
bresStepType2_Lbresfill137
	lda _A1arrived : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp bresStepType2_Lbresfill140 :
	lda _A2arrived : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp bresStepType2_Lbresfill140 :
	lda _A1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(1) : cmp tmp0 : lda #>(1) : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp bresStepType2_Lbresfill136 :skip : .) : : :
bresStepType2_Lbresfill140
.)
	rts
#endif // USE_ASM_BRESTYPE2

#ifdef USE_ASM_BRESTYPE3
;; void bresStepType3()
_bresStepType3:
.(
	ldy #0 : jsr _reachScreen :
	ldy #0 : jsr _hzfill :
	jmp bresStepType3_Lbresfill142 :
bresStepType3_Lbresfill141
	ldy #0 : jsr _A1stepY :
	ldy #0 : jsr _A2stepY :
	ldy #0 : jsr _hzfill :
bresStepType3_Lbresfill142
	lda _A1arrived : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp bresStepType3_Lbresfill145 :
	lda _A2arrived : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda tmp0 : ora tmp0+1 : beq *+5 : jmp bresStepType3_Lbresfill145 :
	lda _A1Y : sta tmp0 :
	lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	lda #<(1) : cmp tmp0 : lda #>(1) : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp bresStepType3_Lbresfill141 :skip : .) : : :
bresStepType3_Lbresfill145
.)
	rts
#endif // USE_ASM_BRESTYPE3


#ifdef USE_ASM_REACHSCREEN
;; void reachScreen()
_reachScreen:
.(
	jmp reachScreen_Lbresfill130 :
reachScreen_Lbresfill129
	ldy #0 : jsr _A1stepY :
	ldy #0 : jsr _A2stepY :
reachScreen_Lbresfill130
    lda _A1arrived
    bne reachScreen_done
    lda _A1Y : sec:
#ifdef USE_COLOR
    sbc #SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR
#else
    sbc #SCREEN_HEIGHT
#endif
    bvc *+4 : eor #$80 

    bmi *+5 : jmp reachScreen_Lbresfill129
	; lda _A1Y : sta tmp0 :
	; lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	; lda tmp0 : cmp #<(22) : lda tmp0+1 : sbc #>(22) : bvc *+4 : eor #$80 : bmi *+5 : jmp reachScreen_Lbresfill129 

// BUGFIX !!! 
reachScreen_done
.)
	rts
#endif // USE_ASM_REACHSCREEN

#ifdef USE_ASM_FILLFACE
;; void fillFace()
_fillFace:
.(
	ldy #0 : jsr _angle2screen :
	ldy #0 : jsr _fill8 :
.)
	rts
#endif // USE_ASM_FILLFACE



.zero
octant .dsb 1          ;

/*
; Used by atan2

FC .byt 00    			;
FD .byt 00    			;
FE .byt 00    			;

*/

#ifdef SAVE_ZERO_PAGE
.text
#endif

_tx .dsb 1
_ty .dsb 1
_res .dsb 1

#ifndef SAVE_ZERO_PAGE
.text
#endif

/*
_atan2_8
.(
//  INIT
    lda #$00
    sta _res
    ldy #0       ;NegIt = False

//  IF TanX = 0 THEN
    lda _tx
    bne TanXNotNull_01
//      IF TanY = 0 THEN
        lda _ty
        bne TanYNotNull_02
//          RETURN 0
            jmp atdone
TanYNotNull_02:
//      ELSE IF TanY > 0 THEN
        bmi TanYNegative_01
//          RETURN PI/2
            lda A_PI_OVER_2
            sta _res
            jmp atdone
//      ELSE
TanYNegative_01:
//          RETURN 3*PI/2
            lda A_3_PI_OVER_2
            sta _res
            jmp atdone
//      END
//  ELSE (TanX != 0)
TanXNotNull_01:
//      IF TanX > 0 THEN
        bmi TanXNegative_01
//          TmpX = TanX
            sta FD
//          IF TanY = 0 THEN
            lda _ty
            bne TanYNotNull_03
//              RETURN 0
                jmp atdone
TanYNotNull_03:
//          ELSE IF TanY > 0 THEN
            bmi TanYNegative_02
//              TmpY = TanY
                sta FC
//              IF TmpY = TmpX THEN
                cmp FD
                bne TanxDiffTanY_01
//                  RETURN PI/4
                    lda A_PI_OVER_4
                    sta _res
                    jmp atdone
//              ELSE IF TmpX < TmpY Then
TanxDiffTanY_01:
                bcc TanXOverTanY_01
//                  SWAP (TmpY, TmpX)
                    ldx FD ; A contains FC
                    sta FD
                    stx FC
//                  Octant = 2 ; PI / 2 ; Angle is in [PI/4 .. PI/2]
                    lda A_PI_OVER_2
                    sta octant
//                  NegIt = 1
                    ldy #1
                    jmp compratio
//              ELSE (TmpX > TmpY)
TanXOverTanY_01:
//                  Octant = 1 ; 0 ; Angle is in [0 .. PI/4]
                    lda A_ZERO
                    sta octant
                    jmp compratio
//              END IF
//
//          ELSE (TanY < 0)
TanYNegative_02:
//              TmpY = -TanY
                eor #$FF
                sec
                adc #$00
                sta FC
//              IF TmpY = TmpX THEN
                cmp FD
                bne TanxDiffTanY_02
//                  RETURN 7*PI/4
                    lda A_7_PI_OVER_4
                    sta _res
                    jmp atdone
TanxDiffTanY_02:
//              ELSE IF TmpX < TmpY Then
                bcc TanXOverTanY_02
//                  SWAP (TmpY, TmpX)
                    ldx FD ; A already contain tanY
                    sta FD
                    stx FC
//                  Octant = 7; 3*PI / 2  Angle is in [3PI/2 .. 7PI/4]
                    lda A_3_PI_OVER_2
                    sta octant
                    jmp compratio
//              ELSE (TmpX > TmpY)
TanXOverTanY_02:
//                  Octant = 8; 2*PI Angle is in [7PI/4 .. 2PI]
                    lda A_ZERO
                    sta octant
//                  NegIt = 1
                    ldy #1
                    jmp compratio
//             END IF
//
//          END IF
//      ELSE (TanX < 0)
TanXNegative_01:
//          TmpX = -TanX
            eor #$FF
            sec
            adc #$00
            sta FD
//          IF TanY = 0 THEN
            lda _ty
            bne TanYNotNull_01
//              RETURN PI
                lda A_PI
                sta _res
                jmp atdone
TanYNotNull_01:
//          ELSE IF TanY > 0 THEN
            bmi TanYNegative_03
//              TmpY = TanY
                sta FC
//              IF TmpY = TmpX THEN
                cmp FD
                bne TanxDiffTanY_03
//                  RETURN 3*PI/4
                    lda A_3_PI_OVER_4
                    sta _res
                    jmp atdone
TanxDiffTanY_03:
//              ELSE IF TmpX < TmpY Then
                bcc TanXOverTanY_03
//                  SWAP (TmpY, TmpX)
                    ldx FD ; A already contains TanY
                    sta FD
                    stx FC
//                  Octant = 3 ;  PI / 2 Angle is in [PI/2 .. 3PI/4]
                    lda A_PI_OVER_2
                    sta octant
                    jmp compratio
//              ELSE (TmpX > TmpY)
TanXOverTanY_03:
//                  NegIt = 1
                    ldy #1
//                  Octant = 4 ; PI Angle is in [3PI/4 .. PI]
                    lda A_PI
                    sta octant
                    jmp compratio
//              END IF
//
//          ELSE (TanY < 0)
TanYNegative_03:
//              TmpY = -TanY
                eor #$FF
                sec
                adc #$00
                sta FC
//              IF TmpY = TmpX THEN
                cmp FD
                bne TanxDiffTanY_04
//                  RETURN 5*PI/4
                    lda A_5_PI_OVER_4
                    sta _res
                    jmp atdone
TanxDiffTanY_04:
//              ELSE IF TmpX < TmpY Then
                bcc TanXOverTanY_04
//                  SWAP (TmpY, TmpX)
                    ldx FD ; A laready contains TanY
                    sta FD
                    stx FC
//                  NegIt = 1
                    ldy #1
//                  Octant = 6 ; 3_PI_OVER_2 #$C0 Angle is in [5PI/4 .. 3PI/2]
                    lda A_3_PI_OVER_2
                    sta octant
                    jmp compratio
//              ELSE (TmpX > TmpY)
TanXOverTanY_04:
//                  Octant = 5 ; PI #$80 Angle is in [PI .. 5PI/4]
                    lda A_PI
                    sta octant
                    jmp compratio
//              END IF
//
//          END IF
//      END IF
//  END

    ;lda _tx
    ;sta FD

    ;lda _ty
    ;sta FC

compratio:
//  Ratio = TmpY / TmpX

// divide FC (tanY) by FD( tanX) and store res in FE
;6 bits division
    lda FC
    asl
    ldx #$06
loop2
    cmp FD
    bcc *+4
    sbc FD
    rol FE
    asl
    dex
    bne loop2


//  Angle =

    lda FE
    and #$3F

    tax
    ;sta _Index

//  IF NegIt THEN
    tya
    beq DontNegIt
//      Angle = -ATAN [Ratio]
        lda atan_table, x
        eor #$FF
        sec
        adc #$00
        jmp SumPart
DontNegIt:
        lda atan_table, x
//
SumPart:
//  RES = Angle + Octant
    clc
    adc octant

    sta _res


atdone
.)
	RTS
*/



/*

; By Jean-Baptiste PERIN (jbperin)
; calculates the atan2 of two 16-bits value coordinates [TanX, Tany]
; provides 8-bits result in Arctan8
; The result is always in the range [0 .. 2^8[
; corresponding to angle in the range [0 .. 2*PI[
;
; Destroys all registers


_TanX .dsb 2
_TanY .dsb 2

_Arctan8 .dsb 1

_TmpX .dsb 2
_TmpY .dsb 2

_Octant .dsb 1
_NegIt .dsb 1
_Ratio .dsb 1

_atan2:
.(
// INIT
	lda #$00
	sta _NegIt
	sta _Octant

//  IF TanX = 0 THEN
    lda     _TanX
    bne     TanXNotNull1
    lda     _TanX+1
    bne     TanXNotNull1
//      IF TanY = 0 THEN
        lda     _TanY+1
        bmi     TanYNegative1
        bne     TanYNotNull1
        lda     _TanY
        bne     TanYNotNull1
//          RETURN 0
            lda #$00 // TODO : Error Case
            sta _Arctan8
            jmp done
TanYNotNull1:
//    ELSE IF TanY > 0 THEN
//      RETURN PI/2
            lda #$40
            sta _Arctan8
            jmp done
//    ELSE
TanYNegative1:
//      RETURN 3*PI/2
            lda #$C0
            sta _Arctan8
            jmp done
//    END
//  ELSE
TanXNotNull1:
//    IF TanY = 0 THEN
        lda     _TanY
        bne     TanYNotNull2
        lda     _TanY+1
        bne     TanYNotNull2
//      IF TanX > 0 THEN
            lda     _TanX+1
            bmi     TanXNegative2
//        RETURN 0
                lda #$00
                sta _Arctan8
                jmp done
//      ELSE
TanXNegative2:
//        RETURN PI
                lda #$80
                sta _Arctan8
                jmp done
//      END
//    ELSE
TanYNotNull2:
//      REM DeltaX DeltaY both different of 0
//      IF TanX > 0 THEN
        lda     _TanX+1
        bmi     TanXNegative3
//        IF TanY > 0 THEN
			lda     _TanY+1
			bmi     TanYNegative3
//          IF TanX = TanY THEN
                ldy _TanX
                lda _TanX+1
                cpy _TanY  ; compare low bytes
                bne NotEqual1
                cmp _TanY+1  ; compare high bytes
                bne NotEqual1
//              RETURN PI/4
                    lda #$20
                    sta _Arctan8
                    jmp done
//          ELSE IF TanX > TanY THEN
NotEqual1:
				sec
				lda 	_TanY
				sbc		_TanX
				lda		_TanY+1
				sbc		_TanX+1
				bcs		TYoverTX
//            REM Octant1 Angle is in [0 .. PI/4]
//            RETURN ATAN (TanY / TanX)
				;clv
				;bvc EndIf3
				jmp octant1
//          ELSE
TYoverTX:
//            REM Octant2 Angle is in [PI/4 .. PI/2]
//            RETURN -ATAN (TanX / TanY) + PI / 2
				;clv
				;bvc EndIf3
				;clv
				jmp octant2
//          END IF
EndIf3:
			clv
			bvc EndIf4
//        ELSE
TanYNegative3:
//          TmpY = -TanY
			lda	_TanY     ; get number low byte
			ldx	_TanY+1     ; get number high  byte

			eor	#$FF        ; invert
			sec	            ; +1
			adc	#$00        ; and add it
			sta _TmpY

			txa				; A <- HiPart (Number)
			eor	#$FF        ; invert
			adc #$00		; Propagate carry
			sta _TmpY+1

//          IF TanX = TmpY THEN
                ldy _TanX
                lda _TanX+1
                cpy _TmpY  ; compare low bytes
                bne NotEqual2
                cmp _TmpY+1  ; compare high bytes
                bne NotEqual2
//              RETURN -PI/4
                    lda #$E0
                    sta _Arctan8
                    jmp done
//          ELSE IF TanX > TmpY THEN
NotEqual2:
			sec
			lda 	_TmpY
			sbc		_TanX
			lda		_TmpY+1
			sbc		_TanX+1
			bcs		AbsTYoverTX
//            REM Octant8 Angle is in [7PI/4 .. 2PI]
//            RETURN -ATAN (TmpY / TanX) + 2*PI
				;clv
				;bvc EndIf4
				;clv
				jmp octant8

//          ELSE
AbsTYoverTX:
//            REM Octant7 Angle is in [3PI/2 .. 7PI/4]
//            RETURN ATAN (TanX / TmpY) + 3*PI / 2
				;clv
				jmp octant7
//          END IF
//        END IF
EndIf4:
		;clv
		;bvc EndIf5
        jmp EndIf5
//      ELSE
TanXNegative3:
//        TmpX = - TanX
			lda	_TanX     ; get number low byte
			ldx	_TanX+1     ; get number high  byte

			eor	#$FF        ; invert
			sec	            ; +1
			adc	#$00        ; and add it
			sta _TmpX

			txa				; A <- HiPart (Number)
			eor	#$FF        ; invert
			adc #$00		; Propagate carry
			sta _TmpX+1
//        IF TanY > 0 THEN
			lda     _TanY+1
			bmi     TanYNegative6
//          IF TmpX = TanY THEN
                ldy _TmpX
                lda _TmpX+1
                cpy _TanY  ; compare low bytes
                bne NotEqual3
                cmp _TanY+1  ; compare high bytes
                bne NotEqual3
//              RETURN 3PI/4
                    lda #$60
                    sta _Arctan8
                    jmp done
//          ELSE IF TmpX > TanY THEN
NotEqual3:
				sec
				lda 	_TanY
				sbc		_TmpX
				lda		_TanY+1
				sbc		_TmpX+1
				bcs		TYoverAbsTX
//            REM Octant4 Angle is in [3PI/4 .. PI]
//            RETURN -ATAN (TanY / TmpX) + PI
					;clv
					;bvc EndIf7
					;clv
					jmp octant4
//          ELSE
TYoverAbsTX:
//            REM Octant3 Angle is in [PI/2 .. 3PI/4]
//            RETURN ATAN (TmpX / TanY) + PI / 2
					;clv
					jmp octant3
//          END IF
EndIf7:
			clv
			bvc EndIf5

//        ELSE
TanYNegative6:
//          TmpY = - TanY
			lda	_TanY     ; get number low byte
			ldx	_TanY+1     ; get number high  byte

			eor	#$FF        ; invert
			sec	            ; +1
			adc	#$00        ; and add it
			sta _TmpY

			txa				; A <- HiPart (Number)
			eor	#$FF        ; invert
			adc #$00		; Propagate carry
			sta _TmpY+1
//          IF TmpX = TmpY THEN
            ldy _TmpX
            lda _TmpX+1
            cpy _TmpY  ; compare low bytes
            bne NotEqual4
            cmp _TmpY+1  ; compare high bytes
            bne NotEqual4
//            RETURN 5*PI/4
                lda #$A0
                sta _Arctan8
                jmp done
//          ELSE IF TmpX > TmpY THEN
NotEqual4:
			sec
			lda 	_TmpY
			sbc		_TmpX
			lda		_TmpY+1
			sbc		_TmpX+1
			bcs		AbsTYoverAbsTX
//            REM Octant5 Angle is in [PI .. 5PI/4]
//            RETURN ATAN (TmpY / TmpX) + PI
				;clv
				;bvc EndIf5
				;clv
				jmp octant5

//          ELSE
AbsTYoverAbsTX:
//            REM Octant6 Angle is in [5PI/4 .. 3PI/2]
//            RETURN -ATAN (TmpX / TmpY) + 3*PI / 2
				;clv
				jmp octant6
//          END IF
//        END
//      END
EndIf5:
//    END
//  END


; |  DIVISOR  |    D I V I D E N D    |SCRAT|      |
; |           |  hi cell     lo cell  |CHPAD| CARRY|
; |  N    N+1 | N+2   N+3 | N+4   N+5 | N+6   N+7  |


octant1:
// REM Octant1 Angle is in [0 .. PI/4]
// RETURN ATAN (TanY / TanX)
	lda _TanY
	sta _N+3
	lda _TanY+1
	sta _N+2

	lda _TanX
	sta _N+1
	lda _TanX+1
	sta _N+0

	lda # $00
	sta _N+4
	sta _N+5

	;clv
	;bvc computeratio
	jmp computeratio

octant2:
// REM Octant2 Angle is in [PI/4 .. PI/2]
// RETURN -ATAN (TanX / TanY) + PI / 2
	lda _TanX
	sta _N+3
	lda _TanX+1
	sta _N+2

	lda _TanY
	sta _N+1
	lda _TanY+1
	sta _N+0



	lda # $40	; PI / 2
	sta _Octant
	lda # $01
	sta _NegIt
	;clv
	;bvc computeratio
	jmp computeratio

octant3:
// REM Octant3 Angle is in [PI/2 .. 3PI/4]
// RETURN ATAN (TmpX / TanY) + PI / 2
	lda _TmpX
	sta _N+3
	lda _TmpX+1
	sta _N+2

	lda _TanY
	sta _N+1
	lda _TanY+1
	sta _N+0



	lda # $40	; PI / 2
	sta _Octant
	;clv
	;bvc computeratio
	jmp computeratio

octant4:
// REM Octant4 Angle is in [3PI/4 .. PI]
// RETURN -ATAN (TanY / TmpX) + PI
	lda _TanY
	sta _N+3
	lda _TanY+1
	sta _N+2

	lda _TmpX
	sta _N+1
	lda _TmpX+1
	sta _N+0



	lda # $80	; PI
	sta _Octant
	lda # $01
	sta _NegIt
	;clv
	;bvc computeratio
	jmp computeratio

octant5:
// REM Octant5 Angle is in [PI .. 5PI/4]
// RETURN ATAN (TmpY / TmpX) + PI
	lda _TmpY
	sta _N+3
	lda _TmpY+1
	sta _N+2

	lda _TmpX
	sta _N+1
	lda _TmpX+1
	sta _N+0



	lda # $80	; PI
	sta _Octant
	clv
	bvc computeratio

octant6:
// REM Octant6 Angle is in [5PI/4 .. 3PI/2]
// RETURN -ATAN (TmpX / TmpY) + 3*PI / 2
	lda _TmpX
	sta _N+3
	lda _TmpX+1
	sta _N+2

	lda _TmpY
	sta _N+1
	lda _TmpY+1
	sta _N+0


	lda # $C0	; 3*PI/2
	sta _Octant
	lda # $01
	sta _NegIt
	clv
	bvc computeratio

octant7:
// REM Octant7 Angle is in [3PI/2 .. 7PI/4]
// RETURN ATAN (TanX / TmpY) + 3*PI / 2
	lda _TanX
	sta _N+3
	lda _TanX+1
	sta _N+2

	lda _TmpY
	sta _N+1
	lda _TmpY+1
	sta _N+0


	lda # $C0	; 3*PI/2
	sta _Octant
	clv
	bvc computeratio
octant8:
// REM Octant8 Angle is in [7PI/4 .. 2PI]
// RETURN -ATAN (TmpY / TanX) + 2*PI
	lda _TmpY
	sta _N+3
	lda _TmpY+1
	sta _N+2

	lda _TanX
	sta _N+1
	lda _TanX+1
	sta _N+0

	lda # $00	; 2*PI
	sta _Octant

	lda # $01
	sta _NegIt

computeratio:
	jsr _div32by16
	lda _N+5
    sta _Ratio
	lsr 		; keep only 6 higher bits of ratio
	lsr
	and #$3F
	sta _ArcTang
	jsr _atan
	ldx _Angle
	lda _NegIt
	beq dontNegIt
	txa
	sec
	eor #$FF
	adc #$00
	//and #$1F ; keep only 5 lower bits
	tax
dontNegIt:
	txa
	clc
	adc _Octant ; add octant part
	sta _Arctan8
done:
.)
    RTS
*/



/*
; By Jean-Baptiste PERIN (jbperin)
; calculate the atan of a Q0.6 value stored in
; six least significant bits of _ArcTang
; The result is always in the range 0 to 2^5-1 and is held in
; _Angle
;
; Destroys all registers

_ArcTang .dsb 1
_Angle .dsb 1
_Index .dsb 1

_atan:
.(
    lda _ArcTang
    and #$3F        ; keep only 6 bits
    tax
    sta _Index
    lda atan_table, x
    sta _Angle
.)
	RTS

atan_table:
    .byt 0
    .byt 1
    .byt 1
    .byt 2
    .byt 3
    .byt 3
    .byt 4
    .byt 4
    .byt 5
    .byt 6
    .byt 7 ; was 6
    .byt 7
    .byt 8
    .byt 8
    .byt 9
    .byt 9
    .byt 10
    .byt 11
    .byt 11
    .byt 12
    .byt 12
    .byt 13
    .byt 13
    .byt 14
    .byt 15
    .byt 16 ; was 15
    .byt 16
    .byt 16
    .byt 17
    .byt 17
    .byt 18
    .byt 18
    .byt 19
    .byt 19
    .byt 20
    .byt 20
    .byt 21
    .byt 21
    .byt 22
    .byt 22
    .byt 23
    .byt 23
    .byt 24
    .byt 24
    .byt 25
    .byt 25
    .byt 25
    .byt 26
    .byt 26
    .byt 27
    .byt 27
    .byt 27
    .byt 28
    .byt 28
    .byt 29
    .byt 29
    .byt 29
    .byt 30
    .byt 30
    .byt 30
    .byt 31
    .byt 31
    .byt 31
    .byt 32


*/

;https://codebase64.org/doku.php?id=base:8bit_atan2_8-bit_angle
_atan2_8:
.(

    lda _tx
    clc
    bpl Xpositiv
    eor #$ff
    sec
Xpositiv:
    tax
    rol octant

    lda _ty
    clc
    bpl Ypositiv
    eor #$ff
    sec
Ypositiv:
    tay
    rol octant

    sec
    lda _log2_tab,x
    sbc _log2_tab,y
    bcc *+4
    eor #$ff
    tax

    lda octant
    rol
    and #$07
    tay

    lda atan_tab, x
    eor octant_adjust,y
    sta _res
.)
    rts


octant_adjust	.byt %00111111		;; x+,y+,|x|>|y|
		.byt %00000000		;; x+,y+,|x|<|y|
		.byt %11000000		;; x+,y-,|x|>|y|
		.byt %11111111		;; x+,y-,|x|<|y|
		.byt %01000000		;; x-,y+,|x|>|y|
		.byt %01111111		;; x-,y+,|x|<|y|
		.byt %10111111		;; x-,y-,|x|>|y|
		.byt %10000000		;; x-,y-,|x|<|y|


		;;;;;;;; atan(2^(x/32))*128/pi ;;;;;;;;

atan_tab	.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$01,$01,$01
		.byt $01,$01,$01,$01,$01,$01,$01,$01
		.byt $01,$01,$01,$01,$01,$01,$01,$01
		.byt $01,$01,$01,$01,$01,$01,$01,$01
		.byt $01,$01,$01,$01,$01,$02,$02,$02
		.byt $02,$02,$02,$02,$02,$02,$02,$02
		.byt $02,$02,$02,$02,$02,$02,$02,$02
		.byt $03,$03,$03,$03,$03,$03,$03,$03
		.byt $03,$03,$03,$03,$03,$04,$04,$04
		.byt $04,$04,$04,$04,$04,$04,$04,$04
		.byt $05,$05,$05,$05,$05,$05,$05,$05
		.byt $06,$06,$06,$06,$06,$06,$06,$06
		.byt $07,$07,$07,$07,$07,$07,$08,$08
		.byt $08,$08,$08,$08,$09,$09,$09,$09
		.byt $09,$0a,$0a,$0a,$0a,$0b,$0b,$0b
		.byt $0b,$0c,$0c,$0c,$0c,$0d,$0d,$0d
		.byt $0d,$0e,$0e,$0e,$0e,$0f,$0f,$0f
		.byt $10,$10,$10,$11,$11,$11,$12,$12
		.byt $12,$13,$13,$13,$14,$14,$15,$15
		.byt $15,$16,$16,$17,$17,$17,$18,$18
		.byt $19,$19,$19,$1a,$1a,$1b,$1b,$1c
		.byt $1c,$1c,$1d,$1d,$1e,$1e,$1f,$1f


		;;;;;;;; log2(x)*32 ;;;;;;;;

_log2_tab	.byt $00,$00,$20,$32,$40,$4a,$52,$59
		.byt $60,$65,$6a,$6e,$72,$76,$79,$7d
		.byt $80,$82,$85,$87,$8a,$8c,$8e,$90
		.byt $92,$94,$96,$98,$99,$9b,$9d,$9e
		.byt $a0,$a1,$a2,$a4,$a5,$a6,$a7,$a9
		.byt $aa,$ab,$ac,$ad,$ae,$af,$b0,$b1
		.byt $b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9
		.byt $b9,$ba,$bb,$bc,$bd,$bd,$be,$bf
		.byt $c0,$c0,$c1,$c2,$c2,$c3,$c4,$c4
		.byt $c5,$c6,$c6,$c7,$c7,$c8,$c9,$c9
		.byt $ca,$ca,$cb,$cc,$cc,$cd,$cd,$ce
		.byt $ce,$cf,$cf,$d0,$d0,$d1,$d1,$d2
		.byt $d2,$d3,$d3,$d4,$d4,$d5,$d5,$d5
		.byt $d6,$d6,$d7,$d7,$d8,$d8,$d9,$d9
		.byt $d9,$da,$da,$db,$db,$db,$dc,$dc
		.byt $dd,$dd,$dd,$de,$de,$de,$df,$df
		.byt $df,$e0,$e0,$e1,$e1,$e1,$e2,$e2
		.byt $e2,$e3,$e3,$e3,$e4,$e4,$e4,$e5
		.byt $e5,$e5,$e6,$e6,$e6,$e7,$e7,$e7
		.byt $e7,$e8,$e8,$e8,$e9,$e9,$e9,$ea
		.byt $ea,$ea,$ea,$eb,$eb,$eb,$ec,$ec
		.byt $ec,$ec,$ed,$ed,$ed,$ed,$ee,$ee
		.byt $ee,$ee,$ef,$ef,$ef,$ef,$f0,$f0
		.byt $f0,$f1,$f1,$f1,$f1,$f1,$f2,$f2
		.byt $f2,$f2,$f3,$f3,$f3,$f3,$f4,$f4
		.byt $f4,$f4,$f5,$f5,$f5,$f5,$f5,$f6
		.byt $f6,$f6,$f6,$f7,$f7,$f7,$f7,$f7
		.byt $f8,$f8,$f8,$f8,$f9,$f9,$f9,$f9
		.byt $f9,$fa,$fa,$fa,$fa,$fa,$fb,$fb
		.byt $fb,$fb,$fb,$fc,$fc,$fc,$fc,$fc
		.byt $fd,$fd,$fd,$fd,$fd,$fd,$fe,$fe
		.byt $fe,$fe,$fe,$ff,$ff,$ff,$ff,$ff





.zero
Tmp .dsb 2

/*
.text
norm:
.(

    ; DeltaXSquare = DeltaX * DeltaX
    lda _DeltaX
    sta _Numberl
    lda _DeltaX+1
    sta _Numberh

    jsr _fastSquare8

    lda _Squarel
    sta _DeltaXSquare
    lda _Squareh
    sta _DeltaXSquare+1

    ; DeltaYSquare = DeltaY * DeltaY
    lda _DeltaY
    sta _Numberl
    lda _DeltaY+1
    sta _Numberh

    jsr _fastSquare8

    lda _Squarel
    sta _DeltaYSquare
    lda _Squareh
    sta _DeltaYSquare+1

    ; Tmp = _DeltaXSquare + _DeltaYSquare
    clc				        ; clear carry
	lda _DeltaXSquare
	adc _DeltaYSquare
	sta Tmp			        ; store sum of LSBs
	lda _DeltaXSquare+1
	adc _DeltaYSquare+1		; add the MSBs using carry from
	sta Tmp+1			    ; the previous calculation

    ; Norm = SQRT (Tmp)
    lda Tmp
    sta NUM
    lda Tmp+1
    sta NUM+1
    jsr _sqrt_16
    lda ROOT
    sta _Norm

.)
  rts



fastnorm:
.(

    ; DeltaXSquare = DeltaX * DeltaX
    lda _DeltaX
    sta _Numberl

    jsr _fastSquare8

    lda _Squarel
    sta _DeltaXSquare
    lda _Squareh
    sta _DeltaXSquare+1

    ; DeltaYSquare = DeltaY * DeltaY
    lda _DeltaY
    sta _Numberl

    jsr _fastSquare8

    ;lda _Squarel
    ;sta _DeltaYSquare
    ;lda _Squareh
    ;sta _DeltaYSquare+1

    ; Tmp = _DeltaXSquare + _DeltaYSquare
    clc				        ; clear carry
	lda _DeltaXSquare
	adc _Squarel
    sta NUM                 ; store sum of LSBs
	lda _DeltaXSquare+1
	adc _Squareh		; add the MSBs using carry from
    sta NUM+1               ; the previous calculation

    ; Norm = SQRT (Tmp)
    jsr _fastsqrt_16
    lda ROOT
    sta _Norm

.)
  rts
*/
.zero
tmpufnX .dsb 1
tmpufnY .dsb 1

/*

.text
ultrafastnorm:
.(
//  IF DX == 0 THEN
	lda _DeltaX
	bne dxNotNull
//  	IF DY > 0 THEN
		lda _DeltaY
		bmi dyNegative01
//  		RETURN DY
			sta _Norm
			jmp ufndone
dyNegative01:
//  	ELSE
//  		RETURN -DY
			eor #$FF
			sec
			adc #$00
			sta _Norm
			jmp ufndone
dxNotNull
//  ELSE IF DX > 0 THEN
	bmi dxNegative
//  	TX = DX
		sta tmpufnX
		jmp computeAbsY
dxNegative
//  ELSE (DX < 0)
//  	TX = -DX
		eor #$FF
		sec
		adc #$00
		sta tmpufnX
//  ENDIF
computeAbsY
//  IF DY == 0 THEN
	lda _DeltaY
	bne dyNotNull
//  	RETURN TX
		lda tmpufnX
		sta _Norm
		jmp ufndone
dyNotNull
//  ELSE IF DY > 0 THEN
	bmi dyNegative02
//  	TY = DY
		sta tmpufnY
		jmp lookup
dyNegative02
//  ELSE (DY < 0)
//  	TY = -DY
		eor #$FF
		sec
		adc #$00
		sta tmpufnY
//  ENDIF
lookup
//  IF TX = TY THEN
	cmp tmpufnX ; TY already in A register
	;bne txDiffty // FIXME deal with overflow !! result is on more than 8 bits
//  	RETURN TX * SQRT(2)
txDiffty
//  ELSE IF TX > TY THEN
	bcc txLessThanty
//  	RETURN TX + TY * (SQRT(2) - 1)
		tay ;
		lda tMultSqrt2m1, y
		clc
		adc tmpufnX
		sta _Norm
		jmp ufndone
//  ELSE (TX < TY)
txLessThanty
//  	RETURN TY + TX * (SQRT(2) - 1)
		ldy tmpufnX
		lda tMultSqrt2m1, y
		clc
		adc tmpufnY
		sta _Norm
//  END IF
ufndone
.)
  rts


tMultSqrt2m1
	.byt 0, 0, 1, 1, 2, 2, 2, 3
	.byt 3, 4, 4, 5, 5, 5, 6, 6
	.byt 7, 7, 7, 8, 8, 9, 9, 10
	.byt 10, 10, 11, 11, 12, 12, 12, 13
	.byt 13, 14, 14, 14, 15, 15, 16, 16
	.byt 17, 17, 17, 18, 18, 19, 19, 19
	.byt 20, 20, 21, 21, 22, 22, 22, 23
	.byt 23, 24, 24, 24, 25, 25, 26, 26
	.byt 27, 27, 27, 28, 28, 29, 29, 29
	.byt 30, 30, 31, 31, 31, 32, 32, 33
	.byt 33, 34, 34, 34, 35, 35, 36, 36
	.byt 36, 37, 37, 38, 38, 39, 39, 39
	.byt 40, 40, 41, 41, 41, 42, 42, 43
	.byt 43, 43, 44, 44, 45, 45, 46, 46
	.byt 46, 47, 47, 48, 48, 48, 49, 49
	.byt 50, 50, 51, 51, 51, 52, 52, 53
*/

.zero
absX .dsb 1
absY .dsb 1

.text
_norm_8:
.(

//  IF DX == 0 THEN
    lda _DeltaX
	bne norm_8_dxNotNull
//    IF DY > 0 THEN
		lda _DeltaY
		bmi norm_8_dyNegativ_01
//      RETURN DY
		sta _Norm
		jmp norm_8_done
norm_8_dyNegativ_01
//    ELSE
//      RETURN -DY
		eor #$FF
		sec
		adc #$00
		sta _Norm
		jmp norm_8_done
norm_8_dxNotNull
//  ELSE IF DX > 0 THEN
	bmi norm_8_dxNegativ_01
//    AX = DX
		sta absX
		jmp norm_8_computeAbsY
norm_8_dxNegativ_01
//  ELSE (DX < 0)
//    AX = -DX
		eor #$FF
		sec
		adc #$00
		sta absX
//  ENDIF
norm_8_computeAbsY
//  IF DY == 0 THEN
	lda _DeltaY
	bne norm_8_dyNotNull
//    RETURN AX
		lda absX
		sta _Norm
		jmp norm_8_done
norm_8_dyNotNull
//  ELSE IF DY > 0 THEN
	bmi norm_8_dyNegativ_02
//    AY = DY
		sta absY
		jmp norm_8_sortAbsVal
norm_8_dyNegativ_02
//  ELSE (DY < 0)
		eor #$FF
		sec
		adc #$00
		sta absY
//    AY = -DY
//  ENDIF
norm_8_sortAbsVal
//  IF AX > AY THEN
	cmp absX
	bcs norm_8_ayOverOrEqualAx
//    TY = AY
		tay
		sta tmpufnY
//    TX = AX
		lda absX
		tax
		sta tmpufnX
		jmp norm_8_approxim
norm_8_ayOverOrEqualAx
//  ELSE
//    TX = AY
		tax
		sta tmpufnX
//    TY = AX
		lda absX
		tay
		sta tmpufnY
//  END
norm_8_approxim
//  IF TY > TX/2 THEN
	lda tmpufnX
	lsr
	cmp tmpufnY
	bcc norm_8_tyLowerOrEqualTxDiv2
	beq norm_8_tyLowerOrEqualTxDiv2
//    RETURN TAB_A[TX] + TAB_B[TY]
		lda tabmult_A,X
		clc
		adc tabmult_B,Y
		sta _Norm
		lda #$00
		adc #$00 ; propagate carry
		sta _Norm+1
		jmp norm_8_done
norm_8_tyLowerOrEqualTxDiv2
//  ELSE (TX/2 <= TY)
//    RETURN TAB_C[TX] + TAB_D[TY]
		lda tabmult_C,X
		clc
		adc tabmult_D,Y
		sta _Norm
		lda #$00
		adc #$00 ; propagate carry
		sta _Norm+1
//  END IF

norm_8_done:
.)
  rts
/*_hyperfastnorm:
.(

//  IF DX == 0 THEN
    lda _DeltaX
	bne dxNotNull
//    IF DY > 0 THEN
		lda _DeltaY
		bmi dyNegativ_01
//      RETURN DY
		sta _Norm
		jmp hfndone
dyNegativ_01
//    ELSE
//      RETURN -DY
		eor #$FF
		sec
		adc #$00
		sta _Norm
		jmp hfndone
dxNotNull
//  ELSE IF DX > 0 THEN
	bmi dxNegativ_01
//    AX = DX
		sta absX
		jmp computeAbsY
dxNegativ_01
//  ELSE (DX < 0)
//    AX = -DX
		eor #$FF
		sec
		adc #$00
		sta absX
//  ENDIF
computeAbsY
//  IF DY == 0 THEN
	lda _DeltaY
	bne dyNotNull
//    RETURN AX
		lda absX
		sta _Norm
		jmp hfndone
dyNotNull
//  ELSE IF DY > 0 THEN
	bmi dyNegativ_02
//    AY = DY
		sta absY
		jmp sortAbsVal
dyNegativ_02
//  ELSE (DY < 0)
		eor #$FF
		sec
		adc #$00
		sta absY
//    AY = -DY
//  ENDIF
sortAbsVal
//  IF AX > AY THEN
	cmp absX
	bcs ayOverOrEqualAx
//    TY = AY
		tay
		sta tmpufnY
//    TX = AX
		lda absX
		tax
		sta tmpufnX
		jmp approxim
ayOverOrEqualAx
//  ELSE
//    TX = AY
		tax
		sta tmpufnX
//    TY = AX
		lda absX
		tay
		sta tmpufnY
//  END
approxim
//  IF TY > TX/2 THEN
	lda tmpufnX
	lsr
	cmp tmpufnY
	bcc tyLowerOrEqualTxDiv2
	beq tyLowerOrEqualTxDiv2
//    RETURN TAB_A[TX] + TAB_B[TY]
		lda tabmult_A,X
		clc
		adc tabmult_B,Y
		sta _Norm
		lda #$00
		adc #$00 ; propagate carry
		sta _Norm+1
		jmp hfndone
tyLowerOrEqualTxDiv2
//  ELSE (TX/2 <= TY)
//    RETURN TAB_C[TX] + TAB_D[TY]
		lda tabmult_C,X
		clc
		adc tabmult_D,Y
		sta _Norm
		lda #$00
		adc #$00 ; propagate carry
		sta _Norm+1
//  END IF

hfndone
.)
  rts
*/
tabmult_A
	.byt 0, 1, 2, 3, 4, 5, 6, 7,
	.byt 8, 9, 10, 11, 12, 13, 14, 15,
	.byt 16, 17, 18, 19, 20, 21, 22, 23,
	.byt 24, 25, 26, 27, 28, 29, 30, 31,
	.byt 32, 33, 34, 35, 36, 37, 38, 39,
	.byt 40, 41, 42, 43, 44, 45, 46, 47,
	.byt 48, 49, 50, 51, 52, 53, 54, 55,
	.byt 56, 57, 58, 59, 60, 61, 62, 63,
	.byt 64, 65, 66, 67, 68, 69, 70, 71,
	.byt 72, 73, 74, 75, 76, 77, 78, 79,
	.byt 80, 81, 82, 83, 84, 85, 86, 87,
	.byt 88, 89, 90, 90, 91, 92, 93, 94,
	.byt 95, 96, 97, 98, 99, 100, 101, 102,
	.byt 103, 104, 105, 106, 107, 108, 109, 110,
	.byt 111, 112, 113, 114, 115, 116, 117, 118,
	.byt 119, 119, 120, 121, 122, 123, 124, 125
tabmult_B
	.byt 0, 0, 0, 0, 0, 1, 1, 1,
	.byt 1, 1, 1, 1, 2, 2, 2, 2,
	.byt 2, 3, 3, 3, 3, 3, 4, 4,
	.byt 4, 4, 4, 5, 5, 5, 6, 6,
	.byt 6, 6, 7, 7, 7, 7, 8, 8,
	.byt 8, 9, 9, 9, 10, 10, 10, 11,
	.byt 11, 11, 12, 12, 13, 13, 13, 14,
	.byt 14, 15, 15, 15, 16, 16, 17, 17,
	.byt 18, 18, 18, 19, 19, 20, 20, 21,
	.byt 21, 22, 22, 23, 23, 24, 24, 25,
	.byt 25, 26, 26, 27, 27, 28, 29, 29,
	.byt 30, 30, 31, 31, 32, 33, 33, 34,
	.byt 34, 35, 36, 36, 37, 38, 38, 39,
	.byt 39, 40, 41, 41, 42, 43, 44, 44,
	.byt 45, 46, 46, 47, 48, 48, 49, 50,
	.byt 51, 51, 52, 53, 54, 54, 55, 56
tabmult_C
	.byt 0, 0, 2, 3, 4, 5, 5, 6,
	.byt 7, 8, 8, 9, 10, 11, 12, 13,
	.byt 14, 14, 15, 16, 17, 18, 19, 19,
	.byt 20, 21, 22, 23, 24, 24, 25, 26,
	.byt 27, 28, 29, 30, 30, 31, 32, 33,
	.byt 34, 35, 35, 36, 37, 38, 39, 40,
	.byt 40, 41, 42, 43, 44, 44, 45, 46,
	.byt 47, 48, 49, 49, 50, 51, 52, 53,
	.byt 54, 54, 55, 56, 57, 58, 59, 59,
	.byt 60, 61, 62, 63, 63, 64, 65, 66,
	.byt 67, 68, 68, 69, 70, 71, 72, 72,
	.byt 73, 74, 75, 76, 76, 77, 78, 79,
	.byt 80, 80, 81, 82, 83, 84, 85, 85,
	.byt 86, 87, 88, 89, 89, 90, 91, 92,
	.byt 93, 93, 94, 95, 96, 97, 97, 98,
	.byt 99, 100, 101, 101, 102, 103, 104, 105
tabmult_D
	.byt 0, 1, 1, 1, 2, 2, 3, 4,
	.byt 4, 5, 5, 6, 7, 7, 8, 8,
	.byt 9, 9, 10, 10, 11, 11, 12, 13,
	.byt 13, 14, 14, 15, 15, 16, 17, 17,
	.byt 18, 18, 19, 19, 20, 20, 21, 22,
	.byt 22, 23, 23, 24, 24, 25, 26, 26,
	.byt 27, 27, 28, 28, 29, 30, 30, 31,
	.byt 31, 32, 33, 33, 34, 34, 35, 35,
	.byt 36, 37, 37, 38, 38, 39, 40, 40,
	.byt 41, 41, 42, 43, 43, 44, 44, 45,
	.byt 46, 46, 47, 47, 48, 49, 49, 50,
	.byt 50, 51, 52, 52, 53, 53, 54, 55,
	.byt 55, 56, 56, 57, 58, 58, 59, 59,
	.byt 60, 61, 61, 62, 63, 63, 64, 64,
	.byt 65, 66, 66, 67, 68, 68, 69, 69,
	.byt 70, 71, 71, 72, 73, 73, 74, 74




#ifdef USE_MULTI40
_multi40
	.word 0
	.word 40
	.word 80
	.word 120
	.word 160
	.word 200
	.word 240
	.word 280
	.word 320
	.word 360
	.word 400
	.word 440
	.word 480
	.word 520
	.word 560
	.word 600
	.word 640
	.word 680
	.word 720
	.word 760
	.word 800
	.word 840
	.word 880
	.word 920
	.word 960
	.word 1000
	.word 1040
#endif // USE_MULTI40


; This table contains lower 8 bits of the adress
ZBufferAdressLow
	.byt <(_zbuffer+40*0)
	.byt <(_zbuffer+40*1)
	.byt <(_zbuffer+40*2)
	.byt <(_zbuffer+40*3)
	.byt <(_zbuffer+40*4)
	.byt <(_zbuffer+40*5)
	.byt <(_zbuffer+40*6)
	.byt <(_zbuffer+40*7)
	.byt <(_zbuffer+40*8)
	.byt <(_zbuffer+40*9)
	.byt <(_zbuffer+40*10)
	.byt <(_zbuffer+40*11)
	.byt <(_zbuffer+40*12)
	.byt <(_zbuffer+40*13)
	.byt <(_zbuffer+40*14)
	.byt <(_zbuffer+40*15)
	.byt <(_zbuffer+40*16)
	.byt <(_zbuffer+40*17)
	.byt <(_zbuffer+40*18)
	.byt <(_zbuffer+40*19)
	.byt <(_zbuffer+40*20)
	.byt <(_zbuffer+40*21)
	.byt <(_zbuffer+40*22)
	.byt <(_zbuffer+40*23)
	.byt <(_zbuffer+40*24)
	.byt <(_zbuffer+40*25)
	.byt <(_zbuffer+40*26)
	.byt <(_zbuffer+40*27)

; This table contains hight 8 bits of the adress
ZBufferAdressHigh
	.byt >(_zbuffer+40*0)
	.byt >(_zbuffer+40*1)
	.byt >(_zbuffer+40*2)
	.byt >(_zbuffer+40*3)
	.byt >(_zbuffer+40*4)
	.byt >(_zbuffer+40*5)
	.byt >(_zbuffer+40*6)
	.byt >(_zbuffer+40*7)
	.byt >(_zbuffer+40*8)
	.byt >(_zbuffer+40*9)
	.byt >(_zbuffer+40*10)
	.byt >(_zbuffer+40*11)
	.byt >(_zbuffer+40*12)
	.byt >(_zbuffer+40*13)
	.byt >(_zbuffer+40*14)
	.byt >(_zbuffer+40*15)
	.byt >(_zbuffer+40*16)
	.byt >(_zbuffer+40*17)
	.byt >(_zbuffer+40*18)
	.byt >(_zbuffer+40*19)
	.byt >(_zbuffer+40*20)
	.byt >(_zbuffer+40*21)
	.byt >(_zbuffer+40*22)
	.byt >(_zbuffer+40*23)
	.byt >(_zbuffer+40*24)
	.byt >(_zbuffer+40*25)
	.byt >(_zbuffer+40*26)
	.byt >(_zbuffer+40*27)


; This table contains lower 8 bits of the adress
FBufferAdressLow
	.byt <(_fbuffer+40*0)
	.byt <(_fbuffer+40*1)
	.byt <(_fbuffer+40*2)
	.byt <(_fbuffer+40*3)
	.byt <(_fbuffer+40*4)
	.byt <(_fbuffer+40*5)
	.byt <(_fbuffer+40*6)
	.byt <(_fbuffer+40*7)
	.byt <(_fbuffer+40*8)
	.byt <(_fbuffer+40*9)
	.byt <(_fbuffer+40*10)
	.byt <(_fbuffer+40*11)
	.byt <(_fbuffer+40*12)
	.byt <(_fbuffer+40*13)
	.byt <(_fbuffer+40*14)
	.byt <(_fbuffer+40*15)
	.byt <(_fbuffer+40*16)
	.byt <(_fbuffer+40*17)
	.byt <(_fbuffer+40*18)
	.byt <(_fbuffer+40*19)
	.byt <(_fbuffer+40*20)
	.byt <(_fbuffer+40*21)
	.byt <(_fbuffer+40*22)
	.byt <(_fbuffer+40*23)
	.byt <(_fbuffer+40*24)
	.byt <(_fbuffer+40*25)
	.byt <(_fbuffer+40*26)
	.byt <(_fbuffer+40*27)

; This table contains hight 8 bits of the adress
FBufferAdressHigh
	.byt >(_fbuffer+40*0)
	.byt >(_fbuffer+40*1)
	.byt >(_fbuffer+40*2)
	.byt >(_fbuffer+40*3)
	.byt >(_fbuffer+40*4)
	.byt >(_fbuffer+40*5)
	.byt >(_fbuffer+40*6)
	.byt >(_fbuffer+40*7)
	.byt >(_fbuffer+40*8)
	.byt >(_fbuffer+40*9)
	.byt >(_fbuffer+40*10)
	.byt >(_fbuffer+40*11)
	.byt >(_fbuffer+40*12)
	.byt >(_fbuffer+40*13)
	.byt >(_fbuffer+40*14)
	.byt >(_fbuffer+40*15)
	.byt >(_fbuffer+40*16)
	.byt >(_fbuffer+40*17)
	.byt >(_fbuffer+40*18)
	.byt >(_fbuffer+40*19)
	.byt >(_fbuffer+40*20)
	.byt >(_fbuffer+40*21)
	.byt >(_fbuffer+40*22)
	.byt >(_fbuffer+40*23)
	.byt >(_fbuffer+40*24)
	.byt >(_fbuffer+40*25)
	.byt >(_fbuffer+40*26)
	.byt >(_fbuffer+40*27)



#ifdef USE_ASM_BUFFER2SCREEN

.text

_buffer2screen:
.(
	ldy #$00

buffer2screen_loop_01:

	lda _fbuffer, y 
	sta ADR_BASE_LORES_SCREEN,y
	lda _fbuffer+256, y 
	sta ADR_BASE_LORES_SCREEN+256,y
	lda _fbuffer+512, y 
	sta ADR_BASE_LORES_SCREEN+512,y
	lda _fbuffer+768, y 
	sta ADR_BASE_LORES_SCREEN+768,y
	iny
	bne buffer2screen_loop_01

	ldy #$10

buffer2screen_loop_02:

	lda _fbuffer+1024, y 
	sta ADR_BASE_LORES_SCREEN+1024,y
	dey
	bpl buffer2screen_loop_02

.)
    rts


#endif // USE_ASM_BUFFER2SCREEN


#ifdef USE_ASM_INITFRAMEBUFFER

// void initScreenBuffers()
_initScreenBuffers:
.(
  
    lda #$FF
    ldx #SCREEN_WIDTH-1

initScreenBuffersLoop_01:
    sta _zbuffer+SCREEN_WIDTH*0 , x
    sta _zbuffer+SCREEN_WIDTH*1 , x
    sta _zbuffer+SCREEN_WIDTH*2 , x
    sta _zbuffer+SCREEN_WIDTH*3 , x
    sta _zbuffer+SCREEN_WIDTH*4 , x
    sta _zbuffer+SCREEN_WIDTH*5 , x
    sta _zbuffer+SCREEN_WIDTH*6 , x
    sta _zbuffer+SCREEN_WIDTH*7 , x
    sta _zbuffer+SCREEN_WIDTH*8 , x
    sta _zbuffer+SCREEN_WIDTH*9 , x
    sta _zbuffer+SCREEN_WIDTH*10 , x
    sta _zbuffer+SCREEN_WIDTH*11 , x
    sta _zbuffer+SCREEN_WIDTH*12 , x
    sta _zbuffer+SCREEN_WIDTH*13 , x
    sta _zbuffer+SCREEN_WIDTH*14 , x
    sta _zbuffer+SCREEN_WIDTH*15 , x
    sta _zbuffer+SCREEN_WIDTH*16 , x
    sta _zbuffer+SCREEN_WIDTH*17 , x
    sta _zbuffer+SCREEN_WIDTH*18 , x
    sta _zbuffer+SCREEN_WIDTH*19 , x
    sta _zbuffer+SCREEN_WIDTH*20 , x
    sta _zbuffer+SCREEN_WIDTH*21 , x
    sta _zbuffer+SCREEN_WIDTH*22 , x
    sta _zbuffer+SCREEN_WIDTH*23 , x
    sta _zbuffer+SCREEN_WIDTH*24 , x
    sta _zbuffer+SCREEN_WIDTH*25 , x 
    ; BUGFIX sta _zbuffer+SCREEN_WIDTH*26 , x
    dex
    bne initScreenBuffersLoop_01

#ifndef USE_HORIZON
    lda #$20
#endif // USE_HORIZON

    ldx #SCREEN_WIDTH-1

initScreenBuffersLoop_02:
#ifdef USE_HORIZON
    lda #$20
#endif // USE_HORIZON
    sta _fbuffer+SCREEN_WIDTH*0 , x
    sta _fbuffer+SCREEN_WIDTH*1 , x
    sta _fbuffer+SCREEN_WIDTH*2 , x
    sta _fbuffer+SCREEN_WIDTH*3 , x
    sta _fbuffer+SCREEN_WIDTH*4 , x
    sta _fbuffer+SCREEN_WIDTH*5 , x
    sta _fbuffer+SCREEN_WIDTH*6 , x
    sta _fbuffer+SCREEN_WIDTH*7 , x
    sta _fbuffer+SCREEN_WIDTH*8 , x
    sta _fbuffer+SCREEN_WIDTH*9 , x
    sta _fbuffer+SCREEN_WIDTH*10 , x
    sta _fbuffer+SCREEN_WIDTH*11 , x
    sta _fbuffer+SCREEN_WIDTH*12 , x
    sta _fbuffer+SCREEN_WIDTH*13 , x
#ifdef USE_HORIZON
    lda #102 ;; light green
#endif // USE_HORIZON
    sta _fbuffer+SCREEN_WIDTH*14 , x
    sta _fbuffer+SCREEN_WIDTH*15 , x
    sta _fbuffer+SCREEN_WIDTH*16 , x
    sta _fbuffer+SCREEN_WIDTH*17 , x
    sta _fbuffer+SCREEN_WIDTH*18 , x
    sta _fbuffer+SCREEN_WIDTH*19 , x
    sta _fbuffer+SCREEN_WIDTH*20 , x
    sta _fbuffer+SCREEN_WIDTH*21 , x
#ifndef USE_COLOR
    sta _fbuffer+SCREEN_WIDTH*22 , x
    sta _fbuffer+SCREEN_WIDTH*23 , x
    sta _fbuffer+SCREEN_WIDTH*24 , x
    sta _fbuffer+SCREEN_WIDTH*25 , x
    sta _fbuffer+SCREEN_WIDTH*26 , x
#endif
    dex
#ifdef USE_COLOR
 	cpx #2
 	beq initScreenBuffersDone
#endif // USE_COLOR
    bpl initScreenBuffersLoop_02
initScreenBuffersDone:
.)
    rts


#endif // USE_ASM_INITFRAMEBUFFER


#ifdef USE_ASM_ZPLOT

_fastzplot:
.(
	// save context
    pha:txa:pha:tya:pha
	lda tmp0: pha: lda tmp0+1 : pha ;; ptrFbuf
	lda tmp1: pha: lda tmp1+1 : pha ;; ptrZbuf


// #ifdef USE_COLOR
//    if ((Y <= 0) || (Y >= SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR) || (X <= 2) || (X >= SCREEN_WIDTH))
//        return;
// #else
//    if ((Y <= 0) || (Y >= SCREEN_HEIGHT) || (X <= 0) || (X >= SCREEN_WIDTH))
//        return;
// #endif

	lda		_plotY
    beq		fastzplot_done
    bmi		fastzplot_done
#ifdef USE_COLOR
    cmp		#SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR
#else
	cmp		#SCREEN_HEIGHT
#endif
    bcs		fastzplot_done
    tax

	lda		_plotX
#ifdef USE_COLOR
	sec
	sbc		#COLUMN_OF_COLOR_ATTRIBUTE
	bvc		*+4
	eor		#$80
	bmi		fastzplot_done

	lda		_plotX				; Reload X coordinate
    cmp		#SCREEN_WIDTH
    bcs		fastzplot_done

#else
    beq		fastzplot_done
    bmi		fastzplot_done
    cmp		#SCREEN_WIDTH
    bcs		fastzplot_done
#endif

    // ptrZbuf = zbuffer + Y*SCREEN_WIDTH+X;;
	lda		ZBufferAdressLow,x	; Get the LOW part of the zbuffer adress
	clc						; Clear the carry (because we will do an addition after)
	adc		_plotX				; Add X coordinate
	sta		tmp1 ; ptrZbuf
	lda		ZBufferAdressHigh,x	; Get the HIGH part of the zbuffer adress
	adc		#0					; Eventually add the carry to complete the 16 bits addition
	sta		tmp1+1	 ; ptrZbuf+ 1			

    // if (dist < *ptrZbuf) {
    lda 	_distpoint		; Access dist
    ldx		#0
    cmp		(tmp1,x)
    bcs		fastzplot_done

    //    *ptrZbuf = dist;
        ldx		#0
        sta		(tmp1, x)
    //    *ptrFbuf = char2disp;
        ldx		_plotY    ; reload Y coordinate
    	lda		FBufferAdressLow,x	; Get the LOW part of the fbuffer adress
        clc						; Clear the carry (because we will do an addition after)
        ;;ldy #0
        adc		_plotX				; Add X coordinate
        sta		tmp0 ; ptrFbuf
        lda		FBufferAdressHigh,x	; Get the HIGH part of the fbuffer adress
        adc		#0					; Eventually add the carry to complete the 16 bits addition
        sta		tmp0+1	 ; ptrFbuf+ 1			

        lda		_ch2disp		; Access char2disp
        ldx		#0
        sta		(tmp0,x)

    //}


fastzplot_done:
	// restore context
	pla: sta tmp1+1: pla: sta tmp1
	pla: sta tmp0+1: pla: sta tmp0
	pla:tay:pla:tax:pla

.)
	rts

// void zplot(unsigned char X,
//           unsigned char Y,
//           unsigned char dist,
//           char          char2disp) {

_zplot:
.(
; sp+0 => X coordinate
; sp+2 => Y coordinate
; sp+4 => dist
; sp+6 => char2disp

	// save context
    pha:tya:pha

	ldy		#2
	lda		(sp),y				; Access Y coordinate
	sta		_plotY

	ldy		#0
	lda		(sp),y				; Access X coordinate
	sta		_plotX

    ldy		#4
    lda		(sp),y				; Access dist
	sta		_distpoint

	ldy		#6
	lda		(sp),y				; Access char2disp
	sta 	_ch2disp

	jsr 	_fastzplot

zplot_done:
	// restore context
	pla:tay:pla

.)
    rts

#endif // USE_ASM_ZPLOT


#ifdef USE_ASM_ZLINE

// void zline(signed char   dx,
//           signed char   py,
//           signed char   nbpoints,
//           unsigned char dist,
//           char          char2disp) {

_zline:
.(
; sp+0 => dx
; sp+2 => py
; sp+4 => nbpoints
; sp+6 => dist
; sp+8 => char2disp

	// save context
    pha
	lda tmp0: pha: lda tmp0+1 : pha ;; ptrFbuf
	lda tmp1: pha: lda tmp1+1 : pha ;; ptrZbuf
	lda reg0: pha ;; store py temporarily
    lda reg1: pha ;; nbpoints
    lda reg2: pha ;; dx
    lda reg3: pha ;; dist
    lda reg4: pha ;; char2disp


    // int            offset;   // offset os starting point
    // char*          ptrFbuf;  // pointer to the frame buffer
    // unsigned char* ptrZbuf;  // pointer to z-buffer
    // signed char    nbp;

	ldy #0
	lda (sp),y				; Access dx 
    sta reg2

	ldy #2
	lda (sp),y				; Access py 
    sta reg0
    tax

	ldy #4
	lda (sp),y				; Access nbpoints 
    beq zline_done
    sta reg1

	ldy #6
	lda (sp),y				; Access dist 
    sta reg3

	ldy #8
	lda (sp),y				; Access char2disp 
    sta reg4

    // nbp     = nbpoints;

    // ptrZbuf = zbuffer + py * SCREEN_WIDTH + dx;
 	lda ZBufferAdressLow,x	; Get the LOW part of the zbuffer adress
	clc						
	adc reg2				; Add dx coordinate
	sta tmp1                ; ptrZbuf
	lda ZBufferAdressHigh,x	; Get the HIGH part of the zbuffer adress
	adc #0					; 
	sta tmp1+1	 ; ptrZbuf+ 1			

    // ptrFbuf = fbuffer + py * SCREEN_WIDTH + dx;
    lda FBufferAdressLow,x	; Get the LOW part of the fbuffer adress
    clc						; 
    adc reg2				; Add dx coordinate
    sta tmp0                ; ptrFbuf
    lda FBufferAdressHigh,x	; Get the HIGH part of the fbuffer adress
    adc #0					; 
    sta tmp0+1	            ; ptrFbuf+ 1			

   // ptrFbuf = fbuffer + offset;

    // while (nbp > 0) {
    ldy reg1
_zline2_loop:
    

    //     if (dist < ptrZbuf[nbp]) {
    lda (tmp1), y
    cmp reg3
    bcc zline_distOver
    //         // printf ("p [%d %d] <- %d. was %d \n", dx+nbpoints, py, dist, ptrZbuf
    //         // [nbpoints]);
    //         ptrFbuf[nbp] = char2disp;
    lda reg4
    sta (tmp0), y
    //         ptrZbuf[nbp] = dist;
    lda reg3
    sta (tmp1), y
   //     }
zline_distOver:
    //     nbp--;
    dey
    bne _zline2_loop
    // }


zline_done:
	// restore context
	pla: sta reg4
	pla: sta reg3
	pla: sta reg2
	pla: sta reg1
    pla: sta reg0
	pla: sta tmp1+1: pla: sta tmp1
	pla: sta tmp0+1: pla: sta tmp0
	pla

.)
    rts

#endif // USE_ASM_ZLINE


// unsigned char zbuffer[SCREEN_WIDTH * SCREEN_HEIGHT];  // z-depth buffer
// char          fbuffer[SCREEN_WIDTH * SCREEN_HEIGHT];  // frame buffer

_fbuffer
	.dsb 1080
_zbuffer
	.dsb 1080





.zero

lineIndex   .dsb 1
departX     .dsb 1
finX        .dsb 1
hLineLength .dsb 1

.text




// void hzfill() {
_hzfill:
.(
; #ifdef USE_PROFILER
; PROFILE_ENTER(ROUTINE_HZFILL)
; #endif
	// save context
    pha:txa:pha:tya:pha

	lda tmp0: pha
	lda tmp0+1: pha
	lda tmp1: pha
	lda tmp1+1: pha

//     if ((A1Y <= 0) || (A1Y >= SCREEN_HEIGHT)) return;
	lda _A1Y				; Access Y coordinate
;     bpl *+5
;     jmp hzfill_done
; #ifdef USE_COLOR
;     cmp #SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR
; #else
;     cmp #SCREEN_HEIGHT
; #endif
;     bcc *+5
; 	jmp hzfill_done
    sta lineIndex ; A1Y

//     if (A1X > A2X) {
	; lda _A1X				
	; sec
	; sbc _A2X				; signed cmp to p2x
	; bvc *+4
	; eor #$80
	; bmi hzfill_A2xOverOrEqualA1x
	lda _A1Right ; (A1X > A2X)
	beq hzfill_A2xOverOrEqualA1x
#ifdef USE_COLOR
//		dx = max(2, A2X);
		lda _A2X
		sec
		sbc #COLUMN_OF_COLOR_ATTRIBUTE
		bvc *+4
		eor #$80
		bmi hzfill_A2xLowerThan3
		lda _A2X
		jmp hzfill_A2xPositiv
hzfill_A2xLowerThan3:
		lda #COLUMN_OF_COLOR_ATTRIBUTE
#else
//      dx = max(0, A2X);
		lda _A2X
		bpl hzfill_A2xPositiv
		lda #0
#endif
hzfill_A2xPositiv:
		sta departX ; dx
//         fx = min(A1X, SCREEN_WIDTH - 1);
		lda _A1X
		sta finX
		sec
		sbc #SCREEN_WIDTH - 1
		bvc *+4
		eor #$80
		bmi hzfill_A1xOverScreenWidth
		lda #SCREEN_WIDTH - 1
		sta finX
hzfill_A1xOverScreenWidth:
		jmp hzfill_computeNbPoints
hzfill_A2xOverOrEqualA1x:
//     } else {
#ifdef USE_COLOR
//		dx = max(2, A1X);
		lda _A1X
		sec
		sbc #COLUMN_OF_COLOR_ATTRIBUTE
		bvc *+4
		eor #$80
		bmi hzfill_A1xLowerThan3
		lda _A1X
		jmp hzfill_A1xPositiv
hzfill_A1xLowerThan3:
		lda #COLUMN_OF_COLOR_ATTRIBUTE
#else
//      dx = max(0, A1X);
		lda _A1X
		bpl hzfill_A1xPositiv
		lda #0
#endif
hzfill_A1xPositiv:
		sta departX
//         fx = min(A2X, SCREEN_WIDTH - 1);
		lda _A2X ; p2x
		sta finX
		sec
		sbc #SCREEN_WIDTH - 1
		bvc *+4
		eor $80
		bmi hzfill_A2xOverScreenWidth
		lda #SCREEN_WIDTH - 1
		sta finX
hzfill_A2xOverScreenWidth:
//     }
hzfill_computeNbPoints:
//     nbpoints = fx - dx;
//     if (nbpoints < 0) return;
	sec
	lda finX
	sbc departX
    beq hzfill_done
	bmi hzfill_done
	sta hLineLength

//     // printf ("dx=%d py=%d nbpoints=%d dist= %d, char2disp= %d\n", dx, py, nbpoints,  dist, char2disp);get();

// #ifdef USE_ZBUFFER
//     zline(dx, A1Y, nbpoints, distface, ch2disp);
	; clc
	; lda sp
	; sta tmp3
	; adc #10
	; sta sp
	; lda sp+1
	; sta tmp3+1
	; adc #0
	; sta sp+1
	; lda tmp0 : ldy #0 : sta (sp),y ;; dx
	; lda reg2 : ldy #2 : sta (sp),y ;; py
	; lda tmp2 : ldy #4 : sta (sp),y ;; nbpoints
	; lda _distface : ldy #6 : sta (sp),y ;; dist
	; lda _ch2disp : ldy #8 : sta (sp),y ;; char2disp


    
	// ldy #10 : jsr _zline

    ldx lineIndex ; A1Y

    // ptrZbuf = zbuffer + py * SCREEN_WIDTH + dx;
 	lda ZBufferAdressLow,x	; Get the LOW part of the zbuffer adress
	clc						
	adc departX				; Add dx coordinate
	sta tmp1                ; ptrZbuf
	lda ZBufferAdressHigh,x	; Get the HIGH part of the zbuffer adress
	adc #0					; 
	sta tmp1+1	 ; ptrZbuf+ 1			

    // ptrFbuf = fbuffer + py * SCREEN_WIDTH + dx;
    lda FBufferAdressLow,x	; Get the LOW part of the fbuffer adress
    clc						; 
    adc departX				; Add dx coordinate
    sta tmp0                ; ptrFbuf
    lda FBufferAdressHigh,x	; Get the HIGH part of the fbuffer adress
    adc #0					; 
    sta tmp0+1	            ; ptrFbuf+ 1			

   // ptrFbuf = fbuffer + offset;

    // while (nbp > 0) {
    ldy hLineLength
_hzline_loop: 

    //     if (dist < ptrZbuf[nbp]) {
    lda (tmp1), y
    cmp _distface
    bcc hzline_distOver
    //         ptrFbuf[nbp] = char2disp;
    lda _ch2disp
    sta (tmp0), y
    //         ptrZbuf[nbp] = dist;
    lda _distface
    sta (tmp1), y
   //     }
hzline_distOver:
    //     nbp--;
    dey
    bne _hzline_loop
    // }





// #else
//     // TODO : draw a line whit no z-buffer
// #endif


hzfill_done:
	// restore context

	pla: sta tmp1+1
	pla: sta tmp1
 	pla: sta tmp0+1
	pla: sta tmp0
 
	pla:tay:pla:tax:pla
// }
; #ifdef USE_PROFILER
; PROFILE_LEAVE(ROUTINE_HZFILL)
; #endif
.)
	rts




#ifdef USE_ASM_GLDRAWFACES
_glDrawFaces:
.(

#ifdef USE_PROFILER
PROFILE_ENTER(ROUTINE_GLDRAWFACES);
#endif // USE_PROFILER

	// Save context
	lda reg0 : pha 

	ldy _nbFaces
	jmp glDrawFaces_nextFace
    // for (ii = 0; ii < nbFaces; ii++) {
glDrawFaces_loop:

    //     idxPt1 = facesPt1[ii] ;
	lda _facesPt1, y
	sta _idxPt1
    //     idxPt2 = facesPt2[ii] ;
	lda _facesPt2, y
	sta _idxPt2
    //     idxPt3 = facesPt3[ii] ;
	lda _facesPt3, y
	sta _idxPt3
    //     ch2disp = facesChar[ii];
	lda _facesChar, y
	sta _ch2disp

	sty reg0 

    //     retrieveFaceData();
	jsr _retrieveFaceData
    //     sortPoints();
	jsr _sortPoints
    //     guessIfFace2BeDrawn();
	jsr _guessIfFace2BeDrawn
    //     if (isFace2BeDrawn) {
	lda _isFace2BeDrawn
	beq glDrawFaces_afterFill
    //         fillFace();
		jsr _fillFace
    //     }
glDrawFaces_afterFill:
	ldy reg0

glDrawFaces_nextFace:
	dey 
	bpl glDrawFaces_loop
    // }

glDrawFaces_done:
	// Restore context
	pla : sta reg0

#ifdef USE_PROFILER
PROFILE_LEAVE(ROUTINE_GLDRAWFACES);
#endif // USE_PROFILER

.)
	rts
#endif //USE_ASM_GLDRAWFACES

#ifdef USE_ASM_RETRIEVEFACEDATA
_retrieveFaceData:
.(

	// save context
    ; pha
	; lda reg0:pha
	; lda tmp0:pha ; tmpH
	; lda tmp1:pha ; tmpV

	; lda _idxPt1 : sta tmp0 :

	; clc : lda #<(_points2dL) : adc tmp0 : sta tmp0 : lda #>(_points2dL) : adc tmp0+1 : sta tmp0+1 :
	; lda tmp0 : sta _d1 : lda tmp0+1 : sta _d1+1 :

	ldy _idxPt1
        // P1AH = points2aH[idxPt1];
	lda _points2aH,y : sta _P1AH 
        // P1AV = points2aV[idxPt1];
	lda _points2aV,y : sta _P1AV 
        // dmoy = points2dL[idxPt1]; //*((int*)(points2d + offPt1 + 2));
	lda _points2dL,y : sta _dmoy: lda _points2dH,y : sta _dmoy+1

	ldy _idxPt2
        // P2AH = points2aH[idxPt2];
	lda _points2aH,y : sta _P2AH 		
        // P2AV = points2aV[idxPt2];
	lda _points2aV,y : sta _P2AV 		
        // dmoy += points2dL[idxPt2]; //*((int*)(points2d + offPt2 + 2));
	clc: lda _points2dL,y : adc _dmoy: sta _dmoy : lda _points2dH,y : adc _dmoy+1 :sta _dmoy+1


    ldy _idxPt3
	    // P3AH = points2aH[idxPt3];
	lda _points2aH,y : sta _P3AH	
        // P3AV = points2aV[idxPt3];
	lda _points2aV,y : sta _P3AV 		
        // dmoy +=  points2dL[idxPt3]; //*((int*)(points2d + offPt3 + 2));
	clc: lda _points2dL,y : adc _dmoy: sta _dmoy : lda _points2dH,y : adc _dmoy+1 :sta _dmoy+1

	lda _dmoy+1
	
	beq moynottoobig		// FIXME :: it should be possible to deal with case *(dmoy+1) = 1
	lda #$FF
	sta _distface
	jmp retreiveFaceData_done

moynottoobig:
        // dmoy = dmoy / 3;
	lda _dmoy

	;Divide by 3 found on http://forums.nesdev.com/viewtopic.php?f=2&t=11336
	;18 bytes, 30 cycles
	sta  tmp0
	lsr
	adc  #21
	lsr
	adc  tmp0
	ror
	lsr
	adc  tmp0
	ror
	lsr
	adc  tmp0
	ror
	lsr

        // if (dmoy >= 256) {
        //     dmoy = 256;
        // }
        // distface = (unsigned char)(dmoy & 0x00FF);
	sta _distface


retreiveFaceData_done:	
	// restore context
	; pla: sta tmp1
	; pla: sta tmp0
	; pla: sta reg0
	;pla

	; jmp leave :
.)
	rts
#endif // USE_ASM_RETRIEVEFACEDATA


    ;; if (abs(P2AH) < abs(P1AH)) {
    ;;     tmpH = P1AH;
    ;;     tmpV = P1AV;
    ;;     P1AH = P2AH;
    ;;     P1AV = P2AV;
    ;;     P2AH = tmpH;
    ;;     P2AV = tmpV;
    ;; }
    ;; if (abs(P3AH) < abs(P1AH)) {
    ;;     tmpH = P1AH;
    ;;     tmpV = P1AV;
    ;;     P1AH = P3AH;
    ;;     P1AV = P3AV;
    ;;     P3AH = tmpH;
    ;;     P3AV = tmpV;
    ;; }
    ;; if (abs(P3AH) < abs(P2AH)) {
    ;;     tmpH = P2AH;
    ;;     tmpV = P2AV;
    ;;     P2AH = P3AH;
    ;;     P2AV = P3AV;
    ;;     P3AH = tmpH;
    ;;     P3AV = tmpV;
    ;; }

#ifdef USE_ASM_SORTPOINTS
_sortPoints:
.(
	; ldx #6 : lda #6 : jsr enter :

	// save context
    pha
	lda reg0:pha
	lda tmp0:pha ; tmpH
	lda tmp1:pha ; tmpV


    ;; if (abs(P2AH) < abs(P1AH)) {
.(
	lda _P1AH
	bpl positiv_02
	eor #$FF
	clc
	adc #1
positiv_02:
	sta reg0

	lda _P2AH
	bpl positiv_01
	eor #$FF
	clc
	adc #1
positiv_01:

	cmp reg0
	bcs sortPoints_step01
.)
    ;;     tmpH = P1AH;
    ;;     tmpV = P1AV;
    ;;     P1AH = P2AH;
    ;;     P1AV = P2AV;
    ;;     P2AH = tmpH;
    ;;     P2AV = tmpV;
	lda _P1AH : sta tmp0 :
	lda _P1AV : sta tmp1 :
	lda _P2AH : sta _P1AH :
	lda _P2AV : sta _P1AV :
	lda tmp0 : sta _P2AH :
	lda tmp1 : sta _P2AV :


    ;; }
sortPoints_step01:	
    ;; if (abs(P3AH) < abs(P1AH)) {
.(
	lda _P1AH
	bpl positiv_02
	eor #$FF
	clc
	adc #1
positiv_02:
	sta reg0

	lda _P3AH
	bpl positiv_01
	eor #$FF
	clc
	adc #1
positiv_01:

	cmp reg0
	bcs sortPoints_step02
.)
    ;;     tmpH = P1AH;
    ;;     tmpV = P1AV;
    ;;     P1AH = P3AH;
    ;;     P1AV = P3AV;
    ;;     P3AH = tmpH;
    ;;     P3AV = tmpV;
	lda _P1AH : sta tmp0 :
	lda _P1AV : sta tmp1 :
	lda _P3AH : sta _P1AH :
	lda _P3AV : sta _P1AV :
	lda tmp0 : sta _P3AH :
	lda tmp1 : sta _P3AV :
    ;; }
sortPoints_step02:	
    ;; if (abs(P3AH) < abs(P2AH)) {
.(
	lda _P2AH
	bpl positiv_02
	eor #$FF
	clc
	adc #1
positiv_02:
	sta reg0

	lda _P3AH
	bpl positiv_01
	eor #$FF
	clc
	adc #1
positiv_01:

	cmp reg0
	bcs sortPoints_done
.)
    ;;     tmpH = P2AH;
    ;;     tmpV = P2AV;
    ;;     P2AH = P3AH;
    ;;     P2AV = P3AV;
    ;;     P3AH = tmpH;
    ;;     P3AV = tmpV;
	lda _P2AH : sta tmp0 :
	lda _P2AV : sta tmp1 :
	lda _P3AH : sta _P2AH :
	lda _P3AV : sta _P2AV :
	lda tmp0 : sta _P3AH :
	lda tmp1 :sta _P3AV :

    ;; }

sortPoints_done:	

	// restore context
	pla: sta tmp1
	pla: sta tmp0
	pla: sta reg0
	pla


	; jmp leave :
.)
	rts
#endif // USE_ASM_SORTPOINTS

#ifdef USE_ASM_GUESSIFFACE2BEDRAWN
_guessIfFace2BeDrawn:
.(
	; ldx #10 : lda #8 : jsr enter :

	// save context
    pha
	lda reg0:pha
	lda reg1:pha
	lda tmp0:pha
	lda tmp1:pha

    // m1 = P1AH & ANGLE_MAX;
	lda _P1AH
	and #ASM_ANGLE_MAX
	sta _m1
    // m2 = P2AH & ANGLE_MAX;
	lda _P2AH
	and #ASM_ANGLE_MAX
	sta _m2
    // m3 = P3AH & ANGLE_MAX;
	lda _P3AH
	and #ASM_ANGLE_MAX
	sta _m3
    // v1 = P1AH & ANGLE_VIEW;
	lda _P1AH
	and #ASM_ANGLE_VIEW
	sta _v1
    // v2 = P2AH & ANGLE_VIEW;
	lda _P2AH
	and #ASM_ANGLE_VIEW
	sta _v2
    // v3 = P3AH & ANGLE_VIEW;
	lda _P3AH
	and #ASM_ANGLE_VIEW
	sta _v3

    // isFace2BeDrawn = 0;
	lda #0
	sta _isFace2BeDrawn
debug_ici:
    // if ((m1 == 0x00) || (m1 == ANGLE_MAX)) {
	lda _m1
	beq guessIfFace2BeDrawn_m1extrema
	cmp #ASM_ANGLE_MAX
	beq guessIfFace2BeDrawn_m1extrema
	jmp guessIfFace2BeDrawn_p1back
guessIfFace2BeDrawn_m1extrema:
    //     if ((v1 == 0x00) || (v1 == ANGLE_VIEW)) {
			lda _v1 
			beq guessIfFace2BeDrawn_p1view
			cmp #ASM_ANGLE_VIEW
			beq guessIfFace2BeDrawn_p1view
			jmp guessIfFace2BeDrawn_p1face
guessIfFace2BeDrawn_p1view:
    //         if (
    //             (
    //                 (P1AH & 0x80) != (P2AH & 0x80)) ||
    //             ((P1AH & 0x80) != (P3AH & 0x80))) {
					lda _P1AH 
					eor _P2AH
					and #$80
					bne guessIfFace2BeDrawn_midscreencrossed
					lda _P1AH 
					eor _P3AH
					and #$80
					bne guessIfFace2BeDrawn_midscreencrossed

					jmp guessIfFace2BeDrawn_p1face
guessIfFace2BeDrawn_midscreencrossed:
    //             if ((abs(P3AH) < 127 - abs(P1AH))) {
					.(		
						lda _P1AH
						bpl positiv_01
						eor #$FF
						clc
						adc #1
					positiv_01:
						sta reg0			; reg 0 <- abs(P1AH)

						lda _P3AH
						bpl positiv_02
						eor #$FF
						clc
						adc #1
					positiv_02:
						clc
						adc reg0			; a  <- abs(P3AH) + abs(P1AH)
						bpl guessIfFace2BeDrawn_found01 ; FIXME if sign bit is set <= 127 considtion rather than < 127

					.)
						jmp guessIfFace2BeDrawn_done
    //                 isFace2BeDrawn=1;
guessIfFace2BeDrawn_found01:
							lda #1
							sta _isFace2BeDrawn
							jmp guessIfFace2BeDrawn_done
    //             }
guessIfFace2BeDrawn_p1face:
    //         } else {
    //             isFace2BeDrawn=1;
					lda #1
					sta _isFace2BeDrawn
					jmp guessIfFace2BeDrawn_done
    //         }
guessIfFace2BeDrawn_p1front:	
    //     } else {
    //         // P1 FRONT
    //         if ((m2 == 0x00) || (m2 == ANGLE_MAX)) {
				lda _m2
				beq guessIfFace2BeDrawn_p2front
				cmp #ASM_ANGLE_MAX
				beq guessIfFace2BeDrawn_p2front
				jmp guessIfFace2BeDrawn_p2back
    //             // P2 FRONT
guessIfFace2BeDrawn_p2front:
    //             if ((m3 == 0x00) || (m3 == ANGLE_MAX)) {
					lda _m3
					beq guessIfFace2BeDrawn_p3front
					cmp #ASM_ANGLE_MAX
					beq guessIfFace2BeDrawn_p3front
					jmp guessIfFace2BeDrawn_p3back
guessIfFace2BeDrawn_p3front:
    //                 // P3 FRONT
    //                 // _4_
    //                 if (((P1AH & 0x80) != (P2AH & 0x80)) 
	//						|| ((P1AH & 0x80) != (P3AH & 0x80))) {
						lda _P1AH 
						eor _P2AH
						and #$80
						bne guessIfFace2BeDrawn_midscreencrossed_02
						lda _P1AH 
						eor _P3AH
						and #$80
						bne guessIfFace2BeDrawn_midscreencrossed_02

						jmp guessIfFace2BeDrawn_done
guessIfFace2BeDrawn_midscreencrossed_02:						
    //                     isFace2BeDrawn=1;
							lda #1
							sta _isFace2BeDrawn
							jmp guessIfFace2BeDrawn_done
    //                 } else {
    //                     // nothing to do
    //                 }
guessIfFace2BeDrawn_p3back:
    //             } else {
    //                 // P3 BACK
    //                 // _3_
    //                 if ((P1AH & 0x80) != (P2AH & 0x80)) {
						lda _P1AH 
						eor _P2AH
						and #$80
						beq guessIfFace2BeDrawn_midscreencrossed_03
				
    //                     if (abs(P2AH) < 127 - abs(P1AH)) {
						.(		
							lda _P1AH
							bpl positiv_01
							eor #$FF
							clc
							adc #1
						positiv_01:
							sta reg0			; reg 0 <- abs(P1AH)

							lda _P2AH
							bpl positiv_02
							eor #$FF
							clc
							adc #1
						positiv_02:
							clc
							adc reg0			; a  <- abs(P2AH) + abs(P1AH)
							bpl guessIfFace2BeDrawn_found02 ; FIXME if sign bit is set <= 127 considtion rather than < 127

						.)
							jmp guessIfFace2BeDrawn_midscreencrossed_04
guessIfFace2BeDrawn_found02:
    //                         isFace2BeDrawn=1;
								lda #1
								sta _isFace2BeDrawn
								jmp guessIfFace2BeDrawn_done
    //                     }
guessIfFace2BeDrawn_midscreencrossed_03:
    //                 } else {
    //                     if ((P1AH & 0x80) != (P3AH & 0x80)) {
							lda _P1AH 
							eor _P3AH
							and #$80
							beq guessIfFace2BeDrawn_midscreencrossed_04
    //                         if (abs(P3AH) < 127 - abs(P1AH)) {
							.(		
								lda _P1AH
								bpl positiv_01
								eor #$FF
								clc
								adc #1
							positiv_01:
								sta reg0			; reg 0 <- abs(P1AH)

								lda _P3AH
								bpl positiv_02
								eor #$FF
								clc
								adc #1
							positiv_02:
								clc
								adc reg0			; a  <- abs(P3AH) + abs(P1AH)
								bpl guessIfFace2BeDrawn_found03 ; FIXME if sign bit is set <= 127 considtion rather than < 127

							.)
								jmp guessIfFace2BeDrawn_midscreencrossed_04
guessIfFace2BeDrawn_found03:
    //                             isFace2BeDrawn=1;
									lda #1
									sta _isFace2BeDrawn
									jmp guessIfFace2BeDrawn_done
    //                         }
    //                     }
    //                 }
guessIfFace2BeDrawn_midscreencrossed_04:
    //                 if ((P1AH & 0x80) != (P3AH & 0x80)) {
						lda _P1AH 
						eor _P3AH
						and #$80
						bne guessIfFace2BeDrawn_tmp01
						jmp guessIfFace2BeDrawn_done
    //                     if (abs(P3AH) < 127 - abs(P1AH)) {
guessIfFace2BeDrawn_tmp01:
						.(		
							lda _P1AH
							bpl positiv_01
							eor #$FF
							clc
							adc #1
						positiv_01:
							sta reg0			; reg 0 <- abs(P1AH)

							lda _P3AH
							bpl positiv_02
							eor #$FF
							clc
							adc #1
						positiv_02:
							clc
							adc reg0			; a  <- abs(P3AH) + abs(P1AH)
							bpl guessIfFace2BeDrawn_found04 ; FIXME if sign bit is set <= 127 considtion rather than < 127

						.)		
							jmp guessIfFace2BeDrawn_done
guessIfFace2BeDrawn_found04:
    //                         isFace2BeDrawn=1;
								lda #1
								sta _isFace2BeDrawn
								jmp guessIfFace2BeDrawn_done
    //                     }
    //                 }
    //             }
guessIfFace2BeDrawn_p2back:
    //         } else {
    //             // P2 BACK
    //             if ((P1AH & 0x80) != (P2AH & 0x80)) {
					lda _P1AH 
					eor _P2AH
					and #$80
					beq guessIfFace2BeDrawn_midscreencrossed_05
    //                 if (abs(P2AH) < 127 - abs(P1AH)) {
					.(		
						lda _P1AH
						bpl positiv_01
						eor #$FF
						clc
						adc #1
					positiv_01:
						sta reg0			; reg 0 <- abs(P1AH)

						lda _P3AH
						bpl positiv_02
						eor #$FF
						clc
						adc #1
					positiv_02:
						clc
						adc reg0			; a  <- abs(P3AH) + abs(P1AH)
						bpl guessIfFace2BeDrawn_found05 ; FIXME if sign bit is set <= 127 considtion rather than < 127

					.)	
						jmp guessIfFace2BeDrawn_midscreencrossed_06
guessIfFace2BeDrawn_found05:
    //                     isFace2BeDrawn=1;
							lda #1
							sta _isFace2BeDrawn
							jmp guessIfFace2BeDrawn_done
    //                 }
guessIfFace2BeDrawn_midscreencrossed_05:
    //             } else {
    //                 if ((P1AH & 0x80) != (P3AH & 0x80)) {
						lda _P1AH 
						eor _P3AH
						and #$80
						beq guessIfFace2BeDrawn_midscreencrossed_06
    //                     if (abs(P3AH) < 127 - abs(P1AH)) {
						.(		
							lda _P1AH
							bpl positiv_01
							eor #$FF
							clc
							adc #1
						positiv_01:
							sta reg0			; reg 0 <- abs(P1AH)

							lda _P3AH
							bpl positiv_02
							eor #$FF
							clc
							adc #1
						positiv_02:
							clc
							adc reg0			; a  <- abs(P3AH) + abs(P1AH)
							bpl guessIfFace2BeDrawn_found06 ; FIXME if sign bit is set <= 127 considtion rather than < 127

						.)	
							jmp guessIfFace2BeDrawn_midscreencrossed_06
guessIfFace2BeDrawn_found06:
    //                         isFace2BeDrawn=1;
								lda #1
								sta _isFace2BeDrawn
								jmp guessIfFace2BeDrawn_done
    //                     }
    //                 }
    //             }
guessIfFace2BeDrawn_midscreencrossed_06:
    //             if ((P1AH & 0x80) != (P3AH & 0x80)) {
					lda _P1AH 
					eor _P3AH
					and #$80
					beq guessIfFace2BeDrawn_done
    //                 if (abs(P3AH) < 127 - abs(P1AH)) {
						.(		
							lda _P1AH
							bpl positiv_01
							eor #$FF
							clc
							adc #1
						positiv_01:
							sta reg0			; reg 0 <- abs(P1AH)

							lda _P3AH
							bpl positiv_02
							eor #$FF
							clc
							adc #1
						positiv_02:
							clc
							adc reg0			; a  <- abs(P3AH) + abs(P1AH)
							bmi guessIfFace2BeDrawn_done ; FIXME if sign bit is set <= 127 considtion rather than < 127

						.)
    //                     isFace2BeDrawn=1;
								lda #1
								sta _isFace2BeDrawn
								jmp guessIfFace2BeDrawn_done
    //                 }
    //             }
    //         }
    //     }
guessIfFace2BeDrawn_p1back:
    // } else {
    //     // P1 BACK
    //     // _1_ nothing to do
    // }

guessIfFace2BeDrawn_done:

	// restore context
	pla: sta tmp1
	pla: sta tmp0
	pla: sta reg1
	pla: sta reg0
	pla

	; jmp leave :

.)
    rts
#endif



#ifdef USE_ASM_GLDRAWSEGMENTS
//void glDrawSegments() {
_glDrawSegments:
.(
#ifdef USE_PROFILER
PROFILE_ENTER(ROUTINE_GLDRAWSEGMENTS);
#endif // USE_PROFILER

	// Save context
	lda reg0 : pha 

    ldy _nbSegments
    jmp glDrawSegments_nextSegment
//     for (ii = 0; ii < nbSegments; ii++) {

glDrawSegments_loop:

//         idxPt1    = segmentsPt1[ii];
        lda _segmentsPt1,y : sta _idxPt1
//         idxPt2    = segmentsPt2[ii];
        lda _segmentsPt2,y : sta _idxPt2
//         ch2disp = segmentsChar[ii];
        lda _segmentsChar,y : sta _ch2disp

//         // dmoy = (d1+d2)/2;
        sty reg0
        ldy _idxPt1
#ifdef ANGLEONLY
//         P1AH = points2aH[idxPt1];
        lda _points2aH, y : sta _P1AH
//         P1AV = points2aV[idxPt1];
        lda _points2aV, y : sta _P1AV
#else 
//         P1X = points2aH[idxPt1];
        lda _points2aH, y : sta _P1X
//         P1Y = points2aV[idxPt1];
        lda _points2aV, y : sta _P1Y
#endif
//         dmoy = points2dL[idxPt1];
        lda _points2dL,y : sta _dmoy: lda _points2dH,y : sta _dmoy+1

        ldy _idxPt2
#ifdef ANGLEONLY
//         P2AH = points2aH[idxPt2];
        lda _points2aH, y : sta _P2AH
//         P2AV = points2aV[idxPt2];
        lda _points2aV, y : sta _P2AV
#else 
//         P2X = points2aH[idxPt2];
        lda _points2aH, y : sta _P2X
//         P2Y = points2aV[idxPt2];
        lda _points2aV, y : sta _P2Y
#endif        
//         dmoy += points2dL[idxPt2];
        clc: lda _points2dL,y : adc _dmoy: sta _dmoy : lda _points2dH,y : adc _dmoy+1 :sta _dmoy+1

//         dmoy = dmoy >> 1;
//         //if (dmoy >= 256) {
//         if ((dmoy & 0xFF00) != 0)
//             continue;
        lda _dmoy+1
        
        beq moynottoobig		// FIXME :: it should be possible to deal with case *(dmoy+1) = 1
        lda #$FF
        sta _distseg
        bne glDrawSegments_drawline
moynottoobig:
        lda _dmoy
        lsr
        sta _distseg
//         distseg = (unsigned char)((dmoy)&0x00FF);
//         distseg--;  // FIXME

glDrawSegments_drawline:
        dec _distseg

#ifdef ANGLEONLY
//         P1X = (SCREEN_WIDTH - P1AH) >> 1;
        sec
        lda #SCREEN_WIDTH
        sbc _P1AH
        cmp #$80
        ror
        sta _P1X

//         P1Y = (SCREEN_HEIGHT - P1AV) >> 1;
        sec
        lda #SCREEN_HEIGHT
        sbc _P1AV
        cmp #$80
        ror
        sta _P1Y

//         P2X = (SCREEN_WIDTH - P2AH) >> 1;
        sec
        lda #SCREEN_WIDTH
        sbc _P2AH
        cmp #$80
        ror
        sta _P2X
//         P2Y = (SCREEN_HEIGHT - P2AV) >> 1;
        sec
        lda #SCREEN_HEIGHT
        sbc _P2AV
        cmp #$80
        ror
        sta _P2Y
#endif
//         lrDrawLine();
        jsr _lrDrawLine

    ldy reg0

glDrawSegments_nextSegment:
	dey 
    bmi glDrawSegments_done
	jmp glDrawSegments_loop
    // }

glDrawSegments_done:
	// Restore context
	pla : sta reg0

#ifdef USE_PROFILER
PROFILE_LEAVE(ROUTINE_GLDRAWSEGMENTS);
#endif // USE_PROFILER
.)
    rts
#endif // USE_ASM_GLDRAWSEGMENTS

