[TOC]



http://6502.org/source/

https://codebase64.org/doku.php?id=base:6502_6510_maths

## Algo arithmétiques

http://nparker.llx.com/a2/mult.html

https://github.com/oric-software/CBM-Editor/blob/master/Generic.s

### Multiplication 8 bits
```
        LDA #0       ;Initialize RESULT to 0
        LDX #8       ;There are 8 bits in NUM2
L1      LSR NUM2     ;Get low bit of NUM2
        BCC L2       ;0 or 1?
        CLC          ;If 1, add NUM1
        ADC NUM1
L2      ROR A        ;"Stairstep" shift (catching carry from add)
        ROR RESULT
        DEX
        BNE L1
        STA RESULT+1
```

### Multiplication 16 bits
```
        LDA #0       ;Initialize RESULT to 0
        STA RESULT+2
        LDX #16      ;There are 16 bits in NUM2
L1      LSR NUM2+1   ;Get low bit of NUM2
        ROR NUM2
        BCC L2       ;0 or 1?
        TAY          ;If 1, add NUM1 (hi byte of RESULT is in A)
        CLC
        LDA NUM1
        ADC RESULT+2
        STA RESULT+2
        TYA
        ADC NUM1+1
L2      ROR A        ;"Stairstep" shift
        ROR RESULT+2
        ROR RESULT+1
        ROR RESULT
        DEX
        BNE L1
        STA RESULT+3
```

### Division de 2 nombres 16 bits

```
        LDA #0      ;Initialize REM to 0
        STA REM
        STA REM+1
        LDX #16     ;There are 16 bits in NUM1
L1      ASL NUM1    ;Shift hi bit of NUM1 into REM
        ROL NUM1+1  ;(vacating the lo bit, which will be used for the quotient)
        ROL REM
        ROL REM+1
        LDA REM
        SEC         ;Trial subtraction
        SBC NUM2
        TAY
        LDA REM+1
        SBC NUM2+1
        BCC L2      ;Did subtraction succeed?
        STA REM+1   ;If yes, save it
        STY REM
        INC NUM1    ;and record a 1 in the quotient
L2      DEX
        BNE L1
```

### Racine carrée

