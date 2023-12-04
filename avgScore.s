.data 

orig: .space 100	# In terms of bytes (25 elements * 4 bytes each)
sorted: .space 100

str0: .asciiz "Enter the number of assignments (between 1 and 25): "
str1: .asciiz "Enter score: "
str2: .asciiz "Original scores: "
str3: .asciiz "Sorted scores (in descending order): "
str4: .asciiz "Enter the number of (lowest) scores to drop: "
str5: .asciiz "Average (rounded down) with dropped scores removed: "
endl: .asciiz "\n"
space: .asciiz " "


.text 

# This is the main program.
# It first asks user to enter the number of assignments.
# It then asks user to input the scores, one at a time.
# It then calls selSort to perform selection sort.
# It then calls printArray twice to print out contents of the original and sorted scores.
# It then asks user to enter the number of (lowest) scores to drop.
# It then calls calcSum on the sorted array with the adjusted length (to account for dropped scores).
# It then prints out average score with the specified number of (lowest) scores dropped from the calculation.
main: 
	addi $sp, $sp -4
	sw $ra, 0($sp)
	li $v0, 4 
	la $a0, str0 
	syscall 
	li $v0, 5	# Read the number of scores from user
	syscall
	move $s0, $v0	# $s0 = numScores
	move $t0, $0
	la $s1, orig	# $s1 = orig
	la $s2, sorted	# $s2 = sorted
loop_in:
	li $v0, 4 
	la $a0, str1 
	syscall 
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	li $v0, 5	# Read elements from user
	syscall
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	bne $t0, $s0, loop_in
	
	move $a0, $s0
	jal selSort	# Call selSort to perform selection sort in original array
	
	li $v0, 4 
	la $a0, str2 
	syscall
	move $a0, $s1	# More efficient than la $a0, orig
	move $a1, $s0
	jal printArray	# Print original scores
	li $v0, 4 
	la $a0, str3 
	syscall 
	move $a0, $s2	# More efficient than la $a0, sorted
	jal printArray	# Print sorted scores
	
	li $v0, 4 
	la $a0, str4 
	syscall 
	li $v0, 5	# Read the number of (lowest) scores to drop
	syscall
	move $a1, $v0
	sub $a1, $s0, $a1	# numScores - drop
	move $a0, $s2
	jal calcSum	# Call calcSum to RECURSIVELY compute the sum of scores that are not dropped
	
	# Your code here to compute average and print it
	
	lw $ra, 0($sp)
	addi $sp, $sp 4
	li $v0, 10 
	syscall
	
	
# printList takes in an array and its size as arguments. 
# It prints all the elements in one line with a newline at the end.
printArray:
	# Loop
	addi $t0, $zero, 0
print_loop:
	bge $t0, $a1, print_epilogue
	sll $t1, $t0, 2
	add $t1, $t1, $a0
	# save $a0
	add $t2, $zero, $a0
	lw $a0, 0($t1)
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, space
	syscall
	# restore $a0
	add $a0, $zero, $t2
	addi $t0, $t0, 1
	j print_loop
	# Epilogue
print_epilogue:
	jr $ra
	
	
# selSort takes in the number of scores as argument. 
# It performs SELECTION sort in descending order and populates the sorted array
selSort:
	# Your implementation of selSort here
	# PROLOGUE
	addi $sp, $sp, -12
	sw $s1, 0($sp)
	sw $s2, 4($sp)
	sw $s3, 8($sp)

	# copy orig to sorted
	# load the address of our arrays
	la $s1, orig
	la $s2, sorted
	# initialize our counter
	addi $t0, $zero, 0
sel_copy_loop:
	bge $t0, $a0, sel_copy_epilogue
	# index into orig
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	# load the value at that index
	lw $t2, 0($t1) 
	# index into sorted
	sll $t3, $t0, 2
	add $t3, $t3, $s2
	# store the value to that index
	sw $t2, 0($t3) 
	#increment our counter
	addi $t0, $t0, 1
	# jump 
	j sel_copy_loop 
sel_copy_epilogue:

	# initialize our counter
	addi $t0, $zero, 0
	addi $s3, $a0, -1
sel_sort_outer_loop:
    bge $t0, $s3, sel_sort_outer_loop_epilogue
	# set our maxIndex
	addi $t1, $t0, 0
	# initialize our counter
	addi $t2, $t0, 1
sel_sort_inner_loop:
	bge $t2, $a0, sel_sort_inner_loop_epilogue
	

sel_sort_inner_loop_epilogue:

sel_sort_outer_loop_epilogue:

	# EPILOGUE
	lw $s1, 0($sp)
	lw $s2, 4($sp)
	lw $s3, 8($sp)
	addi $sp, $sp, 8
	jr $ra
	
	
# calcSum takes in an array and its size as arguments.
# It RECURSIVELY computes and returns the sum of elements in the array.
# Note: you MUST NOT use iterative approach in this function.
calcSum:
	# Your implementation of calcSum here
	
	jr $ra
	
