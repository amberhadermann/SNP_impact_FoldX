echo "What is the path towards your working FoldX script? (start at root)"	#Asking which FoldX script the script has to use
read FoldX	#Reading input question 
echo "Which PDB files do you want to use? (CODE PDB file)" #Asking which PDB files need to be used
read PDB #Reading input question
echo "Do you want to run a BuildModel analysis? (Yes/No)" #Asking whether the BuildModel analysis needs to be performed
read wantBM	#Reading input question
case "$wantBM" in	#Starting questions and actions depending on input wantBM
        "No") echo "NO buildmodel analysis will be run";;	#Confirming no BuildModel analysis will be performed
        "Yes") echo "How many BuildModel runs do you want? (number>1)"	#Asking how many runs need to be run of the BuildModel analysis
                        read Runs	#Reading input question
                echo "How many mutations are you testing? (number)"	#Asking how many mutation lines the individual file contains
                        read mutations #Reading input question
                if find BM.;	#testing whether there is a filingsystem in place
                        then echo "Filing system is already in place"; #Confirming filingsystem is in place
                        else mkdir BM.|echo BM. directory was made;	#Putting filingsystem in place
                fi
                echo "Do you want to perform a Dihedral analysis? (Yes/No)"	#Asking whether the Dihedral analysis needs to be run
                        read wantDH	#Reading input question
                case "$wantDH" in #Starting actions depending on input wantDH
                        "No") echo NO dihedral analysis will be performed;; #Confirming no Dihedral analysis will be performed
                        "Yes") echo Dihedral analysis will be performed #Confirmin a Dihedral analysis will be performed
                                if find DH.;	#testing whether there is a filingsystem in place
                                        then echo "Filing system already in place"; #Confirming filingsystem is in place
                                        else mkdir DH.|echo DH. directory was made; #Putting filingsystem in place
                                fi;;
                esac;;	#Ending actions depending on input wantDH
esac	#Ending actions and questions depending on input wantBM
echo "Do you want to perform a position scan? (Yes/No)"	#Asking whether the Positionscan needs to be performed
read wantPS	#Reading input question
case "$wantPS" in	#Starting actions and questions depending on input wantPS
        "No") echo NO position scan will be run;;	#Confirming no positionscan will be performed
        "Yes") echo "which positions do you want to test? (Positions in format separated by tab)" #Asking which positions need to be scanned
                read positionscanmlocations	#Reading input question
                if find PS.;	#Testing whether filingsystem is in place
                        then echo Filing system already in place;	#Confirming filingsystem is in place
                        else mkdir PS.|echo PS. directory was made;	#Putting filingsystem in place
                fi;;
esac	#Ending actions and questions depending on input wantPS
echo "FoldX analysis will start now" #Stating the questions are over and the analysis will start now
echo "Note that this can take a long time depending on your analysis" #Stating that this can take a long time and that this is normal
for PDB in $PDB;	#Making a vector from the different PDB files that need to be used (from input)
do #Starting a loop to test every PDB file entered in input
for pdbrepair in ./${PDB}_Repair.pdb #Making a vector to use the repaired PDB file with the different PDB files
do #Starting a loop to test every repaired PDB file 
if find ${PDB}.pdb;	#Testing whether the PDB file is already present in the directory
 then echo ${PDB}.pdb already exists;	#Confirming the PDB file is already present
 else  wget https://files.rcsb.org/download/${PDB}.pdb; #Downloading in the PDB file from the protein data base website
fi
if find ${pdbrepair};	#Testing whether the repaired PDB file is present
        then echo ${pdbrepair} already exists; #Confirming the repaire PDB file is present
        else echo need to repair pdb file first this can take a long time|$FoldX --command=RepairPDB --pdb=${PDB}.pdb;	#Stating the PDB file needs to be repaired|repairing the PDB file
