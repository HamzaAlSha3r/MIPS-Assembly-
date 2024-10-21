# Hamza AL Shaer  ->  1211162    -> section 3
# Bashar Hamza 	 ->  1210530    -> section 2

.data 
file_name: .asciiz "C:/Users/hamza/Desktop/courses/Arc/project1/tests.txt"
file_words: .space 1024 
cleaned_buffer: .space 1024
op1_buffer: .space 35 
update_buffer: .space 35
temprory_buffer: .space 35
temprory_bufferN: .space 35
space_char: .asciiz " "
meg_menu: .asciiz "Choose one of the following options \n "
msg_op1: .asciiz  " 1- Add a new medical test  \n " 
msg_op2: .asciiz  " 2- Search for a test by patient ID \n " 
msg_op2_s1: .asciiz  " 1- Retrieve all patient tests \n "
msg_op2_s2: .asciiz  " 2- Retrieve all up normal patient tests \n "
msg_op2_s3: .asciiz  " 3- Retrieve all patient tests in a given specific period \n "
msg_op3: .asciiz  " 3- Searching for unnormal tests \n " 
msg_op4: .asciiz  " 4- Average test value \n " 
msg_op5: .asciiz  " 5- Update an existing test result \n " 
msg_op6: .asciiz  " 6- Delete a test \n "
msg_op7: .asciiz  " 7- Exit the program \n "
Enter_date1: .asciiz  " Enter date range :- \n From: \n "
Enter_date2: .asciiz  " \n To: \n "
msg_enter: .asciiz  " Enter your data : \n  (Write it in the following form :- \n ID: Test_Name, Date(xxxx-xx), Result)  \n \n "
msg_error_file: .asciiz  " Error opening the file \n "
max_reached_error: .asciiz "The number you've entered is illogical, we have stored the maximum value of the number you have entered \n"
ID_doesnt_exist: .asciiz  " There doesn't exit an ID equal to the one you have entered. \n "
msg_ID_NotMatch: .asciiz "The number you are looking for does not exist \n "
msg_Finish_of_program: .asciiz  " The program has been terminated \n "
invalid_id_error: .asciiz "Error --> We found at least one of the patients with an invalid ID, or found a deleted patient. (Patient tests with invalid IDs won't be saved) \n"
not_found_error: .asciiz  "The data you've entered doesn't exist \n "
valid_data: .asciiz  "  The data is valid and has been stored. \n"
newLine: .asciiz "\n"
invalid_date_error: .asciiz "Error --> We found at least one of the patients with an invalid date. (Patient tests with an invalid date won't be saved) \n Note:- \n We only accept dates in the range 2000-2050. "
op2_chosesMsg: .asciiz "\n choose any  selection : \n \n "

date_range1: .space 8
date_range2: .space 8
patient_ID: .space 8   # Allocate space for 7 digits + null terminator
Name_of_Test: .space 4
msg_enterID: .asciiz "Please enter your 7-digit ID: \n"
msg_enterName: .asciiz "Please enter your medical test : \n"
op2_buffer: .space 35
msg_op10: .asciiz  " Enter the test data of whom you want to delete \n (Write it in the following form :- \n ID: Test_Name, Date(xxxx-xx), Result)  \n "
msg_op9: .asciiz  " Enter the new result \n "
msg_op8: .asciiz  " Enter the test data you want to update \n (Write it in the following form :- \n ID: Test_Name, Date(xxxx-xx))  \n "
deleted_test: .asciiz " The patient test has been deleted. \n "
not_deleted: .asciiz " There wasn't found a user with such data. Make sure you entered the data correctly \n "
result_conv: .space 5
minus_char: .ascii "-"
.text 
.globl main 
main: 
############################## open the file ########################################################################################### 
	li $v0,13               
        la $a0,file_name         
        li $a1,0               
        syscall
        move $s0,$v0 
     	blt $v0 , 0 , invalid_file_name  # error handling for invalid file name if $v0 has value neagtive         
    
############################### read the file ###########################################################################################
    	li $v0, 14       
   	move $a0 , $s0        
    	la $a1,file_words      
    	la $a2, 1024     
   	syscall 
   	
############################## Close the file ######################################################################################################
        li $v0, 16               
        move $a0,$s0              
        syscall
############################# Performing the operation that the user wants to perform ##############################################################         

      	la $t8 , file_words 
      	jal validate_buffer 	# call implimation for Data Validation 
      	
      	la $a0,cleaned_buffer
	li $v0,4
	syscall 
	
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall
	
get_value_from_user: 
       	
       	jal print_Menu          # print menu option on consal
       	
       	li $v0, 5	       # reading a integer form user (number of opration) 
	syscall 
	
	move $t1,$v0           # Save the value entered from the user in t1
	
	# cases of Mune  
	beq $t1 , 1 , Add_a_new_medical_test
	beq $t1 , 2 , Search_for_a_test_by_patient_ID
	beq $t1 , 3 , Searching_for_unnormal_tests
	beq $t1 , 4 , Average_test_value
	beq $t1 , 5 , Update_an_existing_test_result
	beq $t1 , 6 , Delete_a_test
	beq $t1 , 7 , exit_a 
	
######################################### implemantion for option in Mune ######################################################################
# case 1 add a new test
Add_a_new_medical_test:
	la $a0 ,msg_enter	# print the mssegge to enter your data 
	li $v0 , 4 
	syscall 
	
	la $a0, op1_buffer 	 # op1 buffer to store new test 
	li $a1, 35 		 # $a1 = max string length
	li $v0, 8 		 # read string
	syscall
	
	
	la $t8 , op1_buffer     	 # save the addres for op1_bufffer
	jal add_newTest_validate2 # cheack validate and store
	
		
	la $a0,cleaned_buffer
	li $v0,4
	syscall
	 
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
	j get_value_from_user
	
# case 2 search by id of patient
Search_for_a_test_by_patient_ID:
    	# Print msg (enter the ID you want to search for it)
    	la $a0, msg_enterID
    	li $v0, 4           	      	 
   	syscall

    	# Read input
    	li $v0, 8           
    	la $a0, patient_ID  	 #  to store input (ID we want to search for it )
    	li $a1, 8           	 # maximum number of characters to read including null terminator
   	syscall
   	
   	la $t6 , patient_ID 
   	
	# print options for Search for a test by patient ID 
	la $a0 ,op2_chosesMsg
	li $v0 , 4 
	syscall
	la $a0 ,msg_op2_s1
	li $v0 , 4 
	syscall
	la $a0 ,msg_op2_s2
	li $v0 , 4 
	syscall 
	la $a0 ,msg_op2_s3
	li $v0 , 4 
	syscall 
	
	li $v0, 5	       # reading a integer form user input from console 
	syscall 
	
	move $t7,$v0           # Save the value entered from the user in t2
	
	
	# cases of Search for a test by patient ID  
	beq $t7 , 1 , Retrieve_all_patient_tests
	beq $t7 , 2 , Retrieve_all_up_normal_patient_tests
	beq $t7 , 3 , Retrieve_all_patient_tests_in_a_given_specific_period
