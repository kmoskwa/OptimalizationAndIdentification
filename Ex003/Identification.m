close all; clear all; clc;


% https://www.mathworks.com/help/curvefit/least-squares-fitting.html
% https://www.mathworks.com/matlabcentral/fileexchange/34765-polyfitn
% modelterms and function definitions
% 1. z=c1.*(x)    + c2.*(y)   + c3
mt1 = 'x y constant';
f1 = '@ (a, b) (c(1).*a + c(2).*b + c(3))';
%2. z=c1.*(x)    + c2.*(y)   + c3.*(x).*(y) + c(4)
mt2 = 'x y x*y constant';
f2 = '@ (a, b) (c(1).*a + c(2).*b + c(3).*a.*b + c(4))';
% 3. z=c1.*(x.^2)  + c2.*(x)   + c3.*(y)     + c(4)
mt3 = 'x^2 x y constant';
f3 = '@ (a, b) (c(1).*a.^2 + c(2).*a + c(3).*b + c(4))';
% 4. z=c1.*(x)    + c2.*(y.^2) + c3.*(y)     + c(4)
mt4 = 'x y^2 y constant';
f4 = '@ (a, b) (c(1).*a + c(2).*b.^2 + c(3).*b + c(4))';
% 5. z=c1.*(x.^2)  + c2.*(y.^2) + c3
mt5 = 'x^2 y^2 constant';
f5 = '@ (a, b) (c(1).*a.^2 + c(2).*b.^2 + c(3))';
% 6. z=c1.*(x.^2)  + c2.*(y.^2) + c3.*(x).*(y) + c(4)
mt6 = 'x^2 y^2 x*y constant';
f6 = '@ (a, b) (c(1).*a.^2 + c(2).*b.^2 + c(3).*a.*b + c(4))';
% 7. z=c1.*(x.^2)  + c2.*(x)   + c3.*(y.^2)   + c(4).*(y)   + c(5)
mt7 = 'x^2 x y^2 y constant';
f7 = '@ (a, b) (c(1).*a.^2 + c(2).*a + c(3).*b.^2 + c(4).*b + c(5))';
% 8. z=c1.*(x.^2)  + c2.*(x)   + c3.*(y.^2)   + c(4).*(y)   + c(5).*(x).*(y)     + c(6)
mt8 = 'x^2 x y^2 y x*y constant';
f8 = '@ (a, b) (c(1).*a.^2 + c(2).*a + c(3).*b.^2 + c(4).*b + c(5).*a.*b + c(6))';
% 9. z=c1.*(x.^3)  + c2.*(x.^2) + c3.*(x)     + c(4).*(y)   + c(5)
mt9 = 'x^3 x^2 x y constant';
f9 = '@ (a, b) (c(1).*a.^3 + c(2).*a.^2 + c(3).*a + c(4).*b + c(5))';
% 10. z=c1.*(x)   + c2.*(y.^3) + c3.*(y.^2)   + c(4).*(y)   + c(5)
mt10 = 'x y^3 y^2 y constant';
f10 = '@ (a, b) (c(1).*a + c(2).*b.^3 + c(3).*b.^2 + c(4).*b + c(5))';
% 11. z=c1.*(x.^3) + c2.*(x.^2) + c3.*(x)     + c(4).*(y.^2) + c(5).*(y)         + c(6)
mt11 = 'x^3 x^2 x y^2 y constant';
f11 = '@ (a, b) (c(1).*a.^3 + c(2).*a.^2 + c(3).*a + c(4).*b.^2 + c(5).*b + c(6))';
% 12. z=c1.*(x.^3) + c2.*(x.^2) + c3.*(x)     + c(4).*(y.^3) + c(5).*(y.^2)       + c(6).*(y)     + c(7)
mt12 = 'x^3 x^2 x y^3 y^2 y constant';
f12 = '@ (a, b) (c(1).*a.^3 + c(2).*a.^2 + c(3).*a + c(4).*b.^3 + c(5).*b.^2 + c(6).*b + c(7))';
% 13. z=c1.*(x.^3) + c2.*(x.^2) + c3.*(y.^3)   + c(4).*(y.^2) + c(5)
mt13 = 'x^3 x^2 y^3 y^2 constant';
f13 = '@ (a, b) (c(1).*a.^3 + c(2).*a.^2 + c(3).*b.^3 + c(4).*b.^2 + c(5))';
% 14. z=c1.*(x.^3) + c2.*(x.^2) + c3.*(y.^3)   + c(4).*(y.^2) + c(5).*(x).*(y)     + c(6)
mt14 = 'x^3 x^2 y^3 y^2 x*y constant';
f14 = '@ (a, b) (c(1).*a.^3 + c(2).*a.^2 + c(3).*b.^3 + c(4).*b.^2 + c(5).*a.*b + c(6))';
% 15. z=c1.*(x.^3) + c2.*(x.^2) + c3.*(y.^3)   + c(4).*(y.^2) + c(5).*(x.^2).*(y.^2) + c(6)
mt15 = 'x^3 x^2 y^3 y^2 x^2*y^2 constant';
f15 = '@ (a, b) (c(1).*a.^3 + c(2).*a.^2 + c(3).*b.^3 + c(4).*b.^2 + c(5).*a.^2.*b.^2 + c(6))';
% 16. z=c1.*(x.^3) + c2.*(x.^2) + c3.*(y.^3)   + c(4).*(y.^2) + c(5).*(x.^2).*(y.^2) + c(6).*(x).*(y) + c(7)
mt16 = 'x^3 x^2 y^3 y^2 x^2*y^2 x*y constant';
f16 = '@ (a, b) (c(1).*a.^3 + c(2).*a.^2 + c(3).*b.^3 + c(4).*b.^2 + c(5).*a.^2.*b.^2 + c(6).*a.*b + c(7))';

