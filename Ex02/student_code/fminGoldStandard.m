function f = fminGoldStandard(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

%compute squared geometric error
n = size(XYZ, 2);
f = 0;
for i = 1:n
    repr = P*XYZ(:,i);
    repr = repr ./ repr(end);
    f = f + norm(repr - xy(:,i))^2;
end

%compute cost function value

end