# case 3 search for unormal tests
Searching_for_unnormal_tests:
    	# Print msg (enter the name of test you want to search for it)
    	la $a0, msg_enterName
    	li $v0, 4           	 	     
   	syscall

    	# Read input
    	li $v0, 8           
    	la $a0, Name_of_Test  	 	#  to store input (name of test we want search for it )
    	li $a1, 4          	 	# maximum number of characters to read including null terminator
   	syscall
   		
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall 

	la $s1 , cleaned_buffer		# get addres of cleaned buffer
   	la $s4 , Name_of_Test  		# store addres of nameTset entered in s4
	move $s2 , $s4    		# store addres of name Tesst 
	addi $s1, $s1 ,9			# add 9 to reach name of test in cleaned buffer
	j compare_Name_LoopN
	
complate_compareN:
 	addi $s1 , $s1 , 1     		# to skip '\n' in cleaned buffer in next test
        lb $t9, ($s1)
        beq $t9 , '\0' , end_compareN
        beq $t9 , '\n' , complate_compareN
        	addi $s1, $s1 ,9			# add 9 to reach name of test in cleaned buffer in next test

compare_Name_LoopN:
	lb   $t7  , ($s4) 			# load first byte from name test we want search for it 
	lb $t8 , ($s1)  		        		# load firs byte from start of test in cleaned buffer
	beq  $t8  , ',' , compare_Result_LoopN 	# if reach ',' then this name test we search for it so go to compare result  
	bne  $t7  , $t8  , Name_notMatchN 	# if not equal then it not name of test we search for it 
	addi $s4 , $s4 , 1
	addi $s1 , $s1 , 1
	j compare_Name_LoopN
	
compare_Result_LoopN:
	subi $s1,$s1,12	      		# sub 12 to reach first addres in test and store it in s7
	move $s7 , $s1  		     	  
	addi $s1 , $s1 , 9  	 	# add 9 for s1 to return to reach name of test
	lb $t8 , ($s1) 
	beq $t8 , 'H' , Hgb_testN
	beq $t8 , 'B' , BGTOrBPT_testN
	beq $t8 , 'L' , LDL_testN
Hgb_testN:
	addi $s1 , $s1 , 14	 	# add 14 for s1 to reach result of test for ID searched in data (cleaned buffer)
	lb $t8 , ($s1)
	# cheack range of normal test Hgp 13.8 - 17.2 
	bne $t8, '1', unnormal_testN 
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
	blt $t8, '3', unnormal_testN  		
    	bgt $t8, '7', unnormal_testN
    	beq $t8 , '7' , CASE1N 
    	beq $t8 , '3' , CASE2N		 
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
	bne $t8, '.', unnormal_testN
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
    	j Retrieve_this_testN
    	
CASE1N:
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
	bne $t8, '.', unnormal_testN
	addi $s1 , $s1 , 1 
	lb $t8 , ($s1)
	bgt $t8 ,'2', unnormal_testN
	j Retrieve_this_testN

CASE2N:
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
	bne $t8, '.', unnormal_testN
	addi $s1 , $s1 , 1 
	lb $t8 , ($s1)
	blt $t8 ,'8', unnormal_testN
	j Retrieve_this_testN
LDL_testN:
	# cheack range of normal test LDL less than 100
	addi $s1 , $s1 , 14	  	# add 14 for s1 to reach result of test for test name we searched for it in data
	addi $s1 , $s1 , 3        	# add 3 for s1 to reach last digit in result
	lb $t8 , ($s1) 
	beq $t8  , '\0' ,Retrieve_this_testN 
	bne $t8 , '\n' , unnormal_testN 	# if If the third digit not equal \n then the result 100 or more so unnormal test
    	j Retrieve_this_testN
	
BGTOrBPT_testN:
	addi $s1 , $s1 , 1		# add 1 for s1 to reach second char of name test 
	lb $t8 , ($s1)
	beq $t8 , 'P' , BPT_testN
	beq $t8 , 'G' , BGT_testN

BGT_testN:
	addi $s1 , $s1 , 13	  	# add 13 for s1 to reach result of test for ID searched in data (cleaned buffer)
	lb $t8 , ($s1)
	# cheack range of normal test BGT  70 - 99 
	blt $t8, '7', unnormal_testN    # if first digit less than 7 then unnormal 
	addi $s1 , $s1 , 3              # add 2 for s1 to reach last digit in result
	lb $t8 , ($s1) 
	beq $t8  , '\0' ,Retrieve_this_testN 
	bne $t8 , '\n' , unnormal_testN 	# if If the third digit not equal \n then the result 100 or more so unnormal test  		
	j Retrieve_this_testN
BPT_testN:
	addi $s1 , $s1 , 13	  	# add 13 for s1 to reach result of test for ID searched in data (cleaned buffer)
	# cheack Systolic Blood Pressure less than 120
	addi $s1 , $s1 , 2 
	lb $t8 , ($s1)
	beq $t8 , ',' , cheack_Diastolic_Blood_PressureN 	# if third digit of result equal ',' then result from two digit ( < 120 )
	subi $s1, $s1 ,2
	lb $t8 , ($s1)		
    	bgt $t8, '1', unnormal_testN
    	addi $s1 , $s1 , 1
    	lb $t8 , ($s1)
    	bgt $t8, '2', unnormal_testN  
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
	beq $t8 , ',' , cheack_Diastolic_Blood_PressureN  
	
cheack_Diastolic_Blood_PressureN:
	addi $s1 , $s1 , 2   			# add 2 to arrive result of Diastolic_Blood_Pressur by skip ',' and space 
	# cheack Diastolic Blood Pressure less than 80
	lb $t8 , 2($s1)	
	beq $t8  , '\0' ,Retrieve_this_testN 
	bne $t8 , '\n' , unnormal_testN
	lb $t8 , ($s1)
	bgt $t8, '8', unnormal_testN
	j Retrieve_this_testN 
unnormal_testN:
	la $s4 , Name_of_Test  			# to return $s4 share for start addres of name test we need search for it
	j skip_testN
Name_notMatchN: 
	la $s4 , Name_of_Test 			# to return $s4 share for start addres of name test we need search for it
	j skip_testN
 
skip_testN:
    	addi $s1 , $s1 , 1
    	lb $t8 , ($s1)
    	beq $t8, '\0', end_compareN
    	beq $t8 , '\n', complate_compareN
    	j skip_testN	
	