fa = {f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13};
%fa = {f16};
mta = {mt1, mt2, mt3, mt4, mt5, mt6, mt7, mt8, mt9, mt10, mt11, mt12, mt13, mt14, mt15, mt16};


y = 0.01 : 0.01 : 0.06;
x =    1 : 2 : 11;
z001 = [ 0.816   0.667   0.646   0.642   0.641   0.643 ];
z002 = [ 0.821   0.678   0.662   0.663   0.668   0.677 ];
z003 = [ 0.826   0.689   0.680   0.686   0.696   0.710 ];
z004 = [ 0.832   0.699   0.696   0.707   0.721   0.744 ];
z005 = [ 0.836   0.710   0.712   0.729   0.750   0.776 ];
z006 = [ 0.842   0.720   0.727   0.750   0.778   0.811 ];
z = [ z001;   z002;   z003;   z004;   z005;   z006  ];

S = size(z);
[X, Y] = meshgrid(x,y);
xp = reshape(X, 1, []);
yp = reshape(Y, 1, []);
zp = reshape(z, 1, []);
xpp = xp';
ypp = yp';
zpp = zp';
d  = length(xp);

figure;
title('Press any key for next model');
for i = 1:length(fa);
    sf = polyfitn([xpp, ypp],zpp, mta{i}); 
    c = sf.Coefficients;
    f = eval(fa{i});

    xx=1:0.5:11;
    yy=0.01:0.002:0.06;
    [XX, YY] = meshgrid(xx, yy);
    w = f(XX, YY);
    while (0 == waitforbuttonpress)
    end;
    clc;
    disp(sf);
    clf;
    plot3(X, Y, z, 'xb');
    hold on;
    for k = 1:S(1); % iterate z001 to z006
        plot3(x, Y(k, :), z(k, :));
    end
    %surf(X, Y, z); 
    mesh(XX, YY, w);
    grid on;
    t = ['(', num2str(i), ')  ', fa{i}];
    t = strrep(t, '@ (a, b)', 'z =');
    t = strrep(t, '.*', '·');
    t = strrep(t, 'a', 'x');
    t = strrep(t, 'b', 'y');
    t = strrep(t, '.^', '^');
    t = strrep(t, '^2', '²');
    t = strrep(t, '^3', '³');
    title(t);
end
