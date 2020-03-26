#ifdef USE_C_BRESFILL
void prepare_bresrun() {
    if (P1Y <= P2Y) {
        if (P2Y <= P3Y) {
            pDepX  = P3X;
            pDepY  = P3Y;
            pArr1X = P2X;
            pArr1Y = P2Y;
            pArr2X = P1X;
            pArr2Y = P1Y;
        } else {
            pDepX = P2X;
            pDepY = P2Y;
            if (P1Y <= P3Y) {
                pArr1X = P3X;
                pArr1Y = P3Y;
                pArr2X = P1X;
                pArr2Y = P1Y;
            } else {
                pArr1X = P1X;
                pArr1Y = P1Y;
                pArr2X = P3X;
                pArr2Y = P3Y;
            }
        }
    } else {
        if (P1Y <= P3Y) {
            pDepX  = P3X;
            pDepY  = P3Y;
            pArr1X = P1X;
            pArr1Y = P1Y;
            pArr2X = P2X;
            pArr2Y = P2Y;
        } else {
            pDepX = P1X;
            pDepY = P1Y;
            if (P2Y <= P3Y) {
                pArr1X = P3X;
                pArr1Y = P3Y;
                pArr2X = P2X;
                pArr2Y = P2Y;
            } else {
                pArr1X = P2X;
                pArr1Y = P2Y;
                pArr2X = P3X;
                pArr2Y = P3Y;
            }
        }
    }
}
#endif  // USE_C_BRESFILL

