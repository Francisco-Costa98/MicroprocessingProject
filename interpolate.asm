#include p18f87k22.inc
	
	extern  khigh, klow, myTable

acs0    udata_acs		    ; reserves space for variables used
	pointer1    res 1
	pointer2    res 1
	counter_interpolate   res 1
rst	code	0		    ; reset vector
	goto	setup		    ; goes to code setup
	
main	code
	
setup
	call counter_reset
	
	
Interpolate 


locate
	call pointer_finder
	
	
pointer_finder
	tblrd*+				    ; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, pointer1	    ; move read data from TABLAT to (FSR0), increment FSR0	
	tblrd*+				    ; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, pointer2	    ; move read data from TABLAT to (FSR0), increment FSR0
	tblrd*-
	dcfsnz	counter_interpolate	    ; count down to zero
	call	counter_reset_interpolate
	return
	
	
	
counter_reset_interpolate			    ; counter reset routine to reset the counter when it goes to zero 
	movlw	upper(myTable)	    ; address of data in PM
	movwf	TBLPTRU		    ; load upper bits to TBLPTRU
	movlw	high(myTable)	    ; address of data in PM
	movwf	TBLPTRH		    ; load high byte to TBLPTRH
	movlw	low(myTable)	    ; address of data in PM
	movwf	TBLPTRL		    ; load low byte to TBLPTRL
	movlw	.30		    ; 30 bytes to read
	movwf 	counter		    ; our counter register
	return