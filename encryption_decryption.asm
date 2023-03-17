# ENCRYPTION - DECRYPTION ALGORITHM
# SEDEN DENIZ TASKIN (sedendeniz)
# GIRAY COSKUN (giraycoskun)

.data

prompt0: .asciiz  "\nProgram is Running\n"
prompt1: .asciiz  "\n Plain (Input) Text \n"
prompt2: .asciiz  "\n Cipher (Encrypted) Text \n"
prompt3: .asciiz  "\n Plain (Decrypted) Text \n"
prompt4: .asciiz  " - "
prompt5: .asciiz  "\n"

initial_vectors: 	.word 0x3412, 0x7856, 0xBC9A, 0xF0DE
keys: 			.word 0x2301, 0x6745, 0xAB89, 0xEFCD, 0xDCFE, 0x98BA, 0x5476, 0x1032
state_vectors: 		.word 0xb8e7, 0x2d36, 0xb912, 0x0186, 0x87c3, 0x9fda, 0xa855, 0x7f84
plain_text: 		.word 0, 0, 0, 0, 0, 0, 0, 0
cipher_text:		.word 0, 0, 0, 0, 0, 0, 0, 0
decrypted_text:		.word 0, 0, 0, 0, 0, 0, 0, 0
temp: 			.word 0, 0, 0, 0, 0, 0, 0, 0

S0: .word 0xF, 0x4, 0x5, 0x8, 0x9, 0x7, 0x2, 0x1, 0xA, 0x3, 0x0, 0xE, 0x6, 0xC, 0xD, 0xB
S1: .word 0x4, 0xA, 0x1, 0x6, 0x8, 0xF, 0x7, 0xC, 0x3, 0x0, 0xE, 0xD, 0x5, 0x9, 0xB, 0x2
S2: .word 0x2, 0xF, 0xC, 0x1, 0x5, 0x6, 0xA, 0xD, 0xE, 0x8, 0x3, 0x4, 0x0, 0xB, 0x9, 0x7
S3: .word 0x7, 0xC, 0xE, 0x9, 0x2, 0x1, 0x5, 0xF, 0xB, 0x6, 0xD, 0x0, 0x4, 0x8, 0xA, 0x3


S: .word 0xF, 0x4, 0x5, 0x8, 0x9, 0x7, 0x2, 0x1, 0xA, 0x3, 0x0, 0xE, 0x6, 0xC, 0xD, 0xB,
	  0x4, 0xA, 0x1, 0x6, 0x8, 0xF, 0x7, 0xC, 0x3, 0x0, 0xE, 0xD, 0x5, 0x9, 0xB, 0x2,
	  0x2, 0xF, 0xC, 0x1, 0x5, 0x6, 0xA, 0xD, 0xE, 0x8, 0x3, 0x4, 0x0, 0xB, 0x9, 0x7,
	  0x7, 0xC, 0xE, 0x9, 0x2, 0x1, 0x5, 0xF, 0xB, 0x6, 0xD, 0x0, 0x4, 0x8, 0xA, 0x3

S_inverse: .word 	0xA, 0x7, 0x6, 0x9, 0x1, 0x2, 0xC, 0x5, 0x3, 0x4, 0x8, 0xF, 0xD, 0xE, 0xB, 0x0,
		0x9, 0x2, 0xF, 0x8, 0x0, 0xC, 0x3, 0x6, 0x4, 0xD, 0x1, 0xE, 0x7, 0xB, 0xA, 0x5,
		0xC, 0x3, 0x0, 0xA, 0xB, 0x4, 0x5, 0xF, 0x9, 0xE, 0x6, 0xD, 0x2, 0x7, 0x8, 0x1,
		0xB, 0x5, 0x4, 0xF, 0xC, 0x6, 0x9, 0x0, 0xD, 0x3, 0xE, 0x8, 0x1, 0xA, 0x2, 0x7

# 4352 13090 21828 30566 39304 48042 56780 65518

.text

main:
	la $a0, prompt0
	li $v0, 4
	syscall
	
	##INPUT##
	add $s0, $zero, $zero
	la $s1, plain_text
