
#ifdef USE_C_ISA1RIGHT1
void isA1Right1 (){
    
    A1Right = 0;
//  log2_tab[];
    if ((mDeltaX1 & 0x80) == 0){
        
        if ((mDeltaX2 & 0x80) == 0){
            // printf ("%d*%d  %d*%d ", mDeltaY1, mDeltaX2, mDeltaY2,mDeltaX1);get ();
            A1Right = ((log2_tab[mDeltaX2] + log2_tab[mDeltaY1])/2) > ((log2_tab[mDeltaX1] + log2_tab[mDeltaY2])/2);
            // A1Right = mDeltaY1*mDeltaX2 > mDeltaY2*mDeltaX1;
        } else {
            A1Right = 0 ; // (mDeltaX1 < 0) 
        }
    } else {
        if ((mDeltaX2 & 0x80) == 0){
            A1Right = 1 ; // (mDeltaX1 < 0)
        } else {
            // printf ("%d*%d  %d*%d ", mDeltaY1, -mDeltaX2, mDeltaY2,-mDeltaX1);get ();
            A1Right = ((log2_tab[abs(mDeltaX2)] + log2_tab[mDeltaY1])/2) < ((log2_tab[abs(mDeltaX1)] + log2_tab[mDeltaY2])/2);
        }
    }
    // if (((mDeltaX1 & 0x80) ^ (mDeltaX2 & 0x80)) == 0) {
    //     A1Right = mDeltaY1*mDeltaX2 > mDeltaY2*mDeltaX1; // (DeltaY1/DeltaX1) > (DeltaY2/DeltaX2) ;
    // }else {
    //     A1Right = (mDeltaX1 < 0) ;
    // }
    
    // A1Right = mDeltaY1*mDeltaX2 > mDeltaY2*mDeltaX1;


//  if (DeltaX1 == 0) {
//     A1Right = (DeltaX2 < 0);
//  } else {
//     if (DeltaX2 == 0){
//         A1Right = (DeltaX1 > 0);
//     } else {
//         if (((DeltaX1 & 0x80) ^ (DeltaX2 & 0x80)) == 0) {
//             A1Right = DeltaY1*DeltaX2 > DeltaY2*DeltaX1; // (DeltaY1/DeltaX1) > (DeltaY2/DeltaX2) ;
//         }else {
//             A1Right = (DeltaX1 > 0) ;
//         }
        
//     }
//  }
}
#endif // USE_C_ISA1RIGHT1



#ifdef USE_C_ISA1RIGHT3
void isA1Right3 (){
 A1Right = (A1X > A2X);
}
#endif // USE_C_ISA1RIGHT3

