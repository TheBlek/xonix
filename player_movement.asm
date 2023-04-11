	asect 0x00

    ldi r0, override_screen
    st r0, r0
    ldi r0, flush
    st r0, r0

    # Initialize player byte
    ldi r0, player_byte
    ldi r1, 0b10000000
    st r0, r1

    while
        ldi r0, calculate_player
        tst r0 # practically infinite loop
    stays nz
        # Send signal to calculate new player data
        st r0, r0

draw:
        # Player offset is in r0
        # Player byte is in r1
        # Load player data 
        ldi r0, player_offset
        ld r0, r0

        ldi r1, player_byte
        ld r1, r1

        # Loading display address with offset to r0
        ldi r3, display
        add r3, r0

        # Add player to the scene
        ld r0, r2
        xor r2, r1
        st r0, r1

        # Flush the buffer
        ldi r3, flush
        st r3, r1

        # Restore player byte by reversing xor operation
        xor r2, r1
        # Add player byte to the background
        or r2, r1
        # Place background to screen
        st r0, r1
    wend
	
	halt

		
    wend


define player_offset, 0x00
define player_byte, 0x01
define player_x, 0x02
define player_y, 0x03
define calculate_player, 0x04
define override_screen, 0x05

define keyboard, 0x5e
define flush, 0x5f
define display, 0x60
	end
