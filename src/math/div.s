


;http://www.6502.org/source/integers/ummodfix/ummodfix.htm
; +-----|-----+-----|-----+-----|-----+-----|------+
; |  DIVISOR  |    D I V I D E N D    |SCRAT|      |
; |           |  hi cell     lo cell  |CHPAD| CARRY|
; |  N    N+1 | N+2   N+3 | N+4   N+5 | N+6   N+7  |
; +-----|-----+-----|-----+-----|-----+-----|------+
; |           | REMAINDER | QUOTIENT  |            |
; +-----|-----+-----|-----+-----|-----+-----|------+
; Both divisor and dividend must be positive numbers
; We must have Dividend Hi Cell < Divisor
; If not, QUOTIENT=FF, REMAINDER=FF is returned
_N    .dsb 7
CARRY .dsb 1

_div32by16
.(
  START:  SEC             ; Detect overflow or /0 condition.
          LDA     _N+2     ; Divisor must be more than high cell of dividend.  To
          SBC     _N       ; find out, subtract divisor from high cell of dividend;
          LDA     _N+3     ; if carry flag is still set at the end, the divisor was
          SBC     _N+1     ; not big enough to avoid overflow. This also takes care
          BCS     oflo   ; of any /0 condition.  Branch if overflow or /0 error.
                          ; We will loop 16 times; but since we shift the dividend
          LDX     #$11    ; over at the same time as shifting the answer in, the
                          ; operation must start AND finish with a shift of the
                          ; low cell of the dividend (which ends up holding the
                          ; quotient), so we start with 17 (11H) in X.
loop:  ROL     _N+4     ; Move low cell of dividend left one bit, also shifting
          ROL     _N+5     ; answer in. The 1st rotation brings in a 0, which later
                          ; gets pushed off the other end in the last rotation.
          DEX
          BEQ     end    ; Branch to the end if finished.

          ROL     _N+2     ; Shift high cell of dividend left one bit, also
          ROL     _N+3     ; shifting next bit in from high bit of low cell.
          LDA #0
          STA CARRY
          ;STZ     CARRY   ; Zero old bits of CARRY so subtraction works right.
          ROL     CARRY   ; Store old high bit of dividend in CARRY.  (For STZ
                          ; one line up, NMOS 6502 will need LDA #0, STA CARRY.)
          SEC             ; See if divisor will fit into high 17 bits of dividend
          LDA     _N+2     ; by subtracting and then looking at carry flag.
          SBC     _N       ; First do low byte.
          STA     _N+6     ; Save difference low byte until we know if we need it.
          LDA     _N+3     ;
          SBC     _N+1     ; Then do high byte.
          TAY             ; Save difference high byte until we know if we need it.
          LDA     CARRY   ; Bit 0 of CARRY serves as 17th bit.
          SBC     #0      ; Complete the subtraction by doing the 17th bit before
          BCC     loop    ; determining if the divisor fit into the high 17 bits
                          ; of the dividend.  If so, the carry flag remains set.
          LDA     _N+6     ; If divisor fit into dividend high 17 bits, update
          STA     _N+2     ; dividend high cell to what it would be after
          STY     _N+3     ; subtraction.
          BCS     loop    ; Always branch.  NMOS 6502 could use BCS here.

oflo: LDA     #$FF    ; If overflow occurred, put FF
          STA     _N+2     ; in remainder low byte
          STA     _N+3     ; and high byte,
          STA     _N+4     ; and in quotient low byte
          STA     _N+5     ; and high byte.
end:
.)
	RTS
