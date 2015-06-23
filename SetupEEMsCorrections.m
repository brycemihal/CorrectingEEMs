% Code for setting up the input file and input directories for running
% corrections on the Raw EEMs.
% Created by: Bryce Mihalevich 
% Last Edit: 06/09/15

% Change Log: 
% 06/09/15 - removed the creation of a new directory and copyfile section
% of the code to simplify file mgmt. Changed default file structure
% 06/17/15 - changed how the script determines the integration time. Added
% the ability to input a worksheet with dilution factors
%
% You must have your Extracted directroy in your RanYYMMDD folder. You must
% have your raw EEMs 'Processed' file and note file named the same. i.e.
% ABC123 (01)- Processed Graph_RM.dat and ABC123 (01).txt Your SetupYYMMDD
% folder must be in the respective RanYYMMDD directory. The Corrected EEMs
% will be saved in the RanYYMMDD folder. Function filw dilutionF.m is
% required to run this script.
% _____________________________________________________________________
% 1. Set the relative path to the directory with the EXTRACTED raw EEMs
cdHome = pwd;
extDir = uigetdir;
cd(extDir)
cd ..   
ranDir = pwd;

% 1.b. Find the date of the Ran EEMs
% Assumes directory path ends in YYMMDD
dateRan = ranDir(length(ranDir)-5:length(ranDir));

% 1.c. Mac or pc slash
m = filesep;

% 1.d. Find the setup folder in the ran folder and store its path
k = dir;
for i = 1:length(k)
    if k(i).isdir == 1
        if  strfind(k(i).name,'Setup') > 0
            setupDir = strcat(pwd,m,k(i).name);
        break
        end
    end
end

% 1.e. Make a correctedEEMs directory 
cd(ranDir)
correctDir = 'CorrectedEEMs';
mkdir(strcat(correctDir,dateRan))
cd(strcat(correctDir,dateRan))
correctDir = pwd; 

% ________________________________________________
% 2. Separate the file types
% Extracted Files
cd(extDir)
extEEMs = dir(extDir);
a=1; b=1; c=1;
% 2.a. store each extracted file input file type in a new variable
for i = 1:length(extEEMs)
    if strfind(char(extEEMs(i).name),'Processed') > 0 %only save files with "Processed"
        EEMFiles{a,1} = char(extEEMs(i).name);
        a = a+1;
    elseif strfind(char(extEEMs(i).name),'Note') > 0
        noteFiles{b,1} = char(extEEMs(i).name);
        b = b+1;
    elseif strfind(char(extEEMs(i).name),'Spectra') > 0
        UVFiles{c,1} = extEEMs(i).name;
        c = c+1;
    end
end
% Setup Files
cd(setupDir)
setupFiles = dir(setupDir);
%2.b. Seperate the RSU Raman Area Graph files and the Blank Processed
% Graph RM_files
a = 1; b = 1;
for i = 1:length(setupFiles)
    if strfind(char(setupFiles(i).name),'Raman') > 0
        rsuFiles{a,1} = char(setupFiles(i).name);
        a = a+1;
    elseif strfind(char(setupFiles(i).name),'Processed') > 0
        blankFiles{b,1} = char(setupFiles(i).name);
        b= b+1;
    end
end

