	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_Clear, LCD_Cursor_Go_Home,LCD_Cursor_D,LCD_Cursor_R,LCD_Send_Byte_D  ; external LCD subroutines
	extern	ADC_Setup, ADC_Read ; external ADC sub routines
    
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine
hexH	    res	1   ; reserve 1 byte for hex values
hexL	    res	1   ; reserve 1 byte for hex values
kH	    res 1   ; reserve 1 byte for k 
kL	    res 1   ; reserve 1 byte for k 
result1	    res 1   ; reserves 1 byte for result
result2	    res 1   ; reserves 1 byte for result
result3	    res 1   ; reserves 1 byte for result
result4	    res 1   ; reserves 1 byte for result
voltage1    res 1   ; reserves 1 byte for result
voltage2    res 1   ; reserves 1 byte for result
voltage3    res 1   ; reserves 1 byte for result
voltage4    res 1   ; reserves 1 byte for result
temp1    res 1   ; reserves 1 byte for result
temp2    res 1   ; reserves 1 byte for result
temp3    res 1   ; reserves 1 byte for result
temp4    res 1   ; reserves 1 byte for result
	    
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
	movwf	hexH
	call	LCD_Write_Hex
	movf	ADRESL,W
	movwf	hexL
	call	LCD_Write_Hex
	call	sixteenbysixteen
	call	LCD_Cursor_D
	call	print_hex
	call	LCD_Cursor_Go_Home
	
	goto	measure_loop		; goto current line in code

	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return

eightbysixteen 
	movlw	0x00
	movwf	result3
	movf	kL, W
	mulwf	hexL
	movff	PRODL, result1
	movff	PRODH, result2
	mulwf	hexH
	movf	PRODL, W
	addwf	result2, 1	    ;assumed no carry bit, if carry bit use addwfc
	movf	PRODH, W
	addwfc	result3, 1
	return
	
sixteenbysixteen
	movlw	0x00
	movwf	result3
	movwf	result4
	movf	kL, W
	mulwf	hexL
	movff	PRODL, result1
	movff	PRODH, result2
	
	mulwf	hexH
	movf	PRODL, W
	addwf	result2, 1	    ;assumed no carry bit, if carry bit use addwfc
	movf	PRODH, W
	addwfc	result3, 1
	
	movf	kH, W
	mulwf	hexL
	movf	PRODL, W
	addwf	result2, 1
	movf	PRODH, W
	addwfc	result3, 1
	
	
	movf	kH, W
	mulwf	hexH
	movf	PRODL, W
	addwfc	result3, 1	
	movf	PRODH, W
	addwfc	result4, 1
	movff	result4, voltage4
	
	return
	
eightbytwentyfour
	
	movff	result4, temp4
	movff	result3, temp3
	movff	result2, temp2
	movff	result1, temp1
	movlw	0x00
	movwf	temp3
	movf	result1, W
	mullw	0x0A
	movff	PRODL, temp1
	movff	PRODH, temp2
	movf	result2, W
	mullw	0x0A
	movf	PRODL, W
	addwf	temp2, 1	    ;assumed no carry bit, if carry bit use addwfc
	movf	PRODH, W
	addwfc	temp3, 1
	movf	result3, W
	mullw	0x0A
	movf	PRODL, W
	addwf	temp3, 1	    ;assumed no carry bit, if carry bit use addwfc
	movf	PRODH, W
	addwfc	temp4, 1
	
	return
	

print_hex	
	movf	result4, W
	call	LCD_Write_Hex
	movf	result3, W
	call	LCD_Write_Hex
	movf	result2, W
	call	LCD_Write_Hex
	movf	result1, W
	call	LCD_Write_Hex
	return
	
	
	end

	
