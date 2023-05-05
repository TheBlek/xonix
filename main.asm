    asect 0x00
 
    ldi r0, override_screen
    ldi r1, 0b1000
    st r0, r1
    ldi r0, flush
    st r0, r0

    ldi r0, override_screen
    ldi r1, 0b1001
    st r0, r1
    ldi r0, flush
    st r0, r0

    ldi r0, override_screen
    ldi r1, 0b1010
    st r0, r1
    ldi r0, flush
    st r0, r0

    ldi r0, override_screen
    ldi r1, 0b1011
    st r0, r1
    ldi r0, flush
    st r0, r0

    ldi r0, override_screen
    ldi r1, 0b1100
    st r0, r1
    ldi r0, flush
    st r0, r0

    ldi r0, override_screen
    ldi r1, 0b1111
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
    st r0, r0

    ldi r0, diagonal
    ldi r1, 4
    st r0, r1

    while
        ldi r0, calculate_player
        tst r1 # practically infinite loop
    stays nz
        # Player offset is in r0
        # Player byte is in r1
        # Load player data 

        # Calculate new player position 
        st r0, r0

        ldi r0, player_offset
        ld r0, r0

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

        if
            # Check if old player position was not colored
            tst r3
        is z
            if
                ldi r3, is_on_solid_ground
                ld r3, r3
                tst r3
            is nz # And if not in tail
                # Reset keyboard input
                ldi r3, reset_keyboard
                st r3, r0

                pushall
                ldi r1, ballAdress
                ld r1, r1
                
                ldi r0, ball
                ld r0, r0

                ldi r3, start_coloring
                st r3, r3

                ldi r1, 0
                ldi r3, override_screen
                st r3, r1
                popall
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

    ldi r2, calculate_ball_horizontal
    st r2, r2


    if
        ldi r0, ballAdress
        ld r0, r0
        ld r0, r1

        ldi r2, ball
        ld r2, r2

        or r1, r2
        cmp r1, r2 #    если шарик врезался в стену
    is eq
        if
            ldi r3, is_on_solid_ground
            ld r3, r3
            tst r3
        is nz
            # Flip a flag
            ldi r3, forwardOrBack
            st r3, r3

            # Move ball back
            ldi r2, calculate_ball_horizontal
            st r2, r2
        else
            ldi r0, override_screen
            ldi r1, 0b1101
            st r0, r1
            ldi r0, flush
            st r0, r0
            halt
        fi
    fi

    ldi r2, calculate_ball_vertical
    st r2, r2

    if
        ldi r0, ballAdress
        ld r0, r0
        ld r0, r2

        ldi r1, ball
        ld r1, r1
        move r1, r3
        or r2, r3
        cmp r2, r3 #    если шарик врезался в стену
    is eq
        if
            ldi r3, is_on_solid_ground
            ld r3, r3
            tst r3
        is nz
            # Flip a flag
            ldi r3, upOrDown
            st r3, r3

            # Move ball back
            ldi r2, calculate_ball_vertical
            st r2, r2
        else
            ldi r0, override_screen
            ldi r1, 0b1101
            st r0, r1
            ldi r0, flush
            st r0, r0
            halt
        fi
    fi

    ldi r3, flush
    ldi r0, ballAdress
    ld r0, r0
    ldi r2, ball
    ld r2, r2

    ld r0, r1 # Env

    or r1, r2

    st r0, r2
    st r3, r2 # flush

    st r0, r1
    popall
    rts

define player_offset, 0x00
define player_byte, 0x01
define player_x, 0x02
define player_y, 0x03
define calculate_player, 0x04
define override_screen, 0x05
define start_coloring, 0x06
define is_on_solid_ground, 0x07

define ball, 0x08
define upOrDown, 0x09
define forwardOrBack, 0x0A
define diagonal, 0x0B
define ballAdress, 0x0C
define calculate_ball_horizontal, 0x0D
define calculate_ball_vertical, 0x0E

define reset_keyboard, 0x5e
define flush, 0x5f
define display, 0x60
    end
