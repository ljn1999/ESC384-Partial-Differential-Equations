fplot(@(x) 2/3*(x-1/x),[1 2],'b')
hold on
fplot(@(x) 1/1024*(x^10-x^(-10)), [1 2], 'r')
legend('m=1', 'm=10')
xlabel('r')
ylabel('u')