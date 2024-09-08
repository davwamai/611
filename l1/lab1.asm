.text
.globl main
		
main:
    	li a7, 5
    	ecall
   	mv t1, a0                   # move input to t1

    	andi t1, t1, 0xFFFFFFFF     # mask for signed -> unsigned. probably not right...

    	li t2, 0                    # t2 = 0 (initial guess)
    	li t3, 4194304              # t3 = 256 << 14 (initial step in (32,14) format)

loop:
    	mul t4, t2, t2              # t4 = t2 * t2 - always overflow?
    	mulhu t5, t2, t2            # t5 = high part of t2 * t2

    	srli t4, t4, 14              # low part right by 14 bits
    	slli t5, t5, 18             # high part left by 18 bits
    	or t4, t4, t5               # or low and high parts into t4

    	beq t4, t1, end_            # t4 == t1 ? done
    	blt t4, t1, add_step        # t4 < t1 ? increase guess

sub_step:
    	sub t2, t2, t3              # t2 = t2 - t3
    	j shift_step

add_step:
    	add t2, t2, t3              # t2 = t2 + t3

shift_step:
    	srai t3, t3, 1              # divide ste by 2. arithmetic instead of logical here? does it matter?
    	bnez t3, loop               # step is not zero ? continue

end_:
    	mv a0, t2
    	li a7, 1
    	ecall

    	li a7, 10
    	ecall
