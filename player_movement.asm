	asect 0x00

    ldi r0, override_screen
    st r0, r0
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

        push r1
        push r2

        ldi r1, ball
        ld r1, r1

        ldi r2, ballAdress
        ld r2, r2

        st r2, r1

        pop r2
        pop r1

        # Flush the buffer
        push r3
        ldi r3, flush
        st r3, r1
        pop r3

        jsr go

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
                    ldi r0, ballAdress
                    ld r0, r2
                    
                    ldi r1, ball
                    ld r1, r1

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

        # ldi r2, ball
        # ld r2, r2

        # ld r0, r1

        # or r1, r2

        # st r0, r2
        # st r3, r2

        # st r0, r1

        # xor r1, r2

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
