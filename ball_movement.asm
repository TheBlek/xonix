	asect	0x06
	halt

# 	ldi r0, to_frame
# 	st r0, r0
# 	ldi r0, flush
#     st r0, r0

# 	ldi r0, screen

# 	ldi r3, 1

#     ldi r2, 0b01000000
#     jsr safe_go_forward
#     inc r0

#     ldi r2, 0b10000000
#     jsr safe_go_forward
#     inc r0

#     ldi r2, 0b10000000
#     jsr safe_go_forward
#     inc r0

#     ldi r2, 0b10000000
#     jsr safe_go_forward
#     st r0, r2
# 	#jsr go_till_another_wall

# 	halt

	asect 0x05
	to_frame: ds 1
	
	asect 0x5f
	flush: ds 1

	asect 0x64
	screen: ds 120

	go_forward:

		push r1
		push r2
		push r3

		ldi r1, 0b10000000
		ldi r2, flush
	
		while
			tst r1
		stays nz

			st r0,r1
			st r2,r1
			shr r1

		wend
		
		st r0, r1

		pop r3
		pop r2
		pop r1
	
	rts

	go_back:
	
		push r1
		push r2
		push r3

		ldi r1, 0b00000001
		ldi r2, flush

		while
			tst r1
		stays nz

			st r0,r1
			st r2,r1
			shl r1

		wend
		
		st r0, r1

		pop r3
		pop r2
		pop r1
	
	rts

	safe_go_forward:

		push r1
		push r3

		ld r0, r1 
		ldi r3, flush

	# go_forward_loop:
		if
            push r1
            and r2, r1
            tst r1
            pop r1
		is z, or
            tst r2
        is nz

			or r1, r2

			st r0, r2
			st r3, r2  	#flush
			st r0, r1

			xor r1, r2
			
			shr r2 
    #         jmp go_forward_loop
		fi

		st r0, r1
		
		pop r3
		pop r1
	
	rts

# 	fucking_frame_back:

# 		push r1
# 		push r3

# 		ld r0, r1 
# 		ldi r3, flush

# 		while
# 			tst r2
# 		stays nz

# 			or r1, r2

# 			st r0, r2
# 			st r3, r2  	#flush
# 			st r0, r1

# 			xor r1, r2
			
# 			shl r2 

# 		wend

# 		st r0, r1
		
# 		pop r3
# 		pop r1
	
# 	rts

# 	go_diagonal_down:#норм

# 		inc r0
# 		inc r0
# 		inc r0
# 		inc r0
	
# 	rts

# 	go_diagonal_back_down:#норм

# 		inc r0
# 		inc r0
# 		inc r0

# 	rts

# 	go_diagonal_up:#норм

# 		dec r0
# 		dec r0
# 		dec r0
# 		dec r0

# 	rts

# 	go_diagonal_back_up:

# 		dec r0
# 		dec r0
# 		dec r0
# 		dec r0

# 	rts

# 	go_till_wall:

#         push r1
#         push r2

#         move r0, r1
#         ld r1, r1

#         ldi r2, 0b00000001

#         if
#             cmp r1, r2
#         is eq

#             ldi r2, 0b10000000
#             jsr safe_go_forward
# 			inc r0

# 			if
# 				tst r3  #0 - up
# 			is z
				
# 				jsr go_diagonal_back_up
# 				ldi r3, 1

# 			else

# 				jsr go_diagonal_back_down
# 				ldi r3, 0

# 			fi

#         else
#         	ldi r2, 0b10000000  
            
# 			if	
# 				cmp r1, r2
# 			is eq 
			
# 				ldi r2, 0b01000000
#             	jsr safe_go_forward
# 				inc r0

# 				jsr go_diagonal_down

#             	jsr go_till_wall

# 			else

# 				jsr go_forward
# 				inc r0

# 				jsr go_diagonal_down

#             	jsr go_till_wall

# 			fi

# 			move r0, r1

# 			ldi r2, 4
# 			add r2, r1

# 			ld r1, r1

# 			ldi r2, 0b11111111

# 			if
# 				cmp r2, r1
# 			is eq

# 				jsr go_diagonal_up
					
# 				ldi r3, 1
# 				jsr go_till_wall

# 			fi
        
#         fi

# 		pop r2
# 		pop r1
#     rts

# 	go_till_another_wall:

# 		push r1
# 		push r2

# 		move r0, r1
# 		ld r1, r1

# 		ldi r2, 0b10000000
		
# 		if
#             cmp r1, r2
#         is eq

#             ldi r2, 0b00000001
#             jsr fucking_frame_back

# 			if
# 				tst r3  #0 - up
# 			is z
				
# 				jsr go_diagonal_up
# 				ldi r3, 1

# 			else

# 				jsr go_diagonal_down
# 				ldi r3, 0
			
# 			fi

#         else
            
#            ldi r2, 0b00000001  

#             if	
# 				cmp r1, r2
# 			is eq 
			
# 				ldi r2, 0b00000010
#             	jsr fucking_frame_back

# 				#

#             	jsr go_till_another_wall
			
# 			else

# 				move r0, r1

# 				ld r1, r1

# 				ldi r2, 0b11111111

# 				if
# 					cmp r2, r1
# 				is eq

# 					jsr go_diagonal_back_up
# 					jsr go_diagonal_back_up
					
# 					ldi r3, 0
# 					jsr go_till_another_wall
				
# 				else

# 					jsr go_back

# 					jsr go_diagonal_back_down

# 					jsr go_till_another_wall
				
# 				fi

# 			fi
        
#         fi

# 		pop r2
# 		pop r1

# 	rts

	end