% ________________________________________________
% 3. Create the input .txt file array
% 3.a. Remove .txt from noteFiles
noteFileshort = strcat(strtok(noteFiles,')'),')');
% 3.b Remove end of EEMs file
EEMFileshort = strtrim(strtok(EEMFiles,'-'));
% 3.c. Create each row of the input text file. Input txt file includes
% extEEMs, extUVF, rsuFiles, blankFiles, corrected EEMs name, integration
% time, dilution factor
% Create cell # rows = length(EEMFiles) and #columns = 7
inputCFile = cell(length(noteFiles),7);
dFac = 0;
dFChoice = 0;
cd(extDir)
for i = 1:length(noteFiles)
    for j = 1:length(EEMFileshort)
        % 3.c.i Match the note files to the EEMs files
        if strcmpi(EEMFileshort(j),noteFileshort(i)) == 1
            % EEMs File
            inputCFile{i,1} = char(EEMFiles(j));
            inputCFile{i,2} = char(UVFiles(j));

            fid = fopen(char(noteFiles(i)));
            % c is the text in the note file
            c = fscanf(fid, '%s');
            fclose(fid);

            % 3.c.ii Find the blank file
            for b = 1:length(blankFiles)
                if strfind(c,strcat(char(strtok(blankFiles(b))),'.blank')) > 0
                    blankf = char(blankFiles(b));
                end
            end

            % 3.c.iii Find the RSU file 
            % Has assumption that blankf = BlankYYMMDD
            for b = 1:length(rsuFiles)
                if strfind(char(rsuFiles(b)),strtok(blankf(6:length(blankf)))) > 0
                    rsuf = char(rsuFiles(b));
                end
            end

            inputCFile{i,3} = rsuf;
            inputCFile{i,4} = blankf;

            % 3.c.iv Find the integration time
            istr = 'EX1:Excitation';
            t = 'IntegrationTime:';
            a = strfind(c,t);
            b = strfind(c,istr);
            itime = c(a(1)+length(t):b(1)-1);

            inputCFile{i,5} = itime;

            % 3.c.v. Uses question dialog box to get user input for the dilution
            % factor. Question will be asked for every loop, unless otherwise
            % selected.    
            % Option to import a worksheet with the dilution factors.
            % Column 1 must have the sample names and Column 2 must have
            % the dilution factors
            
            if dFChoice == 0;
                choice = questdlg('Do you want to import a worksheet with dilution factors?', ...
                        'Dilution Factor Input','Yes','No (manual entry)','No (manual entry)');
                switch choice
                    case 'Yes'
                        % Only grabs the name of the input file
                        [dFName, dFInputPath, FilterIndex] = uigetfile('*.txt');
                        fid = fopen(strcat(dFInputPath,dFName));
                        dFinput = textscan(fid, '%s %s','Delimiter','\t');
                        textlen = length(dFinput{1,1});
                        fclose(fid);
                        dFChoice = 999;
                    case 'No (manual entry)'
                        dFChoice = 111;
                end
            end
            % worksheet entry selected for dF input.
            % Read in the input worksheet (.txt is default) use drop down
            % to select all file types if file is not xlsx
            % Match the sample name to a dilution factor
            if dFChoice == 999
                for ii = 1:textlen-1
                    if strcmpi(strtok(EEMFiles(j)),dFinput{1}(ii)) == 1
                        dF = str2double(char(dFinput{2}(ii)));
                        break
                    end
                end
            end
                              
            % Manual entry selected for dF input.
            if dFChoice == 111;
                if dFac == 2
                    dF = 1;   
                else
                    dF = dilutionF(char(EEMFiles(j)));              
                end
            end
            % User selected that no samples were diluted (dF = 2); 
            % Qustion will not be asked agian
            if dF == 2
                dFac = 2;
                dF = 1;
            end

            inputCFile{i,6} = dF; 
            %3.c.vi. Name of corrected file
            inputCFile{i,7} = strcat(char(EEMFileshort(j)),' Corrected');
            
        end
    end
end

% ___________________________________________________________
% 4. Save the input .txt file array in the corrected EEMs dir
cd(correctDir)
fileName = sprintf('EEMsInput%s.txt',dateRan);
fid = fopen(char(fileName), 'wt');
for i = 1:length(inputCFile(:,1))
    %Raw,RSU,Blank,Integration,Dilution,CorrectedName
fprintf(fid, '%s,%s,%s,%s,%s,%f,%s\n', inputCFile{i,:});
end
fclose(fid);
fprintf('All done!\n');

% Start the correction code
% RunEEMsCorrections
