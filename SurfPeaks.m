% Mark each peak by finding maximum in each row and column
function [peak]= SurfPeaks(A)

m = length(A(1,:)); %num columns
n = length(A(:,1)); %num rows
peakH = zeros(n,m);
peakV = zeros(n,m);
peak = zeros(n,m);
% Compare horizontally
for i = 1:n
    % left and right boundary
    if A(i,1) > A(i,2)
        peakH(i,1) = 1;
    end
    if A(i,m) > A(i,m-1)
        peakH(i,m) = 1;
    end
    % inner points
    for j = 2:m-1
        if A(i,j-1) < A(i,j) && A(i,j) > A(i,j+1)
            peakH(i,j) = 1;
        end
    end
end

% Compare vertically
for j = 1:m
    %top and bottom boundary
    if A(1,j) > A(2,j)
        peakV(1,j) = 1;
    end
    if A(n,j) > A(n-1,j)
        peakV(n,j) = 1;
    end
    % inner points
    for i = 2:n-1
        if A(i-1,j) < A(i,j) && A(i,j) > A(i+1,j)
            peakV(i,j) = 1;
        end
    end
end

% Plot if both peaks align
for i = 1:n
    for j = 1:m
        if peakH(i,j) == 1 && peakV(i,j) == 1
            peak(i,j) = 1;
%             hold on
%             plot(j,i,'ow','MarkerSize',8)
        end
    end
end
