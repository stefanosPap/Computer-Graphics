figure(1)
hold on
for i =1:3
plot([V(1,1) V(2,1)] ,[V(1,2) V(2,2)]);
plot([V(2,1) V(3,1)] ,[V(2,2) V(3,2)]);
plot([V(3,1) V(1,1)] ,[V(3,2) V(1,2)]);
end