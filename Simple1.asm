	#include p18f87k22.inc
	
	code
	org 0x0
	goto	setup
		
setup	movlw	0x00
	movwf	TRISD, ACCESS	;sets port d to input port
	movlw	0xC3		; turns all control lines to high
	movwf	PORTD, ACCESS	; moves high values to port D
	banksel PADCFG1 ; PADCFG1 is not in Access Bank!!
	bsf PADCFG1, REPU, BANKED ; PortE pull-ups on
	movlb 0x00 ; set BSR back to Bank 0
	setf TRISE ; Tri-state PortE
	goto start
	
	
start
	
	
write1	movlw	0x20		; only turns on oe 1 for writting
	movwf	PORTD, ACCESS	;moves value for high oe1 to port D
	
	
	goto 0x0
	end
