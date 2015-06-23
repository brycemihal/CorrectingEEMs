% To DO:
% Bryce: Add tick marks to graph
% Bryce: Add 'x' to multiple maximum peaks

% Change Log:
% 5/28/15 - I was getting an error b/c length of rows were to short. 
% 6/10/15 - I was exporting the wrong file in Aqualog. Changed the length
% of rows back to the way they were. 
% 6/12/15 - Edited contour settings.
% 6/16/15 - Changed save location. Added save for emission at excitation 
% 370 plot. Added known/theoretical fluorescence peaks to plot. Added peak
% intensity identifier (grean plus) to the plot.
% 6/17/15 - Added the export of emPeak and exPeak to the function.

function [FI, maxEm, BIX, TC,emPeak,exPeak] = funEEMsCorrections(Afile, ifile, uvfile, bfile, rfile, dilution_factor, uvlength, correctedpath)
% all of the emission values
% % em = [239.515,241.097,242.681,244.264,245.849,247.434,249.02,250.606,252.193,253.781,255.37,256.959,258.549,260.139,261.73,263.322,264.914,266.507,268.101,269.696,271.291,272.886,274.483,276.079,277.677,279.275,280.874,282.474,284.074,285.675,287.276,288.87,290.481,292.084,293.688,295.292,296.898,298.503,300.11,301.717,303.324,304.932,306.541,308.151,309.761,311.371,312.983,314.594,316.207,317.82,319.433,321.048,322.662,324.278,325.894,327.51,329.127,330.745,332.363,333.982,335.602,337.222,338.842,340.463,342.085,343.707,345.33,346.954,348.578,350.202,351.827,353.453,355.079,356.706,358.333,359.961,361.589,363.218,364.847,366.477,368.108,369.739,371.37,373.003,374.635,376.268,377.902,379.536,381.171,382.806,384.442,386.078,387.715,389.352,390.99,392.628,394.267,395.906,397.546,399.186,400.827,402.468,404.11,405.752,407.394,409.038,410.681,412.325,413.97,415.615,417.26,418.906,420.553,422.2,423.847,425.495,427.143,428.792,430.441,432.091,433.741,435.391,437.042,438.694,440.346,441.998,443.651,445.304,446.957,448.611,450.266,451.921,453.576,455.232,456.888,458.544,460.201,461.859,463.516,465.175,466.833,468.492,470.151,471.811,473.471,475.132,476.793,478.454,480.116,481.778,483.44,485.103,486.766,488.429,490.093,491.758,493.422,495.087,496.753,498.418,500.084,501.751,503.417,505.084,506.752,508.42,510.088,511.756,513.425,515.094,516.763,518.433,520.103,521.774,523.444,525.115,526.787,528.458,530.13,531.803,533.475,535.148,536.821,538.495,540.168,541.842,543.517,545.191,546.866,548.541,550.217,551.892,553.568,555.244,556.921,558.598,560.275,561.952,563.629,565.307,566.985,568.664,570.342,572.021,573.7,575.379,577.058,578.738,580.418,582.098,583.779,585.459,587.14,588.821,590.502,592.184,593.865,595.547,597.229,598.911,600.594,602.276,603.959,605.642,607.325,609.009,610.692,612.376,614.06,615.744,617.428,619.113,620.797]

%emission values to 550
% em = [250.229,254.716,259.208,263.703,268.202,272.705,277.211,281.721,286.234,290.752,295.273,299.797,304.325,308.856,313.392,317.93,322.472,327.018,331.567,336.119,340.675,345.234,349.796,354.362,358.931,363.504,368.079,372.658,377.241,381.826,386.415,391.007,395.601,400.2,404.801,409.405,414.012,418.623,423.236,427.852,432.472,437.094,441.719,446.347,450.978,455.612,460.248,464.888,469.53,474.175,478.823,483.473,488.126,492.782,497.44,502.101,506.765,511.431,516.1,520.771,525.445,530.121,534.8,539.48,544.164,548.85,553.538,558.228,562.921,567.616,572.313,577.012,581.714,586.417,591.123,595.831,600.541,605.253,609.967,614.683,619.401,624.12,628.842,633.566,638.291,643.019,647.748,652.479,657.211,661.946,666.682,671.419,676.158,680.899,685.642,690.386,695.131,699.878,704.627,709.376,714.128,718.88,723.634,728.389,733.146,737.903,742.662,747.422,752.184,756.946,761.71,766.474,771.24,776.006,780.774,785.542,790.312,795.082,799.853,804.625,809.398,814.171,818.945,823.72,828.496];
%em = em(1:125);


