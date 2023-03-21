	asect 0x00

    # Initialize player byte
    ldi r0, player_byte
    ldi r1, 0x80
    st r0, r1

    while
        ldi r2, keyboard
        tst r2 # practically infinite loop
    stays nz
        ld r2, r2

        if 
            tst r2
        is z
            ldi r0, player_offset
            ld r0, r0

            ldi r1, player_byte
            ld r1, r1

            jmp draw
        fi 

        ldi r3, 1

        if
            shr r2
        is cc
            neg r3
        fi

        if
            shr r2
            # Load player_byte anyway, save address in r2
            ldi r2, player_byte
            ld r2, r1
        is cc
            # Shift the byte in right direction
            if
                tst r3
                ldi r3, 0
            is mi
                shl r1
                # If an overflow happens, shift again w/ carry now
                # Set offset to -1 
                if  
                is cs
                    shl r1
                    ldi r3, -1
                fi
            else
                shr r1
                # If an overflow happens, shift again w/ carry now
                # Set offset to 1 
                if
                is cs
                    shr r1
                    ldi r3, 1
                fi
            fi
            # Save new player byte
            st r2, r1
        else
            shla r3
            shla r3
        fi
        # Adjust player offset based on register r3
        # Load player offset to r0
        ldi r2, player_offset
        ld r2, r0
        add r3, r0
        st r2, r0

draw:
        # Assumptions:
        # Player offset is in r0
        # Player byte is in r1

        # Loading display address with offset to r0
        ldi r3, display
        add r3, r0

        # Save what's in the display and place player
        ld r0, r2
        st r0, r1

        # Flush the buffer
        ldi r3, flush
        st r3, r1
       
        # Trick to disable player after next move
        # By storing saved data
        st r0, r2
    wend
	
	halt

define player_offset, 0x00
define player_byte, 0x01

define keyboard, 0x5e
define flush, 0x5f
define display, 0x60
	end
