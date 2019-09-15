
%Conect to the server
igtlConnection = igtlConnect('127.0.0.1',18944);

numberOfTransformsToReceive=1000;
lax = 10;

for transformIndex=1:numberOfTransformsToReceive
    transform  = igtlReceiveTransform(igtlConnection);
    transform.name
    if ~isempty(transform.matrix)
        if transform.name == "ReferenceToTracker"
            %T_PR = transform.matrix;
        elseif transform.name == "ToolToTracker"
            %T_PT = transform.matrix;
        elseif transform.name == "ToolToReference"
            T_RT =transform.matrix;
            transformIndex
            plot3([0 lax],[0 0],[0 0],'r-')
            hold on
            plot3([0 0],[0 lax],[0 0],'g-')
            plot3([0 0],[0 0],[0 lax],'b-')
            px = [lax;0;0;1];
            py = [0;lax;0;1];
            pz = [0;0;lax;1];
            npx = T_RT*px;
            npy = T_RT*py;
            npz = T_RT*pz;
            plot3([T_RT(1,4) npx(1)],[T_RT(2,4) npx(2)],[T_RT(3,4) npx(3)],'r-')
            plot3([T_RT(1,4) npy(1)],[T_RT(2,4) npy(2)],[T_RT(3,4) npy(3)],'g-')
            plot3([T_RT(1,4) npz(1)],[T_RT(2,4) npz(2)],[T_RT(3,4) npz(3)],'b-')
            axis equal
            %axis([-100 100 -100 100 -100 100])
            pause(0.01);
            hold off
        end
    end
end


    



