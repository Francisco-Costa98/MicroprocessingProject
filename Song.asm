#include p18f87k22.inc
	
	extern  setup_keypad, keypad_start, khigh, klow, test
	global	song1, play_song

acs0    udata_acs		    ; reserves space for variables used
song_counter res 1		    ; reserves one bite for counter 
song_pointer res 1
song_freq   res 1
sdelay  res 1

song	code
	   
song1  db	0xfe, 0xbe, 0xe2, 0xc9, 0xa9, 0xfe, 0xfe, 0xe2
  

play_song
	    call song_setup
	    call read_freq
	    return
	    

song_setup
	    movlw	upper(song1)	    ; address of data in PM
	    movwf	TBLPTRU		    ; load upper bits to TBLPTRU
	    movlw	high(song1)	    ; address of data in PM
	    movwf	TBLPTRH		    ; load high byte to TBLPTRH
	    movlw	low(song1)	    ; address of data in PM
	    movwf	TBLPTRL		    ; load low byte to TBLPTRL
	    movlw	.7		    ; 30 bytes to read
	    movwf 	song_counter
	    movlw	0xFF
	    movwf	sdelay
	    return
	    
;int_hi_song	code 0x0008		    ; high vector, no low vector
;	btfss	PIR4,CCP5IF	    ; check that this is timer1 interrupt
;	retfie	1		    ; if not then return
;	call	read_freq
;	bcf	PIR4,CCP5IF	    ; clear interrupt flag
;	retfie	FAST		    ; fast return from interrupt

clock_pulse_song			    ; clock pulse routine to make DAC read in values
	bcf	PORTC, 0	    ; clears clock enable bit
	movlw	0x0A		    ; sets up a delay
	movwf	0x53		    ; moves delayvalue to register 0x53
	call	clk_delay_song	    ; calls delay
	bsf	PORTC, 0	    ; sets clock enable bit
	return

clk_delay_song			    ; clock delay routine
	decfsz 0x53		    ; decrement register 0x53 until zero
	bra clk_delay_song		    ; loops until register is zero
	return
	
read_freq			    ; read routine to read values from table
	tblrd*+			    ; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, song_freq	    ; move read data from TABLAT to (FSR0), increment FSR0	
	movlw	0x00
	movwf	khigh		    ;keep khigh as zero
	movff	song_freq, klow	    ;move the selected freq to klow
	call	int_hi	    ; calls the interrupt value, as this is how we need to read mytable??
	dcfsnz	song_counter	    ; count down to zero
	call	song_setup	    ;reset the song counter
	return	
	
	
	
song_delay			    ; clock delay routine
	decfsz sdelay		    ; decrement register 0x53 until zero
	bra song_delay		    ; loops until register is zero
	return
	
    end