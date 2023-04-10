	asect 0x00

    ldi r0, override_screen
    st r0, r0
    ldi r0, flush
    st r0, r0

    # Initialize player byte
    ldi r0, player_byte
    ldi r1, 0b10000000
    st r0, r1
    ldi r3, 0

    while
        ldi r1, player_byte
        tst r1 # practically infinite loop
    stays nz
        # Player offset is in r0
        # Player byte is in r1
        # Load player data 

        # Send signal to calculate new player data
        ldi r1, calculate_player
        st r1, r1

        ldi r0, player_offset
        ld r0, r0

        # Add display offset into player offset
        ldi r2, display
        add r2, r0

        # Load background
        ld r0, r2

        # Load new player byte
        ldi r1, player_byte
        ld r1, r1

        # Add player to the scene
        xor r2, r1
        st r0, r1
        # Restore player byte by reversing xor operation
        xor r2, r1

        # Flush the buffer
        push r3
        ldi r3, flush
        st r3, r1
        pop r3

        if
            # Check if old player position was not colored
            tst r3
        is z
            if
                move r1, r3
                # Check if new player position is colored
                and r2, r3
            is nz
                # Reset keyboard input
                ldi r3, reset_keyboard
                ld r3, r3
                st r3, r0
            fi
        fi
        # Update register containing color flag
        move r1, r3
        and r2, r3
        # Add player byte to the background
        or r2, r1
        # Place background to screen
        st r0, r1
    wend
	halt

define player_offset, 0x00
define player_byte, 0x01
define player_x, 0x02
define player_y, 0x03
define calculate_player, 0x04
define override_screen, 0x05

define reset_keyboard, 0x5e
define flush, 0x5f
define display, 0x60
	end
