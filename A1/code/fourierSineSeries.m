sinS = 0;
x=[-1:0.001:2];
for n=1:1:3
sinS = sinS+((-2)/n/pi*((-1)^n)+(4*((-1)^n)-4)/((n*pi)^3))*(sin(n*pi*x))
error1 = abs(sinS - (x.^2));
end
plot(x,sinS);
grid on
hold on
error1max = max(error1);
sinS = 0;
for n=1:1:30
sinS = sinS+((-2)/n/pi*((-1)^n)+(4*((-1)^n)-4)/((n*pi)^3))*(sin(n*pi*x))
error2 = abs(sinS - (x.^2));
end
plot(x,sinS,'k--');
error2max = max(error2);
sinS = 0;
for n=1:1:300
sinS = sinS+((-2)/n/pi*((-1)^n)+(4*((-1)^n)-4)/((n*pi)^3))*(sin(n*pi*x))
error3 = abs(sinS - (x.^2));
end
plot(x,sinS,'r','LineWidth',1.5);
error3max = max(error3);
hold on
x=[0:0.001:1]
y=x.^2
plot(x,y,'g')
hold on
x=[1:0.001:2]
y=-(x-2).^2
plot(x,y,'g')
hold on
x=[-1:0.001:0]
y=-x.^2
plot(x,y,'g')
legend({'N=3','N=30','N=300','odd extension'})