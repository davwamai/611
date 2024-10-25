    .data
    .text
    .globl _start

_start:
    # Load in value into t0 (Input binary number N)
    # use 0x3FFFF (262143), the maximum 18-bit value
    li t0, 0x3FFFF  # N = 262143
    # replace the above line with the actual input from switches

    # Init decimal digits D5 to D0 to zero
    li s0, 0   # D5
    li s1, 0   # D4
    li s2, 0   # D3
    li s3, 0   # D2
    li s4, 0   # D1
    li s5, 0   # D0

    # Start processing from MSB to 0 [17:0]

    ###############################################
    # Bit 17 (i = 17)
    ###############################################

    # Step 1: Adjust decimal digits if >=5 by adding 3

    # Adjust D5 (s0)
    srli t1, s0, 2          # t1 = s0 >> 2
    andi t1, t1, 0x1        # t1 = (s0 >> 2) & 0x1
    slli t1, t1, 2          # t1 = t1 << 2 (mask * 3)
    add s0, s0, t1          # s0 = s0 + (mask * 3)

    # Adjust D4 (s1)
    srli t1, s1, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s1, s1, t1

    # Adjust D3 (s2)
    srli t1, s2, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s2, s2, t1

    # Adjust D2 (s3)
    srli t1, s3, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s3, s3, t1

    # Adjust D1 (s4)
    srli t1, s4, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s4, s4, t1

    # Adjust D0 (s5)
    srli t1, s5, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s5, s5, t1

    # Step 2: Shift decimal digits left by 1 bit and manage carries
    # need two temporary registers for carry management: t2 and t3

    # Shift D5 (s0)
    slli s0, s0, 1          # s0 = s0 << 1
    srli t2, s0, 4          # t2 = s0 >> 4 (carry out)
    andi t2, t2, 0x1        # t2 = carry out from D5
    andi s0, s0, 0xF        # s0 = s0 & 0xF

    # Shift D4 (s1)
    slli s1, s1, 1
    or s1, s1, t2           # s1 = s1 | carry_in
    srli t3, s1, 4
    andi t3, t3, 0x1        # t3 = carry out from D4
    andi s1, s1, 0xF

    # Shift D3 (s2)
    slli s2, s2, 1
    or s2, s2, t3
    srli t2, s2, 4
    andi t2, t2, 0x1        # t2 = carry out from D3
    andi s2, s2, 0xF

    # Shift D2 (s3)
    slli s3, s3, 1
    or s3, s3, t2
    srli t3, s3, 4
    andi t3, t3, 0x1        # t3 = carry out from D2
    andi s3, s3, 0xF

    # Shift D1 (s4)
    slli s4, s4, 1
    or s4, s4, t3
    srli t2, s4, 4
    andi t2, t2, 0x1        # t2 = carry out from D1
    andi s4, s4, 0xF

    # Shift D0 (s5)
    slli s5, s5, 1
    or s5, s5, t2
    srli t3, s5, 4
    andi t3, t3, 0x1        # t3 = carry out from D0
    andi s5, s5, 0xF

    # Step 3: Shift in the next binary bit into D0 (bit 17)
    srli t1, t0, 17         # t1 = N >> 17
    andi t1, t1, 0x1        # t1 = (N >> 17) & 0x1
    or s5, s5, t1           # s5 = s5 | bit_i

    ###############################################
    # Bit 16 (i = 16)
    ###############################################

    # Repeat steps similar to bit 17, adjusting for bit 16

    # Step 1: Adjust decimal digits

    # Adjust D5 (s0)
    srli t1, s0, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s0, s0, t1

    # Adjust D4 (s1)
    srli t1, s1, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s1, s1, t1

    # Adjust D3 (s2)
    srli t1, s2, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s2, s2, t1

    # Adjust D2 (s3)
    srli t1, s3, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s3, s3, t1

    # Adjust D1 (s4)
    srli t1, s4, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s4, s4, t1

    # Adjust D0 (s5)
    srli t1, s5, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s5, s5, t1

    # Step 2: Shift decimal digits and manage carries

    # Shift D5 (s0)
    slli s0, s0, 1
    srli t2, s0, 4
    andi t2, t2, 0x1
    andi s0, s0, 0xF

    # Shift D4 (s1)
    slli s1, s1, 1
    or s1, s1, t2
    srli t3, s1, 4
    andi t3, t3, 0x1
    andi s1, s1, 0xF

    # Shift D3 (s2)
    slli s2, s2, 1
    or s2, s2, t3
    srli t2, s2, 4
    andi t2, t2, 0x1
    andi s2, s2, 0xF

    # Shift D2 (s3)
    slli s3, s3, 1
    or s3, s3, t2
    srli t3, s3, 4
    andi t3, t3, 0x1
    andi s3, s3, 0xF

    # Shift D1 (s4)
    slli s4, s4, 1
    or s4, s4, t3
    srli t2, s4, 4
    andi t2, t2, 0x1
    andi s4, s4, 0xF

    # Shift D0 (s5)
    slli s5, s5, 1
    or s5, s5, t2
    srli t3, s5, 4
    andi t3, t3, 0x1
    andi s5, s5, 0xF

    # Step 3: Shift in the next binary bit into D0 (bit 16)
    srli t1, t0, 16         # t1 = N >> 16
    andi t1, t1, 0x1        # t1 = (N >> 16) & 0x1
    or s5, s5, t1           # s5 = s5 | bit_i

    ###############################################
    # Bit 15 (i = 15)
    ###############################################

    # Step 1: Adjust decimal digits

    # Adjust D5 (s0)
    srli t1, s0, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s0, s0, t1

    # Adjust D4 (s1)
    srli t1, s1, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s1, s1, t1

    # Adjust D3 (s2)
    srli t1, s2, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s2, s2, t1

    # Adjust D2 (s3)
    srli t1, s3, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s3, s3, t1

    # Adjust D1 (s4)
    srli t1, s4, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s4, s4, t1

    # Adjust D0 (s5)
    srli t1, s5, 2
    andi t1, t1, 0x1
    slli t1, t1, 2
    add s5, s5, t1

    # Step 2: Shift decimal digits and manage carries

    # Shift D5 (s0)
    slli s0, s0, 1
    srli t2, s0, 4
    andi t2, t2, 0x1
    andi s0, s0, 0xF

    # Shift D4 (s1)
    slli s1, s1, 1
    or s1, s1, t2
    srli t3, s1, 4
    andi t3, t3, 0x1
    andi s1, s1, 0xF

    # Shift D3 (s2)
    slli s2, s2, 1
    or s2, s2, t3
    srli t2, s2, 4
    andi t2, t2, 0x1
    andi s2, s2, 0xF

    # Shift D2 (s3)
    slli s3, s3, 1
    or s3, s3, t2
    srli t3, s3, 4
    andi t3, t3, 0x1
    andi s3, s3, 0xF

    # Shift D1 (s4)
    slli s4, s4, 1
    or s4, s4, t3
    srli t2, s4, 4
    andi t2, t2, 0x1
    andi s4, s4, 0xF

    # Shift D0 (s5)
    slli s5, s5, 1
    or s5, s5, t2
    srli t3, s5, 4
    andi t3, t3, 0x1
    andi s5, s5, 0xF

    # Step 3: Shift in the next binary bit into D0 (bit 15)
    srli t1, t0, 15         # t1 = N >> 15
    andi t1, t1, 0x1        # t1 = (N >> 15) & 0x1
    or s5, s5, t1           # s5 = s5 | bit_i

    ###############################################
    # Continue unrolling for bits 14 down to 0
    ###############################################

    # After processing all bits, decimal digits are in s0 to s5

    # End of program
    li a7, 10        # ecall for exit in RARS (for ECALL convention)
    ecall
