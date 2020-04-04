%==========================================================================
% E. Boutillon
% 06/01/2017
% 
% Méthode d'encodage des codes polaires selon document R1_167209
% Paramètres d'entrée:
% M : taille du code
% K : taille du message
%
% u : message à coder de taille K.
% c : message codé de taille M.
%
% Output:
% P : set of punctured position (taille N-M)
% F : set of frozen position (taille M-K)
% FuP : Union of P and F (taille N -K)
%==========================================================================
function [m,b, Q] = encode1(K, M, u)

% La première chose est de déterminer la taille du code mère.
n = ceil(log2(M));
N = 2^n;
% On calcul l'ordre des bits par fiabilité.

for j = 1:n
    Coeff(j) = 2^((n-j)/4); %D
end;

for i = 1:N
    ind = i - 1;
    x = dec2bin(ind, n)-48;%ascii
    score(i) = sum( x .* Coeff);
end;

[dummy Q] = sort(score, 'ascend');

Q = Q - 1;   % Les index, en matlab, sont toujours décalé à +1.


% Génération des Frozen bits.
FuP = Q(1:(M-K));
Pos = setdiff( (1:N), 1+FuP);


b = zeros(1,N);
b(Pos) = u

H = [1];
for i = 1:n
    H = kron( H, [1 1; 1 0]);
end;

m = mod(b*H,2);  %Encodage






    










   