fi
for individual_file in ./individual_list*.txt	#Making a vector to identify the different individual files in the directory and performing the analysis with everyone of them
do #Starting a loop to run the BuildModel analysis with every individual file
case "$wantBM" in	#Starting actions depending on the input of wantBM
        "No") echo No Buildmodel;; #Confirming no BuildModel analysis will be run
        "Yes") if find Dif_${PDB}_Repair.fxout; #Testing whether there is output of previous FoldX analysises in the directory
                        then echo "Dif_file already exists and it is moved to secure location"	#Confirming that there is output present and that this will be moved
                                mkdir Buildmodel_previousrun	#Make directory to store already present output to secure data
								chmod +rw Dif_${PDB}_Repair.fxout Average_${PDB}_Repair.fxout #Giving the files permission to be moved
                                mv  Dif_${PDB}_Repair.fxout ./Buildmodel_previousrun |mv  Average_${PDB}_Repair.fxout ./Buildmodel_previousrun	#copying the data to the new directory
                                $FoldX --command=BuildModel --pdb=${pdbrepair} --mutant-file=${individual_file} --numberOfRuns=$Runs	#Starting BuildModel analysis with vectors
                                if find BM${individual_file}; #Testing whether the filingsystem for the individual file is in place
                                        then chmod +rw Dif_${PDB}_Repair.fxout Average_${PDB}_Repair.fxout	#Giving permission to files to be moved/removed
											mv Dif_${PDB}_Repair.fxout ./BM${individual_file}|mv  Average_${PDB}_Repair.fxout ./BM${individual_file}; #Copying output files to directory
                                        else  mkdir BM${individual_file}	#Making new directory for the individual file
											chmod +rw Dif_${PDB}_Repair.fxout Average_${PDB}_Repair.fxout	#Giving permission to files to be moved/removed
                                                 mv Dif_${PDB}_Repair.fxout ./BM${individual_file}|mv  Average_${PDB}_Repair.fxout ./BM${individual_file} #Copying output files to new dir
                                fi;
                        else $FoldX --command=BuildModel --pdb=${pdbrepair} --mutant-file=${individual_file} --numberOfRuns=$Runs #Starting BuildModel analysis with vectors
                                if find BM${individual_file}; #Testing whether the filingsystem for the individual file is in place
                                        then chmod +rw Dif_${PDB}_Repair.fxout Average_${PDB}_Repair.fxout #Giving permission to files to be moved/removed
											mv Dif_${PDB}_Repair.fxout ./BM${individual_file}|mv  Average_${PDB}_Repair.fxout ./BM${individual_file}; #Copying output files to directory
                                        else  mkdir BM${individual_file} #Making new directory for the individual file
                                                 chmod +rw Dif_${PDB}_Repair.fxout Average_${PDB}_Repair.fxout #Giving permission to files to be moved/removed
												 mv Dif_${PDB}_Repair.fxout ./BM${individual_file}|mv Average_${PDB}_Repair.fxout ./BM${individual_file}; #Copying output files to new dir
                                fi;
                fi
				chmod +rw WT_${PDB}_Repair_*.pdb #Giving permission to files to be moved/removed
                rm WT_${PDB}_Repair_*.pdb;; #Removing temporary files
