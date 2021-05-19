This example will guide you through a simple full SNP impact analysis, to show you the different steps to go through for your own analysis.

Make sure you downloaded the SNP\_impact\_FoldX.run script and have a working FoldX5(R) script in your directory.

#### 1. Preparations
##### 1.1. PDB file
We'll analyze a small molecule, glucagon, to keep the analysis quick. 
Let's start and explore the corresponding PDB file, its PDB code is 1GCN. Follow [this link](https://www.rcsb.org/structure/1gcn) to learn more about the PDB file. Here you see that this PDB file of Glucagon was provided by a study of [K Sasaki](https://pubmed.ncbi.nlm.nih.gov/171582/). 

If you scroll down on the page you find a frame called "**Macromolecules**", here you'll find all the information on the different subunits of your molecule. Seeing that Glucagon is only a small molecule, it only has 1 subunit referred to as subunit "**A**". If you would look at other molecules, for example [Hemoglobin](https://www.rcsb.org/structure/1SI4), you'll see that there are more subunits (A-D) listed. 

Underneath the subunit names, you'll find a sequence bar, in which you'll be able to align your mutation. You can also look at the sequence, if you go to the "**[Sequence](https://www.rcsb.org/sequence/1GCN)**" tab above the PDB code name.

##### 1.2. BuildModel analysis
To be able to start a BuildModel analysis you'll need a list with the mutations you want to investigate. 
To make this list, you'll need to enter a couple of mutations at locations you found in the [sequence](https://www.rcsb.org/sequence/1GCN) toolbar in this specific format:
> [1 letter code wild type amino acid capital][subunit][position][1 letter code mutant amino acid capital]

Here is one example to get you started: "**YA10P**". This mutation will mutate Tyr from subunit A (the only subunit in this protein) into Pro. Now you look for 3 different mutations at position 2, 20 and 26 and mutate these to His. Describe them following the format. 
To make the list file go to your terminal and enter:
`nano individual_list_1GCN.txt`

Now you get space to enter your mutations. Here you enter the example we provided with your other mutations (note that you don't put a space between mutation@2, and mutation@20 otherwise you file won't run!):
>ExampleMutation;
>Mutation@2,Mutation@20;
>Mutation@26;

NOTE: this will test Mutation1 and Mutation4 separately, while Mutation2 and Mutation3 will be inserted at the same time. 

Now, to save your file enter `ctrl o` and press `enter`
then enter `ctrl x`

Now you created your individual file and you are back at your directory.

