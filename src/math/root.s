.zero
NUM:
_square    .byt 0,0,0     ; input number
storage   .byt 0,0,0     ; temporary data
ROOT:
_thesqrt      .byt 0,0       ; result
REM:
remainder .byt 0,0       ; result remainder

.text

;http://6502org.wikidot.com/software-math-sqrt

_sqrt_16:
.(
   LDA #0
   STA ROOT
   STA REM
   LDX #8
L1 SEC
   LDA NUM+1 ; NUMH
   SBC #$40
   TAY
   LDA REM
   SBC ROOT
   BCC L2
   STY NUM+1 ; NUMH
   STA REM
L2 ROL ROOT
   ASL NUM
   ROL NUM+1 ; NUMH
   ROL REM
   ASL NUM
   ROL NUM+1 ; NUMH
   ROL REM
   DEX
   BNE L1
.)
  RTS

_fastsqrt_16:
.(
   LDA #0
   STA ROOT
   STA REM
   ;LDX #8
   
   ; X = 8
       SEC
       LDA NUM+1 ; NUMH
       SBC #$40
       TAY
       LDA REM
       SBC ROOT
       BCC L21
       STY NUM+1 ; NUMH
       STA REM
L21     ROL ROOT
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM

   ; X = 7
       SEC
       LDA NUM+1 ; NUMH
       SBC #$40
       TAY
       LDA REM
       SBC ROOT
       BCC L22
       STY NUM+1 ; NUMH
       STA REM
L22    ROL ROOT
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM

   ; X = 6
       SEC
       LDA NUM+1 ; NUMH
       SBC #$40
       TAY
       LDA REM
       SBC ROOT
       BCC L23
       STY NUM+1 ; NUMH
       STA REM
L23    ROL ROOT
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM

   ; X = 5
       SEC
       LDA NUM+1 ; NUMH
       SBC #$40
       TAY
       LDA REM
       SBC ROOT
       BCC L24
       STY NUM+1 ; NUMH
       STA REM
L24    ROL ROOT
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM

   ; X = 4
       SEC
       LDA NUM+1 ; NUMH
       SBC #$40
       TAY
       LDA REM
       SBC ROOT
       BCC L25
       STY NUM+1 ; NUMH
       STA REM
L25    ROL ROOT
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM

   ; X = 3
       SEC
       LDA NUM+1 ; NUMH
       SBC #$40
       TAY
       LDA REM
       SBC ROOT
       BCC L26
       STY NUM+1 ; NUMH
       STA REM
L26    ROL ROOT
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM

   ; X = 2
       SEC
       LDA NUM+1 ; NUMH
       SBC #$40
       TAY
       LDA REM
       SBC ROOT
       BCC L27
       STY NUM+1 ; NUMH
       STA REM
L27    ROL ROOT
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM

   ; X = 1
       SEC
       LDA NUM+1 ; NUMH
       SBC #$40
       TAY
       LDA REM
       SBC ROOT
       BCC L28
       STY NUM+1 ; NUMH
       STA REM
L28    ROL ROOT
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM
       ASL NUM
       ROL NUM+1 ; NUMH
       ROL REM

   ;DEX
   ;BNE L1


.)
  RTS


;https://codebase64.org/doku.php?id=base:16bit_and_24bit_sqrt
;-----------------------------------
;   Square Root of a 24bit number
;-----------------------------------
; by Verz - Jul2019
;-----------------------------------
;
;  load the 24bit input in square
;  16bit result in  sqrt & remainder
;-----------------------------------


_sqrt24:
.(
        LDY #$01        ; lsby of first odd number = 1
        STY storage
        DEY
        STY storage+1   ; msby of first odd number (_thesqrt = 0)
        sty storage+2
        sty _thesqrt
        sty _thesqrt+1
again
        SEC
        LDA _square     ; save remainder
        sta remainder
        SBC storage    ; subtract odd lo from integer lo
        STA _square
        LDA _square+1
        sta remainder+1
        SBC storage+1   ; subtract odd mid from integer mid
        STA _square+1
        lda _square+2
        sbc storage+2   ; subtract odd hi from integer hi
        sta _square+2
        BCC nomore    ; is subtract result negative?
        INC _thesqrt      ; no. increment _square root
        bne sqnxt
        inc _thesqrt+1
sqnxt   LDA storage     ; calculate next odd number
        ADC #$01        ; +1+C(=1)
        STA storage
        BCC again
        lda storage+1
        adc #$00
        sta storage+1
        bcc again
        INC storage+2
        JMP again
nomore
.)
        RTS
