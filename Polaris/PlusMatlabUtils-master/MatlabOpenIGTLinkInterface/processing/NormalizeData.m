name_test_day = '01-Aug-2019';
folder = 1
p_plot = true
test_day_path = ['data\' name_test_day];



path = [test_day_path '\' num2str(folder) '\train_index.mat'];

load(path);

input(:,2) = input(:,2)*100/5;  % map 0-5 Volts to 0-100

timestamp = output(:,1);
input_filt = SimpleKalmanFilter(input(:,2), input(1,2), 1, 1, 2);
output_x_filt = SimpleKalmanFilter(output(:,2), output(1,2), 1, 1, 2);
output_y_filt = SimpleKalmanFilter(output(:,3), output(1,3), 1, 1, 2);
output_z_filt = SimpleKalmanFilter(output(:,4), output(1,4), 1, 1, 2);

if p_plot
    figure
    plot(timestamp,output(:,2))
    hold on
    plot(timestamp,output(:,3))
    plot(timestamp,output(:,4))
    title('RAW POLARIS DATA')
    legend({'x position','y position','z position'},'Location','northeast');
    xlabel('[sec]')
    ylabel('[mm]')
    grid on

    figure
    plot3(output(:,2),output(:,3),output(:,4),'*')
    title('3D raw position Polaris Sensor')
    xlabel('x position [mm]')
    ylabel('y position [mm]')
    zlabel('z position [mm]')
    axis equal
    %axis([0 50 75 150 0 70])
    grid on

    figure
    subplot(4,1,1)
    plot(timestamp,input(:,2));
    hold on
    plot(timestamp,input_filt);
    title('DATA FILTERING')
    legend({'measured','filtered'},'Location','northeast');
    xlabel('flex sensor')

    subplot(4,1,2)
    plot(timestamp,output(:,2))
    hold on
    plot(timestamp,output_x_filt)
    legend({'measured','filtered'},'Location','northeast');
    xlabel('x position')
    ylabel('position [mm]')

    subplot(4,1,3)
    plot(timestamp,output(:,3))
    hold on
    plot(timestamp,output_y_filt)
    legend({'measured','filtered'},'Location','northeast');
    xlabel('y position')
    ylabel('position [mm]')

    subplot(4,1,4)
    plot(timestamp,output(:,4))
    hold on
    plot(timestamp,output_z_filt)
    legend({'measured','filtered'},'Location','northeast');
    xlabel('z position')
    ylabel('position [mm]')
end


output_filt = [output_x_filt output_y_filt output_z_filt];
output_filt = offset(output_filt);
output_x_filt = output_filt(:,1);
output_y_filt = output_filt(:,2);
output_z_filt = output_filt(:,3);

if p_plot
    
    figure
    subplot(4,1,1)
    plot(timestamp,input_filt);
    title('FILTERED AND NORMALIZED DATA')
    xlabel('flex sensor')
    subplot(4,1,2)
    plot(timestamp,output_x_filt)
    xlabel('X position')
    subplot(4,1,3)
    plot(timestamp,output_y_filt)
    xlabel('Y position')
    subplot(4,1,4)
    plot(timestamp,output_z_filt)
    xlabel('Z position')

    figure
    plot3(output_x_filt,output_y_filt,output_z_filt,'*')
    title('FILTERED AND NORMALIZED 3D RAW POSITION POLARIS SENSOR')
    xlabel('x position [mm]')
    ylabel('y position [mm]')
    zlabel('z position [mm]')
    axis equal
    grid on
    
end
