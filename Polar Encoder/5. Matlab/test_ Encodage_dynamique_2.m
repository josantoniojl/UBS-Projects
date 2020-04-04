clear
clc
M= [ 0 0 0 0 0 0 0 1 0 0 0 1 1 1 0 0 ];%  9  10 11 12 13 14 15 16];
[ta,tm]=size(M);
k = ceil(log2(tm));
i=0;
tm=tm+1;
% for l = 1:2:tm
%     tm-l
%     if(tm-l>0)
%     b(l)=M((tm-l))+M((tm-l)-1);
%     b(l+1)=M((tm-l)-1);
%     end;
% end;
%m = mod(b,2)  %Encodage
b= [0 0 0 1 1 0 0 0 1 0 0 0 0 0 0 0];
for n=1:k-1
    while i<tm
         for j=1:((2^n))
             b(j+i)=b(j+i)+ b(j+i+(2^n));
         end;
    sortie=mod(b,2)
    i=i+2^(n+1);
    end
    i=0;
end;



%Encodage
%  index5=j+i+(2^n);
%              index4=j+i;
%              index1=n;
%              index2=i;
%              index3=j;
%              indexm=[["n" index1] ["i" index2] ["j" index3] ["i+j" index4] ["j+i+(2^n)" index5]]
% 
