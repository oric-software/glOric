

#ifdef USE_C_ARRAYSPROJECT
void glProjectArrays(){
    unsigned char ii;
    signed char x, y, z;
    signed char ah, av;
    unsigned int dist ;
    unsigned char options=0;

    for (ii = 0; ii < glNbVertices; ii++){
        x = glVerticesX[ii];
        y = glVerticesY[ii];
        z = glVerticesZ[ii];

        glProjectPoint(x, y, z, options, &ah, &av, &dist);

        points2aH[ii] = ah;
        points2aV[ii] = av;
        points2dH[ii] = (signed char)((dist & 0xFF00)>>8) && 0x00FF;
        points2dL[ii] = (signed char) (dist & 0x00FF);

    }
}
#endif // USE_C_ARRAYSPROJECT