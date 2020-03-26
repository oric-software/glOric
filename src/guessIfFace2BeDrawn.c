#ifdef USE_C_GUESSIFFACE2BEDRAWN
void guessIfFace2BeDrawn () {

    m1 = P1AH & ANGLE_MAX;
    m2 = P2AH & ANGLE_MAX;
    m3 = P3AH & ANGLE_MAX;
    v1 = P1AH & ANGLE_VIEW;
    v2 = P2AH & ANGLE_VIEW;
    v3 = P3AH & ANGLE_VIEW;

    isFace2BeDrawn = 0;
    if ((m1 == 0x00) || (m1 == ANGLE_MAX)) {
        if ((v1 == 0x00) || (v1 == ANGLE_VIEW)) {
            if (
                (
                    (P1AH & 0x80) != (P2AH & 0x80)) ||
                ((P1AH & 0x80) != (P3AH & 0x80))) {
                if ((abs(P3AH) < 127 - abs(P1AH))) {
                    isFace2BeDrawn=1;
                }
            } else {
                isFace2BeDrawn=1;
            }
        } else {
            // P1 FRONT
            if ((m2 == 0x00) || (m2 == ANGLE_MAX)) {
                // P2 FRONT
                if ((m3 == 0x00) || (m3 == ANGLE_MAX)) {
                    // P3 FRONT
                    // _4_
                    if (((P1AH & 0x80) != (P2AH & 0x80)) || ((P1AH & 0x80) != (P3AH & 0x80))) {
                        isFace2BeDrawn=1;
                    } else {
                        // nothing to do
                    }
                } else {
                    // P3 BACK
                    // _3_
                    if ((P1AH & 0x80) != (P2AH & 0x80)) {
                        if (abs(P2AH) < 127 - abs(P1AH)) {
                            isFace2BeDrawn=1;
                        }
                    } else {
                        if ((P1AH & 0x80) != (P3AH & 0x80)) {
                            if (abs(P3AH) < 127 - abs(P1AH)) {
                                isFace2BeDrawn=1;
                            }
                        }
                    }

                    if ((P1AH & 0x80) != (P3AH & 0x80)) {
                        if (abs(P3AH) < 127 - abs(P1AH)) {
                            isFace2BeDrawn=1;
                        }
                    }
                }
            } else {
                // P2 BACK
                // _2_ nothing to do
                if ((P1AH & 0x80) != (P2AH & 0x80)) {
                    if (abs(P2AH) < 127 - abs(P1AH)) {
                        isFace2BeDrawn=1;
                    }
                } else {
                    if ((P1AH & 0x80) != (P3AH & 0x80)) {
                        if (abs(P3AH) < 127 - abs(P1AH)) {
                            isFace2BeDrawn=1;
                        }
                    }
                }

                if ((P1AH & 0x80) != (P3AH & 0x80)) {
                    if (abs(P3AH) < 127 - abs(P1AH)) {
                        isFace2BeDrawn=1;
                    }
                }
            }
        }
    } else {
        // P1 BACK
        // _1_ nothing to do
    }
}
#endif // USE_C_GUESSIFFACE2BEDRAWN