Retrieve_this_testN:   	
	la $s4 , Name_of_Test 			# to return $s4 share for start addres of name test we need search for it	
	la $t0 ,  temprory_bufferN		# t0 share for temprory buffer to store test we want print it 
LOOPN:
	lb $t6 , ($s7) 				# load from s7 and store in temprory , such that s7 share for first addres in test
	sb $t6 , ($t0)
	beq $t6 , '\n' , Retrieve_temprory_bufferN        # when reach \n then we reach for end of test it we need Retrieve
	addi $s7 ,$s7 , 1
	addi $t0 ,$t0 , 1 
	j LOOPN
	
Retrieve_temprory_bufferN:
	# print temprory buffer
	la $a0,temprory_bufferN 
	li $v0,4
	syscall 
	
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
	j complate_compareN
end_compareN:
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
	j get_value_from_user	
		
# case 4 calc avg of test 
Average_test_value:
	# counter for tests
	li $t0 , 0 # hgb
	li $t1 , 0 # BGT
	li $t3 , 0 #LDL
	li $t4 , 0 # BPTs
	li $t5 , 0 # BPTd
	# results of summation of test
	li $s0 , 0 # hgb
	li $s1 , 0 # BGT
	li $s3 , 0 #LDL
	li $s4 , 0 # BPTs
	li $s5 , 0 # BPTd
	
	# get addres of cleaned buffer
	la $s2 , cleaned_buffer
	la $s7 , result_conv
	 
compare_nameTest_Loop:
	addi $s2 , $s2 , 9
	lb $t8 , ($s2)  
	beq $t8 , 'H' , Hgb_test
	beq $t8 , 'B' , BGTOrBPT_test
	beq $t8 , 'L' , LDL_test
	
Hgb_test9:
	addi $t0 , $t0 , 1
	jal store_result
	jal convert_floating 
	 
	
LDL_test9:
	addi $t3 , $t3 , 1
	jal store_result 

BGTOrBPT_test9:
	addi $s2 , $s2 , 1		# add 1 for s1 to reach second char of name test 
	lb $t8 , ($s2)
	beq $t8 , 'G' , BGT_test
	j SBP_test

BGT_test9:
	addi $t1 , $t1 , 1
	jal store_result 
SBP_test:
	addi $t4 , $t4 , 1
	jal store_resultB 
DBP_test:
	addi $t5 , $t5 , 1
  	jal store_resultB 

store_result:
	addi $s2 , $s2 , 14
	lb $t9  , ($s2) 
	beq $t9 , '\n' , DONE 
	sb $t9 , ($s7)
	addi $s7 , $s7 , 1
	addi $s2 , $s2 , 1
store_resultB:
	addi $s2 , $s2 , 13

DONE:
	jr $ra 


end_compare3:
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
	j get_value_from_user
	
# case 5 update tset result 
Update_an_existing_test_result:
        la $s2, cleaned_buffer
        la $s7, space_char    # $s7 poinst towards the location of the space character
        lb $s6, ($s7)         # We have the space character stored in $s6 now
        
        	la $a0, cleaned_buffer
	li $v0, 4
	syscall 
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
	
        la $a0, msg_op8      # Print msg  ( The test which we will update )
        li $v0, 4
        syscall
        
        la $a0, op1_buffer   # Load the data test which the user entered to search for
        li $a1, 35
        li $v0, 8
        syscall
        
        	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
	
        la $t1, op1_buffer
        move $s1, $t1
        
        la $a0, msg_op9     # Print msg ( The updated test )
        li $v0, 4
        syscall
        
        la $a0, update_buffer     # Load the new updated data test which we will use to update the cleaned_buffer
        li $a1, 35
        li $v0, 8
        syscall
        
        	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
        
        la $t3, update_buffer
        move $s5, $s2
next_test:        
        move $s5, $s2    # Save the address of the beginning of each test/line
        move $t1, $s1    # Make $t1 point towards the beginning of the line which we will search for and use it for comparing again
        addi $s5, $s5, 23 # Make $s5 point towards the first byte of the result which we will update
compare_line:
        lb $t5, ($s2)    # Load first byte from the cleaned_buffer so we can compare
        lb $t4, ($t1)    # Load first byte from the buffer which holds the line we will search for  
        beq $t5, '-', continue_comparing
        bne $t5, $t4, go_next
        addi $t1, $t1, 1   
        addi $s2, $s2, 1
        j compare_line
        
continue_comparing:
        lb $t5, ($s2)
        lb $t4, ($t1)
        bne $t5, $t4, go_next
        addi $s2, $s2, 1
        addi $t1, $t1, 1
        lb $t5, ($s2)
        lb $t4, ($t1)
        bne $t5, $t4, go_next
        addi $s2, $s2, 1
        addi $t1, $t1, 1
        j update_test
                                              
update_test:
        lb $t4, ($t3)    # Load first byte from the updated_buffer
        lb $t6, ($s5)
        beq $t6, '\n', check_for_newline  # Go to check if the updated one also finished at the \n then it's normal else exit at max.
        beq $t4, '\n', check_the_rest     # If the updated one finished at '\n' before the original one then put spaces for the remaning bytes in the cleaned buffer for the same line
        sb $t4, ($s5)    # Update the cleaned buffer with the new updated_buffer
        addi $t3, $t3, 1
        addi $s5, $s5, 1
        j update_test
        
go_next:
        lb $t4, ($s2)          # Keep moving $s2 which points towards the cleaned buffer into the next line
        beq $t4, '\n', move_one  # Once we reach the \n we go to move_one so we add another 1 and skip the new line
        addi $s2, $s2, 1
        j go_next
        
move_one:
        addi $s2, $s2, 1
        lb $t4, ($s2)
        beq $t4, '\0', not_found
        j next_test 
                      
not_found:
        la $a0, not_found_error      # Once we reach this stage, that means we have reached the end of the cleaned buffer without finding the data the user entered
        li $v0, 4                    # So we will print an error message indicating that the data entered doesn't exist
        syscall
        	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
        j get_value_from_user
        
check_the_rest:
        lb $t4, ($s5)
        beq $t4, '\n', exit_u
        sb $s6, ($s5)      # Store space character instead of the unwanted characters (This case is when the updated buffer has less values than the original one)
        addi $s5, $s5, 1
        j check_the_rest

check_for_newline:     # this case is to check if the original line and the updated one finish at the same char '\n'
        lb $t4, ($t3)
        beq $t4, '\n', exit_u
        j exit_max 
                    
exit_max:
        la $a0, max_reached_error    # This happens when the updated test has more characters than the max for a test so we cannot overwrite the next test
        li $v0, 4
        syscall
        	la $a0, cleaned_buffer
	li $v0, 4
	syscall        
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
        j get_value_from_user	        
       
exit_u: 
        	la $a0, cleaned_buffer
	li $v0, 4
	syscall        
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
	j get_value_from_user
	
