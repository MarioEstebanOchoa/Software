load('1flexionMiddle.mat');

filtered = gh_filter(flex_m(:,2), flex_m(1,2), 0.5, 0.2, 0.5, 0.05);

plot(flex_m(:,1),flex_m(:,2));
hold on
plot(flex_m(:,1),filtered);


function result = gh_filter(data, x0, dx, g, h, dt)
x_est = x0;
result = zeros(length(data),1);
    for i = 1:length(data)
        %prediction step
        x_pred = x_est + (dx*dt);
        %dx = dx;

        %Update step
        residual = data(i) - x_pred;
        dx = dx + h * (residual)/dt;
        x_est = x_pred + g*residual;
        result(i) = x_est;
    end
end