inputLoop:
	
	li $v0, 5
      	syscall		
      	move $t0, $v0
	
	add $t2, $s0, $s0
	add $t2, $t2, $t2
	add $t2, $t2, $s1
	
	sw $t0, 0($t2)
	
	addi $s0, $s0, 1
	bne $s0, 8, inputLoop
	
	#########
	
	##PRINT PLAINTEXT##
	la $a0, prompt1
	la $a1, plain_text
	jal print
	#########
	
	##ENCRYPTION##
	
	add $s0, $zero, $zero
encLoop:
	add $t2, $s0, $s0
	add $t2, $t2, $t2
	la $t0, plain_text
	add $t2, $t2, $t0
	lw $a0, 0($t2)
	la $a1, keys
	la $a2, state_vectors
	la $a3, temp
	jal encryption
	move $s1, $v0
	
	add $t2, $s0, $s0
	add $t2, $t2, $t2
	la $t0, cipher_text
	add $t2, $t2, $t0
	sw $s1, 0($t2)
	
	addi $s0, $s0, 1
	bne $s0, 8, encLoop
	
	#########
	
	##PRINT CIPHER TEXT##
	la $a0, prompt2
	la $a1, cipher_text
	jal print
	#########
	
	
	##INITIALIZATION##
	la $a0, initial_vectors
	la $a1, keys
	la $a2, state_vectors
	la $a3, temp
	
	jal initialization
	#########
	
	##DECRYPTION##
	add $s0, $zero, $zero
