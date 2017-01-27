.equ CHR_U,109
.equ CHR_L,13
.equ CHR_P,199
.equ CHR_C,141
.equ CHR_F,135
.equ CHR_A,231
.equ CHR_E,143



_start:
@ R12 is the status of program 0:Unlock 1:Locked 2:Prog Seq 3:New Code 4:Delete
@ R11 is the end of code array each code seperated by 0
@ R10 is the end of code sequence,if there is no code seq currently r10=r11+4
@ R9  is the pointer in seq
@ R8  is the pointer in array
@ R7  point to end of AnotherArray
@ R6  is the pointer in AnotherArray
@ R5  is temp


mov R12,#0
ldr r11,=CODE
mov r1,#0
str r1,[r11]
add r10,r11,#4
mov r9,r10
ldr r8,=CODE
add r8,r8,#4
ldr r7,=AnotherArray
mov r6,r7
mov r0,#CHR_U
bl Display

StartToCheck:
bl CheckBlue
bl CheckBlack
@if left black is pressed
cmp r0,#0x02
bne DidNotPressLeftTestRight
beq LeftBlackPressedWhenStandBy
FinishLeftBlackPressed:
b  StartToCheck

DidNotPressLeftTestRight:
@if right black is pressed
cmp r0,#0x01
beq RightBlackPressedWhenStandBy
FinishRightBlackPressed:
mov r0,#0 
b  StartToCheck

RightBlackPressedWhenStandBy:     @when press right buttom you want either set new code or delete old code 
                                  @if safe is locked you can do nothing ,so we test r12 first
cmp r12,#1
mov r0,#0  
beq StartToCheck                  @it's locked do nothing

@reach here means it's not locked
@show P and erase current code seq
mov r0,#CHR_P
bl Display
add r10,r11,#4
@then we will test whether the code seq entered by user is already in the code array
@alreay in the array (want to delete)    not in the array(want to add)
b UserEnteringCodeSeq
FinishUserEnteringCodeSeq:
@now user finished entering code seq
@test it's more than 3 digits.
add r9,r11,#4
sub r5,r10,r9
cmp r5,#16
blt NotEnoughDigits

@reach here means there are more than 3 digits
ldr r8,=CODE
add r8,r8,#4
bl CompareArrayWithSeq
@if r0=0 means want to add   if r0!=0 means want to delete and r0 is the start of object code 
cmp r0,#0
beq AddACode                @r0=0 means want to add(code seq is not exist in code array)

 

@when reach here ,r0 hold the address for the start of a old code and want to delete
@1,show F . 2,let user enter again an test if code are repeat correct
str r0,[r13]       @protect the address
mov r4,r1       @r4 is the length of object code 
mov r0,#CHR_F
bl Display

add r9,r11,#4
bl CopyCodeSeqToAnotherArray   @now the code entered first time is in AnotherArray
add r10,r11,#4   @erase the code seq

b UserEnteringCodeSeqForForget
FinishUserEnteringCodeSeqForForget:
@now compare the first enter and second enter
add r9,r11,#4
ldr r6,=AnotherArray
bl CompareTwoEnter    @test r0 to see compare result
cmp r0,#0 
beq FailToRepeatEnter              @fail to repeat correctly
@reach here means we can start to delet
@the code we want to delet start at r5,length is r4, end at r5+r4
@the code end at r4=r5+r4  when r4=r11 we finished 
@this time let r0 be temp
ldr r5,[r13]
add r4,r5,r4 
sub r5,r5,#4
bl Delete
mov r0,#CHR_A
bl Display
mov r0,#0
b StartToCheck


Delete:
cmp r4,r11
beq FinishDelet
ldr r0,[r4],#4
str r0,[r5],#4
b Delete
FinishDelet:
mov r9,#0
str r9,[r5]
mov r11,r5
add r10,r11,#4
mov r9,r10
mov pc,lr



AddACode:     @  1,show C . 2,let user enter again an test if code are repeat correct   
mov r0,#CHR_C
bl Display

add r9,r11,#4
bl CopyCodeSeqToAnotherArray   @now the code entered first time is in AnotherArray
add r10,r11,#4   @erase the code seq

@user will enter again
b UserEnteringCodeSeqForLearn
FinishUserEnteringCodeSeqForLearn:
@now compare the first enter and second enter
add r9,r11,#4
ldr r6,=AnotherArray
bl CompareTwoEnter
@test r0 to see compare result
cmp r0,#0 
beq FailToRepeatEnter              @fail to repeat correctly
@reach here we can add new code to array
mov r11,r10
add r10,r11,#4
mov r9,r10
mov r0,#CHR_A
bl Display
mov r0,#0
b StartToCheck




CopyCodeSeqToAnotherArray:   @will not change r0,r1
cmp r9,r10
beq FinishCopy
ldr r5,[r9],#4
str r5,[r7],#4
b CopyCodeSeqToAnotherArray
FinishCopy:
add r9,r11,#4
mov pc,lr



UserEnteringCodeSeq:
bl CheckBlue
bl CheckBlack
cmp r0,#0x02
beq LeftBlackPressedWhenStandBy
cmp r0,#0x01    
beq FinishUserEnteringCodeSeq  @if press means finish entering code 
b UserEnteringCodeSeq

