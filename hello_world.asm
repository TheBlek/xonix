	asect 0x00
    
    ldi r0, 96
    ldi r1, 0b11001010
    st r0, r1 
    inc r0
    st r0, r1
	
	halt
	end
