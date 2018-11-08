	#include p18f87k22.inc

rst	code	0x0000	; reset vector
	goto	start
	
int_hi	code	0x0008	; high vector, no low vector
	btfss	PIR4,CCP4IF	; check that this is timer0 interrupt
	retfie	1		; if not then return
	incf	LATD		; increment PORTC latch
	bcf	PIR4,CCP4IF	; clear interrupt flag
	retfie  1		; fast return from interrupt

main	code
start	clrf	TRISD		; Set PORTD as all outputs
	clrf	LATD		; Clear PORTD outputs
	movlw	b'00110001'	; Set timer1 to 16-bit, Fosc/4/8
	movwf	T1CON		; = 2MHz clock rate
	banksel CCPTMRS1	; not in access bank!
	bcf	CCPTMRS1,C4TSEL1    ; Choose Timer1
	bcf	CCPTMRS1,C4TSEL0
	movlw	b'00001011'	; Compare mode, reset on compare match
	movwf	CCP4CON
	movlw	0x1E		; set period compare registers
	movwf	CCPR4H		; 0x1E84 gives MSB blink rate at 1Hz
	movlw	0x84
	movwf	CCPR4L
	bsf	PIE4,CCP4IE	; Enable CCP4 interrupt
	bsf	INTCON,PEIE	; Enable peripheral interrupts
	bsf	INTCON,GIE	; Enable all interrupts
	goto	$		; Sit in infinite loop

	end