	#include p18f87k22.inc
	
	code
	org 0x0
	org 0x100		    ; Main code starts here at address 0x100
	call SPI_MasterInit
	goto	setup
	

	; ******* Programme FLASH read Setup Code ****  
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	movlw	0x00
	movwf	TRISC, ACCESS
	movlw	0xFF
	movwf	0x20, ACCESS
	movwf	0x21, ACCESS
	movlw	0xFF
	movwf	0x22, ACCESS
	goto	start
	; ******* My data and where to put it in RAM *
myTable db	0x00, 0x11, 0x33, 0x77, 0xFF, 0xEE, 0xCC, 0x88, 0x00, 0x11, 0x33, 0x77, 0xFF, 0xEE, 0xCC, 0x88, 0x00
	constant 	myArray=0x400	; Address in RAM for data
	constant 	counter=0x10	; Address of counter variable
	; ******* Main programme *********************
start 	lfsr	FSR0, myArray	; Load FSR0 with address in RAM	
	movlw	upper(myTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	.15		;22 bytes to read
	movwf 	counter		; our counter register
loop 	tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move read data from TABLAT to (FSR0), increment FSR0	
	movff	INDF0, PORTC
	call	delay
	decfsz	counter		; count down to zero
	bra	loop		; keep going until finished
	
delay	decfsz 0x20 ; decrement until zero
	bra delay
	call delay1
	return
	
	
delay1	decfsz 0x21 ; decrement until zero
	bra delay
	call delay2
	return
	
delay2	decfsz 0x22 ; decrement until zero
	bra delay1
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