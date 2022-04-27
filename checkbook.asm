#####################################################################
# Assignment #5: Check Book	Programmer: Erik Dohr
# Due Date: 	4/25/21		Course: CSC 225 040
# Last Modified: 04/25/21
#####################################################################
# Functional Description:
# This program can be used to balance your check book.
# <DESCRIBE IN ENGLISH YOUR OVERFLOW FEATURE HERE>
#####################################################################
# Pseudocode:
# 	Print Header;
#	s0 = 0;
# loop:	Prompt user for transaction;
#	v0 << transaction amount;
#	if (v0 = 0) done;
#	s0 = s0 + v0;
#<INSERT PSEUDOCODE FOR OVERFLOW DETECTION ALGORITHM HERE>
#	$t0 = xor (pre-addition total, post addition total)
#	$t1 = xor (value to add, post addition total) //these two lines evaluate whether the values being added together are of the same sign
#	$t0 = and ($t1, $t0) //if they ARE of the same signs
#	bltz $t0, overflow   //AND the  sum is less than zero and overflow must have occured.
#
#	cout << s0
#	go to loop
# done:
# 	cout << "Adios Amigo"
# 
######################################################################
# Register Usage:
# $v0: Transaction Amount
# $s0: Current Bank Balance
#	<HERE YOU DECLARE ANY ADDITIONAL REGISTERS USED>
######################################################################
	.data			# Data declaration section
Head: 	.ascii	"\n\tThis program, written by Erik \"SpazBot\" Dohr,"
	.ascii	" can be used to balance your check book."
	.asciiz	"\n\n\t\t\t\t\t\t\t\t\t  Balance"
tabs:	.asciiz	"\t\t\t\t\t\t\t\t\t"
tran:	.asciiz	"\nTransaction:"
bye:	.asciiz	"\n  ****  Adios Amigo  **** "
OverflowMsg: .asciiz "\nAn Overflow had Occured - This transaction has been ignored."

	.text			# Executable code follows
main:
	li	$v0, 4		# system call code for print_string
	la	$a0, Head	# load address of Header message into $a0
	syscall			# print the Header

	move	$s0, $zero	# Set Bank Balance to zero
loop:
	li	$v0, 4		# system call code for print_string
	la	$a0, tran	# load address of prompt into $a0
	syscall			# print the prompt message

	li	$v0, 5		# system call code for read_integer
	syscall			# reads the amount of  Transaction into $v0

	beqz	$v0, done	# If $v0 equals zero, branch to done
	move	$s2, $s0	#I added this line to store the pre-addition account total for logical use
	addu 	$s0, $s0, $v0	# add transaction amount to the Balance
	
	#MY CODE HERE#
	
	xor	$t0, $s0, $s2	#comparing original bank balance against the sum to get its complement
	xor	$t1, $v0, $s0	#compare inputed value against the sum balance to get sign
	and	$t0, $t0, $t1	#comparing the two signs
	bltz	$t0, overflow
	
	#MY CODE ENDS HERE#

	li	$v0, 4		# system call code for print_string
	la	$a0, tabs	# load address of tabs into $a0
	syscall			# used to space over to the Balance column
	
	li	$v0, 1		# system call code for print_integer
	move	$a0, $s0	# move Bank Balance value to $a0 
	syscall			# print Bank Balance
	b 	loop		# branch to loop

overflow:
	li $v0, 4
	la $a0, OverflowMsg
	syscall
	j loop

done:
	li	$v0, 4		# system call code for print_string
	la	$a0, bye	# load address of msg. into $a0
	syscall			# print the string

	li	$v0, 10		# terminate program run and
	syscall			# return control to system
				# END OF PROGRAM
