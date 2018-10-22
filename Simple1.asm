	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message, LCD_Clear, LCD_Cursor_R , LCD_Cursor_D   ; external LCD subroutines
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine

tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x80    ; reserve 128 bytes for message data

rst	code	0    ; reset vector
	goto	setup


setup	
	banksel PADCFG1 ; PADCFG1 is not in Access Bank!!
	bsf	PADCFG1, REPU, BANKED ; PortE pull-ups on
	movlb	0x00 ; set BSR back to Bank 0
	setf	TRISE, ACCESS ; Tri-state PortE
	movlw	0x0F
	movwf	TRISE, ACCESS
	clrf	LATE
	goto	start
	
start
	movff	PORTE,0x01  
	
	bra start
	
	goto	$		; goto current line in code
	
	
	

	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return

    End
		

	