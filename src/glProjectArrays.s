
#ifdef USE_ASM_ARRAYSPROJECT
_glProjectArrays:
.(
    ;; for (ii = 0; ii < glNbVertices; ii++){
	ldy		_glNbVertices
glProjectArrays_loop:
	dey
	bmi		glProjectArrays_done
		;;     x = glVerticesX[ii];
		lda 	_glVerticesX, y
		sta		_PointX
		;;     y = glVerticesY[ii];
		lda 	_glVerticesY, y
		sta		_PointY
		;;     z = glVerticesZ[ii];
		lda 	_glVerticesZ, y
		sta		_PointZ

    ;;     glProjectPoint(x, y, z, options, &ah, &av, &dist);
		jsr 	_project_i8o8 :

    ;;     points2aH[ii] = ah;
		lda 	_ResX
		sta		_points2aH, y
    ;;     points2aV[ii] = av;
		lda 	_ResY
		sta		_points2aV, y
    ;;     points2dH[ii] = (signed char)((dist & 0xFF00)>>8) && 0x00FF;
		lda		_Norm+1
		sta		_points2dH, y
    ;;     points2dL[ii] = (signed char) (dist & 0x00FF);
		lda		_Norm
		sta		_points2dL, y

    ;; }
	jmp glProjectArrays_loop
glProjectArrays_done:
.)
	rts
#endif ;; USE_ASM_ARRAYSPROJECT

