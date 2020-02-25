
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
        jsr _project_i16

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


