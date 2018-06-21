tic;
for i=1:20
    i
    credibleInterval(parameters{1}(:,1),0.1);
end
a=toc;

tic;
for i=1:20
    i
    credibleInterval2(parameters{1}(:,1),0.1);
end
b=toc;