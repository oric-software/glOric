;; FIXME #include "glOric.h"
#define SCREEN_WIDTH            40
#define SCREEN_HEIGHT           26
;;


.zero
_glTabSprite .dsb 2

.text

;; unsigned char glSpriteNbCar;
;; unsigned char glSpriteCarIdx;
#define NB_MAX_SPRITES 16

_glNbSprites    .dsb 1
_glSpriteIdx    .dsb 1

_glSpriteNbCar  .dsb 1
_glSpriteCarIdx .dsb 1

_glSpriteX .dsb NB_MAX_SPRITES
_glSpriteY .dsb NB_MAX_SPRITES
_glSpriteZ .dsb NB_MAX_SPRITES
_glSprites .dsb 2*NB_MAX_SPRITES

; The sprite and display position will be read from the stack.
; sp+0 => X coordinate
; sp+2 => Y coordinate
; sp+4 => Z coordinate
; sp+6 => Adress of the sprite definition

_glAddSprite:
.(

	ldy #0
	lda (sp),y				; Access X coordinate
    ldy _glNbSprites
    sta _glSpriteX,y

	ldy #2
	lda (sp),y				; Access Y coordinate
    ldy _glNbSprites
    sta _glSpriteY,y

	ldy #4
	lda (sp),y				; Access Y coordinate
    ldy _glNbSprites
    sta _glSpriteZ,y

	ldy #6
	lda (sp),y				; Access Y coordinate
    sta tmp0
	ldy #7
	lda (sp),y				; Access Y coordinate
    sta tmp0+1
    lda _glNbSprites
    asl
    tay
    lda tmp0
    sta _glSprites,y
    iny
    lda tmp0+1
    sta _glSprites,y

    inc _glNbSprites



	;;ldx #6 : lda #0 : jsr enter :
	;; ldy #0 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	;; ldy #0 : lda tmp0 : sta (ap),y :
	;; ldy #2 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	;; ldy #2 : lda tmp0 : sta (ap),y :
	;; ldy #4 : lda (ap),y : sta tmp0 : iny : lda (ap),y : sta tmp0+1 :
	;; ldy #4 : lda tmp0 : sta (ap),y :
	;; lda _glNbSprites : sta tmp0 :
	;; lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
	;; clc : lda #<(_glSpriteX) : adc tmp0 : sta tmp0 : lda #>(_glSpriteX) : adc tmp0+1 : sta tmp0+1 :
	;; ldy #0 : lda (ap),y : sta tmp1 :
	;; ldy #0 : lda tmp1 : sta (tmp0),y :
	;; lda _glNbSprites : sta tmp0 :
	;; lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
	;; clc : lda #<(_glSpriteY) : adc tmp0 : sta tmp0 : lda #>(_glSpriteY) : adc tmp0+1 : sta tmp0+1 :
	;; ldy #2 : lda (ap),y : sta tmp1 :
	;; ldy #0 : lda tmp1 : sta (tmp0),y :
	;; lda _glNbSprites : sta tmp0 :
	;; lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
	;; clc : lda #<(_glSpriteZ) : adc tmp0 : sta tmp0 : lda #>(_glSpriteZ) : adc tmp0+1 : sta tmp0+1 :
	;; ldy #4 : lda (ap),y : sta tmp1 :
	;; ldy #0 : lda tmp1 : sta (tmp0),y :
	;; lda _glNbSprites : sta tmp0 :
	;; lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
	;; lda tmp0 : asl : sta tmp0 : lda tmp0+1 : rol : sta tmp0+1 :
	;; clc : lda #<(_glSprites) : adc tmp0 : sta tmp0 : lda #>(_glSprites) : adc tmp0+1 : sta tmp0+1 :
	;; ldy #6 : lda (ap),y : sta tmp1 : iny : lda (ap),y : sta tmp1+1 :
	;; ldy #0 : lda tmp1 : sta (tmp0),y : iny : lda tmp1+1 : sta (tmp0),y :
	;; lda _glNbSprites : sta tmp0 :
	;; lda tmp0 : sta tmp0 : lda #0 : sta tmp0+1 :
	;; inc tmp0 : .( : bne skip : inc tmp0+1 :skip : .)  :
	;; lda tmp0 : sta _glNbSprites :
	;; jmp leave :
.)
    rts

_glDrawSprites:
.(
    ;;for (glSpriteIdx = 0; glSpriteIdx < 16; glSpriteIdx++)
    lda #0: sta _glSpriteIdx
loopSprites:

        ;;PointX = starX[glSpriteIdx];
        ;;PointY = starY[glSpriteIdx];
        ;;PointZ = starZ[glSpriteIdx];
        ;;glTabSprite = starSprite[glSpriteIdx];
        ldy _glSpriteIdx: 
        lda _glSpriteX,y : sta _PointX:
        lda _glSpriteY,y : sta _PointY:
        lda _glSpriteZ,y : sta _PointZ:
        tya:
        asl: clc: adc #<(_glSprites): sta tmp0:
        lda #>(_glSprites): adc #0: sta tmp0+1:
        ldy #0: lda (tmp0),y: sta _glTabSprite: iny: lda (tmp0),y: sta _glTabSprite+1:

        ;; project_i8o8();
        jsr _project_i8o8

        
        ;;// sX = (SCREEN_WIDTH - aH) >> 1;
        ;;plotX = (SCREEN_WIDTH - (signed char)ResX) >> 1;
        lda #SCREEN_WIDTH: sec: sbc _ResX: cmp #$80: ror : sta _plotX
        ;;// sY = (SCREEN_HEIGHT - aV) >> 1;
        ;;plotY = (SCREEN_HEIGHT - (signed char)ResY) >> 1;
        lda #SCREEN_HEIGHT: sec: sbc _ResY: cmp #$80: ror : sta _plotY
        ;;distpoint = Norm;
        lda _Norm: sta _distpoint
        ;;glSpriteCarIdx=0;
        lda #0: sta _glSpriteCarIdx
        ;;for (glSpriteNbCar = glTabSprite[glSpriteCarIdx++]; glSpriteNbCar >0; glSpriteNbCar --){
         ldy _glSpriteCarIdx 
         lda (_glTabSprite),y
         sta _glSpriteNbCar
         beq endloopcar
         inc _glSpriteCarIdx
loopcar
;;         
;;         ;;    plotX += glTabSprite[glSpriteCarIdx++];
;;         ;;    plotY += glTabSprite[glSpriteCarIdx++];
;;         ;;    ch2disp = glTabSprite[glSpriteCarIdx++]; 
;;         ;;    fastzplot();
            ldy _glSpriteCarIdx: lda (_glTabSprite),y: clc: adc _plotX: sta _plotX: inc _glSpriteCarIdx:
            ldy _glSpriteCarIdx: lda (_glTabSprite),y: clc: adc _plotY: sta _plotY: inc _glSpriteCarIdx:
            ldy _glSpriteCarIdx: lda (_glTabSprite),y: sta _ch2disp: inc _glSpriteCarIdx:
            jsr _fastzplot:
         dec _glSpriteNbCar
         beq endloopcar
         jmp loopcar
 endloopcar        
        ;;}


    inc _glSpriteIdx
    lda _glSpriteIdx
    cmp _glNbSprites
    beq glDrawSprites_done
    jmp loopSprites

glDrawSprites_done:
.)
    rts
