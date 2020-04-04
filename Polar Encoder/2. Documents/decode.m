%==========================================================================
% E. Boutillon
% 06/01/2017
% 
% M�thode de d�codage des codes polaires selon document R1_167209
% Param�tres d'entr�e:
% M : taille du code (M = N = 2^n dans version 1).
% K : taille du message
%
% x : message re�u de taille M (N = M dans la version 1).
% y : message d�cod� de taille M (N = M dans la version 1).
% F : set of frozen position (taille M-K)/
%
% Output:
% y : message d�cod�
% alpha : liste des LLR alpha
% beta  : liste des LLR beta
%==========================================================================
% Historique des versions
% Version 1.0 : (08/01/2016) on ne consid�re pas les bits "punctionn�".
%==========================================================================
function [alpha, beta] = decode(K, M, F, x)

% La premi�re chose est de d�terminer la taille du code m�re.
n = ceil(log2(M));
N = 2^n;
if (N ~= M) echo 'code ponctionn�'; end;
    
% On calcul l'ordre des bits par fiabilit�.
alpha = zeros(N, n+1); % Table des LLR � calculer r�cursivement.
beta  = - ones(N, n+1); % Table des LLR � calculer r�cursivement.

%On place les frozens bits dans le premier dernier layer des beta.
for i = 1:M-K
    beta(F(i)+1,1) = 0;
end;

% On initialise les LLR de la derni�re colonne. 
for i = 1:2^n
    alpha(i,n+1) = x(i);
end;

% On calcul des LLR pour le premier bit de sortie.

for l = n:-1:1  %l est le layer. 
   for i=1:2^(l-1)
        ind   =  2^(n+1-l)*(i-1);
        ind_d =  ind + 2^(n-l); %index down left fonction f.
        alpha(ind+1, l) = f(alpha(ind+1,l+1), alpha(ind_d+1, l+1));
   end;
end;


% On arrive maintenant dans le coeur du sujet, la boucle principale
% permettant de d�coder le code en effectuant l'algo SC des bits 1 � N-1.



for i = 1:N-1;
    
    % N0 = nb de 0 cons�cutif avant le premier 1, ind = nb en bit inverse
    [N0 N1 ind] = bit_reverse(i,n);
    if ind == 1
    a = 1
    end
    %boucle sur les fonctions g
    for k_g = 0:(2^N0-1);
        
        ind_k_g    = ind + 2^(n-N0)*k_g;
        ind_k_g_up = ind_k_g - 2^(n-1-N0);
        
        alpha(ind_k_g+1, N0+1) = g( beta (ind_k_g_up+1, N0+1), ...
                                    alpha(ind_k_g_up+1, N0+2), ...
                                    alpha(ind_k_g   +1, N0+2));
                             
    end;
    
    %boucle sur le nombre de fonction f � faire
    for N0_f = N0:-1:1
        for k_f = 0:(2^(N0_f-1)-1);
        
            ind_k_f    = ind + 2^(n+1-N0_f)*k_f;
            ind_k_f_up = ind_k_f + 2^(n-N0_f);
            alpha(ind_k_f+1, N0_f) = f(alpha(ind_k_f  +1, N0_f+1), ...
                                        alpha(ind_k_f_up+1, N0_f+1));                             
        end;

    end
    
    % D�cision sur le bit ind
    if beta( ind + 1, 1) == -1 %bit non gel�
        
        if alpha( ind + 1,1) > 0 
            beta( ind+1, 1) = 0;
        else
            beta( ind+1, 1) = 1;
        end;
    end;
        
    
    % R�sursion "backward" de mise � jours des d�cisions.
    for N1_b = 1:N1
        for k_b = 0:(2^(N1_b-1)-1);        
            ind_b    = ind   - 2^(n + 1 -N1_b)*k_b;
            ind_b_up = ind_b - 2^(n - N1_b);
            beta(ind_b + 1, N1_b + 1) = beta(ind_b + 1, N1_b); 
            beta(ind_b_up + 1, N1_b + 1) = ...
                mod( beta(ind_b + 1, N1_b)+ beta(ind_b_up + 1, N1_b),2); 
        end
    end
    
    
    
end




function c = f(a,b)

c = sign(a)*sign(b)*min( abs([a b]));

function c = g(beta,a,b)

c = a*(-1)^beta + b; 

function [N0 N1 ind] = bit_reverse(i,n)

u     = dec2bin(i,n);
u_inv = u(end:-1:1);
ind   = bin2dec(u_inv);
ii    = i;
N0 = 0;
while (mod(ii, 2) == 0)
    N0 = N0 + 1;
    ii = ii/2;
end;
N1 = 0;
ii    = i;
while (mod(ii, 2) == 1)
    N1 = N1 + 1;
    ii = (ii-1)/2;
end;





   

