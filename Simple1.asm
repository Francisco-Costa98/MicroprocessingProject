	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
		
start	movlw	0x00
	movwf	TRISD, ACCESS
	movwf	TRISC, ACCESS
	movlw	0x45
	movwf	PORTC, ACCESS
	movff	0x06, PORTD
	incf	0x06, W, ACCESS
	movwf	0x06, ACCESS
	
	goto 0x0
	end
