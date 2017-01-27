To test the code use ARMSim#
http://armsim.cs.uvic.ca/

The 8-Segment display and LEDs will show status of the safe:<br>
 U: indicates safe is unlocked<br>
 L: indicates safe is locked<br>
 P: indicates safe is programming a code<br>
 C: indicates safe is confirming a new code<br>
 F: indicates safe is forgetting an old code<br>
 A: indicates a programming request was successful<br>
 'E': indicates a programming fault.<br>
<br>
The safe starts unlocked, cannot be locked and there are no valid codes. Whenever there are no codes the safe cannot be locked.<br>
<br>
To lock the safe (this should work at ANY time):<br>
1. press the left black button.<br>
<br>
To unlock the safe (This should work ONLY when the safe is locked):<br>
1. Enter a valid code sequence<br>
2. Press the left black button.<br>
<br>
To learn a new code (codes must be 4 buttons or more):<br>
1. Press the right button once<br>
2. 8-segment should show 'P'<br>
3. enter a new code sequence<br>
4. press the right button again.<br>
5. 8-segment should show 'C'<br>
6. enter the same code sequence<br>
7. press the right button a third time.<br>
8. If the code was correct 8-segment displays 'A'<br>
9. if the code was incorrect 8-segment display 'E'<br>
<br>
To forget an old code:<br>
1. Press the right black button<br>
2. 8-segment should show 'P'<br>
3. enter an old code sequence<br>
4. press the right button again.<br>
5. 8-segment should show 'F'<br>
6. enter the same code sequence<br>
7. press the right button a third time<br>
8. If the codes matched 8-segment displays 'A'<br>
9. if the codes did not matched 8-segment displays 'E'<br>

