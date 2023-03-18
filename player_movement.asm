	asect 0x00

    while
        ldi r1, player_y
        tst r1
    stays nz
        ldi r0, player_x
        ld r0, r0

        ld r1, r1

        ldi r2, keyboard
        ld r2, r2

        if 
            tst r2
        is z
            jmp save_pos
        fi 

        ldi r3, 1

        if
            shr r2
        is cs
            neg r3
        fi
        
        if
            shr r2
        is cs
            add r3, r0
        else
            add r3, r1
        fi

save_pos:
        # Saving modified coordinates
        ldi r2, player_x
        st r2, r0
        ldi r2, player_y
        st r2, r1
        
        # dividing by 8 with remainder
        # to find place in byte and byte itself
        # for x coordinate
        ldi r2, 0x07
        and r0, r2
        shra r0
        shra r0
        shra r0

        ldi r3, display
        add r3, r0
        ldi r3, 0x80
        while
            tst r2
        stays nz
            shr r3
            dec r2
        wend

        shla r1
        shla r1
        add r1, r0

        ld r0, r1
        st r0, r3

        ldi r2, flush
        st r2, r3
        
        st r0, r1
    wend
	
	halt

    asect 0x00
player_x:
    asect 0x01
player_y:

    asect 0x5e
keyboard:

    asect 0x5f
flush:
    
    asect 0x60
display:
	end
