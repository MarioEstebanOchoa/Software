
%Conect to the server
igtlConnection = igtlConnect('127.0.0.1',18944);

numberOfTransformsToReceive=1000;
lax = 10;

T_TW = zeros(3,1);
T_MW = zeros(3,1);
T_IW = zeros(3,1);

thumb = animatedline('LineWidth',0.5,'Color','g','Marker','o');
index = animatedline('LineWidth',0.5,'Color','b','Marker','o');
middle = animatedline('LineWidth',0.5, 'Color','r','Marker','o');
%animatedline(x,y,'Color','r','LineWidth',3);

%set(gca, 'XLim', [0 150],'YLim', [-50 120],'ZLim', [-50 100]);
%set(gca, 'XLim', [-140 0],'YLim', [-100 50],'ZLim', [-120 0]);
%set(gca, 'XLim', [-1000 1500],'YLim', [-1000 1200],'ZLim', [-1000 1000]);


view(147,46);
for transformIndex=1:numberOfTransformsToReceive
    transform  = igtlReceiveTransform(igtlConnection);
    transform.name
    if ~isempty(transform.matrix)
        if transform.name == "ThumbToWrist"
            %clearpoints(thumb);
            addpoints(thumb, transform.matrix(1,4), transform.matrix(2,4), transform.matrix(3,4));
        end
        if transform.name == "MiddleToWrist"
            addpoints(middle, transform.matrix(1,4), transform.matrix(2,4), transform.matrix(3,4));
        end
        if transform.name == "IndexToWrist"
            addpoints(index, transform.matrix(1,4), transform.matrix(2,4), transform.matrix(3,4));
        end
        drawnow limitrate;
    end
end

axis equal
axis ([0 150 0 150 -100 150])
    



