#include "config.h"

#ifdef SAVE_ZERO_PAGE
.text
#else
.zero
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

#ifndef TARGET_ORIX
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
#endif