UserEnteringCodeSeqForLearn:
bl CheckBlue
bl CheckBlack
cmp r0,#0x02
beq LeftBlackPressedWhenStandBy
cmp r0,#0x01    
beq FinishUserEnteringCodeSeqForLearn  @if press means finish entering code 
b UserEnteringCodeSeqForLearn

UserEnteringCodeSeqForForget:
bl CheckBlue
bl CheckBlack
cmp r0,#0x02
beq LeftBlackPressedWhenStandBy
cmp r0,#0x01    
beq FinishUserEnteringCodeSeqForForget  @if press means finish entering code 
b UserEnteringCodeSeqForForget


LeftBlackPressedWhenStandBy:   @1,when r12 is 0,try to lock  2,when r12=1 try to unlock
cmp r12,#0
beq TryToLock
@try to unlock here
ldr r8,=CODE
add r8,r8,#4
add r9,r11,#4
bl CompareArrayWithSeq
@test r0 ,r0=0 fail to match ,r0 not equal 0: success to match, if match r0 is the start point of the matched code r1=length of the matched
add r10,r11,#4    @first erase the code seq 

cmp r0,#0
mov r0,#0
add r10,r11,#4    
beq FinishLeftBlackPressed   @invalid unlock try 
@ r0!=0 means matched ,unlock the safe
mov r12,#0
mov r0,#CHR_U
bl Display
mov r0,#0
add r10,r11,#4
b FinishLeftBlackPressed



CompareArrayWithSeq:  @output:r1 is the length of the seq,r0 is the start of the matched code
@R0 is num in array  R1 is num in seq
@if r8>r11(means wrong code seq ,move the point of seq end to next byte of array end)
cmp r8,r11
bgt FailToMatch
@if [r8]=0 (reach an end of one code),r9=r10(reach the end of code seq)
ldr r0,[r8]
cmp r0,#0 @when [r8]!=0 check next number pair
bne IfR8NotEqualTo0
@reache here means [r8]=0 we test [r9] now
cmp r9,r10
bne SetR8ToNextCode                   @this code seq does not match current code move to next code
@reache here means [r8]=0 and r9=r10 code is matched set r0 to the start of the code in array
@and reset r8 r9 to correct place
add r9,r11,#4
sub r1,r10,r9   @r1 now is the length of the seq
sub r0,r8,r1    @r0 now is the start of the matched code 
ldr r8,=CODE
add r8,r8,#4
mov pc,lr




@else text whether next [r8]=[r9] if equal loop again,if not equal set r9 to end of array r8 to begin of next code
IfR8NotEqualTo0:
ldr r0,[r8],#4
ldr r1,[r9],#4
cmp r0,r1
beq CompareArrayWithSeq
@if [r8][r9]not equal
b SetR8ToNextCode
FinishSetR8ToNextCode:
add r9,r11,#4
@now r9 is at the beginning of code seq ,r8 is at the begining of a new code or exceed the code array
b CompareArrayWithSeq

FailToMatch:
ldr r8,=CODE
add r8,r8,#4
add r9,r11,#4
mov r0,#0 
mov pc,lr


SetR8ToNextCode:
ldr r0,[r8],#4
cmp r0,#0
@if [r8]=0 finish, next code start at [r8+4]
@else check next [r8]
bne SetR8ToNextCode
b FinishSetR8ToNextCode



TryToLock:    @if code array is empty do nothing if code array is not empty lock the safe
add r10,r11,#4  @erase the code seq ,then try to lock 
ldr r7,=AnotherArray
ldr r1,=CODE
cmp r1,r11 
beq FailToLock
mov r12,#1
mov r0,#CHR_L
bl Display
mov r0,#0 
b FinishLeftBlackPressed


FailToLock:
mov r0,#CHR_U
bl Display
mov r0,#0
b FinishLeftBlackPressed

CheckBlue:
swi 0x203
cmp r0,#0
bne AddToCodeSeq
FinishAddToCodeSeq:
mov r0,#0
mov pc,lr 
AddToCodeSeq:
str r0,[r10],#4
b FinishAddToCodeSeq






CheckBlack:
swi 0x202
mov pc,lr


Display:
swi 0x200
mov pc,lr


NotEnoughDigits:
add r10,r11,#4   @erase the code seq
mov r0,#CHR_E
bl Display
add r10,r11,#4
mov r0,#0
b StartToCheck

CompareTwoEnter:    @ out put   r0=0 not same    r0=1 same
@when r9=r10 test whether r6=r7 .if equal means matched r0=1;   if not equal means error r0=0
@if [r9]!=[r6] wrong repeat . r0=0
cmp r9,r10
beq TestWhetherAnotherArrayReachTheEnd
ldr r2,[r9],#4
ldr r3,[r6],#4
cmp r2,r3 
beq CompareTwoEnter
@reach here means two enter does not match 
mov r0,#0
ldr r7,=AnotherArray
mov r6,r7
mov pc,lr


TestWhetherAnotherArrayReachTheEnd:
cmp r6,r7
beq CompareTwoEnterSucceed
@reach here mean fail to repeat currently
mov r0,#0
ldr r7,=AnotherArray
mov r6,r7
mov pc,lr

CompareTwoEnterSucceed:
mov r0,#1
ldr r7,=AnotherArray
mov r6,r7
mov pc,lr

FailToRepeatEnter:
add r10,r11,#4
mov r9,r10
mov r0,#CHR_E
bl Display
add r10,r11,#4
mov r0,#0
b StartToCheck



.data
CODE:  .skip 1024
AnotherArray:    .skip 2048

