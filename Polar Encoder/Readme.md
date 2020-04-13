# Projet VHDL
## Polar Encoder

Dans cet espace, il est possible de trouver le code, les spécifications techniques et un document explicatif pour le développement du projet mené en binôme avec Gaëtan Michaud. 

Dans le cadre de la 5G, les codes polaires ont été normalisés. Le but de ce projet est de réaliser un encodeur de code polaire sur une carte FPGA afin de garantir un débit en sortie de 250 Mbit/s.

Le principe de l’encodeur est très simple : on encode un message M de k bits sur un mot Y de n = 2^m  bits, avec n > k.

Ces codes sont les premiers codes pouvant atteindre, de façon prouvée, la capacité du canal pour les canaux sans mémoires symétriques. En plus, ces codes possèdent une faible complexité d'encodage et de décodage, soit de O(n log n). Ces particularités rendent donc les codes polaires très attrayants pour la recherche et les applications industrielles.
