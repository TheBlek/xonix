	asect 0x00

    ldi r1, 0
    ldi r0, override_screen
    st r0, r1
    ldi r0, flush
    st r0, r0

    # Initialize player byte
    ldi r0, player_byte
    ldi r1, 0b10000000
    st r0, r1
    ldi r3, 1

    ldi r0, ball
    ldi r1, 0b01000000
    st r0, r1

    ldi r0, ballAdress
    ldi r1, 0x64
    st r0, r1

    ldi r0, forwardOrBack
    ldi r1, 0
    st r0, r1

    ldi r0, diagonal
    ldi r1, 4
    st r0, r1

    ldi r0, upOrDown
    ldi r1, 1
    st r0, r1

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

        jsr go

        # pushall

        # ldi r1, ball
        # ld r1, r1

        # ldi r2, ballAdress
        # ld r2, r2

        # ld r2, r3
        # or r3, r1

        # st r2, r1


        # Flush the buffer
        # ldi r3, flush
        # st r3, r1
        # popall

        if
            # Check if old player position was not colored
            tst r3
        is z
            if
                move r1, r3
                # Check if new player position is colored
                and r2, r3
            is nz
                if
                    jsr isInTail
                    tst r3
                is z # And if not in tail
                    # Reset keyboard input
                    ldi r3, reset_keyboard
                    ld r3, r3
                    st r3, r0

                    pushall
                    ldi r1, ballAdress
                    ld r1, r1
                    
                    ldi r0, ball
                    ld r0, r0

                    ldi r3, start_coloring
                    st r3, r3

                    while
                        ld r3, r1
                        tst r1
                    stays z
                    wend

                    ldi r3, override_screen
                    st r3, r1

                    ldi r3, turn_count
                    ldi r2, 0
                    st r3, r2
                    popall
                fi
            fi
        else # If old player position was colored
            if
                move r1, r3
                and r2, r3
            is nz, or # If new player position is not colored and there are no turns recorded
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

isInTail: # Checks if player is in it's tail
    pushall

    # go through all segments and check if player is between endpoints
    ldi r1, turn_count
    ld r1, r1
    ldi r0, turns
    while
        dec r1
    stays gt
        ldi r2, player_y
        ld r2, r2
        push r2

        ldi r2, player_x
        ld r2, r2
        push r2

        # If segment has constant x then player_y must be between y0 and y1
        # Analogous with constant y
        ld r0, r2 # Load previous x
        inc r0
        inc r0
        ld r0, r3 # Load next turn's x
        if
            cmp r3, r2
        is eq
            # Then y must be different
            pop r3 # Reorder player_x and player_y in stack
            pop r2
            push r3
            push r2

            # Load prev y in r2 and next y in r3 
            dec r0
            ld r0, r2
            inc r0
            inc r0
            ld r0, r3
        fi
        # Now that we determined coord that is changed (Lets call it z)
        # Now stack looks like this: z (not z)
        # And r3, r2 are z's of ends of a segment
        # And r0 is pointer to end's z of a segment
        # Player_z must be between those two
        pop r3 # Load player change coord
        # player_z - start_z and player_z - end_z must have different signes
        sub r3, r2 
        push r2
        ld r0, r2
        sub r3, r2
        pop r3

        # r3 and r2 must have different signs
        if
            tst r3
        is z, or
            tst r2
        is z, or
            xor r3, r2
        is le
            pop r3 # Pop player's (not z) from stack
            # It must equal segment's (not z)
            dec r0
            ld r0, r2
            if
                cmp r3, r2
            is eq
                popall
                ldi r3, 1
                rts
            else
                if 
                    ldi r2, 1
                    and r0, r2
                is z # If this is a pointer to y (if it's even)
                    # Increase
                    inc r0
                fi
            fi
        else
            pop r3
        fi
        
    wend

    popall
    ldi r3, 0 
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

go:

    pushall

    ldi r0, ballAdress
    ld r0, r0

    ld r0, r1# в r1 окружающая среда
    ldi r2, ball# шарик
    ld r2, r2
    ldi r3, flush

    if
        or r1, r2
        cmp r1, r2 #    если шарик врезался в стену
    is eq

        if
            push r3
            ldi r3, forwardOrBack
            ld r3, r3
            tst r3
            pop r3
        is z   
    
            ldi r1, 1
            ldi r3, forwardOrBack

            st r3, r1

        else
        
            ldi r1, 0
            ldi r3, forwardOrBack

            st r3, r1

        fi

    else

        ldi r2, ball
        ld r2, r2

        ld r0, r1

        or r1, r2

        st r0, r2
        st r3, r2

        st r0, r1

        xor r1, r2

        move r0, r1# в r1 окружающая среда
        
        ldi r2, diagonal
        ld r2, r2

        if
            push r3
            ldi r3, upOrDown
            ld r3, r3
            tst r3
            pop r3
        is nz

            add r2, r1
        
        else
        
            sub r1,r2
            move r2, r1
        
        fi

        ld r1, r1
        ldi r2, ball# шарик

        ld r2, r2

        ldi r3, flush

        if
            or r1, r2
            cmp r1, r2 #    если шарик врезался в стен            
        is eq

            if
                push r3
                ldi r3, upOrDown
                ld r3, r3
                tst r3
                pop r3
            is z  

                ldi r1, 1
                ldi r3, upOrDown
                st r3, r1

            else 

                ldi r1, 0
                ldi r3, upOrDown

                st r3, r1

            fi
        fi
    fi

    ld r0, r1# в r1 окружающая среда
    ldi r2, ball# шарик
    ld r2, r2
    ldi r3, flush

    if
        push r3
        ldi r3, forwardOrBack
        ld r3, r3
        tst r3
        pop r3
    is z # если 0, то ->

        shr r2

        if
            move r0, r1
            inc r1
            ld r1, r1
            tst r1
        is pl

            if
                ldi r1, 0b00000001
                cmp r2, r1
            is eq

                inc r0
                ldi r2, 0b10000000

            fi

        fi

        ldi r3, ball
        st r3, r2

    else 

        shl r2

        if
            move r0, r1
            dec r1
            ld r1, r1
            shr r1
        is cc

            if
                ldi r1, 0b10000000
                cmp r2, r1
            is eq
                
                dec r0
                ldi r2, 0b00000001

            fi

        fi

        ldi r3, ball
        st r3, r2

    fi

    if
        push r1
        ldi r1, upOrDown
        ld r1, r1
        tst r1
        pop r1
    is z

        push r3
        ldi r3, diagonal
        ld r3, r3
        sub r0, r3
        move r3, r0
        pop r3

    else

        push r3
        ldi r3, diagonal
        ld r3, r3
        add r3, r0
        pop r3

    fi

    ldi r3, ballAdress
    st r3, r0
    
    popall

    rts

define player_offset, 0x00
define player_byte, 0x01
define player_x, 0x02
define player_y, 0x03
define calculate_player, 0x04
define override_screen, 0x05
define start_coloring, 0x06

define ball, 0x07
define upOrDown, 0x08
define forwardOrBack, 0x09
define diagonal, 0x0A
define ballAdress, 0x0B

define turn_count, 0x10
define turns, 0x11

define reset_keyboard, 0x5e
define flush, 0x5f
define display, 0x60
	end