# case 6 delete test
Delete_a_test:
        la $s2, cleaned_buffer
        la $s7, minus_char    # $s7 poinst towards the location of the space character
        lb $s6, ($s7)         # We have the space character stored in $s6 now
        
        	la $a0, cleaned_buffer
	li $v0, 4
	syscall 
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
	
        la $a0, msg_op10      # Print msg  ( The test which we will delete )
        li $v0, 4
        syscall
        
        la $a0, op1_buffer   # Load the data test which the user entered to search for then delete it
        li $a1, 35
        li $v0, 8
        syscall
        
        	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
	
        la $t1, op1_buffer
        move $s1, $t1
        
new_test1:
        move $s5, $s2      # Make $s5 point towards the beginning of each line
        move $t1, $s1      # Make $t1 point towards the beginning of the line which we will search for and use it for comparing again
                
search_for_patient:
        lb $t4, ($s2)   # Load first byte from the beginning of each line (patient)
        lb $t5, ($t1)   # Load first byte from the op1_buffer which has the user of which we will delete
        bne $t4, $t5, go_next1
        beq $t4, '-', continue_comparing1
        addi $s2, $s2, 1
        addi $t1, $t1, 1
        j search_for_patient

continue_comparing1:
        lb $t4, ($s2)
        lb $t5, ($t1)
        bne $t4, $t5, go_next1
        beq $t4, ',', delete_test
        addi $s2, $s2, 1
        addi $t1, $t1, 1        
        j continue_comparing1
        
go_next1:
        lb $t4, ($s2)          # Keep moving $s2 which points towards the cleaned buffer into the next line
        beq $t4, '\n', move_one1  # Once we reach the \n we go to move_one so we add another 1 and skip the new line
        addi $s2, $s2, 1
        j go_next1
        
move_one1:
        addi $s2, $s2, 1
        lb $t4, ($s2)
        beq $t4, '\0', exit4
        j new_test1 
                     
         
delete_test:
        lb $t4, ($s5)
        beq $t4, '\n' exit_deleted      # Check if we reached a new line, we don't want to overwrite but we want to exit
        sb $s6, ($s5)      # Store spaces on each byte of the patient of which we will delete (Overwrite it with spaces)
        addi $s5, $s5, 1   # Move to the next byte in the patient line
        j delete_test
 
exit_deleted:
       la $a0, deleted_test           # If we reach this stage that means we have deleted the user so print a message indicating it
       li $v0, 4
       syscall
       
       la $a0 ,newLine		# print \n
       li $v0 , 4 
       syscall
       
        	la $a0, cleaned_buffer
	li $v0, 4
	syscall 
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall           
       j get_value_from_user
                       	
exit4:	
        la $a0, not_deleted      # Print a message that there wasn't a patient with such data
        li $v0, 4
        syscall
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall 
        	la $a0, cleaned_buffer
	li $v0, 4
	syscall 
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  	 
	j get_value_from_user
	
# case 7 exit 
exit_a:
	li $t0 , 0
	la $s2 , cleaned_buffer
loop9:
	lb $t9 , ($s2) 
	beq $t9 , '\0' , end
	addi $t0 , $t0 , 1
	addi $s2 , $s2 , 1
	j loop9
end:
	la $a0,file_name         # Open the file for writing
        li $a1,1                 # 1 = write, 0 = read
        li $v0, 13
        syscall

        move $a0,$v0             # Save file descriptor in $s0
        la $a1, cleaned_buffer
        move $a2, $t0            # Move number of characters from $t4 to $a2
        li $v0, 15               # For writing into a file
        syscall
        
        
	la $a0 ,msg_Finish_of_program # print message of exit program 
	li $v0 , 4 
	syscall 

	li $v0,10 	# exit
	syscall
	 
######################################### implimantion for cases for opration 2  (Search for a test by patient ID) #############################
# case 1 for (Search for a test by patient ID)
Retrieve_all_patient_tests:
        la $s7, space_char    # $s7 poinst towards the location of the space character
        lb $s6, ($s7)         # We have the space character stored in $s6 now
        la $t8, op2_buffer
	la $t1, cleaned_buffer
	la $t6, patient_ID
	move $t7, $t8   # Move address of op1_buffer to $t7
        li $s0, 0   # Flag bit 1 indicates that there actually exists a test with this id, 0 indicates that there are no tests with this id
new_line1:
        move $t5, $t1    # So we can save the initial address of the line
        
compare_id_loop:
        lb $t3, ($t1)       # Load byte from buffer\
        lb $t4, ($t6)
        beq $t3, ':', reset_buffer
        bne $t3, $t4, next_line    # If not equal then we have to skip printing this line
        addi $t6, $t6, 1     # Move to the next character in patient_ID
        addi $t1, $t1, 1    # Move to next character in buffer
        j compare_id_loop # Repeat loop

next_line:
        la $t6, patient_ID # Go back from the beginning so we can compare again
        addi $t1, $t1, 1 # Keep adding ones until new line is reached to compare a new patient ID
        lb $t3, ($t1)
        beq $t3, '\0', exit1
        beq $t3, '\n', skip_one1  #  Once we reach the new line that means we reached a new patient test but we have to skip the new line first
        j next_line

skip_one1:
        addi $t1, $t1, 1 # Added one so we can skip the new line and start the id validation
        lb $t3, ($t1)
        beq $t3, '\0', exit1
        j new_line1

print_test:
        li $s0, 1        # Since we reached this stage that means there exists an ID equal to the one the user entered so the flag has been set to 1
        lb $t9, ($t5)    # Here we load the value of $t5 which points at the beginning of the searched line
        sb $t9, ($t7)    # We store it into $t7 which points into op_buffer1
        beq $t9, '\0', exit1
        addi $t5, $t5, 1
        addi $t7, $t7, 1
        beq $t9, '\0', exit1
        beq $t9, '\n', print_test1
        j print_test
        
reset_buffer:
        lb $t9, ($t7)
        beq $t9, '\0', buffer_done
        sb $s6, ($t7)
        addi $t7, $t7, 1
        lb $t9, ($t7)
        beq $t9, '\n', buffer_done
        j reset_buffer
buffer_done:
       move $t7, $t8
       j print_test
                      
print_test1:
        la $a0, op2_buffer   # We print the saved value in op_buffer1
        li $v0, 4
        syscall
        move $t7, $t8   # Make $t7 point towards the beginning of op1_Buffer again so we can overwrite what was written and print the new line
        j next_line

exit2:
        la $a0, ID_doesnt_exist
        li $v0, 4
        syscall
        	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall
        j get_value_from_user
        
exit1:  
        	beq $s0, 0, exit2		
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall
	j get_value_from_user
