#include p18f87k22.inc
	
	extern  setup_keypad, keypad_start, khigh, klow, test
	global	song1

acs0    udata_acs		    ; reserves space for variables used
	song_counter res 1		    ; reserves one bite for counter 
	
song1  db	0xfe, 0xbe, 0xe2, 0xc9, 0xa9, 0xfe, 0xfe, 0xe2
  
play_song
	    call song_setup
	    

song_setup
	    movlw	upper(song1)	    ; address of data in PM
	    movwf	TBLPTRU		    ; load upper bits to TBLPTRU
	    movlw	high(song1)	    ; address of data in PM
	    movwf	TBLPTRH		    ; load high byte to TBLPTRH
	    movlw	low(song1)	    ; address of data in PM
	    movwf	TBLPTRL		    ; load low byte to TBLPTRL
	    movlw	.7		    ; 30 bytes to read
	    movwf 	song_counter