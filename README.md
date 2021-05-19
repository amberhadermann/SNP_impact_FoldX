The SNP\_impact\_FoldX.run script is a user-friendly command line set of commands that makes running [FoldX®](http://foldxsuite.crg.eu) protein energy stability analyses in a high throughput manner for estimating the impact of a SNP on a protein structure.[1][2]

Throughout this guide we will guide you through every step needed to make sure your analyses run smoothly. **Make sure to read everything before you start**.

#### 1. Installation

This analysis requires a fully operating [FoldX5®](http://foldxsuite.crg.eu/products#foldx) script, installation and download instructions are available on their [website](http://foldxsuite.crg.eu). To make sure your FoldX® script works, run the following command line: `PATH/TO/YOUR/FOLDX/SCRIPT`

>Once the script initiates, you should see this output:
>
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-11-om-20.18.46.png)](https://www.linkpicture.com/view.php?img=LPic609acab117635650192931)

To make sure the SNP\_impact\_FoldX.run script works within your terminal, you run the following command in your BASH or ZSH terminal shell: 

`chmod +xrw SNP_impact_FoldX.run`.

#### 2. Content script

To estimate the SNP impact on a protein structure, the script gives output of three different main FoldX analyses: (1) [BuildModel](http://foldxsuite.crg.eu/command/BuildModel) (2) [Dihedral](http://foldxsuite.crg.eu/command/Dihedrals) (3) [Positionscan](http://foldxsuite.crg.eu/command/PositionScan).

###### 2.1. Why perform a Buildmodel analysis?

While performing a [BuildModel](http://foldxsuite.crg.eu/command/BuildModel) analysis, you will be able to insert different mutations into an already existing PDB file. By inserting these, the FoldX5® program will be able to calculate the difference in Gibbs free energy (∆G). The ∆G will determine the stability of the mutated protein. If ∆G > 0, the mutation is destabilizing, while a mutation causing a ∆G \< 0 the mutation will be stabilizing. Though, this does not tell you what the effect is on the proteins working mechanism itself, it will tell you more about the impact on the eventual protein structure in terms of its absolute value. The bigger the absolute value of ∆G, the bigger the overall impact on the structure.

###### 2.2. Why perform a Dihedral analysis?

The [Dihedral](http://foldxsuite.crg.eu/command/Dihedrals) analysis will provide all the angles between the amino acids. Here we chose to use the [Optimize](http://foldxsuite.crg.eu/command/Optimize) command, what optimizes the angles within the PDB files to provide a structure with the least VanDer Waal force clashes. Though, the script will provide Dihedral analyses output of both files (from the non-optimized and the optimized PDB files). 

By comparing the difference in angles between the mutated and the unmutated PDB files, you'll be able to see the extent of the impact of your mutation on the other amino acids.

###### 2.3. Why perform a Positionscan analysis?

By performing a [Positionscan](http://foldxsuite.crg.eu/command/PositionScan), the program will calculate the ∆G if your location where to be mutated in every other amino acid available. From this output you'll be able to see which mutation would have the most structural impact on your protein on a given location. If you already have experimental data on the impact of the mutation on the protein, this analysis could give insight in why that mutation would have a certain effect and other on the same location wouldn't.

#### 3. Preparations

Before you can start the analysis, we need to set a few parameters and provide input files. Therefore, **a good preparation is key to the success of your analysis**.

###### 3.1. PDB file

Firts t is imperative to have the proper PDB file of your protein of interest in hand.  This means you need the ID your PDB file. It is highly advised to study your protein structure beforehand and recognise which subunits are present. You can add multiple PDB files in the same run and therefore gather all the IDs of the PDB files you'll be using. 
You'll be able to find your proteins ID [here](https://www.rcsb.org).

For FoldX to be able to run analyses on your PDB file, it will need to repair it. This will change nothing major to your PDB file, all information about this process can be found [here](http://foldxsuite.crg.eu/command/RepairPDB). The SNP\_impact\_FoldX.run script will do this for you and saves it as: "yourPDBfile_Repair.pdb". Take into account that this process can take a lot of time depending on the size of your PDB file.

NOTE: There is no need to download the PDB file yourself, the script will do that for you if it isn't present in your current directory. However, when you have done this analysis before it will be faster to add your PDB file and the repaired PDB file to your current directory.

###### 3.2. BuildModel analysis

If you chose to do a BuildModel analysis, you will need an ['individual list'](http://foldxsuite.crg.eu/parameter/mutant-file). This is a .txt file that contains a list of the mutations you want to insert in your protein. This list should be formatted in a very particular way, and it is of utmost importance that you follow the instruction. Since a fault in this file will stop the whole analysis. 

To start making this list, you should know the exact position of your mutation in the PDB file. This means you should align your mutation with the sequence of the PDB file, since some PDB files can contain a shift of a few amino acids. Next to knowing the exact location, make sure to also know the letter of the subunit you want to mutate. All of this information can be found on the [protein data base](https://www.rcsb.org).

When you make this txt file make sure to name it "individual\_list\_\*.txt" (you can add your own name at the " \* "; for example: individual\_list\_RpoC.txt)

NOTE: You can include multiple individual lists to your directory. This might be needed if you are working with a lower grade computer. In that case you divide your mutations across multiple individual files and put all of them in your directory.



To format the .txt file your list all mutations separated by “;” and tabs that you want tested separately. Every mutation should be formatted as followed: 

>[1 letter code wild type amino acid capital][subunit][position][1 letter code mutant amino acid capital]



=> Example: mutating glycine (G) at position 476 in subunit D to alanine (A) = GD476A

>Than your individual file should look like: 

[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-12-om-10.35.02.png)](https://www.linkpicture.com/view.php?img=LPic609b935ac0511954613393)

If you want to insert 2 or more mutations in one PDB file you list them in the format: 
>mutation1, mutation2; 	

=> Example: GD476A, GA321P;

>Than your individual file should look like: 

[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-12-om-10.36.47.png)](https://www.linkpicture.com/view.php?img=LPic609b93afb6b0c975077445)

Since this a high throughput manner, you'll probably want to test more than one mutation. Here you just add the other mutations in the same format on the line below.

=> Example: You want to test GD476A and GA321P seperately.

>Than your individual file should look like: 

[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-12-om-10.39.55.png)](https://www.linkpicture.com/view.php?img=LPic609b946ba0c83531588920)

NOTE: All your mutations need to be present in the PDB file in able for it to work. So, if an error occurs check which mutation was processed last and check whether this amino acid is present in your PDB file. If this is the case please make sure to read the previous note on the amount of individual files.

###### 3.3. Dihedral analysis

No additional preparation is needed for the analysis. However, since it uses the PDB files produced by the BuildModel analysis, you will need to perform a BuildModel analysis first before you can perform a Dihedral analysis. So if you chose not to run a BuildModel analysis, the option for running an Dihedral analysis will not appear.

###### 3.4. Positionscan analysis

For the Positionscan you need to know the exact location you want to scan. This location will need to be formatted in approximately the same way as in the individual file (see 3.2.). However, instead of placing the mutant amino acid code you add the code of which amino acids you want to test. The codes you can use can be found [here](http://foldxsuite.crg.eu/command/PositionScan). The most common is 'a', which tests every natural amino acid.

>[1 letter code wild type amino acid capital][subunit][position][add code letter which amino acids you want to test]



=> Example: Test all different amino acids at place 567 (Pro) in subunit A = PA567a

###### 3.5. Directory for analysis

As a last and final preparation, you now make sure your individual list(s), if you are running a BuildModel analysis is/are present in the map you designate to run this analysis. Next to that, you can add your PDB file and repaired PDB file, if already available. 



NOTE: some analyses will overwrite files, the script provides a failsafe if there are files already present in your directory to make sure you don't lose data. Though, it is highly recommended to provide a directory with only the files you'll be needing for this analysis, to ensure no data gets overwritten.

#### 4. Tutorial

To start the run you run the following command in your BASH or ZSH shell:

`insert/your/path/SNP_impact_FoldX.run`

Now you will get a series of questions. Which questions you get will be dependent on the answers you give on previous ones. Here we'll guide you through a full run. If you chose not to run a certain analysis, you should not be surprised if some will not appear and just ignore the info about them in this tutorial. 

To start this analysis, the script will need the path towards your (working) FoldX5® directory. So to start if this series of questions, the following question will appear: `What is the path towards your working FoldX script? (start at root)`

Now, you will be able to answer this question on the next line. Your answer should point towards your FoldX script, starting from your computers' root. 

=> Example: `~/Downloads/foldx`

The second question will be: `Which PDB files do you want to use? (CODE PDB file)`

Your answer should be the **code** of your protein's PDB file. If you want to add another PDB file, just type it on the same line with 1 space between. 

=> Example: `5UH6 6JCY`

NOTE: you should not add '.pdb' after the code, otherwise your analysis will not start.

The third question will be: `Do you want to run a BuildModel analysis? (Yes/No)`

Your answer can either be 'Yes' or 'No' - attention case sensitive!.

If you answered 'Yes' on the previous question, this will be your next question: `How many BuildModel runs do you want? (number>1)`

Next we need to provide the amount of the analysis to be repeated. The higher your number, the more accurate your eventual average ∆G will be. **Make sure to use a number higher than 1.** However, keep in mind that every run added will take time and memory space, since FoldX will create a lot of small files before it will do its calculations. For every mutation you add in your individual list, the amount you provide here will be repeated. For example an individual file of 50 lines to be run 5 times, will take ±1h to run. 

**It is important to make sure your machine has the required memory capacity to run the amount of analyses** 
=> For example: If you are using a fairly complex protein of e.g. 1.7MB and you want to insert 50 mutations/lines and run them 5 times you'll need about 1GB (1.7MB\*50\*5*2 + output files). 

NOTE: This script will help you sort out the temporary files from the files you'll need for the analysis by removing the temporary files. So, most of memory will become operable again after the analysis is done.

The next question will be: `How many mutations are you testing? (number)`

Here you provide the amount of lines in your individual file. 

NOTE: that you should provide the lines, since when you choose to insert 2 mutations at a time it will count as 1 mutation in the script.

=> Example:

1. For this individual list:

[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-12-om-10.36.47.png)](https://www.linkpicture.com/view.php?img=LPic609b93afb6b0c975077445)

You answer this question with `1`.

2. On the otherhand, when you have this individual list:

[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-12-om-10.39.55.png)](https://www.linkpicture.com/view.php?img=LPic609b946ba0c83531588920)

You answer the question with `2`, since there are now two lines.


The next question (will only appear when you want to run a BuildModel analysis): `Do you want to perform a Dihedral analysis? (Yes/No)`

Your answer can either be 'Yes' or 'No' (case sensitive).

The following question will be: `Do you want to perform a position scan? (Yes/No)`

Like the yes-no questions, your answer can either be 'Yes' or 'No'. Make sure to use the capital, since the answers are case sensitive.

The last and final question will appear if you chose to run a position scan: `which positions do you want to test? (Positions in format separated by a space)`

Here you answer with 1 or more mutations formatted like discussed in 3.5.. Make sure to put a space between mutations if you want to scan multiple locations.

Then the script is expected to run for about 2h for the minimum amount of runs (2), mutations (1) and locations (1) on a fairly complex protein.

**To grasp how to fully prepare and run the script, you can follow the example tutorial in the EXAMPLE.md file.**

#### 5. Output

After the full script has finished, you should find 4 new maps in your directory (if you ran every analysis): **BM.** (=BuildModel output), **DH.** (=Dihedral output), **PS.** (=PositionScan output) and **Molecules.** (= contains all PDB files used and made throughout the analyses). However, if there was output from another run present in your directory, files called **previous_run** will contain the old date to ensure no data gets lost throughout the analysis.

>Expected output files:
>
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-19-om-15.22.23.png)](https://www.linkpicture.com/view.php?img=LPic60a5113291f0f1573643868)

Within the BM. map you find maps named after the individual file(s) your analyses used. In each of these you should find: a Dif file as well as a Average file for each of your PDB files you tested. The Dif file gives you all the ∆G data for every run while the Average file gives you the mean value for each mutation from all the runs. 

NOTE: Each mutation is named after the line (see in 4. Tutorial) it was on in your individual list (by default FoldX®).

>Expected BM. output:
>
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-19-om-15.25.49.png)](https://www.linkpicture.com/view.php?img=LPic60a511eeede072138364825)

Within the DH. map you find maps named after the individual file(s) your BuildModel analyses used. In each of these you should find: DH_ files for each PDB file and each mutation inserted by your BuildModel analyses as well as the same information of the optimized files (see 2.2.). These files consist of a full list of dihedral angles of each amino acid present in your PDB file. To analyze this data, you find the differences between your repaired PDB file output and the output of the mutation. Make sure to only compare optimized files with optimized mutant files and non-optimized with non-optimized files.

NOTE: Each DH file is named after the mutation line (see 4. Tutorial) it was on in your individual list.

>Expected DH. output:
>
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-19-om-15.28.17.png)](https://www.linkpicture.com/view.php?img=LPic60a5128736b301803020340)

Within the PS. map you find maps named after the locations you tested. In those you should find a **PS_** file for every PDB file tested. In these files you find the mutation that was tested (so every amino acid you tested with the code letter; a for every amino acid) with in the next column there ∆G. 

NOTE: some files will not present His (H) as a mutant but "e" or "o". These are His in different protonation states. More information about this can be found [here]( http://foldxsuite.crg.eu/allowed-residues).

>Expected PS. output:
>
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-19-om-15.30.37.png)](https://www.linkpicture.com/view.php?img=LPic60a51311636f51924747962)

In the last map, Molecules., you find every PDB file made and used by the script. These files can be used for visualization purposes or in further analyses.

>Expected molecules. output:
>
>[![image](https://www.linkpicture.com/q/Schermafbeelding-2021-05-19-om-15.34.09.png)](https://www.linkpicture.com/view.php?img=LPic60a513e38d0db1413115394)

#### 6. Licenses

This script is produced to function as a tool to run FoldX® in a user-friendly and high-throughput manner and was produced with an academic FoldX® license.

#### 7. References

[1]: Schymkowitz, J. W. et al. Prediction of water and metal binding sites and their affinities by using the Fold-X force field. Proc Natl Acad Sci U S A 102, 10147-10152, doi:10.1073/pnas.0501980102 (2005).

[2]: Van Durme, J. et al. A graphical interface for the FoldX forcefield. Bioinformatics 27, 1711-1712, doi:10.1093/bioinformatics/btr254 (2011).