# case 2 for (Search for a test by patient ID)
Retrieve_all_up_normal_patient_tests:
	la $s1 , cleaned_buffer		# get addres of cleaned buffer
   	la $s4 , patient_ID		# store addres of ID entered in s4
	move $s2 , $s4    		# store addres of ID pataint 
	j compare_ID_Loop
complate_compare:
        addi $s1 , $s1 , 1     		# to skip '\n' in buffer
        lb $t9, ($s1)
        beq $t9 , '\0' , end_compare
        beq $t9, '\n', complate_compare
compare_ID_Loop:
	lb   $t7  , ($s4) 		# load first byte from ID Patient to compare it
	lb $t8 , ($s1)  
	beq  $t8  , ':' , compare_Result_Loop # if reach : then this number we search for it so go to compare result  
	bne  $t7  , $t8  , ID_notMatch 	     # if not equal with we are save (cleaned buffer) then it not number we search for it 
	addi $s4 , $s4 , 1
	addi $s1 , $s1 , 1
	j compare_ID_Loop
	
compare_Result_Loop:
	move $s7 , $s1  	     		# save value of $s1 in $s7 when reach for : to help me in Retrieve test  
	addi $s1 , $s1 , 2   		# add 2 for s1 to reach name of test for ID searched in data (cleaned buffer)
	lb $t8 , ($s1) 
	beq $t8 , 'H' , Hgb_test
	beq $t8 , 'B' , BGTOrBPT_test
	beq $t8 , 'L' , LDL_test
Hgb_test:
	addi $s1 , $s1 , 14	 	# add 14 for s1 to reach result of test for ID searched in data (cleaned buffer)
	lb $t8 , ($s1)
	# cheack range of normal test Hgp 13.8 - 17.2 
	bne $t8, '1', unnormal_test 
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
	blt $t8, '3', unnormal_test  		
    	bgt $t8, '7', unnormal_test
    	beq $t8 , '7' , CASE1 
    	beq $t8 , '3' , CASE2		 
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
	bne $t8, '.', unnormal_test
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
    	j Retrieve_this_test
    	
CASE1:
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
	bne $t8, '.', unnormal_test
	addi $s1 , $s1 , 1 
	lb $t8 , ($s1)
	bgt $t8 ,'2', unnormal_test
	j Retrieve_this_test

CASE2:
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
	bne $t8, '.', unnormal_test
	addi $s1 , $s1 , 1 
	lb $t8 , ($s1)
	blt $t8 ,'8', unnormal_test
	j Retrieve_this_test
	
LDL_test:
	# cheack range of normal test LDL less than 100
	addi $s1 , $s1 , 14	  	# add 14 for s1 to reach result of test for ID searched in data (cleaned buffer)
	addi $s1 , $s1 , 3         	# add 3 for s1 to reach last digit in result
	lb $t8 , ($s1) 
	beq $t8  , '\0' ,Retrieve_this_test 
	bne $t8 , '\n' , unnormal_test 	# if If the third digit not equal \n then the result 100 or more so unnormal test
    	j Retrieve_this_test
	
BGTOrBPT_test:
	addi $s1 , $s1 , 1		# add 1 for s1 to reach second char of name test 
	lb $t8 , ($s1)
	beq $t8 , 'P' , BPT_test
	beq $t8 , 'G' , BGT_test

BGT_test:
	addi $s1 , $s1 , 13	  	# add 13 for s1 to reach result of test for ID searched in data (cleaned buffer)
	lb $t8 , ($s1)
	# cheack range of normal test BGT  70 - 99 
	blt $t8, '7', unnormal_test   	# if first digit less than 7 then unnormal 
	addi $s1 , $s1 , 3             	# add 2 for s1 to reach last digit in result
	lb $t8 , ($s1)
	beq $t8  , '\0' ,Retrieve_this_test  
	bne $t8 , '\n' , unnormal_test 	# if If the third digit not equal \n then the result 100 or more so unnormal test  		
	j Retrieve_this_test
BPT_test:
	addi $s1 , $s1 , 13	  	# add 13 for s1 to reach result of test for ID searched in data (cleaned buffer)
	# cheack Systolic Blood Pressure less than 120
	addi $s1 , $s1 , 2 
	lb $t8 , ($s1)
	beq $t8 , ',' , cheack_Diastolic_Blood_Pressure 	# if third digit of result equal ',' then result from two digit ( < 120 )
	subi $s1, $s1 ,2
	lb $t8 , ($s1)		
    	bgt $t8, '1', unnormal_test
    	addi $s1 , $s1 , 1
    	lb $t8 , ($s1)
    	bgt $t8, '2', unnormal_test  
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
	addi $s1 , $s1 , 1
	lb $t8 , ($s1)
	beq $t8 , ',' , cheack_Diastolic_Blood_Pressure  
	
cheack_Diastolic_Blood_Pressure:
	addi $s1 , $s1 , 2   		# add 2 to arrive result of Diastolic_Blood_Pressur by skip ',' and space 
	# cheack Diastolic Blood Pressure less than 80
	lb $t8 , 2($s1)	
	beq $t8  , '\0' ,Retrieve_this_test 
	bne $t8 , '\n' , unnormal_test
	lb $t8 , ($s1)
	bgt $t8, '8', unnormal_test
	j Retrieve_this_test 
unnormal_test:
	la $s4 , patient_ID			# to return $s4 share for start addres of name test we need search for it	
	j skip_test
ID_notMatch: 
	la $s4 , patient_ID			# to return $s4 share for start addres of name test we need search for it	
	j skip_test
 
skip_test:
    	addi $s1 , $s1 , 1
    	lb $t8 , ($s1)
    	beq $t8, '\0', end_compare
    	beq $t8 , '\n', complate_compare
    	j skip_test	
	
Retrieve_this_test:
	la $s4 , patient_ID			# to return $s4 share for start addres of name test we need search for it	
	subi $s7 , $s7 , 7   	 		# sub 7 from $s7 to reach first digit in ID in cleaned buufer
	la $t0 ,  temprory_buffer 		# t0 share for temprory buffer
LOOP:
	lb $t6 , ($s7) 
	sb $t6 , ($t0)
	beq $t6 , '\n' , Retrieve_temprory_buffer        	# when reach \n then we reach for end of test it we need Retrieve
	addi $s7 ,$s7 , 1
	addi $t0 ,$t0 , 1 
	j LOOP
	
Retrieve_temprory_buffer:
	# print temprory buffer
	la $a0,temprory_buffer 
	li $v0,4
	syscall 
	
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
	j complate_compare

end_compare:
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
	j get_value_from_user
	
