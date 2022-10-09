.data
q1: .word 1, 4, 5, 6, 2, 3
q1Length: .word 6
ans1: .word 0

q2: .word 3, 2, 1, 4, 2, 1, 5
q2Length: .word 7
ans2: .word 1

q3: .word -1, -2, 3, 4, -2
q3Length: .word 5
ans3: .word 1

originArr: .string "originArr: "
sortedArr: .string "sortedArr: "
newLine: .string "\n"
Question1: .string "Question1\n"
Question2: .string "Question2\n"
Question3: .string "Question3\n"
True: .string "\nTrue"
False: .string "\nFalse"
Accepted: .string "\nAnswer Accepted"
Failed: .string "\nAnswer Failed"
    
.text
main: 
    ## question 2
    la a0, Question2
    addi a7, zero, 4
    ecall
    
    la a0, q2             # get head addr of q2
    lw a1, q2Length       # get q2 size
    mv s0, a0             # keep q2 head addr in s0
    mv s1, a1
    jal containsDuplicate # pass array head addr and size to containsDuplicate
    jal autoTest          # test the result with the answer
 
    j end                 # end the program
containsDuplicate: # bool containsDuplicate(*nums, numsSize), nums:a0, numsSize:a1
    addi sp, sp, -28      # store ra, s0, s1
    sw ra, 0(sp)          # store ra
    sw s0, 4(sp)          # store s0
    sw s1, 8(sp)          # store s1
    sw s2, 12(sp)         # store s2
    sw s3, 16(sp)         # store s3
    sw s4, 20(sp)         # store s4
    sw s5, 24(sp)         # store s5
    
    mv s0, a0             # keep array head addr in s0
    mv s1, a1             # keep array size in s1
    
    ## test
    la a0, originArr
    addi a7, zero, 4
    ecall
    mv a0, s0
    mv a1, s1
    ecall
    jal printArray
    #j end
    ## test
    
    jal beforeHeapSort          # call heapSort to sort the array from little to large
    
    ## do swap nums[0] and nums[i] and heapify while (i' = numsSize - 1; i >= 0; i--)
    mv a0, s0             # a0 = nums
    mv a1, s1             # a1 = numsSize
    addi t3, s1, -1       # i'(t3) = numsSize - 1
    mv a2, t3             # a2 = i'
    jal swapAndHeapify    # do swap and heapify
    
    ## test
    la a0, newLine
    addi a7, zero, 4
    ecall
    la a0, sortedArr
    addi a7, zero, 4
    ecall
    mv a0, s0
    mv a1, s1
    jal printArray
    #j end
    ## test
    
    ## compare adjacent element to check if they are identical
    addi s2, zero, 0      # let s2 be index i of nums[i], and initialized with i = 0
    addi s3, s3, 1        # let s3 be index j of nums[i + 1], and initialized with j = i + 1
    
containsDuplicateWhile:
    bge s3, a1, containsDuplicateFalse # while j < numsSize then do the comparaion with nums[i] and nums[i + 1]
    slli s4, s2, 2        # let s4 be offset of nums + 4 * i, which means nums[i]
    add s4, a0, s4        # s4 = nums + 4 * i
    lw s4, 0(s4)          # s4 = nums[i]
    slli s5, s3, 2        # let s4 be offset of nums + 4 * j, which means nums[j] == nums[i + 1]
    add s5, a0, s5        # s4 = nums + 4 * i
    lw s5, 0(s5)          # s4 = nums[j] = nums[i + 1]
    beq s4, s5, containsDuplicateTrue # True if there is identical elements sit together
    addi s2, s2, 1        # i++
    addi s3, s3, 1        # j++
    j containsDuplicateWhile
containsDuplicateTrue:
    la a0, True
    addi a7, zero, 4
    ecall
    addi a0, zero, 1
    j containsDuplicateSkip
containsDuplicateFalse:
    la a0, False
    addi a7, zero, 4
    ecall
    addi a0, zero, 0
containsDuplicateSkip: 
    #mv a0, s0             # restore nums head addr
    #mv a1, s1             # restore numsSize
    
    lw ra, 0(sp)          # store ra
    lw s0, 4(sp)          # store s0
    lw s1, 8(sp)          # store s1
    lw s2, 12(sp)         # store s2
    lw s3, 16(sp)         # store s3
    lw s4, 20(sp)         # store s4
    lw s5, 24(sp)         # store s5
    addi sp, sp, 28
    
    jr ra
