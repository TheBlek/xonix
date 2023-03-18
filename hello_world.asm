	asect 0x00
    
    ldi r0, display # zero-th byte of a display
    ldi r1, flush # flush byte address
    ldi r2, keyboard # keyboard data address

    while
    stays nz  
        ld r2, r3 # Read keyboard input
        st r0, r3 # Print it to the first byte of the display
        st r1, r0 # Write smth to flush. Doesn't matter what
    wend
    st r0, r1
	
	halt

    asect 0x5e
keyboard:

    asect 0x5f
flush:
    
    asect 0x60
display:
	end
