## 1. Nom du projet
Simulation de système immunitaire

## 2. Description
Ce projet est une simulation en NetLogo qui modélise les interactions entre des virus, des cellules immunitaires et des cellules d'information dans un environnement donné. Le modèle est conçu pour illustrer les mécanismes de défense immunitaire, la reproduction des virus, et l’activation de la mémoire immunitaire à travers un processus d’identification et d’élimination des virus. Les cellules d'information jouent un rôle crucial dans la détection des virus et dans l'amélioration de la production des cellules immunitaires.

## 3. Prérequis
NetLogo : Vous devez installer NetLogo pour exécuter ce modèle. Téléchargez-le à partir du site officiel ici.
Le fichier base4.png est utilisé pour définir les propriétés des patches. Assurez-vous que ce fichier est présent dans le même dossier que le code NetLogo.

## 4. Installation
Installez NetLogo depuis le lien ci-dessus.
Clonez ou téléchargez le dépôt contenant ce projet.
Ouvrez NetLogo et chargez le fichier du modèle .nlogo depuis l'interface.

## 5. Instructions d'utilisation
Initialiser la simulation : Cliquez sur le bouton init-simulation pour initialiser l'environnement avec les virus, les cellules immunitaires et les cellules d'information. L'environnement de base est défini par un fichier d'image base4.png.

Lancer la simulation : Appuyez sur le bouton go pour démarrer la simulation. Les agents (virus, cellules immunitaires et cellules d'information) commenceront à interagir selon les règles définies dans le code.

Paramètres personnalisables :

nb-virus : Nombre initial de virus dans la simulation.\
nb-imun_cells : Nombre initial de cellules immunitaires.\
nb-info_cells : Nombre initial de cellules d'information.\
taux_reproduction_virus : Taux de reproduction des virus dans les zones reproductibles.\
life_immun_cells : Durée de vie des cellules immunitaires.\
starting_prod_imun_cell : Production initiale des cellules immunitaires dans la zone mémoire.\

Déplacement des virus et des cellules : Les virus et les cellules immunitaires se déplacent de manière aléatoire. Les cellules immunitaires tuent les virus lorsqu’elles entrent en contact avec eux.
Transmission de l'information : Les cellules d'information détectent les virus et transmettent cette information aux zones de production des cellules immunitaires, activant ainsi la mémoire immunitaire.
Reproduction des agents : Les virus et les cellules immunitaires se reproduisent selon des règles spécifiques.

## 6. Fonctionnalités principales
Déplacement des agents : Chaque agent (virus, cellule immunitaire, cellule d'information) a un comportement de déplacement défini. Les cellules immunitaires cherchent les virus pour les éliminer, tandis que les cellules d'information cherchent des virus pour informer la mémoire immunitaire.\
Production de cellules immunitaires : Les patches dans certaines zones de l’environnement produisent des cellules immunitaires. Cette production peut être augmentée lorsqu’une cellule d’information informe la mémoire du système.\
Reproduction des virus : Les virus se reproduisent dans des patches spécifiques qui leur permettent de se multiplier.\
Mécanisme de mémoire : La simulation inclut un concept de mémoire immunitaire, où la production des cellules immunitaires est boostée lorsque les cellules d’information rapportent la présence de virus.

## 7. Contexte théorique
Ce modèle simule le système immunitaire d’un organisme en représentant l’interaction entre les virus, les cellules immunitaires et les cellules d'information. L’objectif est de montrer comment les cellules immunitaires peuvent se reproduire en réponse à des agents pathogènes et comment le système de mémoire immunitaire est activé pour améliorer la réponse au fil du temps.

## 9. Références
Documentation NetLogo : https://ccl.northwestern.edu/netlogo/docs/
