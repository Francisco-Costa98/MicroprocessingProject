#include p18f87k22.inc
	
	extern  setup_keypad, keypad_start, khigh, klow, test
	global	song1

acs0    udata_acs		    ; reserves space for variables used
	song_counter res 1		    ; reserves one bite for counter 
	song_pointer res 1
	song_freq   res 1
song1  db	0xfe, 0xbe, 0xe2, 0xc9, 0xa9, 0xfe, 0xfe, 0xe2
  
play_song
	    call song_setup
	    movlw b'00110001'	    ; Set timer5 to 16-bit, Fosc/1:8
	    movwf T5CON		    ; = 2MHz clock rate, approx 1sec rollover
	    banksel CCPTMRS1	    ; CCPTMRS1 is in banked ram
	    bsf	CCPTMRS1, C5TSEL0   ; chooses to use timer5
	    bsf	PIR4, CCP5IE	    ; sets interupt enable bit
	    movlw b'00001011'	    ; Set special event mode	   
	    movwf	CCP5CON	    ; ccp5 module    
	    bsf	PIE4, CCP5IE	    ; sets interrupt enable bit
	    bsf	INTCON,PEIE
	    bsf	INTCON,GIE	    ; Enable all interrupts
	    movlw   0xFF
	    movwf   CCPR5H	    ;sets compare value for 
	    movwf   CCPR5L
	    goto $		    ; Sit in infinite loop
	    

song_setup
	    movlw	upper(song1)	    ; address of data in PM
	    movwf	TBLPTRU		    ; load upper bits to TBLPTRU
	    movlw	high(song1)	    ; address of data in PM
	    movwf	TBLPTRH		    ; load high byte to TBLPTRH
	    movlw	low(song1)	    ; address of data in PM
	    movwf	TBLPTRL		    ; load low byte to TBLPTRL
	    movlw	.7		    ; 30 bytes to read
	    movwf 	song_counter
	    return
	    
int_hi	code 0x0008		    ; high vector, no low vector
	btfss	PIR4,CCP5IF	    ; check that this is timer1 interrupt
	retfie	1		    ; if not then return
	call	read_freq
	
	call	read		    ; reads values from table
	
	bcf	PIR4,CCP5IF	    ; clear interrupt flag
	retfie	FAST		    ; fast return from interrupt
	
read_song				    ; read routine to read values from table
	tblrd*+			    ; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, PORTD	    ; move read data from TABLAT to (FSR0), increment FSR0	
	call	clock_pulse	    ; calls clock pulse to read in values
	dcfsnz	counter		    ; count down to zero
	call	counter_reset	    ; if counte is zero, the counter is reset
	return	
	
clock_pulse			    ; clock pulse routine to make DAC read in values
	bcf	PORTC, 0	    ; clears clock enable bit
	movlw	0x0A		    ; sets up a delay
	movwf	0x53		    ; moves delayvalue to register 0x53
	call	clk_delay	    ; calls delay
	bsf	PORTC, 0	    ; sets clock enable bit
	return

clk_delay			    ; clock delay routine
	decfsz 0x53		    ; decrement register 0x53 until zero
	bra clk_delay		    ; loops until register is zero
	return
	
read_freq			    ; read routine to read values from table
	tblrd*+			    ; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, song_freq	    ; move read data from TABLAT to (FSR0), increment FSR0	
	call	clock_pulse	    ; calls clock pulse to read in values
	dcfsnz	counter		    ; count down to zero
	; call a return function after read all frequencies 
	return	
	
end