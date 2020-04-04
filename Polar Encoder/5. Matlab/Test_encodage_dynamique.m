%b=[ 0 0 0 0 0 0 0 1 0 0 0 1 1 1 0 0];
b= [0 0 0 1 0 1 0 1];
H = [1];
for i = 1:3
    H = kron( H, [1 1; 1 0]);
end;
m = mod(b*H,2)  %Encodage

% b=[0 0 0 1 1 1 0 0];

% H = [1];
% for i = 1:4
%     H = kron( H, [1 1; 1 0]);
% end;
% H
% m = mod(b*H,2)  %Encodage