cosineS = 1/3;
x=[-1:0.00001:2];
for n=1:1:3
cosineS = cosineS + 4/(n^2)/(pi^2)*((-1)^n) * cos(n*pi*x);
error1 = abs(cosineS - (x.^2));
end
plot(x,cosineS);
grid on
hold on
error1max = max(error1);
cosineS = 1/3;
for n=1:1:30
cosineS = cosineS + 4/(n^2)/(pi^2)*((-1)^n) * cos(n*pi*x);
error2 = abs(cosineS - (x.^2));
end
plot(x,cosineS,'k--');
error2max = max(error2);
cosineS = 1/3;
for n=1:1:300
cosineS = cosineS + 4/(n^2)/(pi^2)*((-1)^n) * cos(n*pi*x);
error3 = abs(cosineS - (x.^2));
end
plot(x,cosineS,'r','LineWidth',1.5);
hold on
error3max = max(error3);
x=[-1:0.001:1]
y=x.^2
plot(x,y,'g')
hold on
x=[1:0.001:2]
y=(x-2).^2
plot(x,y,'g')
legend({'N=3','N=30','N=300','even extension'})