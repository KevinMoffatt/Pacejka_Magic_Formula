function [ C ] = ImportTireData(filename)
%ImportTireData
% ImportTireData( filename ) returns a cell array, C, which contains the % variable names in the first cell and the data for each variable name. % in the second cell.
fid = fopen(filename);
C = cell(1,2);
pos = 1;
sizeC = 0;
while ~feof(fid)
[a, pos] = textscan(fid, '%s = %12f',pos, 'CommentStyle', '$'); 
while size(a{1},1) <= 1
[a,pos] = textscan(fid, '%s = %12f',pos, 'CommentStyle', '$'); 
end
    for i = 1:size(a{2},1)
        C{1}(sizeC+i) = a{1}(i);
        C{2}(sizeC+i) = a{2}(i);
    end
    sizeC = size(C{1},2);
end
fclose(fid); % Close file
end