decLoop:

	add $t2, $s0, $s0
	add $t2, $t2, $t2
	la $t0, cipher_text
	add $t2, $t2, $t0
	lw $a0, 0($t2)
	la $a1, keys
	la $a2, state_vectors
	la $a3, temp
	jal decryption
	move $s1, $v0
	
	add $t2, $s0, $s0
	add $t2, $t2, $t2
	la $t0, decrypted_text
	add $t2, $t2, $t0
	sw $s1, 0($t2)
	
	addi $s0, $s0, 1
	bne $s0, 8, decLoop
	#########
	
	##PRINT DECRYPTED TEXT##
	la $a0, prompt3
	la $a1, decrypted_text
	jal print
	#########
	
	
	li $v0, 10
	syscall
 
 print:
 	#a0 -> prompt title
 	#a1 -> array to print
 	
 	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	move $s1, $a0
 	move $s2, $a1
 	
 	add $s0, $zero, $zero
 	move $a0, $s1
 	li $v0, 4
      	syscall	
      	
 printLoop:
 	
	add $t2, $s0, $s0
	add $t2, $t2, $t2
	add $t2, $t2, $s2
	
	lw $t0, 0($t2)
	
	move $a0, $t0
	li $v0, 34
	syscall
	
	la $a0, prompt4
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	la $a0, prompt5
	li $v0, 4
	syscall
	
	
	addi $s0, $s0, 1
	bne $s0, 8, printLoop
 	
 	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16	
	jr $ra



    encryption:

	#s0, s1, s2, s3, s4, s5, s6, s7
	addi $sp, $sp, -36
	sw $ra, 32($sp)
	sw $s7, 28($sp)
	sw $s6, 24($sp)
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	move $s0, $a0 # plain text word
	move $s1, $a1 # keys
	move $s2, $a2 # states
	move $s3, $a3 # temp array for w func
	
	#t0
	lw $t0, 0($s2) #t0 = R0
	add $t0, $t0, $s0
	and $t0, $t0, 65535 #0000 0000 0000 0000 1111 1111 111 11111 -> mod 2^16
	sw $t0, 0($s3)
	
	lw $t0, 0($s2) #t0 = R0
	lw $t1, 0($s1) #t1 = K0
	xor $t0, $t0, $t1
	sw $t0, 4($s3)
	
	lw $t0, 4($s2) #t0 = R1
	lw $t1, 4($s1) #t1 = K1
	xor $t0, $t0, $t1
	sw $t0, 8($s3)
	
	lw $t0, 8($s2) #t0 = R2
	lw $t1, 8($s1) #t1 = K2
	xor $t0, $t0, $t1
	sw $t0, 12($s3)
	
	lw $t0, 12($s2) #t0 = R3
	lw $t1, 12($s1) #t1 = K3
	xor $t0, $t0, $t1
	sw $t0, 16($s3)
	
	move $a0, $s3
	jal w_function
	move $s4, $v0 #s4 = t0
	
	#t1
	lw $t0, 4($s2) #t0 = R1
	add $t0, $t0, $s4
	and $t0, $t0, 65535 #0000 0000 0000 0000 1111 1111 111 11111 -> mod 2^16
	sw $t0, 0($s3)
	
	lw $t0, 16($s2) #t0 = R4
	lw $t1, 16($s1) #t1 = K4
	xor $t0, $t0, $t1
	sw $t0, 4($s3)
	
	lw $t0, 20($s2) #t0 = R5
	lw $t1, 20($s1) #t1 = K5
	xor $t0, $t0, $t1
	sw $t0, 8($s3)
	
	lw $t0, 24($s2) #t0 = R6
	lw $t1, 24($s1) #t1 = K6
	xor $t0, $t0, $t1
	sw $t0, 12($s3)
	
	lw $t0, 28($s2) #t0 = R7
	lw $t1, 28($s1) #t1 = K7
	xor $t0, $t0, $t1
	sw $t0, 16($s3)
	
	move $a0, $s3
	jal w_function
	move $s5, $v0 #s5 = t1
	
	#t2
	lw $t0, 8($s2) #t0 = R2
	add $t0, $t0, $s5
	and $t0, $t0, 65535 #0000 0000 0000 0000 1111 1111 111 11111 -> mod 2^16
	sw $t0, 0($s3)
	
	lw $t0, 16($s2) #t0 = R4
	lw $t1, 0($s1) #t1 = K0
	xor $t0, $t0, $t1
	sw $t0, 4($s3)
	
	lw $t0, 20($s2) #t0 = R5
	lw $t1, 4($s1) #t1 = K1
	xor $t0, $t0, $t1
	sw $t0, 8($s3)
	
	lw $t0, 24($s2) #t0 = R6
	lw $t1, 8($s1) #t1 = K2
	xor $t0, $t0, $t1
	sw $t0, 12($s3)
	
	lw $t0, 28($s2) #t0 = R7
	lw $t1, 12($s1) #t1 = K3
	xor $t0, $t0, $t1
	sw $t0, 16($s3)
	
	move $a0, $s3
	jal w_function
	move $s6, $v0 #s6 = t2
	
	#C
	lw $t0, 12($s2) #t0 = R3
	add $t0, $t0, $s6
	and $t0, $t0, 65535 #0000 0000 0000 0000 1111 1111 111 11111 -> mod 2^16
	sw $t0, 0($s3)
	
	lw $t0, 0($s2) #t0 = R0
	lw $t1, 16($s1) #t1 = K4
	xor $t0, $t0, $t1
	sw $t0, 4($s3)
	
	lw $t0, 4($s2) #t0 = R1
	lw $t1, 20($s1) #t1 = K5
	xor $t0, $t0, $t1
	sw $t0, 8($s3)
	
	lw $t0, 8($s2) #t0 = R2
	lw $t1, 24($s1) #t1 = K6
	xor $t0, $t0, $t1
	sw $t0, 12($s3)
	
	lw $t0, 12($s2) #t0 = R3
	lw $t1, 28($s1) #t1 = K7
	xor $t0, $t0, $t1
	sw $t0, 16($s3)
	
	move $a0, $s3
	jal w_function
	move $t0, $v0 #t0 = C
	
	lw $t1, 0($s2)
	add $t0, $t0, $t1
	and $t0, $t0, 65535
	move $v0, $t0 #v0 = C
	
	la $s7, temp
	
	#T0
	lw $t0, 0($s2)
	add $t0, $t0, $s6
	and $t0, $t0, 65535 #t0 = T0
	sw $t0, 0($s7)
	
	#T1
	lw $t1, 4($s2)
	add $t1, $t1, $s4
	and $t1, $t1, 65535 #t1 = T1
	sw $t1, 4($s7)
	
	#T2
	lw $t2, 8($s2)
	add $t2, $t2, $s5
	and $t2, $t2, 65535 #t2 = T2
	sw $t2, 8($s7)
	
	#T3
	lw $t3, 12($s2)
	lw $t8, 0($s2)
	add $t3, $t3, $t8
	add $t3, $t3, $s6
	add $t3, $t3, $s4
	and $t3, $t3, 65535 #t3 = T3
	sw $t3, 12($s7)
	
	#T4
	lw $t4, 16($s2)
	xor $t4, $t4, $t3 #t4 = T4
	sw $t4, 16($s7)
	
	#T5
	lw $t5, 4($s2)
	add $t5, $t5, $s4
	and $t5, $t5, 65535
	lw $t8, 20($s2)
	xor $t5, $t5, $t8 #t5 = T5
	sw $t5, 20($s7)
	
	#T6
	lw $t6, 8($s2)
	add $t6, $t6, $s5
	and $t6, $t6, 65535
	lw $t8, 24($s2)
	xor $t6, $t6, $t8 #t6 = T6
	sw $t6, 24($s7)
	
	#T7
	lw $t7, 0($s2)
	add $t7, $t7, $s6
	and $t7, $t7, 65535
	lw $t8, 28($s2)
	xor $t7, $t7, $t8 #t7 = T7
	sw $t7, 28($s7)
	
	add $t0, $zero, $zero #t8 = i
	
