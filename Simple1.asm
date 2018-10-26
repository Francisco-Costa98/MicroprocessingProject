	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message, LCD_Clear, LCD_Cursor_R , LCD_Cursor_D, LCD_Send_Byte_D   ; external LCD subroutines
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine

tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x80    ; reserve 128 bytes for message data

rst	code	0    ; reset vector
	goto	setup


setup	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	banksel PADCFG1 ; PADCFG1 is not in Access Bank!!
	bsf	PADCFG1, REPU, BANKED ; PortE pull-ups on
	movlb	0x00 ; set BSR back to Bank 0
	setf	TRISE, ACCESS ; Tri-state PortE	
	clrf	LATE
	clrf	LATD
	movlw	0x0F
	movwf	TRISE, ACCESS
	movlw	0x00
	movwf	TRISD, ACCESS
	movlw	0x0A
	movwf	0x20, ACCESS
	goto	start
	
start	
	movlw	0x0F
	movwf	TRISE, ACCESS
	movlw	0x0A
	movwf	0x20, ACCESS
	call	delay
	movff	PORTE, 0x01
	movlw	0x00
	addwf	0x01, 0, 0
	sublw	0x0F
	movwf	0x01
	
	movlw	0xF0
	movwf	TRISE, ACCESS
	movlw	0x0A
	movwf	0x20, ACCESS
	call	delay
	movff	PORTE, 0x02
	movlw	0x00
	addwf	0x02, 0, 0
	sublw	0xF0
	movwf	0x02
	movlw	0x00
	addwf	0x01, 0, 0
	addwf	0x02, 1, 0
	movlw	0x0A
	movwf	0x20, ACCESS
	call	delay
	
	
test0	movlw	.130
	cpfseq	0x02
	bra	test1
	movlw	0x00
	movwf	0x03, ACCESS
	movlw	0x30 
	movwf	0x04
	call	Write
	goto	finish
test1	movlw	.17
	cpfseq	0x02
	bra	test2
	movlw	0x01
	movwf	0x03, ACCESS
	movlw	0x31
	movwf	0x04
	call	Write
	goto	finish
test2	movlw	.18
	cpfseq	0x02
	bra	test3
	movlw	0x02
	movwf	0x03, ACCESS
	movlw	0x32
	movwf	0x04
	call	Write
	goto	finish
test3	movlw	.20
	cpfseq	0x02
	bra	test4
	movlw	0x03
	movwf	0x03, ACCESS
	movlw	0x33
	movwf	0x04
	call	Write
	goto	finish
test4	movlw	.33
	cpfseq	0x02
	bra	test5
	movlw	0x04
	movwf	0x03, ACCESS
	movlw	0x34
	movwf	0x04
	call	Write
	goto	finish
test5	movlw	.34
	cpfseq	0x02
	bra	test6
	movlw	0x05
	movwf	0x03, ACCESS
	movlw	0x35
	movwf	0x04
	call	Write
	goto	finish
test6	movlw	.36
	cpfseq	0x02
	bra	test7
	movlw	0x06
	movwf	0x03, ACCESS
	movlw	0x36
	movwf	0x04	
	call	Write
	goto	finish
test7	movlw	.65
	cpfseq	0x02
	bra	test8
	movlw	0x07
	movwf	0x03, ACCESS
	movlw	0x37
	movwf	0x04
	call	Write
	goto	finish
test8	movlw	.66
	cpfseq	0x02
	bra	test9
	movlw	0x08
	movwf	0x03, ACCESS
	movlw	0x38
	movwf	0x04
	call	Write
	goto	finish
test9	movlw	.68
	cpfseq	0x02
	bra	testA
	movlw	0x09
	movwf	0x03, ACCESS
	movlw	0x39
	movwf	0x04
	call	Write
	goto	finish
testA	movlw	.129
	cpfseq	0x02
	bra	testB
	movlw	0x0A
	movwf	0x03, ACCESS
	movlw	0x41 
	movwf	0x04
	call	Write
	goto	finish
testB	movlw	.132
	cpfseq	0x02
	bra	testC
	movlw	0x0B
	movwf	0x03, ACCESS
	movlw	0x42
	movwf	0x04
	call	Write
	goto	finish
testC	movlw	.136
	cpfseq	0x02
	bra	testD
	movlw	0x0C
	movwf	0x03, ACCESS
	movlw	0x43
	movwf	0x04
	call	Write
	goto	finish
testD	movlw	.72
	cpfseq	0x02
	bra	testE
	movlw	0x0D
	movwf	0x03, ACCESS
	movlw	0x44
	movwf	0x04
	call	Write
	goto	finish
testE	movlw	.40
	cpfseq	0x02
	bra	testF
	movlw	0x0E
	movwf	0x03, ACCESS
	movlw	0x45
	movwf	0x04
	call	Write
	goto	finish
testF	movlw	.24
	cpfseq	0x02
	bra	finish2
	movlw	0x0F
	movwf	0x03, ACCESS
	movlw	0x46
	movwf	0x04
	call	Write
	goto	finish

finish	
	movff	0x03, PORTD
	goto	start		; goto current line in code
	
finish2	
	bra finish
	

	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	0x20	; decrement until zero
	bra delay
	return
	
Write	movlw	0x0A
	movwf	0x20, ACCESS
	call	delay
	movlw	0x00
	addwf	0x04, 0, 0
	call	LCD_Send_Byte_D
	movlw	0x0A
	movwf	0x20, ACCESS
	call	delay
	call	LCD_Cursor_R
	movlw	0xFF
	movwf	0x20, ACCESS
	movlw	0x10
	movwf	0x22
	call	phat_delay
	return
	
phat_delay	decfsz 0x20 ; decrement until zero
	bra phat_delay
	call delay2	
	return
	
delay2	decfsz 0x21 ; decrement until zero	
	bra phat_delay
	call delay3
	return
		
delay3	decfsz 0x22 ; decrement until zero	
	bra phat_delay
	return

    End
		

	