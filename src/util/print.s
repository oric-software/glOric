
;
; This is a simple display module
; called by the C part of the program
;



;
; We define the adress of the TEXT screen.
;
#define DISPLAY_ADRESS $BB80


;
; We use a table of bytes to avoid the multiplication 
; by 40. We could have used a multiplication routine
; but introducing table accessing is not a bad thing.
; In order to speed up things, we precompute the real
; adress of each start of line. Each table takes only
; 28 bytes, even if it looks impressive at first glance.
;

; This table contains lower 8 bits of the adress
ScreenAdressLow
	.byt <(DISPLAY_ADRESS+40*0)
	.byt <(DISPLAY_ADRESS+40*1)
	.byt <(DISPLAY_ADRESS+40*2)
	.byt <(DISPLAY_ADRESS+40*3)
	.byt <(DISPLAY_ADRESS+40*4)
	.byt <(DISPLAY_ADRESS+40*5)
	.byt <(DISPLAY_ADRESS+40*6)
	.byt <(DISPLAY_ADRESS+40*7)
	.byt <(DISPLAY_ADRESS+40*8)
	.byt <(DISPLAY_ADRESS+40*9)
	.byt <(DISPLAY_ADRESS+40*10)
	.byt <(DISPLAY_ADRESS+40*11)
	.byt <(DISPLAY_ADRESS+40*12)
	.byt <(DISPLAY_ADRESS+40*13)
	.byt <(DISPLAY_ADRESS+40*14)
	.byt <(DISPLAY_ADRESS+40*15)
	.byt <(DISPLAY_ADRESS+40*16)
	.byt <(DISPLAY_ADRESS+40*17)
	.byt <(DISPLAY_ADRESS+40*18)
	.byt <(DISPLAY_ADRESS+40*19)
	.byt <(DISPLAY_ADRESS+40*20)
	.byt <(DISPLAY_ADRESS+40*21)
	.byt <(DISPLAY_ADRESS+40*22)
	.byt <(DISPLAY_ADRESS+40*23)
	.byt <(DISPLAY_ADRESS+40*24)
	.byt <(DISPLAY_ADRESS+40*25)
	.byt <(DISPLAY_ADRESS+40*26)
	.byt <(DISPLAY_ADRESS+40*27)

; This table contains hight 8 bits of the adress
ScreenAdressHigh
	.byt >(DISPLAY_ADRESS+40*0)
	.byt >(DISPLAY_ADRESS+40*1)
	.byt >(DISPLAY_ADRESS+40*2)
	.byt >(DISPLAY_ADRESS+40*3)
	.byt >(DISPLAY_ADRESS+40*4)
	.byt >(DISPLAY_ADRESS+40*5)
	.byt >(DISPLAY_ADRESS+40*6)
	.byt >(DISPLAY_ADRESS+40*7)
	.byt >(DISPLAY_ADRESS+40*8)
	.byt >(DISPLAY_ADRESS+40*9)
	.byt >(DISPLAY_ADRESS+40*10)
	.byt >(DISPLAY_ADRESS+40*11)
	.byt >(DISPLAY_ADRESS+40*12)
	.byt >(DISPLAY_ADRESS+40*13)
	.byt >(DISPLAY_ADRESS+40*14)
	.byt >(DISPLAY_ADRESS+40*15)
	.byt >(DISPLAY_ADRESS+40*16)
	.byt >(DISPLAY_ADRESS+40*17)
	.byt >(DISPLAY_ADRESS+40*18)
	.byt >(DISPLAY_ADRESS+40*19)
	.byt >(DISPLAY_ADRESS+40*20)
	.byt >(DISPLAY_ADRESS+40*21)
	.byt >(DISPLAY_ADRESS+40*22)
	.byt >(DISPLAY_ADRESS+40*23)
	.byt >(DISPLAY_ADRESS+40*24)
	.byt >(DISPLAY_ADRESS+40*25)
	.byt >(DISPLAY_ADRESS+40*26)
	.byt >(DISPLAY_ADRESS+40*27)



#ifdef USE_ASM_PLOT