esac #Ending actions depending on the input of wantBM
case "$wantDH" in #Starting actions depending on the input of wantDH
        "No") echo No Dihedrals;; #Confirming no Dihedral analysis will be run
        "Yes")  for mutationsvectorloop in $(seq 1 $mutations) #Making a vector to run the analysis for each mutant file from mutations output (question)
                do #Starting a loop to run the Dihedral analysis for every mutation that was inserted by BuildModel analysis
                if find DH_${PDB}_Repair_${mutationsvectorloop}_1.fxout; #Testing whether there is output of previous FoldX analysises in the directory
                        then echo DH output ${PDB}_Repair_${mutationsvectorloop}_1 already exists and is moved to secure location #Confirming there are output files from previous runs
                                mkdir DH_previousrun	#Making a directory to put the output files from previous runs in
                                chmod +rw DH_*.fxout	#Giving permission to files to be moved/removed
								mv DH_*.fxout ./DH_previousrun	#Moving output files to the new directory
								$FoldX --command=Dihedrals --pdb=${PDB}_Repair_${mutationsvectorloop}_1.pdb #Performing Dihedral analysis for each mutatant pdb file  
                                if find DH${individual_file};	#Testing whether there is a filingsystem in place for that individual file
                                        then echo DH output is placed in file DH${individual_file}; #Confirming there is a filingsystem in place for that individual file
                                        else mkdir DH${individual_file}|echo DH output is placed in new file DH${individual_file}; #Making a directory for that individual file
                                fi
                                chmod +rw DH_${PDB}_Repair_${mutationsvectorloop}_1.fxout #Giving permission to files to be moved/removed
								mv DH_${PDB}_Repair_${mutationsvectorloop}_1.fxout ./DH${individual_file};	#Moving output in the directory
                        else  $FoldX --command=Dihedrals --pdb=${PDB}_Repair_${mutationsvectorloop}_1.pdb	#Performing Dihedral analysis for each mutatant pdb file
                                if find DH${individual_file}; #Testing whether there is a filingsystem in place for that individual file
                                     then echo DH output is placed in file DH${individual_file}; #Confirming there is a filingsystem in place for that individual file
                                     else mkdir DH${individual_file}|echo DH output is placed in new file DH${individual_file}; #Making a directory for that individual file
                                fi
                                chmod +rw DH_${PDB}_Repair_${mutationsvectorloop}_1.fxout #Giving permission to files to be moved/removed
								mv DH_${PDB}_Repair_${mutationsvectorloop}_1.fxout ./DH${individual_file};	#Moving output in the directory
                fi
                if find Optimized_${PDB}_${mutationsvectorloop}_1.pdb;	#Testing whether there is output of previous FoldX analysises in the directory
                        then echo Opimize output ${PDB}_Repair_${mutationsvectorloop}_1 already exists and is moved to secure location; #Confirming there is output from previous runs
							if find DH_previousrun; #Testing whether there is a back up filingsystem in place
								then chmod +rw Optimized_${PDB}_${mutationsvectorloop}_1.pdb	#Giving permission to files to be moved/removed
									 mv Optimized_${PDB}_${mutationsvectorloop}_1.pdb DH_previousrun; #Moving output files to the back up directory
								 else chmod +rw Optimized_${PDB}_${mutationsvectorloop}_1.pdb #Giving permission to files to be moved/removed
									mkdir DH_previousrun	#Making a directory to put the output files from previous runs in
									mv Optimized_${PDB}_${mutationsvectorloop}_1.pdb DH_previousrun; #Moving output files to the back up directory
							fi
							echo ${PDB}_Repair_${mutationsvectorloop}_1.pdb will be optimized|$FoldX --command=Optimize --pdb=${PDB}_Repair_${mutationsvectorloop}_1.pdb #Optimalizes file
                            $FoldX --command=Dihedrals --pdb=Optimized_${PDB}_Repair_${mutationsvectorloop}_1.pdb #Performing Dihedral analysis on optimized mutant file
                        else echo ${PDB}_Repair_${mutationsvectorloop}_1.pdb will be optimized|$FoldX --command=Optimize --pdb=${PDB}_Repair_${mutationsvectorloop}_1.pdb #Optimalizes file
                             $FoldX --command=Dihedrals --pdb=Optimized_${PDB}_Repair_${mutationsvectorloop}_1.pdb; #Performing Dihedral analysis on optimized mutant file
                fi
				chmod +rw DH_Optimized_${PDB}_Repair_${mutationsvectorloop}_1.fxout #Giving permission to files to be moved/removed
                mv DH_Optimized_${PDB}_Repair_${mutationsvectorloop}_1.fxout ./DH${individual_file} #Moving output files to individual file specific directory
                done #Ending a loop to run the Dihedral analysis for every mutation that was inserted by BuildModel analysis
                echo Dihedrals will be calculated for ${PDB}_Repair|$FoldX --command=Dihedrals --pdb=${PDB}_Repair.pdb #Performing Dihedral analysis on WT file
                chmod +rw DH_${PDB}_Repair.fxout #Giving permission to files to be moved/removed
				mv DH_${PDB}_Repair.fxout ./DH${individual_file} #Moving output files to individual file specific directory
                if find Optimized_${PDB}_Repair.pdb; #Testing whether the repaired PDB file has been optimized before
                        then echo ${PDB} has been optimized| $FoldX --command=Dihedrals --pdb=Optimized_${PDB}_Repair.pdb; #Performing Dihedral analysis on optimized wild type file
                        else echo ${PDB} will be optimized| $FoldX --command=Optimize --pdb=${PDB}_Repair.pdb #Optimalizes file
                             $FoldX --command=Dihedrals --pdb=Optimized_${PDB}_Repair.pdb; #Performing Dihedral analysis on optimized wild type file
                fi
                chmod +rw DH_Optimized_${PDB}_Repair.fxout #Giving permission to files to be moved/removed
				mv DH_Optimized_${PDB}_Repair.fxout ./DH${individual_file} #Moving output files to individual file specific directory
                if find molecules.; #Testing whether the PDB filingsystem is in place
                        then if find molecules${individual_file} #Testing whether individual file specific PDB filingsystem is in place
                                then chmod +rw ${PDB}_Repair_*_1.pdb Optimized_${PDB}_Repair_*_1.pdb #Giving permission to files to be moved/removed
									mv ${PDB}_Repair_*_1.pdb ./molecules${individual_file}| mv Optimized_${PDB}_Repair_*_1.pdb ./molecules${individual_file}; #Moving PDB files to dir
                                else mkdir molecules${individual_file}	#Make individual file specific PDB filingsystem
									chmod +rw ${PDB}_Repair_*_1.pdb Optimized_${PDB}_Repair_*_1.pdb #Giving permission to files to be moved/removed
                                        mv ${PDB}_Repair_*_1.pdb ./molecules${individual_file}| mv Optimized_${PDB}_Repair_*_1.pdb  #Moving PDB files to individual file specific dir
                                fi;
                        else mkdir molecules. #Making PDB filingsystem
                                mkdir molecules${individual_file} #Make individual file specific PDB filingsystem
								chmod +rw ${PDB}_Repair_*_1.pdb Optimized_${PDB}_Repair_*_1.pdb #Giving permission to files to be moved/removed
                                mv ${PDB}_Repair_*_1.pdb ./molecules${individual_file}| mv Optimized_${PDB}_Repair_*_1.pdb #Moving PDB files to individual file specific dir
                fi;;
