# CorrectingEEMs

Procedure for preparing files and running the correction code for EEMs scans in MATLAB.

- Prepared by: Bryce Mihalevich
- Last Edit: 6/17/2015

## 1.	Data Needed

- For each integration time (try to follow naming conventions):
  * BlankYYMMDD (##) – Processed Graph_ RM.dat
  * RSUYYMMDD (##) – Raman Area Graph.dat
  * BlankYYMMDD05 (##) – Processed Graph_ RM.dat
  * RSUYYMMDD (##) – Raman Area Graph.dat
  * BlankYYMMDD25 (##) – Processed Graph_ RM.dat
  * RSUYYMMDD25 (##) – Raman Area Graph.dat

- For each sample to be corrected:
  * SAMPLENAME (##) – Note.txt
  * SAMPLENAME (##) – Abs Spectra Graphs.dat
  * SAMPLENAME (##) – Processed Graphs_ RM.dat

## 2.	Exporting Data
* Blank and RSU files
  * Blank and RSU files are exported from the Aqualog software while in the Setup project file. Select File->HJY Export->…
*	UV and EEMs files
  * UV and EEMs files are exported from the Aqualog software while in the sample analysis project file. Select File->HJY Export->…
*	Note file
  *	To export the Note file from the Aqualog software make the Note tab active in your sample analysis project file. Select File->Export->ASCII. Rename the Note file to be SAMPLENAME (##) – Note.txt. Select Save, a new box will appear. Check the box that says, “Export Selected Data Only” and click save.

## 3.	File structure for running the Correction Code
[Your Chosen Directory]
* RanYYMMDD
  *	ExtractedYYMMDD
    *	SAMPLENAME (##) – Note.txt
    *	SAMPLENAME (##) – Abs Spectra Graphs.dat
    *	SAMPLENAME (##) – Processed Graphs_ RM.dat
    *	…for each sample to be corrected
  *	SetupYYMMDD (copy and paste the SetupYYMMDD folder from the SetupFolders directory on the lab computer)
    *	BlankYYMMDD (##) – Processed Graph_ RM.dat
    *	RSUYYMMDD (##) – Raman Area Graph.dat
    *	… for each RSU and Blank created at different integration times

## 4.	Analysis log of your Samples
*	Create an analysis log of every sample you ran on YYMMDD that includes: 
  -	Sample identifier
  -	Dilution Factor
*	The Matlab script will not use this file unless you export the log as a .txt file with the Sample ID in the column 1 and the dilution factor in column 2. You can choose to either import the .txt file for the program to match the dilution factors or enter each dilution factor manually while the script runs. 

## 5.	Running the Matlab Scripts
1.	Required scripts and function files:
  *	SetupEEMsCorrections.m
  *	RunEEMsCorrections.m
  *	funEEMsCorrections
  *	dilutionF.m
2.	Add the required scripts to the path
3.	Open the “SetupEEMsCorrections.m” script in Matlab
  1.	Click the run button (green arrow)
  2.	You will be prompted to select a directory. Select the “ExtractedYYMMDD” folder containing all of the extracted Aqualog data in the “RanYYMMDD” directory and click “Open”. 
  3.	You will be prompted to import a file containing dilution factors or input each dilution factor manually. 
    *	For manual entry: If no samples in the sample set were diluted, select “No samples being corrected were diluted”.  If this sample was diluted select “Yes” and then choose the dilution factor or input a dilution factor by choosing “Other”. 
    *	The program will loop through and ask for a dilution factor for each sample in the sample set, unless you choose “No samples being corrected were diluted”.  
  4.	When complete the program will have created a new directory in your RanYYMMDD folder named CorrectedEEMsYYMMDD.  In it will be the file EEMsInputYYMMDD.txt
  5.	You can now run the correction script. (You could add RunEEMsCorrectinos.m to the end of the SetupEEMsCorrections.m file to auto run it after setup.)
4.	Open the “RunEEMsCorrections.m” script in Matlab
  1.	Click the run button (green arrow)
  2.	You will be prompted to select a directory. Select the “CorrectedEEMsYYMMDD” folder created in the “RanYYMMDD” directory and click “Open”. 
  3.	The script will run for each row in the EMMsInputYYMMDD.txt file. This might take some time if you have a large sample set. 

4.	The program will save in your CorrectedEEMsYYMMDD directory:
  -	.tif image of the EEM, 
  -	.tif of the max emission at excitation 370nm, 
  -	.xls file of the EEM matrix 
  -	.txt file of parameters

