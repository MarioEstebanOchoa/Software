function result = offset_imu(matrix)
    result = matrix;
    x = mean(matrix);
    y = median(x);
    [m,n] =size(matrix);
    for i=1:n
        if x(i) < (y-270)
            result(:,i) = matrix(:,i) +360;
        end
        if x(i) > (y+270)
            result(:,i) = matrix(:,i) -360;
        end
    end
end
