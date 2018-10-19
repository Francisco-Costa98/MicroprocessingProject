	#include p18f87k22.inc
	
	code
	org 0x0
	
	
	org 0x100		    ; Main code starts here at address 0x100
	call SPI_MasterInit
	goto	start
	
	
start
	movlw   0xFF
	movwf   0x20, ACCESS
	movwf   0x21, ACCESS
loop	movlw	0x45
	call	SPI_MasterTransmit
	bra 	loop	; Not yet finished goto start of loop again
	
delay	decfsz 0x20 ; decrement until zero
	bra delay
	call delay2	
	return
	
delay2	decfsz 0x21 ; decrement until zero	
	bra delay2
	return
		
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
	call Wait_Transmit
	return
Wait_Transmit ; Wait for transmission to complete
	btfss PIR2, SSP2IF
	bra Wait_Transmit
	bcf PIR2, SSP2IF ; clear interrupt flag
	return

	goto 0x00
	end