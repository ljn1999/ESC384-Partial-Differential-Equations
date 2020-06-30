function ldrum

% number of grid spacings in each direction (i.e., 1/h)
ns1 = 32;

% number of grid points in each direction
n1 = ns1+1;

% generates 2d grid points
x1 = linspace(0,1,n1)';
[xm,ym] = ndgrid(x1,x1);

% concaternate grid points as single-index array
xx = [xm(:),ym(:)]; 

% grid spacing
h = 1/ns1;

% construct a matrix for the n1 x n1 grid
n2 = n1*n1;
A = sparse([],[],[],n2,n2);
for i = 2:n1-1 % interior nodes only
    for j = 2:n1-1% interior nodes only
        % fill the FD equation for node (i,j)
        
        % find single-index value of self and neighbors
        indc = i  + n1*(j-1);  % center node: (i,j)
        indl = i-1  + n1*(j-1);  % left node: (i-1,j)
        indr = i+1  + n1*(j-1);  % right node: (i+1,j)
        indb = i  + n1*(j-2);  % bottom node: (i,j-1)
        indt = i  + n1*j;  % top node: (i,j+1)
        
        % fill values
        A(indc,indc) = 4/h^2;     % center value
        A(indl,indc) = -1/h^2;    % left value
        A(indr,indc) = -1/h^2;    % right value
        A(indc,indb) = -1/h^2;    % bottom value
        A(indc,indt) = -1/h^2;    % top value
    end
end

% specify the domain shape
ldomain = false;

% we now find the interior nodes; these are the unknowns of the problem
if (ldomain)
    % identify interior nodes of L-shaped domain
    interior = find(((xx(:,1) > 0) & (xx(:,1) < 1) & (xx(:,2) > 0) & (xx(:,2) < 1)) ...
        & ((xx(:,1) > 1/2) | (xx(:,2) < 1/2)));
else
    % identify interior nodes of a square
    interior = find((xx(:,1) > 0) & (xx(:,1) < 1) & (xx(:,2) > 0) & (xx(:,2) < 1));
end

% extract the equations and unknowns associated with interior nodes
Aint = A(interior,interior);

% find the 10 smallest eigenvalues
neig = 10;
[V,D] = eigs(Aint,neig,'sm');

% display the sqrt of the neig eigenvalues
fprintf('%.8e\n',sqrt(diag(D)));

% eigenfunction to be plotted; change this to plot different eigenfunctions
ieig = 1;  

% plotting style
use_pretty_plot = false;

% plot the specified eigenfunctions
U = zeros(n2,1);
U(interior) = V(:,ieig);
figure(1), clf,
if (use_pretty_plot)
    pretty_plot(xm,ym,U);
else
    regular_plot(xm,ym,U);
end

end

function regular_plot(xm,ym,U)
% regular plotting
if (sum(U) < 0)
    U = -U;
end
surf(xm,ym,reshape(U,size(xm)));  hold on;
shading interp;
view(0,90);
axis equal;
axis off;
axis([0,1,0,1]);
% plot the border
if (sum(abs(U(xm < 1/2 & ym > 1/2))) < 0.1)
   plot([0,1,1,1/2,1/2,0,0],[0,0,1,1,1/2,1/2,0],'k-'); 
end
end

function pretty_plot(xm,ym,U)
% pretty plot for the L-shaped domain problem. 
xm = 50*xm;
ym = 50*ym;
if (sum(U) < 0)
    U = -U;
end
U = U/max(abs(U));
if (min(U) < -0.01)
    Ushift = -0.4;
else
    Ushift = 0;
end
U = 40*(1/(max(U)-min(U))*(U-min(U)+Ushift));


figh = figure(1);
clf;
h = surf(ym,xm,reshape(U,size(xm))');
axis off;
logoax = axes('CameraPosition', [-193.4013 -265.1546  220.4819],...
    'CameraTarget',[26 26 10], ...
    'CameraUpVector',[0 0 1], ...
    'CameraViewAngle',9.5, ...
    'DataAspectRatio', [1 1 .9],...
    'Position',[0 0 1 1], ...
    'Visible','off', ...
    'XLim',[1 51], ...
    'YLim',[1 51], ...
    'ZLim',[-13 40], ...
    'parent',figh);
s = set(h, ...
    'EdgeColor','none', ...
    'FaceColor',[0.9 0.2 0.2], ...
    'FaceLighting','phong', ...
    'AmbientStrength',0.3, ...
    'DiffuseStrength',0.6, ...
    'Clipping','off',...
    'BackFaceLighting','lit', ...
    'SpecularStrength',1, ...
    'SpecularColorReflectance',1, ...
    'SpecularExponent',7, ...
    'parent',logoax);
l1 = light('Position',[40 100 20], ...
    'Style','local', ...
    'Color',[0 0.8 0.8], ...
    'parent',logoax);
l2 = light('Position',[.5 -1 .4], ...
    'Color',[0.8 0.8 0], ...
    'parent',logoax);
%z = zoom(figh);
%z.setAxes3DPanAndZoomStyle(logoax,'camera');
end