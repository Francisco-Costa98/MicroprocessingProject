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
	
	
start	call write1
	call read
	goto 0x0
	end
	
	
write1	movlw	0x21		; only turns on oe 1 and clock1 for writting, dont care about mem2
	movwf	PORTD, ACCESS	;moves value for high oe1 to port D
	movlw	0x45		; chose random number to send to porte
	movwf	PORTE, ACCESS
	movlw	0x20		;makes clock tick
	movwf	PORTD, ACCESS	;makes clock tick
	movlw	0x21		;makes clock tick
	movwf	PORTD, ACCESS	;makes clock tick
	return
	
read	movlw	0x01		; only turns on clock1 for writting, dont care about mem2
	movwf	PORTD, ACCESS	;moves value for low oe1 to port D
	movlw	0x21		; only turns on oe1 for writting, dont care about mem2
	movwf	PORTD, ACCESS	;moves value for high oe1 to port D
	return
	
	
	goto 0x0
	end
