#ifdef USE_C_RETRIEVEFACEDATA
void retrieveFaceData(){

        // printf ("face %d : %d %d %d\n",ii, idxPt1, idxPt2, idxPt3);get();
        dmoy = points2dL[idxPt1]; //*((int*)(points2d + offPt1 + 2));
        P1AH = points2aH[idxPt1];
        P1AV = points2aV[idxPt1];

        dmoy += points2dL[idxPt2]; //*((int*)(points2d + offPt2 + 2));
        P2AH = points2aH[idxPt2];
        P2AV = points2aV[idxPt2];

        dmoy +=  points2dL[idxPt3]; //*((int*)(points2d + offPt3 + 2));
        P3AH = points2aH[idxPt3];
        P3AV = points2aV[idxPt3];

        // printf ("dis %d %d %d\n",d1, d2, d3);get();
        dmoy = dmoy / 3;
        if (dmoy >= 256) {
            dmoy = 256;
        }
        distface = (unsigned char)(dmoy & 0x00FF);

        // printf ("disface %d %d\n",dmoy, distface);get();

}
#endif // USE_C_RETRIEVEFACEDATA
