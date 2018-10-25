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
	movlw	0X00
	movwf	PORTF, ACCESS
	goto	start
	
start	clrf	LATE
	movlw	0x0F
	movwf	TRISE, ACCESS
	movff	PORTE, 0x01, ACCESS
	movlw	0x0F
	subwf	0x01, 1, 0
	clrf	LATE
	movlw	0xF0
	movwf	TRISE, ACCESS
	call	delay
	movff	PORTE, 0x02, ACCESS
	movlw	0xF0
	subwf	0x02, 1, 0
	movfw	0x01
	addwf	0x02, 1, 0
test0	movlw	.130
	cpfseq	0x02
	bra	test1
	movlw	0x00
	movwf	0x03, ACCESS
	goto	finish
test1	movlw	.17
	cpfseq	0x02
	bra	test2
	movlw	0x01
	movwf	0x03, ACCESS
	goto	finish
test2	movlw	.18
	cpfseq	0x02
	bra	test3
	movlw	0x02
	movwf	0x03, ACCESS
	goto	finish
test3	movlw	.20
	cpfseq	0x02
	bra	test4
	movlw	0x03
	movwf	0x03, ACCESS
	goto	finish
test4	movlw	.33
	cpfseq	0x02
	bra	test5
	movlw	0x04
	movwf	0x03, ACCESS
	goto	finish
test5	movlw	.34
	cpfseq	0x02
	bra	test6
	movlw	0x05
	movwf	0x03, ACCESS
	goto	finish
test6	movlw	.36
	cpfseq	0x02
	bra	test7
	movlw	0x06
	movwf	0x03, ACCESS
	goto	finish
test7	movlw	.65
	cpfseq	0x02
	bra	test8
	movlw	0x07
	movwf	0x03, ACCESS
	goto	finish
test8	movlw	.66
	cpfseq	0x02
	bra	test9
	movlw	0x08
	movwf	0x03, ACCESS
	goto	finish
test9	movlw	.68
	cpfseq	0x02
	bra	testA
	movlw	0x09
	movwf	0x03, ACCESS
	goto	finish
testA	movlw	.129
	cpfseq	0x02
	bra	testB
	movlw	0x0A
	movwf	0x03, ACCESS
	goto	finish
testB	movlw	.132
	cpfseq	0x02
	bra	testC
	movlw	0x0B
	movwf	0x03, ACCESS
	goto	finish
testC	movlw	.136
	cpfseq	0x02
	bra	testD
	movlw	0x0C
	movwf	0x03, ACCESS
	goto	finish
testD	movlw	.72
	cpfseq	0x02
	bra	testE
	movlw	0x0D
	movwf	0x03, ACCESS
	goto	finish
testE	movlw	.40
	cpfseq	0x02
	bra	testF
	movlw	0x0E
	movwf	0x03, ACCESS
	goto	finish
testF	movlw	.24
	cpfseq	0x02
	movlw	0x00
	movlw	0x0F
	movwf	0x03, ACCESS
	goto	finish
finish	nop
	nop
	nop

	movff 0x03, PORTF, ACCESS
	
	
	goto	start		; goto current line in code
	
	
	

	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return

    End
		

	