esac 	#Ending actions depending on the input of wantDH
done 	#Ending loop to test every PDB for every individual file
done 	#Ending loop to test every repaired PDB file
case "$wantPS" in	#Starting actions depending on the input of wantPS
        "No") echo No Positionscan;; #Confirming that no positionscan will be run 
        "Yes") echo start position scan	#Stating the positionscan will start
                for Mutations in $positionscanmlocations	#Making vector to test every location (question)
                do      #Starting loop to scan every location
					if find ./PS./PS_${Mutations};	# Testing whether the filingsystem is in place
                    	then echo file system is in place;	#Confirming the filingsystem is in place
                        else mkdir ./PS./PS_${Mutations}| echo new file system is in place;	#Creating filingsystem
                    fi
                 	$FoldX --command=PositionScan --pdb=${PDB}_Repair.pdb --positions=${Mutations}	#Performing the positionscan
                    cp PS_*.txt ./PS./PS_${Mutations};	#Copying the output in the specialized filingsystem
                done;;	#Ending loop to scan every location
esac	#Ending actions depending on the input of wantPS
chmod +rw *.fxout energies_* Optimized_* PS_* ${PDB}_Repair_*_*.pdb	#Giving permission to files to be moved/removed
rm *.fxout	#Remove temporary files
rm energies_*	#Remove temporary files
mv Optimized_* ./molecules.	#Moving optimized PDB files in the PDB filing system
rm PS_*	#Remove temporary files
rm *_${PDB}_*	#Remove temporary files
rm ${PDB}_Repair_*_*.pdb	#Remove temporary files
rmdir ./molecules	#Remove temporary files
done	#Starting loop to test every PDB file entered in input
