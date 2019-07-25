clear
close all
load('3flexionMiddle.mat')

flex_m(:,2) = flex_m(:,2)*100/5;

radius = 10;
coeff = ones(1, radius)/radius;

filtered = filter(coeff, 1, flex_m(20:end,2));

plot(middle(20:end,1),middle(20:end,2),'.')
hold on
plot(flex_m(20:end,1),filtered,'.')


order = 2;
framelen = 21;


sgf = sgolayfilt(flex_m(20:end,2),order,framelen);


sgf1 = sgolayfilt(middle(20:end,2),order,framelen);
plot(flex_m(20:end,1),sgf1,'.')

figure(2)
plot(sgf,sgf1,'*')