# case 3 for (Search for a test by patient ID)
Retrieve_all_patient_tests_in_a_given_specific_period:
        la $s7, op1_buffer
        la $s1, cleaned_buffer
        la $t9, patient_ID
        la $s0, space_char
        lb $t0, ($s0)
        
        la $a0, Enter_date1    # Message to ask the user to enter the first date range
        li $v0, 4
        syscall
	
	move $s5, $s1   # To save the address of the first byte of the first patient (line)
	move $s6, $s7   # $s6 now points towards the beginning of op1_buffer
	
	li $v0, 8                 # To read the first date range
    	la $a0, date_range1  	 #  to store input
    	li $a1, 8           	 # maximum number of characters to read including null terminator
   	syscall
   	
   	la $t1, date_range1
   	move $s4, $t1             # To save the address of the first byte of the 1st range
   	
   	la $a0, Enter_date2    # Message to ask the user to enter the second date range
        li $v0, 4
        syscall

	
	li $v0, 8                 # To read the first date range
    	la $a0, date_range2  	 #  to store input
    	li $a1, 8           	 # maximum number of characters to read including null terminator
   	syscall		
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall 
	 
	la $t3, date_range2	
        move $s3, $t3             # To save the address of the first byte of the 2nd range

compare_id_loop2:
        lb $t4, ($s1)       # Load byte from cleaned_buffer
        lb $t5, ($t9)       # Load byte from patient_ID
        beq $t4, ':', move_to_date   # Reaching this stage means that they have the same ID
        bne $t4, $t5, Skip_line    # If not equal then we have to skip checking the date for this one
        addi $t9, $t9, 1     # Move to the next character in patient_ID
        addi $s1, $s1, 1    # Move to next character in buffer
        j compare_id_loop2 # Repeat loop
                
move_to_date:
        move $s1, $s5       #     $s1 now points towards the first byte of the line
        addi $s1, $s1, 14   #     Move the cleaned buffer to point towards the first byte of the date
        move $s2, $s1       #     To save the address of the first byte of the date of a line in the cleaned buffer
        move $t1, $s4       #     $t1 now points towards the first byte of the first date range
        move $t3, $s3       #     $t3 now points towards the first byte of the second date range
        	lb $t4, ($s1)      #     load first byte of the first date of the first line in the cleaned buffer
        	lb $t5, ($t1)	  # 	load first byte	of the first date range (1)
        	blt $t4, $t5, Skip_line
        	beq $t4, $t5, check_next_byte
        j check_next_range

check_next_byte:
        addi $s1, $s1, 1
        addi $t1, $t1, 1
        lb $t4, ($s1)      #    2x22-22
        	lb $t5, ($t1)	  #    2x22-22 	
        	blt $t4, $t5, Skip_line
        	addi $s1, $s1, 1
        	addi $t1, $t1, 1	
        lb $t4, ($s1)     #   22x2-22
        lb $t5, ($t1)     #   22x2-22
        blt $t4, $t5, Skip_line
        beq $t4, $t5, check_next_byte1
        j check_next_range
        
check_next_byte1:
        addi $s1, $s1, 1
        addi $t1, $t1, 1
         lb $t4, ($s1)     #    222x-22
        	lb $t5, ($t1)	  #    222x-22
        	blt $t4, $t5, Skip_line
        	beq $t4, $t5, check_month
        	j check_next_range

check_month:
        	addi $s1, $s1, 2   # Skip ( - )
        	addi $t1, $t1, 2   # Skip ( - )
        	lb $t4, ($s1)      # 2222-x2
        	lb $t5, ($t1)      # 2222-x2
        	blt $t4, $t5, Skip_line
        	beq $t4, $t5, check_next_byte2
        	j check_next_range
        	
check_next_byte2:
	addi $s1, $s1, 1
	addi $t1, $t1, 1
	lb $t4, ($s1)    # 2222-2x
	lb $t5, ($t1)    # 2222-2x
	blt $t4, $t5, Skip_line
	j check_next_range      	

check_next_range:
        move $s1, $s2  # $s1 now points towards the beginning of the date in the cleaned buffer
        lb $t4, ($s1)  # x222-22
        lb $t5, ($t3)  # x222-22
        bgt $t4, $t5, Skip_line
        beq $t4, $t5, check_next_byte_2
        j reset_buffer1
        
check_next_byte_2:
        addi $s1, $s1, 1
        addi $t3, $t3, 1
        lb $t4, ($s1)      #    2x22-22
        	lb $t5, ($t3)	  #    2x22-22 	
        	bgt $t4, $t5, Skip_line
        	addi $s1, $s1, 1
        	addi $t3, $t3, 1	
        lb $t4, ($s1)     #   22x2-22
        lb $t5, ($t3)     #   22x2-22
        bgt $t4, $t5, Skip_line
        beq $t4, $t5, check_next_byte1_2
        j reset_buffer1
        
check_next_byte1_2:
        addi $s1, $s1, 1
        addi $t3, $t3, 1
        lb $t4, ($s1)     #    222x-22
        	lb $t5, ($t3)	  #    222x-22
        	bgt $t4, $t5, Skip_line
        	beq $t4, $t5, check_month_2
        	j reset_buffer1

check_month_2:
        	addi $s1, $s1, 2   # Skip ( - )
        	addi $t3, $t3, 2   # Skip ( - )
        	lb $t4, ($s1)      # 2222-x2
        	lb $t5, ($t3)      # 2222-x2
        	bgt $t4, $t5, Skip_line
        	beq $t4, $t5, check_next_byte2_2
        	j reset_buffer1
        	
check_next_byte2_2:
	addi $s1, $s1, 1
	addi $t3, $t3, 1
	lb $t4, ($s1)    # 2222-2x
	lb $t5, ($t3)    # 2222-2x
	bgt $t4, $t5, Skip_line
	j reset_buffer1      

Skip_line:
        lb $t4, ($s1)
        beq $t4, '\n', Skip_one
        addi $s1, $s1, 1
        j Skip_line
        
Skip_one:
        addi $s1, $s1, 1
        lb $t4, ($s1)
        beq $t4, '\0', exit_d
        move $s5, $s1  # $s5 now points towards the first byte of the next line ( we will use it to print the line if needed )
        la $t9, patient_ID   # Now $t9 points towards the first byte of the patient ID which we will use to check the ID again for the next patient (line)
        j compare_id_loop2

print_line:
        lb $t8, ($s5)
        sb $t8, ($s6)
        beq $t8, '\0', exit_d
        addi $s5, $s5, 1
        addi $s6, $s6, 1        
        beq $t8, '\0', exit_d
        beq $t8, '\n', print_line2
        j print_line
        
print_line2:
        la $a0, op1_buffer
        li $v0, 4
        syscall
        move $s6, $s7   # Now $s6 towards  the beginning of op1_buffer which $s7 points to
        j Skip_line

reset_buffer1:
        lb $t4, ($s6)
        beq $t4, '\0', buffer_done1
        beq $t4, '\n', buffer_done1
        sb $t0, ($s6)        
        addi $s6, $s6, 1
        j reset_buffer1
