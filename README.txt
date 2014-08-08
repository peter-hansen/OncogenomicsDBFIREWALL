CAUTION: ANY line with a grey filled in dot next to it has a connection to an object in the interface builder. If you change or delete this line you will get errors trying to load that view. To avoid this, DON’T RENAME THINGS, or if you absolutely must rename or remove on of those lines, find the object that it is connect to and ctrl+click on it. All its connections should pop up, and delete the one you deleted in code in that menu.

Main Page:
Add databases: Nothing

Query: 
Change drop down menus: Go to line 280 in DatabaseViewController.m and find the array that corresponds to the drop down menu. Simply change whatever you want to change in the array. 

Change appearance of output: Nothing
Add extra data to output: Nothing

GSEA:
Add Samples: Nothing
Add Genesets to drop down menu: Nothing
Add genesets to category: Nothing, unless more than 100 samples are added to a single category. If this happens use the following steps:
	1.	Find Main_iPhone.storyboard
	2.	If the Controller Scene is not open on the left side of the screen, open it by clicking on the button in the lower left that looks like two boxes around a right facing arrow.
	3.	Go through the Controller Scene in the following path: Controller Scene -> Controller ->View -> Scroll View ->View and select the final View.
	4.	In the upper right, find the tab that looks like a ruler. Change the height variable (it should be about 2000 for iPhone) to however much bigger it needs to be.
	5.	Repeat for Main_iPad.storyboard
Add category: This is probably the most involved process since this couldn’t be automated. The steps are exactly what needs to be done though, if something is wrong contact phansen@terpmail.umd.edu
	1.	Find Main_iPhone.storyboard
	2.	In the visual display, find the View Controller called simply “Controller”. It should look exactly like the GSEA page
	3.	Create a new button and place it wherever you want by clicking and dragging one from the lower right object selector. DO NOT copy and paste an existing button, it will get connections mixed up. It will be easiest if you add it in line with the rest of them, but be aware that directly after where the cMAP button currently is there is a hidden label that displaces which set is currently selected. Consider either moving or deleting this label, but I caution against resizing because it might cut off things.
	4.	In the upper right, click on the button that looks like a guy wearing a bow tie on a tuxedo. GSEAController.m should automatically open parallel to the graphical interface. Scroll down to around line 103. Copy and paste the cMAP function and rename it to whatever you want (this doesn’t really matter because it’s only ever called by the system and we will never have to type it out).
	5.	There should be a small hollow circle immediately to the left of the - (IBAction) line for the function you just created. Click and drag from this circle to the button you just created. The circle should now be filled in. If it isn’t, try again.
	6.	Repeat (except for step 4) for Main_iPad.storyboard
	7.	At this point to make viewing easier, you can click on the button directly to the left of the tuxedo button we pressed earlier, and then navigate back to GSEAController.m. Don’t worry, it will keep your place for you.
	8.	Change everything in your new function from cMAP to whatever you want, but be sure to be consistent. Then, if you are adding a category that does not have positive and negative samples, make sure to change _posNeg = false;. There will be some errors that pop up, but that’s ok because they should go away by the end.
	9.	Scroll up to around line 73, and copy exactly one of the NSMutableArray objects, and name it what you previously decided on in step 8.
	10.	Scroll down to what should be line 478 where NSArray *sampleSets is defined. Immediately above initialize the NSMutableArray you created earlier just as the others are. In sampleSets, add _yourNewSet into the array. Make sure that you add it so that the order in which each sample set is defined in html is the same as they are defined in the array.
	11.	Scroll to what should be line 552 and change the second parameter of CGRectMake: from 412 +c*34 to 451 +c*34 and look a few lines down for UISwitch *mySwitch = … and change the CGRectMake in that line from 407 + c*34 to 441 +c*34
	12.	Do the same thing as step 14 around line 628 and line 661
	13.	That’s it! If you add a lot more, you might have to adjust the iPad’s positioning as well. In that case just do something similar to what you do in steps 11 and 12 for the areas directly before the lines mentioned.
