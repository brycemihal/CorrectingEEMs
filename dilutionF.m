% Function for Dilution factor selection
function [dF] = dilutionF(extEEMs)
% Open quesiton box for user input of dilution factor
str = char(extEEMs);
choice = questdlg(sprintf('Was %s diluted?',str),'Dilution Factor Input', ...
    'Yes', 'No', 'No samples being corrected were diluted', ...
    'No samples being corrected were diluted');
switch choice
    case 'Yes'
        choice2 = questdlg('What is the dilution factor?','Dilution Factor Input', ...
            '0.25','0.50','Other','0.25');
        switch choice2
            case '0.25'
                dF = 0.25;
            case '0.50'
                dF = 0.50;
            case 'Other'
                dFin = inputdlg('Enter the dilution factor for this sample (number): ', ...
                    'Dilution Factor Input');
                dF = str2double(dFin{:});
        end
    case 'No'
        dF = 1;
    case 'No samples being corrected were diluted'
        dF = 2;
end
        
        
