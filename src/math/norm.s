

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
_hyperfastnorm:
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
