	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message, LCD_Write_Hex   ; external LCD subroutines
	extern	ADC_Setup, ADC_Read ; external ADC sub routines
    
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine

tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x80    ; reserve 128 bytes for message data

rst	code	0    ; reset vector
	goto	setup

	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	call	ADC_Setup	; setup ADC
	movlw	0x00
	movwf	TRISA, ACCESS	;set up porta as output
	goto	start
	
	; ******* Main programme ****************************************
start 	
	call	measure_loop
	
measure_loop
	call	ADC_Read
	movf	ADRESH,W
	call	LCD_Write_Hex
	movf	ADRESL,W
	call	LCD_Write_Hex
	goto	measure_loop		; goto current line in code

	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return

	end

	
