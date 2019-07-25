
%Conect to the server
igtlConnection = igtlConnect('127.0.0.1',18944);

numberOfTransformsToReceive=1000;
lax = 10;

T_TW = zeros(3,1);
T_MW = zeros(3,1);
T_IW = zeros(3,1);
p = plot3(0,0,0,'g*');
%m = plot3(0,0,0,'r*');
%i = plot3(0,0,0,'b*');
for transformIndex=1:numberOfTransformsToReceive
    transform  = igtlReceiveTransform(igtlConnection);
    transform.name;
    if ~isempty(transform.matrix)
        if transform.name == "ThumbToWrist"
            p.XData = transform.matrix(1,4);
            p.YData = transform.matrix(2,4);
            p.ZData = transform.matrix(3,4);
            %T_TW(1) = transform.matrix(1,4);
            %T_TW(2) = transform.matrix(2,4);
            %T_TW(3) = transform.matrix(3,4);
        end
        if transform.name == "MiddleToWrist"
            %m.XData = transform.matrix(1,4);
            %m.YData = transform.matrix(2,4);
            %m.ZData = transform.matrix(3,4);
            %T_MW = transform.matrix(1,4);
        end
        if transform.name == "IndexToWrist"
            %i.XData = transform.matrix(1,4);
            %i.YData = transform.matrix(2,4);
            %i.ZData = transform.matrix(3,4);
            %T_IW =transform.matrix(1,4);
        end
            transformIndex
            %plot3(T_IW(1,4),T_IW(2,4),T_IW(3,4),'r*');
            %hold on
            %plot3(T_TW(1),T_TW(2),T_TW(3),'g*');
            %plot3(T_MW(1,4),T_MW(2,4),T_MW(3,4),'b*');
            axis equal
            axis([0 150 -50 120 -50 100]);
            drawnow limitrate;
            %pause(0.01);
            %hold off
    end
end


    