encryption_endloop:
	
	add $t1, $t0, $t0
	add $t1, $t1, $t1
	add $t2, $t1, $s7
	add $t3, $t1, $s2
	lw  $t4, 0($t2)
	sw  $t4, 0($t3)
	
	addi $t0, $t0, 1
	bne $t0, 8, encryption_endloop
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36	
	jr $ra
	
	
initialization:
	
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	move $s0, $a0 # initial vectors 
	move $s1, $a1 # keys
	move $s2, $a2 # states
	move $s4, $a3 # temp array for w func


	add $t0, $zero, $zero  #t0 = i
	
initializationLoop:
	beq $t0, 8, initializationEndLoop
	
	
	move $t1, $t0
	addi $t2, $zero, 4
	divu $t1, $t2
	mfhi $t1      # t1 = i mod4
	
	add $t1, $t1, $t1
	add $t1, $t1, $t1
	add $t1, $t1, $s0
	lw $t2, 0($t1)
	
	add $t1, $t0, $t0
	add $t1, $t1, $t1
	add $t1, $t1, $s2
	sw $t2, 0($t1)
	
	addi $t0, $t0, 1   
	
	j initializationLoop
	
initializationEndLoop:

	add $s3, $zero, $zero
	
calculationLoop:
	
	# t0
	lw $t0, 0($s2)
	add $t0, $t0, $s3
	and $t0, $t0, 65535 #0000 0000 0000 0000 1111 1111 111 11111
	
	sw $t0, 0($s4)
	lw $t1, 0($s1)
	sw $t1, 4($s4)
	lw $t2, 4($s1)
	sw $t2, 8($s4)
	lw $t3, 8($s1)
	sw $t3, 12($s4)
	lw $t4, 12($s1)
	sw $t4, 16($s4)
	move $a0, $s4
	jal w_function
	move $s5, $v0  # s5 = t0
	
	# t1
	lw $t0, 4($s2)
	add $t0, $t0, $s5
	and $t0, $t0, 65535
	
	sw $t0, 0($s4)
	
	lw $t1, 16($s1)
	sw $t1, 4($s4)
	
	lw $t2, 20($s1)
	sw $t2, 8($s4)
	
	lw $t3, 24($s1)
	sw $t3, 12($s4)
	
	lw $t4, 28($s1)
	sw $t4, 16($s4)
	
	move $a0, $s4
	jal w_function
	move $s6, $v0  # s6 = t1
	
	# t2
	lw $t0, 8($s2)
	add $t0, $t0, $s6
	and $t0, $t0, 65535
	
	sw $t0, 0($s4)
	
	lw $t1, 0($s1)
	sw $t1, 4($s4)
	
	lw $t2, 8($s1)
	sw $t2, 8($s4)
	
	lw $t3, 16($s1)
	sw $t3, 12($s4)
	
	lw $t4, 24($s1)
	sw $t4, 16($s4)
	
	move $a0, $s4
	jal w_function
	move $s7, $v0  # s7 = t2
	
	# t3
	lw $t0, 12($s2)
	add $t0, $t0, $s7
	and $t0, $t0, 65535
	
	sw $t0, 0($s4)
	
	lw $t1, 4($s1)
	sw $t1, 4($s4)
	
	lw $t2, 12($s1)
	sw $t2, 8($s4)
	
	lw $t3, 20($s1)
	sw $t3, 12($s4)
	
	lw $t4, 28($s1)
	sw $t4, 16($s4)
	
	move $a0, $s4
	jal w_function
	move $t9, $v0  # s4 = t3
	
	# R0(i+1)
	lw $t0, 0($s2)
	add $t0, $t0, $t9
	and $t0, $t0, 65535
	
	sll $t1, $t0, 16
	or $t1, $t0, $t1
	rol $t1, $t1, 3
	srl $t1, $t1, 16
	sw $t1, 0($s2)
	
	# R1(i+1)
	lw $t0, 4($s2)
	add $t0, $t0, $s5
	and $t0, $t0, 65535
	
	sll $t1, $t0, 16
	or $t1, $t0, $t1
	ror $t1, $t1, 5
	srl $t1, $t1, 16
	sw $t1, 4($s2)
	
	# R2(i+1)
	lw $t0, 8($s2)
	add $t0, $t0, $s6
	and $t0, $t0, 65535
	
	sll $t1, $t0, 16
	or $t1, $t0, $t1
	rol $t1, $t1, 8
	srl $t1, $t1, 16
	sw $t1, 8($s2)
	
	# R3(i+1)
	lw $t0, 12($s2)
	add $t0, $t0, $s7
	and $t0, $t0, 65535
	
	sll $t1, $t0, 16
	or $t1, $t0, $t1
	rol $t1, $t1, 6
	srl $t1, $t1, 16
	sw $t1, 12($s2)
	
	# R4(i+1)
	lw $t0, 16($s2)
	lw $t1, 12($s2)
	xor $t0, $t0, $t1
	sw $t0, 16($s2)
	
	# R5(i+1)
	lw $t0, 20($s2)
	lw $t1, 4($s2)
	xor $t0, $t0, $t1
	sw $t0, 20($s2)
	
	# R6(i+1)
	lw $t0, 24($s2)
	lw $t1, 8($s2)
	xor $t0, $t0, $t1
	sw $t0, 24($s2)
	
	# R7(i+1)
	lw $t0, 28($s2)
	lw $t1, 0($s2)
	xor $t0, $t0, $t1
	sw $t0, 28($s2)
	
	addi $s3, $s3, 1
	bne $s3, 4, calculationLoop

	move $v0, $s2

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24

	jr $ra
	

