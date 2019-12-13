


.zero

Tempsq:                     ; temp byte for intermediate result
    .byte $00

_Squarel             ; square low byte
_Squareh	= _Squarel+1 ; square high byte
    .word $FFFF

_Numberl  .byte $FF            ; number to square low byte
_Numberh  .byte $FF ; number to square high byte


.text

;http://www.6502.org/source/integers/square.htm
_Square8:
.(
    LDA #$00        ; clear A
    STA _Squarel     ; clear square low byte
                    ; (no need to clear the high byte, it gets shifted out)
    LDA	_Numberl     ; get number low byte
	LDX	_Numberh     ; get number high  byte
	BPL	NoNneg      ; if +ve don't negate it
                            ; else do a two's complement
	EOR	#$FF        ; invert
    SEC	            ; +1
	ADC	#$00        ; and add it

NoNneg:
	STA	Tempsq      ; save ABS(number)
	LDX	#$08        ; set bit count

Nextr2bit:
	ASL	_Squarel     ; low byte *2
	ROL	_Squareh     ; high byte *2+carry from low
	ASL	            ; shift number byte
	BCC	NoSqadd     ; don't do add if C = 0
	TAY                 ; save A
	CLC                 ; clear carry for add
	LDA	Tempsq      ; get number
	ADC	_Squarel     ; add number^2 low byte
	STA	_Squarel     ; save number^2 low byte
	LDA	#$00        ; clear A
	ADC	_Squareh     ; add number^2 high byte
	STA	_Squareh     ; save number^2 high byte
	TYA                 ; get A back

NoSqadd:
	DEX                 ; decrement bit count
	BNE	Nextr2bit   ; go do next bit
.)
	RTS

_fastSquare8:
.(
    LDA #$00        ; clear A
    STA _Squarel     ; clear square low byte
                    ; (no need to clear the high byte, it gets shifted out)
    LDA	_Numberl     ; get number low byte
	;LDX	_Numberh     ; get number high  byte
	BPL	NoNneg      ; if +ve don't negate it
                            ; else do a two's complement
	EOR	#$FF        ; invert
    SEC	            ; +1
	ADC	#$00        ; and add it

NoNneg:
	STA	Tempsq      ; save ABS(number)
	LDX	#$08        ; set bit count

Nextr2bit:
	ASL	_Squarel     ; low byte *2
	ROL	_Squareh     ; high byte *2+carry from low
	ASL	            ; shift number byte
	BCC	NoSqadd     ; don't do add if C = 0
	TAY                 ; save A
	CLC                 ; clear carry for add
	LDA	Tempsq      ; get number
	ADC	_Squarel     ; add number^2 low byte
	STA	_Squarel     ; save number^2 low byte
	LDA	#$00        ; clear A
	ADC	_Squareh     ; add number^2 high byte
	STA	_Squareh     ; save number^2 high byte
	TYA                 ; get A back

NoSqadd:
	DEX                 ; decrement bit count
	BNE	Nextr2bit   ; go do next bit
.)
	RTS

; By Jean-Baptiste PERIN (jbperin)
; extension of routine by Lee Davison at http://www.6502.org/source/integers/square.htm
; Calculates the 32 bits unsigned integer square of the signed 16 bit integer in
; Numberl/Numberh.  The result is always in the range 0 to ‭4294836225‬ and is held in
; Square1/Square2/Square3/Square4
;
; Destroys all registers


_Square1  .byte $00 ; square low bytes
_Square2  .byte $00
_Square3  .byte $00 ; square high bytes
_Square4  .byte $00



TempForRoot1:                     ; temp byte for intermediate result
    .byte $00
TempForRoot2:
    .byte $00

Accu1:
    .byte $00
Accu2:
    .byte $00



_Square16:
.(
	////    S = 0
	LDA     #$00        ; clear A
	STA     _Square1     ; clear square low byte
						; (no need to clear the high byte, it gets shifted out)

	////   A = N
	LDA	_Numberl     ; get number low byte
	LDX	_Numberh     ; get number high  byte

	////    If  N<0
	BPL	NoNneg      ; if +ve don t negate it
                            ; else do a two s complement
	////		T = -N
	EOR	#$FF        ; invert
    SEC	            ; +1
	ADC	#$00        ; and add it
	STA TempForRoot1
	STA Accu1

	TXA				; A <- HiPart (Number)
	EOR	#$FF        ; invert
	ADC #$00		; Propagate carry
	STA TempForRoot2
	STA Accu2
	JMP startloop

	////    Else
NoNneg:
	////		T = N
	STA	TempForRoot1      ; save ABS(number)
	STA Accu1
	STX	TempForRoot2
	STX Accu2
	////    EndIf

startloop:

	////    For X = 16 -> 0
	LDX	#$10        ; 16 bits operands

Nextr2bit:
	//// 		S = S * 2
	ASL	_Square1     ; low byte *2
	ROL	_Square2     ; high byte *2+carry from low
	ROL	_Square3     ; propagate
	ROL	_Square4     ; propagate

	//// 		A = A * 2
	ASL	 Accu1          ; shift number byte
	ROL	 Accu2

	////    	If  Carry != 0
	BCC	NoSqadd     ; don t do add if C = 0
	TAY                 ; save A
	CLC                 ; clear carry for add
	////    		S = S + T
	LDA	TempForRoot1      ; get number
	ADC	_Square1     ; add number^2 low byte
	STA	_Square1     ; save number^2 low byte
	LDA	TempForRoot2
	ADC	_Square2     ; add number^2 high bytes
	STA	_Square2     ; save number^2 high bytes
	LDA #$00
	ADC	_Square3
	STA	_Square3
	LDA #$00
	ADC	_Square4
	STA	_Square4
	TYA                 ; get A back
	////    	EndIf

NoSqadd:
	////    Next X
	DEX                 ; decrement bit count
	BNE	Nextr2bit   ; go do next bit
.)
	RTS
