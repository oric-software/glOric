
#define A_ZERO        #$00
#define A_PI_OVER_4   #$20
#define A_PI_OVER_2   #$40
#define A_3_PI_OVER_4 #$60
#define A_PI          #$80
#define A_5_PI_OVER_4 #$A0
#define A_3_PI_OVER_2 #$C0
#define A_7_PI_OVER_4 #$E0


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
