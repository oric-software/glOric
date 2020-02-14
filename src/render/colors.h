#ifndef COLORS_H
#define COLORS_H

#define LORES_SCREEN_ADDRESS 0xBB80
#define HIRES_SCREEN_ADDRESS 0xA000

#define LORES_SCREEN_WIDTH 40
#define LORES_SCREEN_HEIGHT 26

#define HIRES_SCREEN_WIDTH 240
#define HIRES_SCREEN_HEIGHT 200


#define INK_BLACK	0
#define INK_RED		1
#define INK_GREEN	2
#define INK_YELLOW	3
#define INK_BLUE	4
#define INK_MAGENTA	5
#define INK_CYAN	6
#define INK_WHITE	7

// Character Set modifier	
#define STANDARD_CHARSET 8 //		Use Standard Charset	
#define ALTERNATE_CHARSET 9 //		Use Alternate Charset	
#define DOUBLE_STANDARD_CHARSET  10	//	Use Double Size Standard Charset	
#define DOUBLE_ALTERNATE_CHARSET 11 //		Use Double Size Alternate Charset	
#define BLINKING_STANDARD_CHARSET 12 //		Use Blinking Standard Charset	
#define BLINKING_ALTERNATE_CHARSET 13 //		Use Blinking Alternate Charset	
#define DOUBLE_BLINK_STANDARD_CHARSET 14	//	Use Double Size Blinking Standard Charset	
#define DOUBLE_BLINK_ALTERNATE_CHARSET 15	//	Use Double Size Blinking Alternate Charset

// Change Paper (background) color	
#define PAPER_BLACK	16
#define PAPER_RED	17
#define PAPER_GREEN	18
#define PAPER_YELLOW	19
#define PAPER_BLUE	20
#define PAPER_MAGENTA	21
#define PAPER_CYAN	22
#define PAPER_WHITE	23

// Video control attributes	
#define TEXT_60Hz	24
#define TEXT_50Hz	26
#define HIRES_60Hz	28
#define HIRES_50Hz	30



#endif // COLORS_H