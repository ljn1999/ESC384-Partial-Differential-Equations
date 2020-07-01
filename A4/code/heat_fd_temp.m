function heat_fd_temp

% functions
gfun = @(x) 0.5*x.*(2-x) + 1/(6*pi)*sin(3*pi*x);
ffun = @(x,t) exp(-3*x).*exp(t);

% discretization parameters
n = 16;
J = 16;
T = 1;

% setup spatial and temporal grids
xx = linspace(0,1,n+1)';
tt = linspace(0,T,J+1)';
dx = 1/n;
dt = T/J;

% assemble the A matrix
% (not the most effcient method, but it will work)
A = sparse([],[],[],n,n);
for i = 1:n
    if (i == 1) 
        % left boundary
        A(i,i) = 2*n*n;
        A(i,i+1) = -1*n*n;
    elseif (i == n)
        % right boundary
        A(i,i-1) = -2*n*n;
        A(i,i) = 2*n*n+2*n;
    else
        % all other points
        A(i,i-1) = -1*n*n;
        A(i,i) = 2*n*n;
        A(i,i+1) = -1*n*n;
    end
end

% iteration
I = speye(n,n);

% assemble C and D matrices in terms of A, I, and dt
C = 1/2*A + 1/dt*I;
D = -1/2*A + 1/dt*I;

% initialize state
xxi = xx(2:end);  % x excluding the left node
U = gfun(xxi);

% record the initial state in UU; note the first node is left as 0
UU = zeros(n+1,J+1);
UU(2:end,1) = U; 
for j = 1:J    
    % evaluate F
    F = 1/2*ffun(xxi,tt(j+1)) + 1/2*ffun(xxi,tt(j)); % THIS LINE IS INCORRECT; FIX ME
    
    % solve linear system 
    % expression involves U, C, D, and F. Do NOT use "inv".
    U = C\(D*U + F);
    
    % record solution in UU
    UU(2:end,j+1) = U;
end

% find time indices to plot
tplot = [0,1/16,1/8,1/4,1/2,1]';
[~,it] = intersect(tt,tplot); %

% plot solution
figure(1), clf,
plot(xx,UU(:,it),'o-');
xlabel('x');
ylabel('u');
legend('t=0','t=1/16','t=1/8','t=1/4','t=1/2','t=1');

% evaluate output
s = UU(end,end);
size(UU)
size(ffun)
size(A)
end