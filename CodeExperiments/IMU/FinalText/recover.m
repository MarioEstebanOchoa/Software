function result = recover(matrix)
    result = matrix;
    x = median(matrix);
    [m,n] = size(matrix);
    for i=1:n
        ch = find(matrix(:,i)<(x(i)-300));
        for j=1:length(ch)  
            result(ch(j),i) = matrix(ch(j),i) + 360;
        end
        ch = find(matrix(:,i)>(x(i)+300));
        for j=1:length(ch)  
            result(ch(j),i) = matrix(ch(j),i) - 360;
        end
    end
end