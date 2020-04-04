function [Sortie] = actodeg(aceleration_xy,aceleration_z)

if(aceleration_xy>=0 & aceleration_z>=0)
    Sortie=aceleration_xy*90;
elseif (aceleration_xy>=0 & aceleration_z<=0)
    Sortie=90+(90-90*aceleration_xy);
elseif (aceleration_xy<=0 & aceleration_z<=0)
    Sortie=180-(90*aceleration_xy);
else
    Sortie=270+(90+90*aceleration_xy);
end