eemdata = importdata(Afile);
em = eemdata.rowheaders(2:length(eemdata.rowheaders))';
ex = eemdata.data(1,:);

% ex = 830:-2:248;
emlen = length(em);
exlen = length(ex);%These must be updated before you start to be your wavelength ranges and increments

%Reads in blank file and pulls out raman scan (ex=350 nm)
B = importdata(char(bfile)); %Reads in Blank EEM file
Blank = B.data(2:126,:);%Use 251 if you have a larger excitation range that covers the entire emission range.
Raman = importdata(char(rfile)); %Imports the Raman File
%Ramany = Raman.data(24:134,4);%Picks out Raman file 375-430 em, 350 ex all
%raman scans are at ex 350
Ramany = Raman.data(22:131,4);%%% For Aqualog Picks out rows 32:45, col 4 which is Em 349.796:450.978	
%%%Ramany = Raman.data == 370 : Raman.data == 430  %%% Wouldn'tthis be more accurate then by row???
%Ramany = Ramany/10;  

%The section below calculates the area under the raman curve.
y = Ramany;
x = 375:0.5:430;  %% originally ran with this correction changed to the
%x = [374.635,376.268,377.902,379.536,381.171,382.806,384.442,386.078,387.715,389.352,390.99,392.628,394.267,395.906,397.546,399.186,400.827,402.468,404.11,405.752,407.394,409.038,410.681,412.325,413.97,415.615,417.26,418.906,420.553,422.2,423.847,425.495,427.143,428.792,430.441,];
% Correct Raman Excitation
summation = 0; 
iteration=1;
for i=1:100 %This may need to be changed depending on the Raman scan parameters.  This integrates from em 370-450 nm. Number of rows minus one because the loop adds one
    y0 = y(i); 
    y1 = y(i + 1); 
    dx = x(i+1) - x(i); 
    summation = summation + dx * (y0 + y1)/2;
    iteration = iteration+1;
end

%BaseRect = (y(1)+y(110))/2*(x(110)-x(1));
%BaseRect = sum(Raman.data(21:131,6));
%RamanArea = summation - BaseRect
RamanArea = summation;

Brc=Blank/RamanArea; %This raman normalizes the corrected blank file.
%Brc = Brc(1:125,:);

%Read in sample file, instrument correct, IFE, Raman normalize, Blank subtract

A = importdata(char(Afile));  % Reads in raw EEM file that has been exported using spectra express.
% BAM - Getting an error b/c length of A.data = 126 not 127.
% Changed 127 to length(A.data(:,1)) on 5/28/15
% Changed length(A.data(:,1)) back to 127 on 6/10/15
% textlengthofdata = length(A.data(:,1));
A = A.data(3:127,:); %Use 251 if you have a larger excitation range that covers the entire emission range.

abs = importdata(char(uvfile));  % Reads in the UV absorance file that has been transferred to a csv file format using UVChemStation.
%abs254 = abs.data(123,10);
waves = flipud(abs.data(:,1));
%data = abs.data(:,10);
data = abs.data(:,10);
% Performs Inner Filter Calculation using the UV absorbance spectrum.
% transform for excitation
ex_abs = data;  %%% Absorbance values

% BAM - Getting an error b/c length of A = 124 not 125.
% Changed 125 to length(A(:,1)) on 5/29/15
% Changed length(A(:,1)) back to 125 on 6/10/15
emforIFC = em(1:125);
em_data = flipud(data);
em_abs = interp1(waves,em_data,emforIFC);  %%% Interp for the Abosorbance every 2 nm, 
    %%results in interpolated Abs
%em_abs(2:234) = em_abs(2:233);
%em_abs(1) = data(125);

for i=1:length(em_abs)
    for j=1:length(ex_abs)
        IFC(i,j)=ex_abs(j)+em_abs(i);
    end
end