############

		
w_function:

	#s0, s1, s2, s3, s4
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	lw $s0, 0($a0)
	lw $s1, 4($a0)
	lw $s2, 8($a0)
	lw $s3, 12($a0)
	lw $s4, 16($a0)
	
	xor $t0, $s0, $s1
	move $a0, $t0
	jal f_function
	move $t0, $v0
	
	xor $t0, $t0, $s2
	move $a0, $t0
	jal f_function
	move $t0, $v0
	
	xor $t0, $t0, $s3
	move $a0, $t0
	jal f_function
	move $t0, $v0
	
	xor $t0, $t0, $s4
	move $a0, $t0
	jal f_function
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	jr $ra

	
	
f_function:

	#s0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# a0 is also input to nonlinear function
	jal smalltable_nonlinear_function #largetable_nonlinear_function
	move $a0, $v0
	jal linear_function
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4	
	jr $ra
	
	
	
linear_function:

	#s0, s1, s2
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s0, $a0
	sll $t0, $s0, 16
	or $t1, $s0, $t0
	
	rol $s1, $t1, 6
	ror $s2, $t1, 6
	
	srl $s1, $s1, 16
	srl $s2, $s2, 16
	
	xor $t1, $s0, $s1
	xor $t1, $t1, $s2
	
	move $v0, $t1
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16	
	jr $ra


largetable_nonlinear_function:

	#s0, s1, s2, s3
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	
	move $t0, $a0
	addi $t1, $zero, 15 #0000000000001111
	addi $t2, $zero, 240 #0000000011110000
	addi $t3, $zero, 3840 #0000111100000000
	addi $t4, $zero, 61440 #1111000000000000
	
	and $s3, $t0, $t1 
	and $s2, $t0, $t2
	srl $s2, $s2, 4
	and $s1, $t0, $t3
	srl $s1, $s1, 8
	and $s0, $t0, $t4
	srl $s0, $s0, 12
	
	la $t5, S
	
	add $t1, $zero, $t5
	add $s0, $s0, $s0
	add $s0, $s0, $s0
	add $t1, $t1, $s0
	lw  $s0, 0($t1)
	
	add $t2, $zero, $t5
	addi $s1, $s1, 16
	add $s1, $s1, $s1
	add $s1, $s1, $s1
	add $t2, $t2, $s1
	lw  $s1, 0($t2)
	
	add $t3, $zero, $t5
	addi $s2, $s2, 32
	add $s2, $s2, $s2
	add $s2, $s2, $s2
	add $t3, $t3, $s2
	lw  $s2, 0($t3)
	
	add $t4, $zero, $t5
	addi $s3, $s3, 48
	add $s3, $s3, $s3
	add $s3, $s3, $s3
	add $t4, $t4, $s3
	lw  $s3, 0($t4)
	
	sll $s0, $s0, 12
	sll $s1, $s1, 8
	sll $s2, $s2, 4
	
	or $s0, $s0, $s1
	or $s0, $s0, $s2
	or $s0, $s0, $s3

	move $v0, $s0
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra
	
