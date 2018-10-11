	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw   0xFF
	movwf   0x20, ACCESS
	movwf   0x21, ACCESS
	movwf	TRISD, ACCESS
	movlw 	0x0
	movwf	TRISC, ACCESS	    ; Port C all outputs
	bra 	test
loop	movff 	0x06, PORTC
	incf 	0x06, W, ACCESS
test	movwf	0x06, ACCESS	    ; Test for end of loop condition
	movf PORTD, W, ACCESS
	cpfsgt 	0x06, ACCESS
	call	delay
	bra 	loop	; Not yet finished goto start of loop again
	
delay	decfsz 0x20 ; decrement until zero
	bra delay
	call delay2	
	return
	
delay2	decfsz 0x21 ; decrement until zero	
	bra delay
	return
		
	goto 	0x0		    ; Re-run program from start
	
	end
