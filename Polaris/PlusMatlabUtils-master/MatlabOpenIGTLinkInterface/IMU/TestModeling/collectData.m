clear
close all
clc
s=serial('COM6','BaudRate',115200);
fopen(s);
samples = 500;
Volts = fscanf(s);
data = zeros(samples,3);
f = fopen('IMU.txt','w');

for i=1:samples
    i
    Volts = fscanf(s);
    pos = find(Volts==',');
    x = str2double(Volts(1:pos(1)-1));
    y = str2double(Volts(pos(1)+1:pos(2)-1));
    z = str2double(Volts(pos(2)+1:end-2));
    %data(i,:) = [x y z]
    fprintf(f,[num2str(x) ',' num2str(y) ',' num2str(z) '\n']);
end

fclose(s);
delete(s);

%%
data=dlmread('IMU.txt',',');
lax = 1;
data_rad = deg2rad(data);

for j = 1:length(data_rad)
    j
    x = data_rad(j,1);
    y = data_rad(j,2);
    z = data_rad(j,3);
    R1 = [cos(x)*cos(y) (cos(x)*sin(y)*sin(z)-sin(x)*cos(z)) (cos(x)*sin(y)*cos(z)+sin(x)*sin(z));sin(x)*cos(y) (sin(x)*sin(y)*sin(z)+cos(x)*cos(z)) (sin(x)*sin(y)*cos(z)-cos(x)*sin(z));-sin(y) cos(y)*sin(z) cos(y)*cos(z)];
    R2 = [cos(x)*cos(y) (cos(x)*sin(y)*sin(z)-sin(x)*cos(z)) (cos(x)*sin(y)*cos(z)+sin(x)*sin(z));sin(x)*cos(y) (sin(x)*sin(y)*sin(z)+cos(x)*cos(z)) (sin(x)*sin(y)*cos(z)-cos(x)*sin(z));-sin(y) cos(y)*sin(z) cos(y)*cos(z)];
    R12 = R1'*R2;
    plot3([0 lax],[0 0],[0 0],'r-')
    hold on
    plot3([0 0],[0 lax],[0 0],'g-')
    plot3([0 0],[0 0],[0 lax],'b-')
    px = [lax;0;0];
    py = [0;lax;0];
    pz = [0;0;lax];
    npx = R1*px;
    npy = R1*py;
    npz = R1*pz;
    plot3([0 npx(1)],[0 npx(2)],[0 npx(3)],'r-')
    plot3([0 npy(1)],[0 npy(2)],[0 npy(3)],'g-')
    plot3([0 npz(1)],[0 npz(2)],[0 npz(3)],'b-')
    axis equal
    axis([-2 2 -2 2 -2 2])
    pause(0.01);
    hold off
end