%contourf(IFC)
%figure; contourf(A)
% BAM - Getting an error b/c length of A = 124 not 125.
% Changed 125 to length(A(:,1)) on 5/28/15
% Changed length(A(:,1)) back to 125 on 6/10/15
% textlengthofdata2 = length(A(:,1));
AforIFC = A(1:125,:);%A(1:161,:)
Aci = AforIFC.*10.^(0.5*IFC);

%Aci(162:173,:) = A(162:173,:);%Adding back in data with no IFC

Acir = Aci/RamanArea; %This raman normalizes the instrument and IFE corrected EEM file.
% BAM - error occurs when the A = 124 and A.data = 126. Matrix dimensions
% do not match. Acir ends up having one less row than the Blank. A row of
% zeros needs to be added in this case (Blank has two rows of zeros and Acir 
% only has one in this case). Added following if statement on 5/29/15.
% Add a row of zeros to the top of Acir if it is not 125 rows long
% 6/10/15 - removed section of code. I was exporting the wrong aqualog file
% % if length(Acir(:,1)) == 125
% % else
% %     % find the length of the existing array
% %     numRows = length(Acir(:,1));
% %     numColumns = length(Acir(1,:));
% %     %Create singel row # of columns in Acir
% %     newRow = zeros(1,numColumns);
% %     % create a new array of length + 1
% %     newArray = zeros(numRows+1,numColumns);
% %     % start a for loop to relocate each existing row to one lower.
% %     j = 1;
% %     for i = 1:numRows
% %         if i == 1
% %             newArray(j,:) = newRow;
% %             j = i+1;
% %         end
% %         newArray(j,:) = Acir(i,:);
% %         j = j+1;
% %     end
% %     Acir = newArray;
% % end
Asub = Acir - Brc; %This blank subtracts the corrected EEM file.

Adil = Asub*dilution_factor/uvlength; %This applies the dillution factor normalization.

% Save the raman normalized and correceted EEM matrix (inner filter too).
pathname = correctedpath;

for i=1:length(ifile)

    pathname(length(pathname) + 1) = ifile(i);

end

pathnamelength = length(pathname);

pathname(pathnamelength + 1: pathnamelength + 4) = '.xls';
% BAM - Changed save location and name
cd(correctedpath)
Fname = strcat(ifile,' Matrix.xls');
save(Fname, 'Adil', '-ascii', '-double', '-tabs');
% save(pathname, 'Adil', '-ascii', '-double', '-tabs');

% This next part calculates the fluorescence index
%ex = fliplr(ex);
emI = 250:5:830; %em wavelengths needed for interpolation
A = Adil; %Transposes corrected matrix for plotting and FI.  %%% Does this really transpose it?

%%%%%%% FI %%%%%%%%%%%
ex370 = find(ex == 370); %Index where excitation is 370 for FI
FIem =  interp1(em,A(:,ex370),emI); %interpolates along ex370 to get emission values for FI

em470 = find(emI==470); %Index where emission is 470
em520 = find(emI==520); %Index where emission is 520
FI = FIem(em470)/FIem(em520); %Calculates FI

%%%%%% PeakT  %%%%%%%%%
ex276 = find(ex == 276); % for T peak should be 275
em350 = find(emI==350); % for T peak
Tem = interp1(em,A(:,ex276),emI); %interpolates along ex276 to get emission values for PeakT, should be ex275
PeakT = Tem(em350) %% emission 350 at ex276

%%%%%% PeakC %%%%%%%%%%%
em410 = find(emI == 410); %row index for em410
em430 = find(emI == 430); % row index for em430
ex340 = find(ex == 340);  % col index for ex 340
ex320 = find(ex == 320); % col index for ex 320  %%%% REMEMBER EX cols go from large to small, 
maxCarea = A(em410:em430, ex340:ex320)
PeakC = max([A(:)])

%%%%%% PeakT/PeakC %%%%%%%%%
TC = PeakT/PeakC; %BAM added semicolon

%%%%%%%%%% BIX  %%%%%%%%%%%%

ex310 = find(ex == 310);  % for BIX
BIXem = interp1(em,A(:,ex310),emI); %interpolates along ex310 to get emission values for BIX

