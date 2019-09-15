function result = offset(input)

mn = min(input);
result(:,1) = input(:,1) - mn(1);
result(:,2) = input(:,2) - mn(2);
result(:,3) = input(:,3) - mn(3);

end