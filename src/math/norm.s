

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

tmpufn .dsb 1

ultrafastnorm:
.(
IF DX == 0 THEN
	RETURN DY * SQRT(2)
ELSE IF DX < 0 THEN
	TX = -DX
ELSE (DX > 0)
	TX = DX
ENDIF
IF DY == 0 THEN
	RETURN DX * SQRT(2)
ELSE IF DY < 0 THEN
	TY = -DY 
ELSE (DY > 0)
	TY = DY 
ENDIF
IF TX = TY THEN
	RETURN TX * SQRT(2)
ELSE IF TX > TY THEN
	RETURN TX + TY * (SQRT(2) - 1)
ELSE (TX < TY)
	RETURN TY + TX * (SQRT(2) - 1)
.)
  rts
