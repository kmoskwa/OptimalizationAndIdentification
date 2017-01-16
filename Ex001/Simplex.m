clc
close all
clear all

func = @(x) 4*x(1)^3+x(2)^2+10;
%func = @(x) x(1) + x(2);
singleSteps = true;
data.func = @(x) x(1) + x(2);c = 10;
%data.func = @(x,y) sin(x) + cos(y);
%data.func = @(x, y) 4*x^3 + y^2 + 10;
data.spaceXFrom   = -6;
data.spaceXTo     =  6;
data.spaceYFrom   =  data.spaceXFrom;
data.spaceYTo     =  data.spaceXTo;
data.spaceZFrom   = -1000;
data.spaceZTo     =  1000;
data.resolution   =  100;
data.contourLines =  120;

data.spaceX = linspace(data.spaceXFrom, data.spaceXTo, data.resolution);
data.spaceY = linspace(data.spaceYFrom, data.spaceYTo, data.resolution);
data.spaceZ = linspace(data.spaceZFrom, data.spaceZTo, data.resolution);

%calculate function values
for i = 1:data.resolution
    for j = 1:data.resolution
        data.value(j, i) = feval(func,[data.spaceX(i), data.spaceY(j)]);
    end
end

[x1, x2] = meshgrid(data.spaceX, data.spaceY);
z = data.func([x1, x2]);

figure
%contour(x, y, z, data.contourLines)
%contour(data.spaceX, data.spaceY, data.value, data.contourLines)
contour(data.spaceX, data.spaceY, data.value, data.spaceZ);
%surf(x1, x1, data.value);


diverted = 0;
converged = 0;

%while (~diverted && ~converged)
    
%    draw(data);
%end
