To test the code use ARMSim#
http://armsim.cs.uvic.ca/

The 8-Segment display and LEDs will show status of the safe:
? U: indicates safe is unlocked
? L: indicates safe is locked
? P: indicates safe is programming a code
? C: indicates safe is confirming a new code
? F: indicates safe is forgetting an old code
? A: indicates a programming request was successful
? 'E': indicates a programming fault.

The safe starts unlocked, cannot be locked and there are no valid codes. Whenever there are no codes the safe cannot be locked.

To lock the safe (this should work at ANY time):
1. press the left black button.

To unlock the safe (This should work ONLY when the safe is locked):
1. Enter a valid code sequence
2. Press the left black button.

To learn a new code (codes must be 4 buttons or more):
1. Press the right button once
2. 8-segment should show 'P'
3. enter a new code sequence
4. press the right button again.
5. 8-segment should show 'C'
6. enter the same code sequence
7. press the right button a third time.
8. If the code was correct 8-segment displays 'A'
9. if the code was incorrect 8-segment display 'E'

To forget an old code:
1. Press the right black button
2. 8-segment should show 'P'
3. enter an old code sequence
4. press the right button again.
5. 8-segment should show 'F'
6. enter the same code sequence
7. press the right button a third time
8. If the codes matched 8-segment displays 'A'
9. if the codes did not matched 8-segment displays 'E'