smalltable_nonlinear_function:

	#s0, s1, s2, s3
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $t0, $a0
	addi $t1, $zero, 15 # 0000000000001111
	addi $t2, $zero, 240 # 0000000011110000
	addi $t3, $zero, 3840 # 0000111100000000
	addi $t4, $zero, 61440 # 1111000000000000
	and $s3, $t0, $t1 
	and $s2, $t0, $t2
	srl $s2, $s2, 4
	and $s1, $t0, $t3
	srl $s1, $s1, 8
	and $s0, $t0, $t4
	srl $s0, $s0, 12
	
	la $t5, S0
	
	add $t1, $zero, $t5
	add $s0, $s0, $s0
	add $s0, $s0, $s0
	add $t1, $t1, $s0
	lw  $s0, 0($t1)
	
	la $t5, S1
	
	add $t2, $zero, $t5
	add $s1, $s1, $s1
	add $s1, $s1, $s1
	add $t2, $t2, $s1
	lw  $s1, 0($t2)
	
	la $t5, S2
	
	add $t3, $zero, $t5
	add $s2, $s2, $s2
	add $s2, $s2, $s2
	add $t3, $t3, $s2
	lw  $s2, 0($t3)
	
	la $t5, S3
	
	add $t4, $zero, $t5
	add $s3, $s3, $s3
	add $s3, $s3, $s3
	add $t4, $t4, $s3
	lw  $s3, 0($t4)
	
	sll $s0, $s0, 12
	sll $s1, $s1, 8
	sll $s2, $s2, 4
	
	or $s0, $s0, $s1
	or $s0, $s0, $s2
	or $s0, $s0, $s3

	move $v0, $s0
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra
	
s_function_inverse:

	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	la $s0, S_inverse
	
	move $t0, $a0
	and $s1, $t0, 15 # t0 and 0000000000001111
	and $s2, $t0, 240 # t0 and 0000000011110000
	and $s3, $t0, 3840 # 0000111100000000
	and $s4, $t0, 61440 # 1111000000000000
	srl $s2, $s2, 4
	srl $s3, $s3, 8
	srl $s4, $s4, 12
	
	add $t0, $zero, $s0
	addi $s1, $s1, 48
	add $s1, $s1, $s1
	add $s1, $s1, $s1
	add $t0, $t0, $s1
	lw  $s1, 0($t0)
	
	add $t0, $zero, $s0
	addi $s2, $s2, 32
	add $s2, $s2, $s2
	add $s2, $s2, $s2
	add $t0, $t0, $s2
	lw  $s2, 0($t0)
	
	add $t0, $zero, $s0
	addi $s3, $s3, 16
	add $s3, $s3, $s3
	add $s3, $s3, $s3
	add $t0, $t0, $s3
	lw  $s3, 0($t0)
	
	add $t0, $zero, $s0
	add $s4, $s4, $s4
	add $s4, $s4, $s4
	add $t0, $t0, $s4
	lw  $s4, 0($t0)
	
	sll $s2, $s2, 4
	sll $s3, $s3, 8
	sll $s4, $s4, 12
	
	or $s1, $s1, $s2
	or $s1, $s1, $s3
	or $s1, $s1, $s4
	
	move $v0, $s1
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24	
	jr $ra

