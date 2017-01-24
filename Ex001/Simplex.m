function main

clc
close all
clear all

func1 = @(x) x(1)^2 + x(2)^2;
func2 = @(x) exp(x(1))*(4*x(1)^2 + 2*x(2)^2 + 4*x(1)*x(2) + 2 * x(1) + 1);
func3 = @(x) 100 * (x(2) - x(1)^2)^2 + (1-x(1))^2;
func4 = @(x) sin(x(1)) + cos(x(2));
func = func1;
startPoint = [5, 5];
step = [2.2, 2.2];
pauses = 0;
degree = 2
reqMin = 1.0E-20;
convGe = 1.0E-01;
countLimit = 1000;

drawFunc(func, 100, 120, -8, 8, -8, 8, -10000, 10000);
hold;

[xMin, vNewLo, iterations] = simplex (func, degree, startPoint, reqMin, step, convGe, countLimit, pauses);
%pause;
disp('Finished');
disp(['iterations: ', num2str(iterations)]);
disp(['xMin: ', num2str(xMin), ' = ', num2str(vNewLo)]);
return;

    function drawFunc(func, resolution, contourLines, minX, maxX, minY, maxY, minZ, maxZ)
        spaceX = linspace(minX, maxX, resolution);
        spaceY = linspace(minY, maxY, resolution);
        minval = 0;
        maxval = 0;
        for i = 1:resolution
            for j = 1:resolution
                val = feval(func,[spaceX(i), spaceY(j)]);
                minval = min(val, minval);
                maxval = max(val, maxval);
                value(j, i) = val;
            end
        end
        minZ   = minval * 2;
        maxZ   = maxval * 2;
        spaceZ = linspace(minZ, maxZ, resolution);
        
        figure;
        contour(spaceX, spaceY, value, spaceZ);
    end

    function checkPause(isPauseEnabled)
        if (isPauseEnabled == 1)
            pause;
        end
    end

    function drawSimplex(simplex, color, pauses, text)
        title(text);
        plot(simplex(1, [1 2]), simplex(2, [1 2]), color);
        plot(simplex(1, [2 3]), simplex(2, [2 3]), color);
        plot(simplex(1, [3 1]), simplex(2, [3 1]), color);
        checkPause(pauses);
        drawnow;
    end

    function displayCurrent(xBar, pointNo, point, value, type)
        disp([type, '  - pointNo : ', num2str(pointNo), ', centroid(xBar) : ', num2str(xBar), ', point : ', num2str(point), ', value : ', num2str(value)]); 
    end


    function [xMin, vNewLo, iterations] = simplex (func, degree, start, reqMin, step, convGe, countLimit, pauses)
        %requisitions
        % reqmin >= 0.0
        % degree > 1
        % konvge > 1
        xMin = [];
        vNewLo = [];
        iterations = 0;
        
        alpha = 1.0;
        beta = 0.5;
        gamma = 2.0;
        eps = 0.001;
        
        jcount = convGe;
        degreeN = degree;
        degreePlus1 = degree + 1;
        degreNN = degreePlus1;
        delta = 1.0;
        reqMinCoef = reqMin * degreeN;
        %
        %  Initial or restarted loop.
        %
        %%while 1
        for i = 1:degree
            simplex(i, degreePlus1) = start(i);
        end
        
        funcVal(degreePlus1) = func(start);
        iterations = iterations + 1;
        %Construct first simplex from provided point
        for j = 1 : degree
            x = start(j);
            start(j) = start(j) + step(j) * delta;
            for i = 1 : degree
                simplex(i,j) = start(i);
            end
            funcVal(j) = func(start);
            iterations = iterations + 1;
            start(j) = x;
        end
        drawSimplex(simplex, 'k', pauses, 'Init');
        %  Find highest and lowest Y values.  vNewLo = value(iHi) indicates
        %  the vertex of the simplex to be replaced.
        vLo = funcVal(1);
        iLo = 1;
        %find lowest value
        for i = 2:degreePlus1
            if ( funcVal(i) < vLo )
                vLo = funcVal(i);
                iLo = i;
            end
        end
        %  Main loop.
        while 1
            % In case of exceeding number of maximum counts - break procedure
            if ( countLimit <= iterations )
                break
            end
            %find lowest value
            vNewLo = funcVal(1);
            iHi = 1;
            
            for i = 2:degreePlus1
                if (vNewLo < funcVal(i))
                    vNewLo = funcVal(i);
                    iHi = i;
                end
            end
            %  Calculate xBar, the centroid of the simplex vertices
            %  excepting the vertex with Y value YNEWLO.
            for i = 1:degree
                value = 0.0;
                for j = 1:degreePlus1
                    value = value + simplex(i, j);
                end
                value = value - simplex(i, iHi);
                xBar(i) = value / degreeN;
            end
            
            %  Reflection through the centroid.
            for i = 1:degree
                xRefl(i) = xBar(i) + alpha * (xBar(i) - simplex(i, iHi));
            end
            vRefl = func(xRefl);
            iterations = iterations + 1;
            %  Successful reflection, so extension.
            if ( vRefl < vLo )
                for i = 1:degree
                    xExt(i) = xBar(i) + gamma * (xRefl(i) - xBar(i));
                end
                vExt = func (xExt);
                iterations = iterations + 1;
                %  Check extension.
                if (vRefl < vExt)
                    for i = 1:degree
                        simplex(i, iHi) = xRefl(i);
                    end
                    funcVal(iHi) = vRefl;
                    drawSimplex(simplex, 'r', pauses, 'Reflection');
                    displayCurrent(xBar, iLo, xRefl, vRefl, 'Reflection');
                    %  Retain extension or contraction.
                else % (vRefl < vExt)
                    for i = 1:degree
                        simplex(i,iHi) = xExt(i);
                    end
                    funcVal(iHi) = vExt;
                    drawSimplex(simplex, 'm', pauses, 'Extension');
                    displayCurrent(xBar, iLo, xExt, vExt, 'Extension');
                end
                %  No extension.
            else
                test = 0;
                for i = 1:degreePlus1
                    if (vRefl < funcVal(i))
                        test = test + 1;
                    end
                end
                if (1 < test)
                    for i = 1:degree
                        simplex(i,iHi) = xRefl(i);
                    end
                    funcVal(iHi) = vRefl;
                    drawSimplex(simplex, 'r', pauses, 'Reflection');
                    displayCurrent(xBar, iLo, xRefl, vRefl, 'Reflection');
                    %  Contraction on the vak(iHi) side of the centroid.
                elseif (test == 0)
                    for i = 1 : degree
                        xExt(i) = xBar(i) + beta * (simplex(i, iHi) - xBar(i));
                    end
                    vExt = func(xExt);
                    iterations = iterations + 1;
                    %  Contract the whole simplex.
                    if ( funcVal(iHi) < vExt )
                        for j = 1:degreePlus1
                            for i = 1:degree
                                simplex(i, j) = (simplex(i, j) + simplex(i, iLo)) * 0.5;
                                xMin(i) = simplex(i, j);
                            end
                            funcVal(j) = func(xMin);
                            iterations = iterations + 1;
                            drawSimplex(simplex, 'b', pauses, 'Contraction');
                            displayCurrent(xBar, iLo, xExt, vExt, 'Contraction');
                        end
                        vLo = funcVal(1);
                        iLo = 1;
                        for i = 2 : degreePlus1
                            if (funcVal(i) < vLo)
                                vLo = funcVal(i);
                                iLo = i;
                            end
                        end
                        continue
                        %  Retain contraction.
                    else % if ( y(ihi) < vExt )
                        for i = 1:degree
                            simplex(i, iHi) = xExt(i);
                        end
                        funcVal(iHi) = vExt;
                        drawSimplex(simplex, 'g', pauses, 'Extension');
                        displayCurrent(xBar, iLo, xExt, vExt, 'Extension');
                    end
                    %  Contraction on the reflection side of the centroid.
                elseif (test == 1)
                    for i = 1:degree
                        xExt(i) = xBar(i) + beta * (xRefl(i) - xBar(i));
                    end
                    vExt = func(xExt);
                    iterations = iterations + 1;
                    %  Retain reflection?
                    if (vExt <= vRefl)
                        for i = 1:degree
                            simplex(i,iHi) = xExt(i);
                        end
                        funcVal(iHi) = vExt;
                        drawSimplex(simplex, 'g', pauses, 'Extension');
                        displayCurrent(xBar, iLo, xExt, vExt, 'Extension');
                    else
                        for i = 1:degree
                            simplex(i,iHi) = xRefl(i);
                        end
                        funcVal(iHi) = vRefl;
                        drawSimplex(simplex, 'r', pauses, 'Reflection');
                        displayCurrent(xBar, iLo, xRefl, vRefl, 'Extension');
                    end
                end
            end
            %  Check if YLO improved.
            if ( funcVal(iHi) < vLo )
                vLo = funcVal(iHi);
                iLo = iHi;
            end
            jcount = jcount - 1;
            if ( 0 < jcount )
                continue
            end
            %  Check to see if minimum reached.
            if ( iterations <= countLimit )
                jcount = convGe;
                value = 0.0;
                for i = 1:degreePlus1
                    value = value + funcVal(i);
                end
                x = value / degreNN;
                value = 0.0;
                for i = 1:degreePlus1
                    value = value + (funcVal(i) - x)^2;
                end
                if ( value <= reqMinCoef )
                    break
                end
            end
        end
        for i = 1:degree
            xMin(i) = simplex(i,iLo);
        end
        return
    end

end

