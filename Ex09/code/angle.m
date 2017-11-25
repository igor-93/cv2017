% calculates angles from point x to y
function a = angle(x,y)
x = y-x;
a = atan2(x(2),x(1));
if a < 0
    a = 2*pi + a;
end