buffer_done1:
       move $s6, $s7
       j print_line
               
                
exit_d:                             			       			      			       			              			       			      			       			
	la $a0 ,newLine		# print \n
	li $v0 , 4 
	syscall  
	j get_value_from_user
	
###################################### convert from string to floating ####################################
convert_floating:
    # Initialize variables
    li      $t6, 0          # Counter for digits before the decimal point
    li      $t7, 0          # Counter for digits after the decimal point
    li      $t8, 0          # Flag to track if the current digit is before or after the decimal point
    li      $t9, 10         # Base for decimal arithmetic
    
    mtc1 $zero,$f1
    cvt.s.w $f1,$f1
    mtc1 $t9,$f5
    cvt.s.w $f5,$f5
    mtc1 $t9,$f4
    cvt.s.w $f4,$f4
    
    
    # Load the address of the float number storage
    
    loop4:
        lb      $s6, 0($s7)    # Load the current character
        
        # Check if the current character is the decimal point
        beq     $s6 , '.', set_decimal_flag   # If decimal point, set decimal flag and continue
        
        # Check if the current character is the null terminator
        blt    $s6 ,'0' done3       # If not a digit, exit loop
        
        # Check if the current character is a digit
        bgt    $s6 ,'9' done3       # If not a digit, exit loop
        
        
        # Convert character to integer
        subi    $s6 , $s6, '0'  # Convert ASCII digit to integer
        
        # Check if the current digit is before or after the decimal point
        beq     $t8, $zero, before_decimal
        b       after_decimal
        
    before_decimal:
        # Multiply previous digits by base
        mul.s   $f1, $f1, $f4   # Multiply float number by 10
        mtc1    $s6, $f2         # Convert integer to float
        cvt.s.w $f2, $f2
        add.s   $f1, $f1, $f2    # Add digit to float number
        j       next_char
        
    after_decimal:
        # Divide following digits by base
        mtc1    $s6, $f2         # Convert integer to float
        cvt.s.w  $f2,$f2
        div.s   $f2, $f2, $f4    # Divide float number by divisor
        add.s   $f1, $f1, $f2    # Add digit to float number
        mul.s   $f4,$f4,$f5	   #muliply the divisor by 10
        j       next_char
        
    set_decimal_flag:
        # Set flag to indicate decimal point has been encountered
        li      $t8, 1           # Set decimal flag
        j       next_char
        
    next_char:
        # Move to the next character in the string
        addi    $a0, $a0, 1      # Move to next character
        j       loop4             # Repeat loop
        
    done3:
        # Store the final float number in memory
        addi $sp,$sp ,-4
        sw $ra,($sp)
        lw $ra ,($sp)
        addi $sp,$sp,4
        
        jr      $ra               # Return
  
###################################### implimantion for validity data #####################################
# Function to validate Buffer
validate_buffer:
    # move address of line buffer
    move $t1, $t8
    # Load address of cleaned buffer
    la $t2, cleaned_buffer
    li $t9, 1  # A flag to check if the whole file is valid 1 --> Valid, 0 --> Invalid
    j new_line
    

new_line:
    # Store the address at the beginning of each line so if it's valid we return to it and start storing the line in the cleaned buffer
    move $t4, $t1
    # Loop through characters of ID
validate_id_loop:
    lb $t3, ($t1)       # Load byte from buffer
    beq $t3, ':', date_validation    # If ':' is encountered, ID is valid
    blt $t3, 48, id_invalid   # If character is less than (Asci) '0', ID is invalid
    bgt $t3, 57, id_invalid   # If character is greater than (Asci) '9', ID is invalid
    addi $t1, $t1, 1    # Move to next character in buffer
    j validate_id_loop # Repeat loop
    
date_validation:
    # Only dates between 2000-2059 are acceptable
    addi $t1, $t1, 7  # Skip ':' , space, name, and ','
    lb $t3, ($t1)
    bne $t3, '2' date_invalid   # Only 2 is acceptable in '2'xxx
    addi $t1, $t1, 1 
    lb $t3, ($t1)
    bne $t3, '0', date_invalid   # Only 0 is acceptable in x'0'xx
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bgt $t3, '5', date_invalid    # Only 0-5 are acceptable in xx'0-5'x
    blt $t3, '0', date_invalid
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bgt $t3, '9', date_invalid   # Only 0-9 are acceptable in xxx'0-9'
    blt $t3, '0', date_invalid
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bne $t3, '-' date_invalid   # Check that only '-' format is acceptable
    addi $t1, $t1, 1
    lb $t3, ($t1)
    beq $t3, '1', case1  # Case when the month starts with 1 then the number next to it has to be 0-2
    bgt $t3, '1', date_invalid  # We are checking the 1st digit in month so it has to be either 1 or 0 since we are here, then it has to be 0
    blt $t3, '0', date_invalid
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bgt $t3, '9', date_invalid   # Since the first number is 0 then the 2nd number has to be in the range '0-9'
    ble $t3, '0', date_invalid
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bne $t3, ',', date_invalid	# if not equal , then date invalid month greatar than from 2 digit
    j date_valid
    
case1:
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bgt $t3, '2', date_invalid  # Since the first number is 1 then the 2nd number has to be in the range '0-2'
    blt $t3, '0', date_invalid
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bne $t3, ',', date_invalid	# if not equal , then date invalid month greatar than from 2 digit
    j date_valid
    
skip_line:
    lb $t3, ($t1)
    beq $t3, '\n', skip_one  #  Once we reach the new line that means we reached a new patient test but we have to skip the new line first
    addi $t1, $t1, 1 # Keep adding ones until new line is reache
    j skip_line

skip_invalid_line:        # I made another one for the invalid lines because in this case we don't have to add 1 for $t2 ( Cleaned buffer )
    lb $t3, ($t1)
    beq $t3, '\n', skip_invalid_one  #  Once we reach the new line that means we reached a new patient test but we have to skip the new line first
    addi $t1, $t1, 1 # Keep adding ones until new line is reache
    j skip_invalid_line        

skip_invalid_one:
    addi $t1, $t1, 1 # Added one so we can skip the new line and start the id validation
    lb $t3, ($t1)
    beq $t3, '\0', exit
    j new_line

skip_one:
    addi $t1, $t1, 1 # Added one so we can skip the new line and start the id validation
    addi $t2, $t2, 1
    lb $t3, ($t1)
    beq $t3, '\0', exit
    j new_line
   
date_valid:
    # We need to store this line (patient) and move to the next patient
    lb $t5, ($t4)   		# Since we reached this stage and $t4 points towards the beginning of the valid line then we have to store it in the cleaned buffer
    beq $t5, '\0', exit
    sb $t5, ($t2)   	      # $t2 points towards the clean buffer so now we are storing the valid line into the cleaned buffer 
    beq $t5, '\n', skip_line   # We go here so we update the original $t1 and move to the next line and check its validity
    addi $t4, $t4, 1
    addi $t2, $t2, 1
    j date_valid

