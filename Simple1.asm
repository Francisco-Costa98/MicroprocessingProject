	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw   0xFF
	movwf   0x20, ACCESS
	movwf   0x21, ACCESS
	movwf   0x22, ACCESS
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
	call delay3
	return
	goto	setup
		
SPI_MasterInit ; Set Clock edge to positive
	bsf SSP2STAT, CKE
	; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
	movlw (1<<SSPEN)|(1<<CKP)|(0x02)
	movwf SSP2CON1
	; SDO2 output; SCK2 output
	bcf TRISD, SDO2
	bcf TRISD, SCK2
	return
SPI_MasterTransmit ; Start transmission of data (held in W)
	movwf SSP2BUF
Wait_Transmit ; Wait for transmission to complete
	btfss PIR2, SSP2IF
	bra Wait_Transmit
	bcf PIR2, SSP2IF ; clear interrupt flag
	return
