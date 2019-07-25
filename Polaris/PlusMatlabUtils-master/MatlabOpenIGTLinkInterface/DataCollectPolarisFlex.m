%Conect to the server
igtlConnection = igtlConnect('127.0.0.1',18944);
numberOfTransformsToReceive=400;
 
a = arduino();

flex_m = zeros(1,2);
names = zeros(5,1);
trans = zeros(4,4,5);
middle = zeros(1,4);
index = zeros(1,4);
thumb = zeros(1,4);
index_thumb = zeros(1,8);

times = zeros(5,1);
dates = zeros(1,2);
md = 1;
in = 1;
th = 1;
it = 1;

fopen('middle.txt','w');            %to clear the file
fopen('index.txt','w');            %to clear the file
fopen('thumb.txt','w');            %to clear the file
fopen('index_thumb.txt','w');            %to clear the file

startTime = -1;


transform  = igtlReceiveTransform(igtlConnection);

while isempty(transform.matrix)
  disp('waiting...')  
  transform  = igtlReceiveTransform(igtlConnection);
end
startTime=transform.timestamp;
relativeTime=0;
tic();

for transformIndex=1:numberOfTransformsToReceive
    for i = 1:5
        transform  = igtlReceiveTransform(igtlConnection);
        if ~isempty(transform.matrix)
            dates(transformIndex,:) = [posixtime(datetime('now')) transform.timestamp];
            if startTime<0
                startTime=transform.timestamp;
                relativeTime=0;
            else
                relativeTime=transform.timestamp-startTime;
            end 
            trans(:,:,i) = transform.matrix;
            times(i) = relativeTime;
            if transform.name == "MiddleToWrist"
                names(i) = 1;
            elseif transform.name == "IndexToWrist"
                names(i) = 2;
            elseif transform.name == "ThumbToWrist"
                names(i) = 3;
            end
        else
            %names = zeros(5,1);
            %trans = zeros(4,4,5);
            %times = zeros(5,1);
            break
        end
    end
    if any(names == 1)
        disp("Trans middle")
        f = find(names == 1,1,'last');
        middle(md,:) = [times(f), trans(1,4,f) trans(2,4,f) trans(3,4,f)];
        flex_m(md,:) = [toc() readVoltage(a,'A0')];
        md = md+1;
    end
    if any(names == 2)
        disp("Trans index")
        f = find(names == 2,1,'last');
        index(in,:) = [times(f), trans(1,4,f) trans(2,4,f) trans(3,4,f)];
        in = in+1;
    end
    if any(names == 3)
        disp("Trans thumb")
        f = find(names == 3,1,'last');
        thumb(th,:) = [times(f), trans(1,4,f) trans(2,4,f) trans(3,4,f)];
        th = th+1;
    end
    if any(names == 2) && any(names == 3)
        disp("Trans indexThumb")
        f = find(names == 2,1,'last');
        g = find(names == 3,1,'last');
        index_thumb(it,:) = [times(f), trans(1,4,f) trans(2,4,f) trans(3,4,f) times(g), trans(1,4,g) trans(2,4,g) trans(3,4,g)];
        it = it+1;
    end
    
    names = zeros(5,1);
    trans = zeros(4,4,5);
    times = zeros(5,1);
    transformIndex
end
elapsedTime = toc();

%% plot
close all
plot(flex_m(:,1),normalize(flex_m(:,2),'range'),'-')
hold on
plot(middle(:,1),normalize(middle(:,2),'range'),'-')
plot(middle(:,1),normalize(middle(:,3),'range'),'-')
plot(middle(:,1),normalize(middle(:,4),'range'),'-')

clear a