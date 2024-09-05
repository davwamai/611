    .data
prompt_input:
    .string "enter a signed 32-bit integer: "
prompt_output:
    .string "answer is: \n"
newline:
    .byte 10  # '\n'

    .text
    .global _start

_start:
    # prompt input
    la a0, prompt_input
    jal ra, print_string

    # read integer input
    jal ra, read_int                              # result stored in a0

    mv t0, a0                                     # copy input value to t0

    # compute square root of t0
    jal ra, sqrt_newton

    # print
    la a0, prompt_output
    jal ra, print_string

    mv a0, t0                                     # Move square root result to a0
    jal ra, print_int

    # print newline
    la a0, newline
    jal ra, print_string

    # exit
    li a7, 10
    ecall

# function:     Newton-Raphson square root approx.
# arg: t0       - unsigned 32-bit value (14 fractional bits)
# output: t0   - square root (also in 14 fractional bits)
sqrt_newton:
    li t1, 0x4000                                 # initial guess (sqrt(16384) = 128 in fractional bits)
    li t2, 100                                     # iteration counter

sqrt_iterate:
    beqz t2, sqrt_done

    # Newton-Raphson step: x = (x + n/x) / 2
    div t3, t0, t1                                # t3 = n / x
    add t3, t1, t3                                # t3 = x + n / x
    srai t3, t3, 1                                # t3 = (x + n / x) / 2
    mv t1, t3                                     # update guess

    addi t2, t2, -1                               # decrease iteration counter
    j sqrt_iterate

sqrt_done:
    mv t0, t1                                     # store the result
    ret

# function:     Print a string to the console
# output: a0       - address of the string
print_string:
    li a7, 4                                      # ecall for write string
    li a1, 1                                      # write to stdout (fd = 1)
    mv a2, a0                                     # a2 = address of string
    ecall
    ret

# function:     Read a signed integer from the console
# output: a0    - integer value
read_int:
    li a7, 5                                      # ecall for reading an integer
    ecall
    ret

# function:     Print an integer to the console
# arg: a0       - integer to print
print_int:
    li a7, 1                                      # ecall for print integer
    ecall
    ret
