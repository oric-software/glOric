

.zero
Tmp .dsb 2

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

.zero
tmpufnX .dsb 1
tmpufnY .dsb 1

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