beforeHeapSort:
    addi sp, sp -16       # store ra, s0, s1, s2
    sw ra, 0(sp)          # store ra because I call heapify
    sw s0, 4(sp)          # store s0 because I use a0
    sw s1, 8(sp)          # store s1 because I use a1
    sw s2, 12(sp)         # store s2 because I use s2
    
    mv s0, a0             # keep array head addr in s0
    mv s1, a1             # keep numsSize in a1
    srli t6, a1, 1        # i(t6) = (numsSize / 2) - 1
    addi t6, t6, -1
callHeapifyWhile:
    bge t6, zero, heapSortSkip # while i >= 0, then do heapify
    
    lw ra, 0(sp)          # restore ra
    lw s0, 4(sp)          # restore s0
    lw s1, 8(sp)          # restore s1
    lw s2, 12(sp)         # restore s2
    addi sp, sp, 16
    
    jr ra                 # return from heapSort
heapSortSkip:
    mv a0, s0             # a0 = *nums
    mv a1, t6             # a1 = i
    mv a2, s1             # a2 = numsSize
    
    jal heapify           # call heapify
    
    addi t6, t6, -1       # i--
    j callHeapifyWhile    # do next heapify while i still >= 0
swapAndHeapify:
    addi sp, sp, -24      # store ra, s0, s1, s2, s3, s4
    sw ra, 0(sp)          # store ra
    sw s0, 4(sp)          # store s0
    sw s1, 8(sp)          # store s1
    sw s2, 12(sp)         # store s2
    sw s3, 16(sp)         # store s3
    sw s4, 20(sp)         # store s4
    
    mv s0, a0             # keep nums head addr in s0
    mv s1, a1             # keep numsSize in s1
    mv s2, a2             # keep i' in s2
swayAndHeapifyWhile:
    bge s2, zero, swapAndHeapifySkip # while i >= 0 then do swap and heapify

    ## test
    #mv a0, s0 # test
    #mv a1, s1 # test
    #jal printArray # test
    #j end # test
    ## test

    lw ra, 0(sp)          # restore ra
    lw s0, 4(sp)          # restore s0
    lw s1, 8(sp)          # restore s1
    lw s2, 12(sp)         # restore s2
    lw s3, 16(sp)         # restore s3
    lw s4, 20(sp)         # restore s4
    addi sp, sp, 24
    
    jr ra
swapAndHeapifySkip:
    addi s3, s0, 0        # let s3 be 0 and get nums[0]
    slli s4, s2, 2        # let s4 be i' and get nums[i']
    add s4, s0, s4        # s4 = nums + 4 * i'
    
    ## call swap
    mv a0, s3
    mv a1, s4
    jal swap              # swap(&nums[0], &nums[i])
    
    ## call heapify
    mv a0, s0
    mv a1, s2
    jal beforeHeapSort
    
    ## test
    #mv a0, s0 # test
    #mv a1, s1 # test
    #jal printArray # test
    #j end # test
    ## test
    
    addi s2, s2, -1       # i(s2)--
    j swayAndHeapifyWhile
heapify: # void heapify(*nums, i, numsSize), nums:a0, i:a1, numsSize:a2
    addi sp, sp -8       # store s10, s11
    sw s10, 0(sp)        # store s10
    sw s11, 4(sp)        # store s11
    slli t5, a1, 2       # offset in array with i * 4
    add t5, a0, t5       # add offset to base addr: (a0 + 4i)
    lw t5, 0(t5)         # let t5 be currValue = *(a0 + 4i)
    slli t4, a1, 1       # let t4 be j = i * 2 + 1, means left child
    addi t4, t4, 1
heapifyWhile:
    bge t4, a2, assignCurrVal # while j < numsSize do adjust parent node
    addi t3, a2, -1      # if j < (numsSize - 1) && nums[j] < nums[j + 1] then j++
    slt  t3, t4, t3      # if j < numsSize - 1 then keep doing
    beq t3, zero, heapifySkip
    addi s11, t4, 1      # let s11 be dereference of *(nums + (j + 1))
    slli s11, s11, 2     # s11 = 4 * (j + 1)
    add s11, a0, s11     # s11 = nums + 4 * (j + 1)
    lw s11, 0(s11)       # s11 = *(nums + 4(j + 1)) = nums[j + 1]
    slli s10, t4, 2      # s10 = 4 * j
    add s10, a0, s10     # s10 = (num + 4j)
    lw s10, 0(s10)       # s10 = *(num + 4j) = nums[j]
    slt t3, s10, s11     # if nums[j] < nums[j + 1] ?
    beq t3, zero, heapifySkip # if nums[j] < nums[j + 1] then j++
    addi t4, t4, 1       # j++
