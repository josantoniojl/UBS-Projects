# Base OS
## Mini projet : Home Automation Box

Le but de ce space sera d’expliquer tous les démarches pour créer une distribution linux pour la machine cible
“humingoboard HB2 Gate 1.4”. Ainsi que la détection de l’humidité et la temperature de l’environnement en utilisant
le capteur “Adafruit Si70212”.

L’outil principal utilisé dans l’élaboration du projet a éte l’outil “Yocto Project”. Puisqu’il est “open source” et permet
aux développeurs de créer des systèmes personnalisés basés sur Linux quelle que soit l’architecture matérielle. La
distribution utilisée du Yocto project a été “Poky” car elle contient le système de construction OpenEmbedded (BitBake
et OpenEmbedded Core) ainsi qu’un ensemble de “metadata”, ce qui nous permet de faire notre propre distribution.
La fonction principale qui a été utilisé de la distrbution “Poky” a été BitBake puisqu’il est le cœur du système de
compilation OpenEmbedded et il est responsable de l’analyse des “metadata”, pour générer une liste de tâches qui
seront exécutés.
