Fill the "COM Port" and "Axis Number" box in the config panel, and click Initialize axes button. 
Find information about COM Port in your computer's device manager. "Axis Number" Being the total number of axes intalled.

Auto Run:
To use auto run, set the wave form parameters for the axis selected and click "Save trace to current axis", do the same for all axis need to auto run. Then click the "Start all Axes" button. Note, all axes need to have the same duration.

Alternatively, click on the "Custom File" tab, browse to the folder that contains the ".txt" file or files, click "OK", all ".txt" file will be shown automaticlly in the "Select File" list box. Selected the ".txt" file of interest to see its preview on the plot above. Save to current axis as usual. Note, all axes need to have the same duration (In this case, number of elements in the vector).


Changelog

V1.1
1. Added a "Max Speed" edit field in the config panel, user can now customize the max speed for all axes.
2. Now when exit the program (close the GUI), all the variables and global variables created by this program will be cleared.
3. Fix the problem that when actuator is near the top position, if continue to inch+, actuator would some times return to a very low position.
4. When actuator is at home position(0mm), some times the current position will not display correctly, the codes to fix this problem is now moved into the "Read_Current_Position" function. So this function can directly be used, no subsequent correction for this problem is needed.
5. Status text area notifications update. 

V2.0
1. User can now import a ".txt" file that contains single row vector for the Auto Run. In "Auto Run" panel, choose "Custom File" tab, browse to the folder that contains the ".txt" file or files, click "OK", all ".txt" file will be shown automaticlly in the "Select File" list box. Selected the ".txt" file of interest to see its preview on the plot above.
2. Fixed the problem that when starting all axes, the duration is read from the editfield at the time "Start All Axes" button is pressed, rather than as its value previously saved. 