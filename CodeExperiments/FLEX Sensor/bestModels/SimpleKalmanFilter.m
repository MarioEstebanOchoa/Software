function result = SimpleKalmanFilter(data, last_estimate, mea_e, est_e, q)
    
result = zeros(length(data),1);
  
    for i=1:length(data)
        kalman_gain = est_e/(est_e + mea_e);
        current_estimate = last_estimate + kalman_gain * (data(i) - last_estimate);
        est_e = (1 - kalman_gain)*est_e + abs(last_estimate - current_estimate)*q;
        last_estimate = current_estimate;
        result(i) = current_estimate; 
    end

end