[Square Root](http://6502org.wikidot.com/software-math-sqrt)
[16 bits square root](http://6502.org/source/integers/root.htm)
[24 bits square root](https://www.codebase64.org/doku.php?id=base:16bit_and_24bit_sqrt)


### Division non signée par une constante:

[Unsigned Integer Division Routines on nes dev](http://forums.nesdev.com/viewtopic.php?f=2&t=11336)

```
; Unsigned Integer Division Routines
; by Omegamatrix


;Divide by 2
;1 byte, 2 cycles
  lsr


;Divide by 3
;18 bytes, 30 cycles
  sta  temp
  lsr
  adc  #21
  lsr
  adc  temp
  ror
  lsr
  adc  temp
  ror
  lsr
  adc  temp
  ror
  lsr


;Divide by 4
;2 bytes, 4 cycles
  lsr
  lsr


;Divide by 5
;18 bytes, 30 cycles
  sta  temp
  lsr
  adc  #13
  adc  temp
  ror
  lsr
  lsr
  adc  temp
  ror
  adc  temp
  ror
  lsr
  lsr


;Divide by 6
;17 bytes, 30 cycles
  lsr
  sta  temp
  lsr
  lsr
  adc  temp
  ror
  lsr
  adc  temp
  ror
  lsr
  adc  temp
  ror
  lsr


;Divide by 7 (From December '84 Apple Assembly Line)
;15 bytes, 27 cycles
  sta  temp
  lsr
  lsr
  lsr
  adc  temp
  ror
  lsr
  lsr
  adc  temp
  ror
  lsr
  lsr


;Divide by 8
;3 bytes, 6 cycles
  lsr
  lsr
  lsr


;Divide by 9
;17 bytes, 30 cycles
  sta  temp
  lsr
  lsr
  lsr
  adc  temp
  ror
  adc  temp
  ror
  adc  temp
  ror
  lsr
  lsr
  lsr


;Divide by 10
;17 bytes, 30 cycles
  lsr
  sta  temp
  lsr
  adc  temp
  ror
  lsr
  lsr
  adc  temp
  ror
  adc  temp
  ror
  lsr
  lsr


;Divide by 11
;20 bytes, 35 cycles
  sta  temp
  lsr
  lsr
  adc  temp
  ror
  adc  temp
  ror
  adc  temp
  ror
  lsr
  adc  temp
  ror
  lsr
  lsr
  lsr


;Divide by 12
;17 bytes, 30 cycles
  lsr
  lsr
  sta  temp
  lsr
  adc  temp
  ror
  lsr
  adc  temp
  ror
  lsr
  adc  temp
  ror
  lsr


; Divide by 13
; 21 bytes, 37 cycles
  sta  temp
  lsr
  adc  temp
  ror
  adc  temp
  ror
  adc  temp
  ror
  lsr
  lsr
  clc
  adc  temp
  ror
  lsr
  lsr
  lsr


;Divide by 14
;1/14 = 1/7 * 1/2
;16 bytes, 29 cycles
  sta  temp
  lsr
  lsr
  lsr
  adc  temp
  ror
  lsr
  lsr
  adc  temp
  ror
  lsr
  lsr
  lsr


;Divide by 15
;14 bytes, 24 cycles
  sta  temp
  lsr
  adc  #4
  lsr
  lsr
  lsr
  adc  temp
  ror
  lsr
  lsr
  lsr


;Divide by 16
;4 bytes, 8 cycles
  lsr
  lsr
  lsr
  lsr


;Divide by 17
;18 bytes, 30 cycles
  sta  temp
  lsr
  adc  temp
  ror
  adc  temp
  ror
  adc  temp
  ror
  adc  #0
  lsr
  lsr
  lsr
  lsr


;Divide by 18 = 1/9 * 1/2
;18 bytes, 32 cycles
  sta  temp
  lsr
  lsr
  lsr
  adc  temp
  ror
  adc  temp
  ror
  adc  temp
  ror
  lsr
  lsr
  lsr
  lsr


;Divide by 19
;17 bytes, 30 cycles
  sta  temp
  lsr
  adc  temp
  ror
  lsr
  adc  temp
  ror
  adc  temp
  ror
  lsr
  lsr
  lsr
  lsr


;Divide by 20
;18 bytes, 32 cycles
  lsr
  lsr
  sta  temp
  lsr
  adc  temp
  ror
  lsr
  lsr
  adc  temp
  ror
  adc  temp
  ror
  lsr
  lsr


;Divide by 21
;20 bytes, 36 cycles
  sta  temp
  lsr
  adc  temp
  ror
  lsr
  lsr
  lsr
  lsr
  adc  temp
  ror
  adc  temp
  ror
  lsr
  lsr
  lsr
  lsr


;Divide by 22
;21 bytes, 34 cycles
   lsr
   cmp  #33
   adc  #0
   sta  temp
   lsr
   adc  temp
   ror
   adc  temp
   ror
   lsr
   adc  temp
   ror
   lsr
   lsr
   lsr


;Divide by 23
;19 bytes, 34 cycles
  sta  temp
  lsr
  lsr
  lsr
  adc  temp
  ror
  adc  temp
  ror
  lsr
  adc  temp
  ror
  lsr
  lsr
  lsr
  lsr


;Divide by 24
;15 bytes, 27 cycles
   lsr
   lsr
   lsr
   sta   temp
   lsr
   lsr
   adc   temp
   ror
   lsr
   adc   temp
   ror
   lsr


;Divide by 25
;16 bytes, 29 cycles
  sta  temp
  lsr
  lsr
  lsr
  adc  temp
  ror
  lsr
  adc  temp
  ror
  lsr
  lsr
  lsr
  lsr


;Divide by 26
;21 bytes, 37 cycles
  lsr
  sta  temp
  lsr
  adc  temp
  ror
  adc  temp
  ror
  adc  temp
  ror
  lsr
  lsr
  adc  temp
  ror
  lsr
  lsr
  lsr


;Divide by 27
;15 bytes, 27 cycles
  sta  temp
  lsr
  adc  temp
  ror
  lsr
  lsr
  adc  temp
  ror
  lsr
  lsr
  lsr
  lsr


;Divide by 28
;14 bytes, 24 cycles
  lsr
  lsr
  sta  temp
  lsr
  adc  #2
  lsr
  lsr
  adc  temp
  ror
  lsr
  lsr


;Divide by 29
;20 bytes, 36 cycles
  sta  temp
  lsr
  lsr
  adc  temp
  ror
  adc  temp
  ror
  lsr
  lsr
  lsr
  adc  temp
  ror
  lsr
  lsr
  lsr
  lsr


;Divide by 30
;14 bytes, 26 cycles
  sta  temp
  lsr
  lsr
  lsr
  lsr
  sec
  adc  temp
  ror
  lsr
  lsr
  lsr
  lsr


;Divide by 31
;14 bytes, 26 cycles
  sta  temp
  lsr
  lsr
  lsr
  lsr
  lsr
  adc  temp
  ror
  lsr
  lsr
  lsr
  lsr


;Divide by 32
  lsr
  lsr
  lsr
  lsr
  lsr
```


## Algo trigonométriques


```
ZERO        #$00
PI_OVER_4   #$20
PI_OVER_2   #$40
3_PI_OVER_4 #$60
PI          #$80
5_PI_OVER_4 #$A0
3_PI_OVER_2 #$C0
7_PI_OVER_4 #$E0


IF TanX = 0 THEN
    IF TanY = 0 THEN
        RETURN 0
    ELSE IF TanY > 0 THEN
        RETURN PI/2
    ELSE
        RETURN 3*PI/2
    END
ELSE (TanX != 0)
    IF TanX > 0 THEN
        TmpX = TanX
        IF TanY = 0 THEN
            RETURN 0
        ELSE IF TanY > 0 THEN
            TmpY = TanY
            IF TmpY = TmpX THEN
                RETURN PI/4
            ELSE IF TmpX < TmpY Then
                SWAP (TmpY, TmpX)
                Octant = 2 ; PI / 2 ; Angle is in [PI/4 .. PI/2]
                NegIt = 1
            ELSE (TmpX > TmpY)
                Octant = 1 ; 0 ; Angle is in [0 .. PI/4]
            END IF

        ELSE (TanY < 0)
            TmpY = -TanY
            IF TmpY = TmpX THEN
                RETURN 7*PI/4
            ELSE IF TmpX < TmpY Then
                SWAP (TmpY, TmpX)
                Octant = 7; 3*PI / 2  Angle is in [3PI/2 .. 7PI/4]
            ELSE (TmpX > TmpY)
                Octant = 8; 2*PI Angle is in [7PI/4 .. 2PI]
                 NegIt = 1
           END IF

        END IF
    ELSE (TanX < 0)
        TmpX = -TanX
        IF TanY = 0 THEN
            RETURN PI
        ELSE IF TanY > 0 THEN
            TmpY = TanY
            IF TmpY = TmpX THEN
                RETURN 3*PI/4
            ELSE IF TmpX < TmpY Then
                SWAP (TmpY, TmpX)
                Octant = 3 ;  PI / 2 Angle is in [PI/2 .. 3PI/4]
            ELSE (TmpX > TmpY)
                NegIt = 1
                Octant = 4 ; PI Angle is in [3PI/4 .. PI]
            END IF

        ELSE (TanY < 0)
            TmpY = -TanY
            IF TmpY = TmpX THEN
                RETURN 5*PI/4
            ELSE IF TmpX < TmpY Then
                SWAP (TmpY, TmpX)
                NegIt = 1
                Octant = 6 ; 3_PI_OVER_2 #$C0 Angle is in [5PI/4 .. 3PI/2]
            ELSE (TmpX > TmpY)
                Octant = 5 ; PI #$80 Angle is in [PI .. 5PI/4]
            END IF

        END IF
    END IF
END

Ratio = TmpY / TmpX

IF NegIt THEN
    Angle = -ATAN [Ratio]
ELSE
    Angle = ATAN [Ratio]

RES = Angle + Octant


```


https://geekshavefeelings.com/posts/fixed-point-atan2

### Arctangente

```basic
IF TanX = 0 THEN
  IF TanY = 0 THEN
    RETURN 0
  ELSE IF TanY > 0 THEN
    RETURN PI/2
  ELSE
    RETURN 3*PI/2
  END
ELSE
  IF TanY = 0 THEN
    IF TanX > 0 THEN
      RETURN 0
    ELSE
      RETURN PI or -PI
    END
  ELSE
    REM TanX TanY both different of 0  
    IF TanX > 0 THEN
      IF TanY > 0 THEN
        IF TanX = TanY Then
          RETURN PI/4
        ELSE IF TanX > TanY THEN
          REM Octant1 Angle is in [0 .. PI/4]
          RETURN ATAN (TanY / TanX)
        ELSE
          REM Octant2 Angle is in [PI/4 .. PI/2]
          RETURN -ATAN (TanX / TanY) + PI / 2
        END IF
      ELSE
        TmpY = -TanY
        IF TanX = TmpY Then
          RETURN PI/4
        ELSE IF TanX > TmpY THEN
          REM Octant8 Angle is in [7PI/4 .. 2PI]
          RETURN -ATAN (TmpY / TanX) + 2*PI
        ELSE
          REM Octant7 Angle is in [3PI/2 .. 7PI/4]
          RETURN ATAN (TanX / TmpY) + 3*PI / 2
        END IF
      END
    ELSE
      TmpX = -TanX
      IF TanY > 0 THEN
        IF TmpX > TanY THEN
          REM Octant4 Angle is in [3PI/4 .. PI]
          RETURN -ATAN (TanY / TmpX) + PI
        ELSE
          REM Octant3 Angle is in [PI/2 .. 3PI/4]
          RETURN ATAN (TmpX / TanY) + PI / 2
        END IF
      ELSE
        TmpY = - TanY
        IF TmpX > TmpY THEN
          REM Octant5 Angle is in [PI .. 5PI/4]
          RETURN ATAN (TmpY / TmpX) + PI
        ELSE
          REM Octant6 Angle is in [5PI/4 .. 3PI/2]
          RETURN -ATAN (TmpX / TmpY) + 3*PI / 2
        END IF
      END
    END
  END
END
```

[arctan.asm](https://github.com/dustmop/arctan24/blob/master/arctan.asm) avec les explications [ici](http://www.dustmop.io/blog/2015/07/22/discrete-arctan-in-6502/)

ou bien

[atan2 en 6502 par la méthode CORDIC](https://atariage.com/forums/blogs/entry/3385-atan2-in-6502/)

ou encore

[8bit_atan2](https://codebase64.org/doku.php?id=base:8bit_atan2_8-bit_angle)
## Algo de dessin

### Tracé de Segment

[Algo de  Bresenham](https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm)

```
plotLine(int x0, int y0, int x1, int y1)
    dx =  abs(x1-x0);
    sx = x0<x1 ? 1 : -1;
    dy = -abs(y1-y0);
    sy = y0<y1 ? 1 : -1;
    err = dx+dy;  /* error value e_xy */
    while (true)   /* loop */
        if (x0==x1 && y0==y1) break;
        e2 = 2*err;
        if (e2 >= dy)
            err += dy; /* e_xy+e_x > 0 */
            x0 += sx;
        end if
        if (e2 <= dx) /* e_xy+e_y < 0 */
            err += dx;
            y0 += sy;
        end if
    end while
```


## Algo de geometrie


### Norme euclidienne
```
IF DX == 0 THEN
  IF DY > 0 THEN
    RETURN DY
  ELSE
    RETURN -DY
ELSE IF DX > 0 THEN
  AX = DX
ELSE (DX < 0)
  AX = -DX
ENDIF
IF DY == 0 THEN
  RETURN AX
ELSE IF DY > 0 THEN
  AY = DY
ELSE (DY < 0)
  AY = -DY
ENDIF
IF AX > AY THEN
  TX = AX
  TY = AY
ELSE
  TX = AY
  TY = AX
END
IF TY >= TX/2 THEN
  RETURN TAB_C[TX] + TAB_D[TY]
ELSE (TX < TY)
  RETURN TAB_A[TX] + TAB_B[TY]
END IF
```

### géométrie 3D

http://geomalgorithms.com/


[Line and Plane Intersection](http://geomalgorithms.com/a05-_intersect-1.html)

```C
#define SMALL_NUM   0.00000001 // anything that avoids division overflow
// dot product (3D) which allows vector operations in arguments
#define dot(u,v)   ((u).x * (v).x + (u).y * (v).y + (u).z * (v).z)
#define perp(u,v)  ((u).x * (v).y - (u).y * (v).x)  // perp product  (2D)
```


```C
// intersect3D_SegmentPlane(): find the 3D intersection of a segment and a plane
//    Input:  S = a segment, and Pn = a plane = {Point V0;  Vector n;}
//    Output: *I0 = the intersect point (when it exists)
//    Return: 0 = disjoint (no intersection)
//            1 =  intersection in the unique point *I0
//            2 = the  segment lies in the plane
int
intersect3D_SegmentPlane( Segment S, Plane Pn, Point* I )
{
    Vector    u = S.P1 - S.P0;
    Vector    w = S.P0 - Pn.V0;

    float     D = dot(Pn.n, u);
    float     N = -dot(Pn.n, w);

    if (fabs(D) < SMALL_NUM) {           // segment is parallel to plane
        if (N == 0)                      // segment lies in plane
            return 2;
        else
            return 0;                    // no intersection
    }
    // they are not parallel
    // compute intersect param
    float sI = N / D;
    if (sI < 0 || sI > 1)
        return 0;                        // no intersection

    *I = S.P0 + sI * u;                  // compute segment intersect point
    return 1;
}
```
