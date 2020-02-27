#include "config.h"

#include "util/keyboard.h"

#ifdef USE_RT_KEYBOARD


extern void move(char key);

void keyPressed (char dif, char v){

	// sprintf (status_string, "key pressed: %d %d   ", dif, v);
	// AdvancedPrint(3,6 ,status_string);
    switch (v) {
    case 4 :
        switch (dif) {
        case 8:
            // KEY UP
            move(11);
            break;
        case 64:
            // KEY DOWN
            move(10);
            break;
        case 32:
            // KEY LEFT
            move(8);
            break;
        case -128:
            // KEY RIGHT
            move(9);
            break;
        }
    break;
    case 5:
        switch (dif) {
        case 8:
            // KEY P
            move(80);
            break;
        }
    break;
    case 3:
        switch (dif) {
        case 4:
            // KEY M
            move(59);
            break;
        }
    case 6:
        switch (dif) {
        case 32:
            // KEY Q
            move(81);
            break;
        }
    case 2:
        switch (dif) {
        case 32:
            // KEY W
            move(90);
            break;
        }
    case 1:
        switch (dif) {
        case 64:
            // KEY A
            move(65);
            break;
        }
    case 0:
        switch (dif) {
        case 64:
            // KEY X
            move(88);
            break;
        }
    }
}
void keyReleased (char dif, char v){
	// sprintf (status_string, "   key released: %d %d    ", dif, v);
	// AdvancedPrint(3, 6,status_string);
}


void keyEvent()
{
    char i,j;
    char mask=1;
	char diff;
     
    for (j=0;j<8;j++)
    {
		if ((diff = (oldKeyBank[j] ^ KeyBank [j])) != 0){
			// printf ("diff = %d\n");
			if ((KeyBank [j] & diff) == 0) {
				keyReleased (diff, j);
			} else {
				keyPressed (diff, j);
			}
		}
		oldKeyBank[j] = KeyBank [j];
	}
}
#endif USE_RT_KEYBOARD