%Conect to the server
igtlConnection = igtlConnect('127.0.0.1',18944);
numberOfTransformsToReceive=2000;
 
a = arduino();

flex_m = zeros(1,2);
flex_in = zeros(1,2);
flex_th = zeros(1,2);

middle = zeros(1,4);
index = zeros(1,4);
thumb = zeros(1,4);
names = zeros(5,1);


md = 1;
in = 1;
th = 1;
it = 1;
j = 1;

transformIndex = 1;
startTime = -1;
tic();

while transformIndex < numberOfTransformsToReceive
    transform  = igtlReceiveTransform(igtlConnection);
    if toc() > 0.05 
    % ES CUANDO MAS DEMORA POR EL TIMEOUT     
        for i=1:5
            transform  = igtlReceiveTransform(igtlConnection);    
            if ~isempty(transform.matrix)
                if startTime<0
                    startTime=transform.timestamp;
                    relativeTime=0;
                else
                    relativeTime = transform.timestamp-startTime;
                end
                %disp(transform.name)
                if transform.name == "MiddleToWrist"
                    names(i) = 1;
                    flex_m(md,:) = [relativeTime readVoltage(a,'A0')];
                    middle(md,:) = [relativeTime, transform.matrix(1,4) transform.matrix(2,4) transform.matrix(3,4)];
                    md = md + 1;
                elseif transform.name == "IndexToWrist"
                    names(i) = 2;
                    flex_in(in,:) = [relativeTime readVoltage(a,'A1')];
                    index(in,:) = [relativeTime, transform.matrix(1,4) transform.matrix(2,4) transform.matrix(3,4)];
                    in = in + 1;
                elseif transform.name == "ThumbToWrist"
                    names(i) = 3;
                    flex_th(th,:) = [relativeTime readVoltage(a,'A2')];
                    thumb(th,:) = [relativeTime, transform.matrix(1,4) transform.matrix(2,4) transform.matrix(3,4)];
                    th = th + 1;
                end
%                 if startTime>0
%                     flex_m(j,:) = [relativeTime readVoltage(a,'A0')];
%                     flex_in(j,:) = [relativeTime readVoltage(a,'A1')];
%                     flex_th(j,:) = [relativeTime readVoltage(a,'A2')];
%                     j = j+1;
%                 end
                transformIndex = transformIndex + 1; 
            end
        end
        disp(transformIndex)
%         if any(names == 1)
%             disp("Trans middle")
%         end
%         if any(names == 2)
%             disp("Trans index")
%         end
%         if any(names == 3)
%             disp("Trans thumb")
%         end
        if (any(names==1) )%&& any(names==2) && any(names==3))
            disp("OK")
        else
            disp("move")
        end
        %disp(names)
        names = zeros(5,1);
        tic();  
    end
end
clear a;

%% intersection

% int_mi = intersect(middle(:,1),index(:,1));
% [m, n] = size(int_mi);
% mid_ind = zeros(m,7);
% 
% for i = 1:size(int_mi)
%     mid_pt = find(middle(:,1)==int_mi(i));
%     ind_pt = find(index(:,1)==int_mi(i));
%     mid_ind(i,1) = int_mi(i);
%     mid_ind(i,2:4) = middle(mid_pt,2:4);
%     mid_ind(i,5:7) = index(ind_pt,2:4);
% end

int_it = intersect(index(:,1),thumb(:,1));
[m, n] = size(int_it);
index_thumb = zeros(m,7);

for i = 1:size(int_it)
    ind_pt = find(index(:,1)==int_it(i),1,'last');
    th_pt = find(thumb(:,1)==int_it(i),1,'last');
    index_thumb(i,1) = int_it(i);
    index_thumb(i,2:4) = index(ind_pt,2:4);
    index_thumb(i,5:7) = thumb(th_pt,2:4);
end

%% plot
close all

figure(1)
subplot(2,1,1);
plot(middle(:,1),normalize(middle(:,2),'range'),'.-')
hold on
plot(middle(:,1),normalize(middle(:,3),'range'),'.-')
plot(middle(:,1),normalize(middle(:,4),'range'),'.-')

subplot(2,1,2);
plot(flex_m(:,1),normalize(flex_m(:,2),'range'),'*-')

% figure(1)
% subplot(2,1,1);
% plot(middle(:,1),middle(:,2))
% hold on
% plot(middle(:,1),middle(:,3))
% plot(middle(:,1),middle(:,4))
% 
% subplot(2,1,2);
% plot(flex_m(:,1),flex_m(:,2))


figure(2)
subplot(2,1,1)
plot(index(:,1),normalize(index(:,2),'range'),'.-')
hold on
plot(index(:,1),normalize(index(:,3),'range'),'.-')
plot(index(:,1),normalize(index(:,4),'range'),'.-')
subplot(2,1,2);
plot(flex_in(:,1),normalize(flex_in(:,2),'range'),'*-')

figure(3)
subplot(2,1,1)
plot(thumb(:,1),normalize(thumb(:,2),'range'),'.-')
hold on
plot(thumb(:,1),normalize(thumb(:,3),'range'),'.-')
plot(thumb(:,1),normalize(thumb(:,4),'range'),'.-')
subplot(2,1,2);
plot(flex_in(:,1),normalize(flex_in(:,2),'range'),'*-')
hold on
plot(flex_th(:,1),normalize(flex_th(:,2),'range'),'*-')