linear_function_inverse:

	#s0, s1, s2
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	move $s0, $a0

	sll $t0, $s0, 16
	or $t1, $s0, $t0
	
	rol $s1, $t1, 10
	ror $s2, $t1, 10
	
	srl $s1, $s1, 16
	srl $s2, $s2, 16
	
	xor $t1, $s0, $s1
	xor $s3, $t1, $s2    # s3 = Y
	
	sll $t0, $s3, 16
	or $t1, $s3, $t0
	
	rol $s1, $t1, 4
	ror $s2, $t1, 4
	
	srl $s1, $s1, 16
	srl $s2, $s2, 16
	
	xor $t1, $s3, $s1
	xor $t1, $t1, $s2    # t1 = L-1(X)
	
	move $v0, $t1
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra

f_function_inverse:

	#s0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# a0 is also input to inverse linear function
	jal  linear_function_inverse
	move $a0, $v0
	jal s_function_inverse
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4	
	jr $ra
	

w_function_inverse:

	#s0, s1, s2, s3, s4
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	lw $s0, 0($a0)		# X
	lw $s1, 4($a0)		# A
	lw $s2, 8($a0)		# B
	lw $s3, 12($a0)		# C
	lw $s4, 16($a0)		# D
	
	move $a0, $s0
	jal f_function_inverse
	move $t0, $v0
	
	xor $t0, $t0, $s4
	
	move $a0, $t0
	jal f_function_inverse
	move $t0, $v0
	
	xor $t0, $t0, $s3
	
	move $a0, $t0
	jal f_function_inverse
	move $t0, $v0
	
	xor $t0, $t0, $s2
	move $a0, $t0
	jal f_function_inverse
	move $t0, $v0
	
	xor $t0, $t0, $s1
	move $v0, $t0
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	jr $ra
	
