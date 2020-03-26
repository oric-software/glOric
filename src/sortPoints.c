#ifdef USE_C_SORTPOINTS
void sortPoints(){
    signed char   tmpH, tmpV;
    if (abs(P2AH) < abs(P1AH)) {
        tmpH = P1AH;
        tmpV = P1AV;
        P1AH = P2AH;
        P1AV = P2AV;
        P2AH = tmpH;
        P2AV = tmpV;
    }
    if (abs(P3AH) < abs(P1AH)) {
        tmpH = P1AH;
        tmpV = P1AV;
        P1AH = P3AH;
        P1AV = P3AV;
        P3AH = tmpH;
        P3AV = tmpV;
    }
    if (abs(P3AH) < abs(P2AH)) {
        tmpH = P2AH;
        tmpV = P2AV;
        P2AH = P3AH;
        P2AV = P3AV;
        P3AH = tmpH;
        P3AV = tmpV;
    }
}
#endif // USE_C_SORTPOINTS