_asmplot:
.(

	lda		_plotY
    beq		asmplot_done
    bmi		asmplot_done
#ifdef USE_COLOR
    cmp		#SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR
#else
	cmp		#SCREEN_HEIGHT
#endif
    bcs		asmplot_done
    tax

	lda		_plotX
#ifdef USE_COLOR
	sec
	sbc		#COLUMN_OF_COLOR_ATTRIBUTE
	bvc		*+4
	eor		#$80
	bmi		asmplot_done

	lda		_plotX				; Reload X coordinate
    cmp		#SCREEN_WIDTH
    bcs		asmplot_done

#else
    beq		asmplot_done
    bmi		asmplot_done
    cmp		#SCREEN_WIDTH
    bcs		asmplot_done
#endif

	lda tmp0: pha: lda tmp0+1 : pha 

	ldx		_plotY    ; reload Y coordinate
	lda		ScreenAdressLow,x	; Get the LOW part of the fbuffer adress
	clc						; Clear the carry (because we will do an addition after)

	adc		_plotX				; Add X coordinate
	sta		tmp0 ; ptrFbuf
	lda		ScreenAdressHigh,x	; Get the HIGH part of the fbuffer adress
	adc		#0					; Eventually add the carry to complete the 16 bits addition
	sta		tmp0+1	 ; ptrFbuf+ 1			

	lda		_ch2disp		; Access char2disp
	ldx		#0
	sta		(tmp0,x)

	pla: sta tmp0+1: pla: sta tmp0
asmplot_done:
.)
	rts


;; void plot(signed char X,
;;           signed char Y,
;;           char          char2disp) {

_plot:
.(
	; ldx #10 : lda #2 : jsr enter :

	ldy #0
	lda (sp),y				; Access X coordinate
	sta _plotX


	ldy #2
	lda (sp),y				; Access Y coordinate
	sta _plotY
	

	ldy #4
	lda (sp),y				; Access Y coordinate
	sta _ch2disp 

	jsr _asmplot

.)
	rts 
#endif // USE_ASM_PLOT


;
; The message and display position will be read from the stack.
; sp+0 => X coordinate
; sp+2 => Y coordinate
; sp+4 => Adress of the message to display
;
_AdvancedPrint
.(
	; Initialise display adress
	; this uses self-modifying code
	; (the $0123 is replaced by display adress)
	
	; The idea is to get the Y position from the stack,
	; and use it as an index in the two adress tables.
	; We also need to add the value of the X position,
	; also taken from the stack to the resulting value.
	
	ldy #2
	lda (sp),y				; Access Y coordinate
	tax
	
	lda ScreenAdressLow,x	; Get the LOW part of the screen adress
	clc						; Clear the carry (because we will do an addition after)
	ldy #0
	adc (sp),y				; Add X coordinate
	sta write+1
	lda ScreenAdressHigh,x	; Get the HIGH part of the screen adress
	adc #0					; Eventually add the carry to complete the 16 bits addition
	sta write+2				



	; Initialise message adress using the stack parameter
	; this uses self-modifying code
	; (the $0123 is replaced by message adress)
	ldy #4
	lda (sp),y
	sta read+1
	iny
	lda (sp),y
	sta read+2


	; Start at the first character
	ldx #0
loop_char

	; Read the character, exit if it is a 0
read
	lda $0123,x
	beq end_loop_char

	; Write the character on screen
write
	sta $0123,x

	; Next character, and loop
	inx
	jmp loop_char  

	; Finished !
end_loop_char
.)
	rts

;
; The message and display position will be read from the stack.
; sp+0 => X coordinate
; sp+2 => Y coordinate
; sp+4 => ascii code of character to display
;
_PutChar
.(
	; Initialise display adress
	; this uses self-modifying code
	; (the $0123 is replaced by display adress)
	
	; The idea is to get the Y position from the stack,
	; and use it as an index in the two adress tables.
	; We also need to add the value of the X position,
	; also taken from the stack to the resulting value.
	
	ldy #2
	lda (sp),y				; Access Y coordinate
	tax
	
	lda ScreenAdressLow,x	; Get the LOW part of the screen adress
	clc						; Clear the carry (because we will do an addition after)
	ldy #0
	adc (sp),y				; Add X coordinate
	sta write+1
	lda ScreenAdressHigh,x	; Get the HIGH part of the screen adress
	adc #0					; Eventually add the carry to complete the 16 bits addition
	sta write+2				



	; Initialise message adress using the stack parameter
	; this uses self-modifying code
	; (the $0123 is replaced by message adress)
	ldy #4
	lda (sp),y

	; Write the character on screen
write
	sta $0123
.)
	rts