decryption:

	#s0, s1, s2, s3, s4, s5, s6, s7
	addi $sp, $sp, -36
	sw $ra, 32($sp)
	sw $s7, 28($sp)
	sw $s6, 24($sp)
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	move $s0, $a0 # cipher text word
	move $s1, $a1 # keys
	move $s2, $a2 # states
	move $s3, $a3 # temp array for w func
	
	#t2
	lw $t0, 0($s2) #t2 = R0
	sub $t0, $s0, $t0
	addi $t0, $t0, 65536 #1 0000 0000 0000 0000
	and $t0, $t0, 65535 #0000 0000 0000 0000 1111 1111 111 11111 -> mod 2^16
	sw $t0, 0($s3)
	
	lw $t0, 0($s2) #t0 = R0
	lw $t1, 16($s1) #t1 = K4
	xor $t0, $t0, $t1
	sw $t0, 4($s3)
	
	lw $t0, 4($s2) #t0 = R1
	lw $t1, 20($s1) #t1 = K5
	xor $t0, $t0, $t1
	sw $t0, 8($s3)
	
	lw $t0, 8($s2) #t0 = R2
	lw $t1, 24($s1) #t1 = K6
	xor $t0, $t0, $t1
	sw $t0, 12($s3)
	
	lw $t0, 12($s2) #t0 = R3
	lw $t1, 28($s1) #t1 = K7
	xor $t0, $t0, $t1
	sw $t0, 16($s3)
	
	move $a0, $s3
	jal w_function_inverse
	move $s4, $v0 
	
	lw $t0, 12($s2) #t0 = R3
	sub $s4, $s4, $t0
	addi $s4, $s4, 65536
	and $s4, $s4, 65535  #s4 = t2
	
	
	#t1
	sw $s4, 0($s3)
	
	lw $t0, 16($s2) #t0 = R4
	lw $t1, 0($s1) #t1 = K0
	xor $t0, $t0, $t1
	sw $t0, 4($s3)
	
	lw $t0, 20($s2) #t0 = R5
	lw $t1, 4($s1) #t1 = K1
	xor $t0, $t0, $t1
	sw $t0, 8($s3)
	
	lw $t0, 24($s2) #t0 = R6
	lw $t1, 8($s1) #t1 = K2
	xor $t0, $t0, $t1
	sw $t0, 12($s3)
	
	lw $t0, 28($s2) #t0 = R7
	lw $t1, 12($s1) #t1 = K3
	xor $t0, $t0, $t1
	sw $t0, 16($s3)
	
	move $a0, $s3
	jal w_function_inverse
	move $s5, $v0 
	
	lw $t0, 8($s2) #t0 = R2
	sub $s5, $s5, $t0
	addi $s5, $s5, 65536
	and $s5, $s5, 65535  #s5 = t1
	
	#t0
	sw $s5, 0($s3)
	
	lw $t0, 16($s2) #t0 = R4
	lw $t1, 16($s1) #t1 = K4
	xor $t0, $t0, $t1
	sw $t0, 4($s3)
	
	lw $t0, 20($s2) #t0 = R5
	lw $t1, 20($s1) #t1 = K5
	xor $t0, $t0, $t1
	sw $t0, 8($s3)
	
	lw $t0, 24($s2) #t0 = R6
	lw $t1, 24($s1) #t1 = K6
	xor $t0, $t0, $t1
	sw $t0, 12($s3)
	
	lw $t0, 28($s2) #t0 = R7
	lw $t1, 28($s1) #t1 = K7
	xor $t0, $t0, $t1
	sw $t0, 16($s3)
	
	move $a0, $s3
	jal w_function_inverse
	move $s6, $v0 
	
	lw $t0, 4($s2) #t0 =R1
	sub $s6, $s6, $t0
	addi $s6, $s6, 65536
	and $s6, $s6, 65535  #s6 = t0
	
	#P
	sw $s6, 0($s3)
	
	lw $t0, 0($s2) #t0 = R0
	lw $t1, 0($s1) #t1 = K0
	xor $t0, $t0, $t1
	sw $t0, 4($s3)
	
	lw $t0, 4($s2) #t0 = R1
	lw $t1, 4($s1) #t1 = K1
	xor $t0, $t0, $t1
	sw $t0, 8($s3)
	
	lw $t0, 8($s2) #t0 = R2
	lw $t1, 8($s1) #t1 = K2
	xor $t0, $t0, $t1
	sw $t0, 12($s3)
	
	lw $t0, 12($s2) #t0 = R3
	lw $t1, 12($s1) #t1 = K3
	xor $t0, $t0, $t1
	sw $t0, 16($s3)
	
	move $a0, $s3
	jal w_function_inverse
	move $s7, $v0 
	
	lw $t0, 0($s2) #t0 = R0
	sub $s7, $s7, $t0
	addi $s7, $s7, 65536
	and $s7, $s7, 65535  #s7 = P
	
	move $v0, $s7
	
	move $s7, $s3
	
	#T0
	lw $t0, 0($s2)
	add $t0, $t0, $s4
	and $t0, $t0, 65535 #t0 = T0
	sw $t0, 0($s7)
	
	#T1
	lw $t1, 4($s2)
	add $t1, $t1, $s6
	and $t1, $t1, 65535 #t1 = T1
	sw $t1, 4($s7)
	
	#T2
	lw $t2, 8($s2)
	add $t2, $t2, $s5
	and $t2, $t2, 65535 #t2 = T2
	sw $t2, 8($s7)
	
	#T3
	lw $t3, 12($s2)
	lw $t8, 0($s2)
	add $t3, $t3, $t8
	add $t3, $t3, $s4
	add $t3, $t3, $s6
	and $t3, $t3, 65535 #t3 = T3
	sw $t3, 12($s7)
	
	#T4
	lw $t4, 16($s2)
	xor $t4, $t4, $t3 #t4 = T4
	sw $t4, 16($s7)
	
	#T5
	lw $t5, 4($s2)
	add $t5, $t5, $s6
	and $t5, $t5, 65535
	lw $t8, 20($s2)
	xor $t5, $t5, $t8 #t5 = T5
	sw $t5, 20($s7)
	
	#T6
	lw $t6, 8($s2)
	add $t6, $t6, $s5
	and $t6, $t6, 65535
	lw $t8, 24($s2)
	xor $t6, $t6, $t8 #t6 = T6
	sw $t6, 24($s7)
	
	#T7
	lw $t7, 0($s2)
	add $t7, $t7, $s4
	and $t7, $t7, 65535
	lw $t8, 28($s2)
	xor $t7, $t7, $t8 #t7 = T7
	sw $t7, 28($s7)
	
	add $t0, $zero, $zero #t8 = i
	
decryption_endloop:
	
	add $t1, $t0, $t0
	add $t1, $t1, $t1
	add $t2, $t1, $s7
	add $t3, $t1, $s2
	lw  $t4, 0($t2)
	sw  $t4, 0($t3)
	
	addi $t0, $t0, 1
	bne $t0, 8, decryption_endloop
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36	
	jr $ra

