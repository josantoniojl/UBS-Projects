==============
4.Conclusions
==============

La réalisation de ce projet peut être comparé au projet SESI, puisque le niveau d'effort a aussi été élevé. Si bien, la création de l'image et la recette n'a été pas difficile, tous les sujets autour le projet l’ont été. Surtout parce que c'était la première fois dans ma vie que j'ai utilisé Linux. Quelques exemples des difficultés rencontrées étaient quelques commandes pour configurer l'adresse IP de la machine cible et la machine hôte, la connexion SSH, l’envoie des documents via SSH, l’édition des documents en mode vi et monter des mémoires externes. 

Un autre exemple qui a également pris du temps a été la communication I2C et série sur la carte hummingboard, puisque je n'avais pas programmé ce type de communication dans un environnement Linux et en utilisant du code C. 

Le principal défi du développement du projet a été de sauvegarder l’image de notre distribution dans la mémoire emmc. Si bien la procédure n’était pas difficile, certains détails doivent être considérés comme la configuration des 'jumpers'. Parce que si la configuration n’est pas bien faite l’OS jamais va démarrer via l’emmc, après de nombreuses essayes j’ai trouvé la légende suivante pendant le démarrage : "la partition emmc ne pouvait pas être initialisée", ce message m’a permis de comprendre l’erreur possible et dans la documentation de la carte, j'ai trouvé la configuration de ‘Jumpers’ nécessaires pour démarrer le système comme nous souhaitons. Par conséquent, une conclusion est de toujours avoir les manuels et fiches techniques des systèmes, puisque la source d'information est fiable et parceque en général ils contiennent toutes les informations nécessaires pour développer nos projets.

Si bien j'ai reussi de stocker l'image dans l'emmc, je n'avais pas le temps d'effectuer la détection de température et d'humidité, comme je l'avais fait dans la micro SD. L'emmc était la dernière exigence que j'avais fait et je n'ai eu plus le temps de la perfectionner. Certaines améliorations peuvent être apportées dans le travail, par exemple la modification de la recette, afin de compiler l'application, installer et démarrer le service et d’attribuer une adresse IP a la machine cible. De cette façon, notre image pourrait être reproduite pour un grand nombre de cartes de développement.

Finalement, tous les défis trouvés m'ont aidé à comprendre le fonctionnement de l'outil Yocto Project. J'ai appris de nouvelles commandes, et surtout je peux vous assurer que mes compétences dans l'environnement Linux ont considérablement progressé. 
