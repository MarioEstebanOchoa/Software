function result = SimpleKalmanFilter(data, last_estimate, mea_e, est_e, q)
[m,n] = size(data);
result = zeros(m,n);
    for j = 1:n
        for i=1:m
            kalman_gain = est_e/(est_e + mea_e);
            current_estimate = last_estimate(j) + kalman_gain * (data(i,j) - last_estimate(j));
            est_e = (1 - kalman_gain)*est_e + abs(last_estimate(j) - current_estimate)*q;
            last_estimate(j) = current_estimate;
            result(i,j) = current_estimate; 
        end
    end
end