em380 = find(emI==380); %Index where emission is 380
em420 = find(emI==420); %Index where emission is 420
em435 = find(emI==435); %Index where emission is 435
maxBIX = max(BIXem(em420:em435)) %max em values between 420 and 435)
BIX = BIXem(em380)/(maxBIX); %BAM added semicolon %emmission intensity at em380 / max emmission intensity 420:430

A=A';
%A=flipud(A);

%FI = A(em470, ex370)./A(em520, ex370); %Calculates the fluorescence index.
%FI = A(em470, ex370)./A(em520, ex370); %Calculates the fluorescence index.

% Graph ...

figure(1), clf; %, subplot(2,1,1); This subplot puts the 370ex emission curve on the bottom half of the EEM tiff file.

% set colormap

% set min and max intensity values (to be mapped to min and max colors in

% colormap)

% prevent auto-setting of caxis by changing caxis to manual control

% now draw the graph


% cut code from F4
% % Acut = A;
% % for j=1:66
% %     i = find(em<(ex(j)+5));
% %     Acut(i,j)=NaN;
% % end
% % for j=1:66
% %     i = find(em>(ex(j)*2-5));
% %     Acut(i,j)=NaN;
% % end
% % A=Acut;

%Aplot = flipud(A);

contourf(em,ex,A,100,'LineColor','none'); %BAM - Removed contour lines for better visability % with 30 contour lines

% BAM - add maximum intensity to the contourplot
figure(1)
hold on 
[I,J] = find(A == max(A(:)));
emPeak = em(J); exPeak = ex(I);
plot(emPeak,exPeak,'ow','MarkerSize',3)

%Add points to each peak on the graph
% [peaks] = SurfPeaks(A);
% % peaks = peaks'; 
% for i = 1:length(ex)
%     for j = 1:length(em)
%         if peaks(i,j) == 1
%             hold on
%             if em(j) < 550 && ex(i) < 450
%             plot(em(j),ex(i),'+w','MarkerSize',4)
%             end
%         end
%     end
% end

%BAM - add known/theoretical fluorescence peaks to plot
% Source: USGS Organic Mater Research; http://or.water.usgs.gov/proj/carbon/EEMS.html
hold on
%  text(em,ex,identifier)
text(306,270,'B') %Tyrosine like-protein like, associated with autochthonous OM
text(340,270,'T') %Tryptophan-like, protein like, associated with phytoplankton 
% productivity and has been associated with wastewater
text(450,260,'A') %Humic-like
text(390,300,'M/N') %Humic like, possibly marine, possible microbial reprocessing, 
% more labile humic acids
text(440,340,'C') %Humic-like, terrestrial, wide spread
text(510,390,'D') %soil fulvic acid
text(460,370,'FDOM') %In-Situ fluorescence that is highly correleated to DOC concentrations

%maxEm = em(emlen-(find(A(ex370, :) == max(A(ex370, :)))));
maxEm = em((find(A(ex370, :) == max(A(ex370, :)))));

handle = gca;

set(handle,'fontsize', 14);

colormap(jet);

% caxis sets range for plotting. Change as necessary.

caxis([0, max(max(A))]);

caxis('manual');

H = colorbar('vert');

set(H,'fontsize',14);

xlabel('Emission Wavelength, nm','fontsize',12)

ylabel('Excitation Wavelength, nm','fontsize',12)

title (ifile, 'fontsize', 12); 

% Saves current object, this won't work if you close the figure first.
% This command saves the current object only.
% Enter the path name for the corrected EEM figure to be placed.

pathname = correctedpath;

for i=1:length(ifile)

    pathname(length(pathname) + 1) = ifile(i);

end

pathnamelength = length(pathname);

pathname(pathnamelength + 1: pathnamelength + 4) = '.tif';

% saveas(gcf,pathname,'tif');
%BAM - changed the save name and location
Fname = strcat(ifile,' EEMS');
cd(correctedpath)
saveas(gcf, Fname, 'tiffn'); 


figure, plot(em, A(ex370,:), 'k-', 'LineWidth', 2.0), xlabel('Emission Wavelength, nm'), title('Emission at Excitation 370nm');
%BAM - changed the save name and location
Fname = strcat(ifile,' Peak');
saveas(gcf, Fname, 'tiffn'); 


