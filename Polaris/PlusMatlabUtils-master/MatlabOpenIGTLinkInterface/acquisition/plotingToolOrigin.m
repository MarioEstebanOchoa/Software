
%Conect to the server
igtlConnection = igtlConnect('127.0.0.1',18944);

numberOfTransformsToReceive=1000;

% hold on
% plot3([0 1],[0 0],[0 0],'r-')
% plot3([0 0],[0 1],[0 0],'g-')
% plot3([0 0],[0 0],[0 1],'b-')
% 
% px = [1;0;0;1]
% py = [0;1;0;1]
% pz = [0;0;1;1]
lax = 50;

for transformIndex=1:numberOfTransformsToReceive
    
    transform  = igtlReceiveTransform(igtlConnection);
    if ~isempty(transform.matrix)
%         disp(['------------ ',transform.name,' ----------']);
        %disp(transform.matrix);
        T = transform.matrix;
        if transform.name == "ReferenceToTracker"
%             disp("REF")
%             diff = matrix(:,4);
%             disp(diff);
        end
        if transform.name == "ToolToTracker"
%             disp("TOOL")
            %T = matrix;
            %plot3([0 1],[0 0],[0 0],'r-')
            
            %plot3([0 0],[0 1],[0 0],'g-')
            %plot3([0 0],[0 0],[0 1],'b-')
            transformIndex
            px = [lax;0;0;1];
            py = [0;lax;0;1];
            pz = [0;0;lax;1];
            npx = T*px;
            npy = T*py;
            npz = T*pz;
            plot3([T(1,4) npx(1)],[T(2,4) npx(2)],[T(3,4) npx(3)],'r-')
            hold on
            plot3([T(1,4) npy(1)],[T(2,4) npy(2)],[T(3,4) npy(3)],'g-')
            plot3([T(1,4) npz(1)],[T(2,4) npz(2)],[T(3,4) npz(3)],'b-')
            axis equal
%             toolpos = matrix(:,4);
%             disp(toolpos);
            %plot3(toolpos(1,1)-diff(1,1),toolpos(2,1)-diff(2,1),toolpos(3,1)-diff(3,1),'o');
            pause(0.01);
            az = 135;
            el = 60;
            view(az, el);
            %axis([-400 300 -200 500 -1600 -900])
            hold off
        end
    end
end


    