##### 1.3. PositionScan analysis
For this analysis you will not need to make a list, but you will need your location at the ready when the question comes.
You'll need to look at which locations you want to test, to make this tutorial quick, you'll test the locations of the mutations you provided for the BuildModel analysis.
However, you'll need to format them differently:
>[1 letter code wild type amino acid capital][subunit][position][add code letter which amino acids you want to test] 
This code letter can be found [here](http://foldxsuite.crg.eu/command/PositionScan).

Like with the BuildModel analysis, I'll give you one example, "**YA10a**", but you change your own mutations to this format.

#### 2. Starting the script
To start the script, you enter:
`./SNP_impact_FoldX.run`
Now you get a series of questions you'll need to answer. Since we'll be performing a full analysis, you will get all the questions. However, if you were to choose not to perform an analysis, some questions might not be shown.
1. `Which PDB files do you want to use? (CODE PDB file)`. Since we are testing Glucagon, you'll need to enter the PDB code of this protein. So you type: ` 1GCN`, and enter.
2. `Do you want to run a BuildModel analysis? (Yes/No)`. Your answer can either be 'Yes' or 'No'. Since we want to go through all analyses, you type: `Yes`. (Make sure to use the capital!)
3. `How many BuildModel runs do you want? (number)` Here you provide the amount you want your analysis to be repeated. To make this a quick analysis you answer: `2`.
4. `How many mutations are you testing? (number)` Here you provide the amount of lines in your individual file. Since you entered the mutations in the given format in your individual file, you should enter `3`. Although, you entered a total of 4 mutations, you answer with 3, since you provided 2 mutations at line 2 to be put in the same protein at the same time.
5. `Do you want to perform a Dihedral analysis? (Yes/No)` Here, you answer `Yes`, since we'll be performing the total analysis. (Make sure to use the capital!)
6. `Do you want to perform a position scan? (Yes/No)` Again, since we want everything, you answer `Yes`. (Make sure to use the capital!)
7. `which positions do you want to test? (Positions in format separated by a space)` Since we prepared these questions before hand, you already have these mutations in the right format (see 1.3.). Now you just put your mutations in any order you like with spaces between them, since we already provided you with 1 example, we'll put this one in for you: `YA10a Mutation@2 Mutation@20 Mutation@26`

If you press enter now, the analysis starts. You will not have to do anything more except for wait and the script will provide you with the output.
#### 3. Looking at the output
After the analysis is done and you enter `ls`on the command line, you should get approximately this output:
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-17-om-08.44.53.png)](https://www.linkpicture.com/view.php?img=LPic60a2110a2c5982032397002)

Here you see that the script has downloaded the PDB file from the internet (**1GCN.pdb**) and repaired it (**1GCN_Repair.pdb**). Next to these PDB files, it also created 4 directories: **BuildModel.**, **DH.**, **PS** and **molecules.**.
We'll first look at the **BuildModel.** directory, containing the output from the BuildModel analysis. Enter `cd BuildModel.`into your terminal, and then enter `ls`.
Now you should get approximately this output:
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-17-om-08.52.36.png)](https://www.linkpicture.com/view.php?img=LPic60a212c78419b35542339)

Here you see a directory with the name of your individual list, if you were to add multiple individual lists, you would have multiple files with the name of each one you used. To enter this directory you enter: `cd individual_list_1GCN.txt`. To see what output the analysis has created you enter `ls`again.
Now you should get approximately this output:
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-17-om-10.04.16.png)](https://www.linkpicture.com/view.php?img=LPic60a22393bfc0b684449541)

Now you see that there are 2 output files, an Average and a Dif file. In the Dif file you get all the output created by FoldX5(r), this means every ∆G for every repeated run for every mutation. While the Average file contains the mean ∆G (from the repeated runs) for every mutation.
If you want to have a quick look at the output from the Dif file you enter `cat Dif_1GCN_Repair.fxout`.
Now you should get approximately this output:
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-17-om-10.10.57.png)](https://www.linkpicture.com/view.php?img=LPic60a2251f9422c347768320)

The fist column provides you with the PDB file info. Note that not the mutation names are used but numbers. For example **1GCN_Repair_1_0.pdb** is equal to the mutation from line 1 (so here **YA10P**) and the 0 represents the base run. While **1GCN_Repair_1_1.pdb** will represent the same mutation line but the second run. If we had entered a number>2 on question 3 (see 2.), you would have **1GCN_Repair_1_2.pdb**, **1GCN_Repair_1_3.pdb** and so on. 
If we look at **1GCN_Repair_2_0.pdb**, this represents line two of our individual file. This means that 2 mutations, Mutation@2 and mutation@20 were inserted into this pdb file and therefore the output will represent the ∆G of both these mutations.

Now we look at the Average file by entering `cat Average_1GCN_Repair.fxout`.
Now you should get approximately this output:
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-17-om-10.20.41.png)](https://www.linkpicture.com/view.php?img=LPic60a2276c955dd1464831090)

You see that in the notation of the PDB file in this file the second number has disappeared and you get for example **1GCN_Repair_1.pdb**. All the columns after that will give you info on the average of the amount of runs you repeated. This output also provides you with the standard deviation between the runs.

Now we have seen all the BuildModel output and we go further towards the Dihedral analysis output. To go here quickly you enter `cd ../../DH.` and to see what is present in that directory you enter `ls`.
Which should give you approximately this output:
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-17-om-10.27.37.png)](https://www.linkpicture.com/view.php?img=LPic60a2291bf1ad41993178848)

Just as in the BuildModel. map, you'll find a directory by the name of the individual list you used. Now, we'll go to that file by entering `cd individual_list_1GCN.txt` and list its content by using `ls`.
This gives you approximately this output:
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-17-om-10.31.15.png)](https://www.linkpicture.com/view.php?img=LPic60a229e6a693c1221674917)

Here you see that there a multiple DH files, every file corresponds to the DiHedral output of either the wild type (files without number) or to a mutated PDB file (files with numbers). The first mutant file numbers correspond to the mutation lines of the individual file, like with the output of the BuildModel analysis. Next to the normal files, you'll also find optimized files. These files have been changed to have the lowest possible ∆G by only changing the angles of the connections. The same principle of numbers applies to those as well.
To take a quick look at a file enter `cat DH_1GCN_Repair_1_1.fxout`. 
This gives you approximately this output:
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-17-om-11.25.46.png)](https://www.linkpicture.com/view.php?img=LPic60a23706d11a71714856378)

Here you see which PDB file was used in the first column, while in the second column you see the amino acid that is present at the place provided in column 3 and 4. Where the column 3 provides the subunit and column 4 gives the number of the PDB sequence. All the other columns provide the angles of all connections. If you want to analyze these results, you need to compare every mutated file to the wild type file and be sure to only compare optimized files with optimized files and non-optimized files with non-optimized files. However, if you want to know the difference between the non-optimized and the optimized you can compare the wild type files with each other.

As a last analysis, this script provided you with a positionscan. Let's take a look at this output, but first go to the file by entering `cd ../../PS` and to look at the content enter `ls`.
This should give you this output:
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-17-om-11.41.26.png)](https://www.linkpicture.com/view.php?img=LPic60a23a57073c7562671328)

Here, you see directories created for every location we inserted at question 7 (see 2.). To enter the output for our example mutation you enter `cd ./PS_YA10a` and to see its content `ls`. The only file provided is the output file of this mutation and so you can have a quick look at it by entering `cat PS_1GCN_Repair_scanning_output.txt 
The output should look approximately like this: 
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-17-om-11.45.28.png)](https://www.linkpicture.com/view.php?img=LPic60a23b57ea3b42069216214)

You see which mutations was inserted in the first column, while in the second you'll find the ∆G for that mutation compared to the wild type.
For example, from this data we see that a mutation Tyr to Ser would have the most destabilizing effect. While most others have barely any effect at all. 
Note that e stands for His in a different protonated form. For more info on this click [here](http://foldxsuite.crg.eu/allowed-residues).

That was the lost analysis output, but there is still one file to look at. In the file **molecules.** you'll find all the unique PDB files that were created throughout the analysis. These can be helpful to visualize the impact of the mutations via other tools.

#### 4. Analysis
Seeing that every protein is different, providing one general hypothesis out of this data is difficult. Especially when you are looking for information on the effect of a mutation on the working mechanism. Therefore, you'll need to look at your individual protein and handle the output according to your experimental needs.
However, note that this output remains an in silico analysis and will have limitations. Therefore, using this script will help you form hypotheses surrounding the subject but will probably not provide you with the whole story.
