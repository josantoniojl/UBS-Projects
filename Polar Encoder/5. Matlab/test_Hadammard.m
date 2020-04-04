clear
clc
M= [ 1 2 3 4 5 6 7 8]%  9  10 11 12 13 14 15 16];
[ta,tm]=size(M);
k = ceil(log2(tm));
i=0;

for l = 1:2:tm
    b(l)=M(l)+M(l+1);
    b(l+1)=M(l+1);
end;
ress=tm/4
for n=1:k-1
    if i<tm
    for ip=1:((tm/4))
%              for j=1:((2^n))
%              b(j+i)=b(j+i)+b(j+i+(2^n));
%             end;
%             b;
    i=i+2^(n+1)
    ip
    end
    end
    i=0;
end;

dd=0;
for n=1:k-1
    while dd<tm
    dd=dd+2^(n+1);
    end
    dd=0;
end;