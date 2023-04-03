	asect	0x00

	ldi r0, screen

	jsr frame

	halt
	
	asect 0x5f
	buffer: ds 1
	
	asect 0x60
	screen: ds 128 
	

	#*...сверху вниз
	#.*.
	#..*


	frame:

		push r0
		push r1
		push r2

		ldi r0, 0x60
		ldi	r1, 0b11111111
		ldi r2, buffer

		st r0, r1

		inc r0

		st r0, r1

		inc r0

		st r0, r1

		inc r0

		st r0, r1

		ldi r0, 0xDC

		ldi	r1, 0b11111111

		st r0, r1

		inc r0

		st r0, r1

		inc r0

		st r0, r1

		inc r0

		st r0, r1
		
		
		ldi r0, 0x64
		ldi r1, 0b10000000

		ldi r3, 31


		while
			dec r3
		stays nz
		
			st r0, r1
			
			inc r0
			inc r0
			inc r0
			inc r0

		wend

		ldi r0, 0x67
		ldi r1, 0b00000001

		ldi r3, 31


		while
			dec r3
		stays nz
		
			st r0, r1
			
			inc r0
			inc r0
			inc r0
			inc r0
			
		wend
		
		st r2, r1
		
		pop r2
		pop r1
		pop r0

	rts
	
	end
