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

        jsr changeMovement

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

                # TODO: Color the territory
                push r2 # Basically remove all turns
                ldi r3, turn_count
                ldi r2, 0
                st r3, r2
                pop r2
            fi
        else # If old player position was colored
            if
                move r1, r3
                and r2, r3
            is nz, or # If new player position is colored and there are no turns recorded
                ldi r3, turn_count
                ld r3, r3
                tst r3
            is nz
            then
            else
                push r2
                ldi r3, turn_count
                ldi r2, 1
                st r3, r2

                ldi r3, turns
                ldi r2, player_x
                ld r2, r2
                st r3, r2
                inc r3

                ldi r2, player_y
                ld r2, r2
                st r3, r2
                pop r2 
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
	
checkCoord:
	# r0 - xCoord, r1 - yCoord
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
	ldi r3, 0x80 # r3 - mask
	
	while
		tst r2
	stays nz
		shr r3
		dec r2	
	wend	

	shla r1
	shla r1	
	add r1, r0 #r0 now is the number of a byte
	ld r0, r1 # r1 now is a byte
	and r3, r1 # r1 now has only requested bit (i.e. 0b00000100)
	rts

changeMovement:
    pushall
	ldi r0, player_y # r0 - previous Y
	ld r0, r0
    push r0
    
	ldi r0, player_x # r0 - previous X
	ld r0, r0
    push r0
	
	jsr calculatePlayer
	
	ldi r0, player_x # r0 - current X
	ld r0, r0
	
	ldi r1, player_y # r1 - current Y
	ld r1, r1

    ldi r2, turns
    ldi r3, turn_count
    ld r3, r3


    if
        tst r3 # If there were zero turns
    is z, or
        dec r3
        shla r3
        add r3, r2 # Get the address of the last turn in r2

        ld r2, r3 # Load last turn's x into r3
        inc r2
        sub r3, r0
    is z, or
        ld r2, r2 # Load last turn's y into r2
        sub r2, r1
    is z 
    then
        # If the change is only in one or less coordinate
        # We don't need to record this position
        pop r1
        pop r1
        popall
        rts
    fi

    # If both coordinates changed
    # Record the last position
    ldi r0, turns
    ldi r1, turn_count
    ld r1, r2 # Load turn count
    inc r2
    st r1, r2 # Increase turn count and store it
    dec r2
    shla r2
    add r2, r0 # Get the address of new turn in r2

    pop r1 # Last x
    st r0, r1
    inc r0

    pop r1 # Last y
    st r0, r1
    popall
	
	rts	
	
	
calculatePlayer: # update player position
	ldi r3, calculate_player 
	st r3, r3 
	rts
	
	


define player_offset, 0x00
define player_byte, 0x01
define player_x, 0x02
define player_y, 0x03
define calculate_player, 0x04
define override_screen, 0x05
define turn_count, 0x10
define turns, 0x11

define reset_keyboard, 0x5e
define flush, 0x5f
define display, 0x60
	end