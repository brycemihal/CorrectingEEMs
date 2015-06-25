% Code for running correction on the Raw EEMs.
% Created by: Bryce Mihalevich 
% Last Edit: 06/09/15
% Change Log: 
% 06/09/15 - simplified the number of directories to read files in from.
% 6/10/15 - edited comments, fixed directory error
% 6/16/15 - added sample name and headers to the output file, completely 
% changed output save file code  
% 6/17/15 - added more headers and parameters to the output file


% 1. Select the CorrectedEEMs folder created in the SetupEEMsCorrection
% script. This was saved in the RanYYMMDD folder.
% Set the relative working directory
correctDir = uigetdir;
cd(correctDir) 
cd ..

m = filesep;
% 1.a Assign the directories
% EEM, UV, and Note files are in extracted
% rsu, and blank are in Setup
k = dir;
for i = 1:length(k)
    if k(i).isdir == 1
        if  strfind(k(i).name,'Setup') > 0
            setupDir = strcat(pwd,m,k(i).name);
        elseif strfind(k(i).name,'Extracted') > 0
            extDir = strcat(pwd,m,k(i).name);
        end
    end
end
    
% 2. Read the input file
inputFile = dir(strcat(correctDir,m,'*.txt'));
for i = 1:length(inputFile)
    if strfind(inputFile(i).name,'Input') > 0 
        inputFile = inputFile(i).name;
        break
    end
end
fid = fopen(strcat(correctDir,m,inputFile));
inputText = textscan(fid, '%s %s %s %s %f %f %s','Delimiter',',');
textlen = length(inputText{1,1});
fclose(fid);


% 3. Run the correction for each line in the input file. Save each line
% into CorrectionOutput.txt
% Find the date of the Ran EEMs
% Assumes directory path ends in YYMMDD
dateRan = correctDir(length(correctDir)-5:length(correctDir));
cd(correctDir)
fileName = sprintf('CorrectionOutput%s.txt',dateRan); %output file
fid = fopen(char(fileName), 'wt');
%headers for output file
fprintf(fid, '%s,%s,%s,%s,%s,%s,%s\n','Sample_Code','FI','maxEm','BIX','TC','EM Peak', 'EX Peak'); 

for n = 1:textlen
    
%     blankDir = sprintf('%s',char(inputText{1,7}(n)));
%     uvpath = sprintf('%s',char(inputText{1,8}(n)));
    
    Afile = sprintf('%s%s%s', extDir,m,char(inputText{1,1}(n))); %Name of exported raw EEMr
    
    ifile = sprintf('%s', char(inputText{1,7}(n)));  %Name of corrected file to save
    
    bfile = sprintf('%s%s%s', setupDir,m,char(inputText{1,4}(n))); %Name of blank file
    
    rfile = sprintf('%s%s%s', setupDir,m, char(inputText{1,3}(n))); %Name of raman file

    uvfile = sprintf('%s%s%s', extDir,m,char(inputText{1,2}(n))); %Name of UV file

    dilution_factor = inputText{1,6}(n); %Input dilution factor
    
    uvlength = inputText{1,5}(n); %Input integration time, cannot be of type "cell"
    
    [FI(n),maxEm(n),BIX(n),TC(n),emPeak,exPeak] = funEEMsCorrections(Afile,ifile,uvfile,bfile,rfile,dilution_factor,uvlength,correctDir); %Save out corrected EEM and fluorescence index
   
    SampleName = ifile(1:strfind(ifile,'(')-2);
    
%     % Return the emission row at the wavelength of 254nm for SUVA254 analysis
%     suvaData = importdata(uvfile,' ',1000);
%     r254{n,1} = strsplit(char(suvaData(292)),'\t');
    
    fprintf('Progress: %3.0f of %3.0f\n',n,textlen)
    
    fprintf(fid, '%s,%f,%f,%f,%f,%f,%f\n', SampleName,FI(n),maxEm(n),BIX(n),TC(n),emPeak,exPeak);
       
end
fclose(fid);

% %Save the SUVA data into a new file
% fileName = sprintf('SUVA254_%s.txt',dateRan); %output file
% fid = fopen(char(fileName), 'wt'); 
% fprintf(fid, '%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t',...
%     'Wavelength','Abs Detector Raw','Ref Detector Raw', ...
%     'Linear interp','Dark subtracted Abs Detector', ...
%     'Corrected Ref Detector','Corrected Intensity','-Log(T)', ...
%     '% Transmittance')
% 
% fprintf(fid,'\n')
% for i = 1:length(r254(:,1))
%     for j = 1:length(r254{1})  
%         fprintf(fid, '%s\t', char(r254{i}(j)));
%     end
%     fprintf(fid,'\n');
% end
% fclose(fid);

fprintf('All done!\n');

