clear 

%Conect to the server
igtlConnection = igtlConnect('127.0.0.1',18944);
numberOfTransformsToReceive = 500;
uselessInitialData = 50;

% middle, index, thumb

fingerToRecord = "thumb";

name_test_day = date;

folder = 5;

% if folder == 1
%   [status, msg, msgID] = mkdir('data\',name_test_day)
%     if msg == "Directory already exists."
%         return
%     end    
% end

[status, msg, msgID] = mkdir(['data\' name_test_day '\'],num2str(folder))
if msg == "Directory already exists."
    return
end

path = ['data\' name_test_day '\' num2str(folder)];

a = arduino();

flex = zeros(1,2);
flex1 = zeros(1,2);
flex2 = zeros(1,2);

middle = zeros(1,4);
index = zeros(1,4);
thumb = zeros(1,4);


md = 1;
in = 1;
th = 1;
it = 1;
j = 1;

transformIndex = 1;
startTime = -1;
tic();

while transformIndex < numberOfTransformsToReceive+uselessInitialData
    transform  = igtlReceiveTransform(igtlConnection);
    if toc() > 0.02
    if ~isempty(transform.matrix)
        if startTime<0
            startTime=transform.timestamp;
            relativeTime=0;
        else
            relativeTime = transform.timestamp-startTime;
        end
        transformation = [relativeTime, transform.matrix(1,4) transform.matrix(2,4) transform.matrix(3,4)];
        if fingerToRecord == "middle"
            if transform.name == "MiddleToWrist"
                disp("OK middle")
                flex(md,:) = [relativeTime readVoltage(a,'A0')];
                position(md,:) = transformation;
                md = md + 1;
            else
                disp("Move middle")
            end
        elseif fingerToRecord == "index"
            if transform.name == "IndexToWrist"
                disp("OK index")
                flex(in,:) = [relativeTime readVoltage(a,'A1')];
                position(in,:) = transformation;
                in = in + 1;
            else
                disp("Move index")
            end
        elseif fingerToRecord == "thumb"
            if transform.name == "ThumbToWrist"
                disp("OK thumb")
                flex1(th,:) = [relativeTime readVoltage(a,'A1')];
                flex2(th,:) = [relativeTime readVoltage(a,'A2')];
                position(th,:) = transformation;
                th = th + 1;
            else
                disp("Move thumb")
            end
        end
        transformIndex = transformIndex + 1;
        disp(transformIndex)
    else 
        disp(['Move ' char(fingerToRecord)])
    end
    tic();
    end
end
        
clear a;

flex = flex(uselessInitialData:end,:);
flex1 = flex1(uselessInitialData:end,:);
flex2 = flex2(uselessInitialData:end,:);
position = position(uselessInitialData:end,:);



%% plot
close all

figure
subplot(2,1,1);
plot(position(:,1),normalize(position(:,2),'range'),'.-')
hold on
plot(position(:,1),normalize(position(:,3),'range'),'.-')
plot(position(:,1),normalize(position(:,4),'range'),'.-')

if fingerToRecord == "thumb"
    subplot(2,1,2);
    plot(flex1(:,1),normalize(flex1(:,2),'range'),'*-')
    hold on
    plot(flex2(:,1),normalize(flex2(:,2),'range'),'*-')
    
else
    subplot(2,1,2);
    plot(flex(:,1),normalize(flex(:,2),'range'),'*-')
end

figure
subplot(2,1,1);
plot(position(:,1),position(:,2))
hold on
plot(position(:,1),position(:,3))
plot(position(:,1),position(:,4))

if fingerToRecord == "thumb"
subplot(2,1,2);
plot(flex1(:,1),flex1(:,2))
hold on
plot(flex2(:,1),flex2(:,2))
else
subplot(2,1,2);
plot(flex(:,1),flex(:,2))
end

figure
plot3(position(:,2),position(:,3),position(:,4),'*')
%axis([0 100 0 100 0 100])
axis equal

%% Saving data for training and testing 

l = length(position);
pt = 80; %percentage for training
lt = fix(l*pt/100);

if fingerToRecord == "thumb"
    input1 = flex1(1:lt,:);
    input2 = flex2(1:lt,:);
    output = position(1:lt,:);
    name = [path '\train_' char(fingerToRecord)];
    save(name,'input1','input2','output')

    input1 = flex1(lt+1:end,:);
    input2 = flex2(lt+1:end,:);
    output = position(lt+1:end,:); 
    name = [path '\test_' char(fingerToRecord)];
    save(name,'input1','input2','output')
else
    input = flex(1:lt,:);
    output = position(1:lt,:);
    name = [path '\train_' char(fingerToRecord)];
    save(name,'input','output')

    input = flex(lt+1:end,:);  
    output = position(lt+1:end,:); 
    name = [path '\test_' char(fingerToRecord)];
    save(name,'input','output')
end 
