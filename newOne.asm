	asect	0x06

	ldi r0, toFrame
	st r0, r0
	ldi r0, flush
    st r0, r0

	ldi r0, ball
	ldi r1, 0b01000000
	st r0, r1

	ldi r0, forwardOrBack
	ldi r1, 0
	st r0, r1

	ldi r0, screen
	inc r0
	ldi r1, 0b00010000
	st r0,r1

	ldi r0, screen

	while 
		tst r0
	stays nz
	
		jsr go

	wend

 	halt

	asect 0x02
	ball: ds 1

	asect 0x03
	forwardOrBack: ds 1

	asect 0x04
	diagonal: ds 1

	asect 0x05
	toFrame: ds 1
	
	asect 0x5f
	flush: ds 1

	asect 0x64
	screen: ds 120

	go:

		push r1
		push r2
		push r3
	
		ld r0, r1#	в r1 окружающая среда
		ldi r2, ball#	шарик
		ld r2, r2
		ldi r3, flush

		if
			or r1, r2
			cmp r1, r2	#    если шарик врезался в стену
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

			or r1, r2

			st r0, r2
			st r3, r2

			st r0, r1

			xor r1, r2

		fi

		if
			push r3
			ldi r3, forwardOrBack
			ld r3, r3
			tst r3
			pop r3
		is z #	если 0, то ->

			shr r2

			if
				ldi r1, 0b00000000
				cmp r2, r1
			is eq

				ldi r2, 0b10000000
				inc r0
			
			fi
	
			ldi r3, ball
			st r3, r2

			
		else 

			shl r2

			if
				ldi r1, 0b00000000
				cmp r2, r1
			is eq

				ldi r2, 0b00000001
				dec r0

			fi
	
			ldi r3, ball
			st r3, r2

		fi

		pop r3
		pop r2
		pop r1

	rts

	end
