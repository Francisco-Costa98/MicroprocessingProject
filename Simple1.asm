	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_Clear, LCD_Cursor_Go_Home  ; external LCD subroutines
	extern	ADC_Setup, ADC_Read ; external ADC sub routines
    
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine
hex1H	    res	1   ; reserve 1 byte for hex values
hex1L	    res	1   ; reserve 1 byte for hex values
kH	    res 1   ; reserve 1 byte for k 
kL	    res 1   ; reserve 1 byte for k 

tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x80    ; reserve 128 bytes for message data

rst	code	0    ; reset vector
	goto	setup

	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	call	ADC_Setup	; setup ADC
	movlw	0x41
	movwf	kH
	movlw	0x8A
	movwf	kL
	goto	start
	
	; ******* Main programme ****************************************
start 	
	call	measure_loop
	
measure_loop
	call	ADC_Read
	movf	ADRESH,W
	movwf	hex1H
	call	LCD_Write_Hex
	movf	ADRESL,W
	movwf	hex1L
	call	LCD_Write_Hex
	call	eightbysixteen
	call	LCD_Cursor_Go_Home
	goto	measure_loop		; goto current line in code

	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return

eightbysixteen 
	
	end

	
