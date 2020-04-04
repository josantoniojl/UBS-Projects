function [Sortie] = actodeg_z(aceleration_z,aceleration_xy)

if(aceleration_xy>=0 & aceleration_z>=0)
    Sortie=90-(aceleration_z*90);
elseif (aceleration_xy>=0 & aceleration_z<=0)
    Sortie=90-(90*aceleration_z);
elseif (aceleration_xy<=0 & aceleration_z<=0)
    Sortie=180+(90+90*aceleration_z);
else
    Sortie=270+(90*aceleration_z);
end