date_invalid:
    # We just have to print an error and move to the next patient without storing this one
    li $t9, 0  # A flag to check if the whole file is valid 1 --> Valid, 0 --> Invalid
    li $v0, 4
    la $a0, invalid_date_error
    syscall
    j skip_invalid_line  # We move to the next line since this one is invalid

id_invalid:
    # We need to print that this patient has invalid ID then skip to the next one without storing this one
    li $t9, 0  # A flag to check if the whole file is valid 1 --> Valid, 0 --> Invalid
    li $v0, 4
    la $a0, invalid_id_error
    syscall 
    j skip_invalid_line   # We move to the next line since this one is invalid
    
all_data_valid:
    li $t9, 0
    li $v0, 4
    la $a0, valid_data
    syscall
    j exit
    
exit:
    # Since we reached this stage we have to null terminate the cleaned buffer and exit
    beq $t9, 1, all_data_valid
    sb $zero, ($t2)
    jr $ra              # Return


#######################################-Implementation for add new test validity-######################################
add_newTest_validate2:  
    move $t1, $t8
    li $t9, 1  # A flag to check if the whole file is valid 1 --> Valid, 0 --> Invalid
new_line2:
    # Store the address at the beginning of each line so if it's valid we return to it and start storing the line in the cleaned buffer
    move $t4, $t1
    # Loop through characters of ID
validate_id_loop2:
    lb $t3, ($t1)       # Load byte from buffer
    beq $t3, ':', date_validation2    # If ':' is encountered, ID is valid
    blt $t3, 48, id_invalid2   # If character is less than (Asci) '0', ID is invalid
    bgt $t3, 57, id_invalid2   # If character is greater than (Asci) '9', ID is invalid
    addi $t1, $t1, 1    # Move to next character in buffer
    j validate_id_loop2 # Repeat loop
    
date_validation2:
    # Only dates between 2000-2059 are acceptable
    addi $t1, $t1, 7  # Skip ':' , space, name, and ','
    lb $t3, ($t1)
    bne $t3, '2' date_invalid2   # Only 2 is acceptable in '2'xxx
    addi $t1, $t1, 1 
    lb $t3, ($t1)
    bne $t3, '0', date_invalid2   # Only 0 is acceptable in x'0'xx
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bgt $t3, '5', date_invalid2    # Only 0-5 are acceptable in xx'0-5'x
    blt $t3, '0', date_invalid2
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bgt $t3, '9', date_invalid2   # Only 0-9 are acceptable in xxx'0-9'
    blt $t3, '0', date_invalid2
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bne $t3, '-' date_invalid2   # Check that only '-' format is acceptable
    addi $t1, $t1, 1
    lb $t3, ($t1)
    beq $t3, '1', case12  # Case when the month starts with 1 then the number next to it has to be 0-2
    bgt $t3, '1', date_invalid2  # We are checking the 1st digit in month so it has to be either 1 or 0 since we are here, then it has to be 0
    blt $t3, '0', date_invalid2
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bgt $t3, '9', date_invalid2   # Since the first number is 0 then the 2nd number has to be in the range '0-9'
    ble $t3, '0', date_invalid2
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bne $t3, ',', date_invalid2	# if not equal , then date invalid month greatar than from 2 digit
    j date_valid2
    
case12:
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bgt $t3, '2', date_invalid2  # Since the first number is 1 then the 2nd number has to be in the range '0-2'
    blt $t3, '0', date_invalid2
    addi $t1, $t1, 1
    lb $t3, ($t1)
    bne $t3, ',', date_invalid2	# if not equal , then date invalid month greatar than from 2 digit
    j date_valid2
    
skip_line2:
    lb $t3, ($t1)
    beq $t3, '\0', exit3
    addi $t1, $t1, 1 # Keep adding ones until new line is reached
    beq $t3, '\0', exit3
    lb $t3, ($t1)
    beq $t3, '\n', skip_one2  #  Once we reach the new line that means we reached a new patient test but we have to skip the new line first
    j skip_line2

skip_one2:
    addi $t1, $t1, 1 # Added one so we can skip the new line and start the id validation
    addi $t2, $t2, 1
    lb $t3, ($t1)
    beq $t3, '\0', exit3
    j new_line2
   
date_valid2:
    # We need to store this line (patient) and move to the next patient
    lb $t5, ($t4)   		# Since we reached this stage and $t4 points towards the beginning of the valid line then we have to store it in the cleaned buffer
    beq $t5, '\0', exit3
    sb $t5, ($t2)   	      # $t2 points towards the clean buffer so now we are storing the valid line into the cleaned buffer 
    beq $t5, '\n', skip_line2   # We go here so we update the original $t1 and move to the next line and check its validity
    addi $t4, $t4, 1
    addi $t2, $t2, 1
    j date_valid2

date_invalid2:
    # We just have to print an error and move to the next patient without storing this one
    li $t9, 0  # A flag to check if the whole file is valid 1 --> Valid, 0 --> Invalid
    li $v0, 4
    la $a0, invalid_date_error
    syscall
    j exit3  # We move to the next line since this one is invalid

id_invalid2:
    # We need to print that this patient has invalid ID then skip to the next one without storing this one
    li $t9, 0  # A flag to check if the whole file is valid 1 --> Valid, 0 --> Invalid
    li $v0, 4
    la $a0, invalid_id_error
    syscall 
    j exit3   # We move to the next line since this one is invalid
    
all_data_valid2:
    li $t9, 0
    li $v0, 4
    la $a0, valid_data
    syscall
    j exit3
    
exit3:
    # Since we reached this stage we have to null terminate the cleaned buffer and exit
    beq $t9, 1 all_data_valid
    sb $zero, ($t2)
    jr $ra              # Return    
    
#########################################  Print the menu options  ###########################################################################           
print_Menu:
	la $a0 ,meg_menu
	li $v0 , 4 
	syscall 
	la $a0 ,msg_op1
	li $v0 , 4 
	syscall
	la $a0 ,msg_op2
	li $v0 , 4 
	syscall
	la $a0 ,msg_op3
	li $v0 , 4 
	syscall
	la $a0 ,msg_op4
	li $v0 , 4 
	syscall
	la $a0 ,msg_op5
	li $v0 , 4 
	syscall
	la $a0 ,msg_op6
	li $v0 , 4 
	syscall
	la $a0 ,msg_op7
	li $v0 , 4 
	syscall
	jr $ra 
	       
#############################################  error handling in open file ###########################################################        
invalid_file_name: 
	la $a0 ,msg_error_file
	li $v0 , 4 
	syscall 
	
	li $v0,10 	# exit
	syscall