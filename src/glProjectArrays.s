
#ifdef USE_ASM_ARRAYSPROJECT
_glProjectArrays:
.(
    // for (ii = 0; ii < nbPoints; ii++){
	ldy		_nbPoints
glProjectArrays_loop:
	dey
	bmi		glProjectArrays_done
		//     x = points3dX[ii];
		lda 	_points3dX, y
		sta		_PointX
		//     y = points3dY[ii];
		lda 	_points3dY, y
		sta		_PointY
		//     z = points3dZ[ii];
		lda 	_points3dZ, y
		sta		_PointZ

    //     projectPoint(x, y, z, options, &ah, &av, &dist);
		jsr 	_project_i8o8 :

    //     points2aH[ii] = ah;
		lda 	_ResX
		sta		_points2aH, y
    //     points2aV[ii] = av;
		lda 	_ResY
		sta		_points2aV, y
    //     points2dH[ii] = (signed char)((dist & 0xFF00)>>8) && 0x00FF;
		lda		_Norm+1
		sta		_points2dH, y
    //     points2dL[ii] = (signed char) (dist & 0x00FF);
		lda		_Norm
		sta		_points2dL, y

    // }
	jmp glProjectArrays_loop
glProjectArrays_done:
.)
	rts
#endif // USE_ASM_ARRAYSPROJECT

