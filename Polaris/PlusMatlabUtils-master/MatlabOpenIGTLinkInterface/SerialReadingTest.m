s = serial('COM6');
fopen(s);
while s.BytesAvailable>-1
    disp(s.fscanf)
end
fclose(s)
delete(s)
clear s