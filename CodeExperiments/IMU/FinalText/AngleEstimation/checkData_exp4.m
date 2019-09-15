load('defineHidden_exp4.mat')
middle = performance_f(performance_f(:,1)==1,:);
index = performance_f(performance_f(:,1)==2,:);
thumb = performance_f(performance_f(:,1)==3,:);

middle_x = middle(:,2);
middle_y = middle(:,3);
middle_z = middle(:,4);

index_x = index(:,2);
index_y = index(:,3);
index_z = index(:,4);

thumb_x = thumb(:,2);
thumb_y = thumb(:,3);
thumb_z = thumb(:,4);

%cftool


[M,I] = min(middle(:,4));
middle(I,:)

[M,I] = min(index(:,4));
index(I,:)

[M,I] = min(thumb(:,4));
thumb(I,:)