heapifySkip:
    slli s10, t4, 2      # let s10 = 4 * j
    add s10, a0, s10     # s10 = (nums + 4j)
    lw s10, 0(s10)       # s10 = *(nums + 4j)
    slt s10, t5, s10     # if (currValue >= nums[j]) then break
    beq s10, zero, assignCurrVal
    andi t3, t4, 1       # if (j % 2 == 0) then parent = j / 2 - 1
    beq t3, zero, innerEvenAssign # else if (j % 2 == 1) then parent = j / 2
    j innerOddAssign
innerEvenAssign:
    srli t3, t4, 1       # let t3 be parent = j / 2 - 1
    addi t3, t3, -1
    j innerOddAssignSkip
innerOddAssign:
    srli t3, t4, 1       # let t3 be parent = j / 2
innerOddAssignSkip:
    slli t3, t3, 2       # t3 = parent * 4
    add t3, a0, t3       # t3 = (nums + 4 * parent)
    slli s11, t4, 2      # let s11 = 4 * j
    add s11, a0, s11     # s11 = nums + 4j
    lw s11, 0(s11)       # s11 = nums[j]
    sw s11, 0(t3)        # nums[parent] = nums[j]
    slli t4, t4, 1       # j = j * 2 + 1
    addi t4, t4, 1
    
    j heapifyWhile
assignCurrVal:
    andi t3, t4, 1       # if (j % 2 == 0) then parent = j / 2 - 1
    beq t3, zero, evenAssign # else if (j % 2 == 1) then parent = j / 2
    j oddAssign
evenAssign:
    srli t3, t4, 1       # let t3 be parent = j / 2 - 1
    addi t3, t3, -1
    j oddAssignSkip
oddAssign:
    srli t3, t4, 1       # let t3 be parent = j / 2
oddAssignSkip:
    slli t3, t3, 2       # t3 = parent * 4
    add t3, a0, t3       # t3 = (nums + 4 * parent)
    sw t5, 0(t3)         # nums[parent] = currValue
    
    lw s10, 0(sp)        # restore s10
    lw s11, 4(sp)        # restore s11
    addi sp, sp, 8
    
    jr ra
swap: # void swam(*x, *y)
    addi sp, sp, -8       # store s0, s1
    sw s0, 0(sp)          # store s0
    sw s1, 4(sp)          # store s1
    
    lw s0, 0(a0)          # s0 = nums[0]
    lw s1, 0(a1)          # s1 = nums[i]
    
    sw s0, 0(a1)          # nums[i] = nums[0]
    sw s1, 0(a0)          # nums[0] = nums[i]
    
    lw s0, 0(sp)          # restore s0
    lw s1, 4(sp)          # restore s1
    addi sp, sp, 8
    
    jr ra
printArray: # void printArray(*nums, numsSize), nums:a0, numsSize:a1
    addi sp, sp, -12      # store ra, s0, s1
    sw ra, 0(sp)          # store ra
    sw s0, 4(sp)          # store s0
    sw s1, 8(sp)          # store s1
    
    mv s0, a0             # keep nums head addr in s0
    mv s1, a1             # keep numsSize in s1
    addi t0, zero, 0        # i = 0
    mv t1, a0             # keep nums head addr in t1
printArrayWhile:
    blt t0, a1, printArraySkip # while i < numsSize, then do print array
    
    mv a0, s0             # restore nums head addr
    mv a1, s1             # restore numsSize
    lw ra, 0(sp)          # restore ra
    lw s0, 4(sp)          # restore s0
    lw s1, 8(sp)          # restore s1
    addi sp, sp, 12
    
    ## test
    #mv a0, ra
    #addi a7, zero, 1
    #ecall
    #j end
    ## test
          
    jr ra                 # return if i !< numsSize
printArraySkip:
    lw a0, 0(t1)          # a0 = t1[i]
    addi a7, zero, 1      # print number
    ecall
    addi t0, t0, 1        # i++
    addi t1, t1, 4        # t1 += 4, means iterate to next element in int array
    j printArrayWhile
autoTest:
    addi sp, sp, -4       # store s0
    sw s0, 0(sp)          # store s0
    
    la s0, ans2
    lw s0, 0(s0)
    
    beq s0, a0, autoTestAccepted # if ans == your answer then accepted
    j autoTestFailed
autoTestAccepted:
    la a0, Accepted
    addi a7, zero, 4
    ecall
    j autoTestSkip
autoTestFailed:
    la a0, Failed
    addi a7, zero, 4
    ecall
autoTestSkip:
    lw s0, 0(s0)          # restore s0
    addi sp, sp, 4        # restore s0
    jr ra
end:
    addi a7, zero, 10
    ecall
