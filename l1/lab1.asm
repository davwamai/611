    .data
prompt: .asciz "Enter a 32-bit signed integer in (32,14) fixed-point format: \n"

    .text
    .globl main

main:
    la a0, prompt           # Load address of prompt string
    li a7, 4                # Syscall for printing string
    ecall

    li a7, 5                # Syscall for reading integer
    ecall
    mv t1, a0               # Move input to t1 for processing

    li t2, 0                # t2 = 0 (initial guess)
    li t3, 4194304          # t3 = 256 << 14 (initial step)


sqrt_loop:
    mul t4, t2, t2          # t4 = x2 * x2 (low part in (32,14) format)
    mulhu t5, t2, t2        # t5 = high part of x2 * x2 (high part in (32,14))

    srai t4, t4, 14         # Shift low part right by 14 bits
    slli t5, t5, 18         # Shift high part left by 18 bits to combine
    or t4, t4, t5           # Combine low and high parts into t4 (now in (32,14))

    # Compare square of the guess (x4) to the input (x1)
    beq t4, t1, end_loop    # If x4 == x1, we are done

    blt t4, t1, add_step
    
    sub_step:
        sub t2, t2, t3      # x2 = x2 - x3
        j half_step

    add_step:
        add t2, t2, t3      # x2 = x2 + x3

half_step:
    srai t3, t3, 1          # Divide step by 2
    bnez t3, sqrt_loop      # If step is not zero, continue the loop

end_loop:
    mv a0, t2               # Move result to a0
    li a7, 1                # Syscall for printing integer
    ecall

    li a7, 10               # exit
    ecall
