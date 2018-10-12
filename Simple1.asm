	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
		
start	movlw	0x00
	movwf	TRISD, ACCESS
	movwf	TRISC, ACCESS
	movlw	0x45
	movwf	PORTC, ACCESS
	movlw	0x00
	movwf	PORTD, ACCESS
	movlw	0x01
	movwf	PORTD, ACCESS
	
	goto 0x0
	end
