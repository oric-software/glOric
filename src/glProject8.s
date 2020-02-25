#include "config.h"

#ifdef USE_REWORKED_PROJECTION
_project_i8o8:
.(
	// save context
	pha

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
debugici:
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
	pla
.)
	rts


/*
_project16:
.(
	// save context
	pha

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
	jsr _fastatan2 ; _atan2_8
	lda _res
	sta _AngleH

	// Norm = norm (DeltaX, DeltaY)
	jsr _hyperfastnorm; fastnorm ; ultrafastnorm ; ;

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
	jsr _fastatan2 ; _atan2_8
	lda _res
	sta _AngleV

	// AnglePH = AngleH - CamRotZ
	sec
	lda _AngleH
	sbc _CamRotZ
	sta AnglePH
	bvc project_noHAngleOverflow
	lda #$80
	sta HAngleOverflow

project_noHAngleOverflow:
	// AnglePV = AngleV - CamRotX
	sec
	lda _AngleV
	sbc _CamRotX
	sta AnglePV
	bvc project_noVAngleOverflow
	lda #$80
	sta VAngleOverflow

project_noVAngleOverflow:
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
debugici:
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
	pla
.)
	rts
*/


/*
.zero
octant			.dsb 1          ;

.text

_tx				.dsb 1
_ty				.dsb 1
_res			.dsb 1
*/
;https://codebase64.org/doku.php?id=base:8bit_atan2_8-bit_angle
/*
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
    lda log2_tab,x
    sbc log2_tab,y
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
*/
/*
.zero

absX            .dsb 1
absY            .dsb 1
tmpufnX         .dsb 1
tmpufnY         .dsb 1
*/
.text
/*
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
*/
;;void projectPoint(
;;	signed char x, 
;;	signed char y , 
;;	signed char z, 
;;	unsigned char options, 
;;	signed char *ah, 
;;	signed char *av,
;;	unsigned int *dist,
;;)

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



#endif // USE_REWORKED_PROJECTION
