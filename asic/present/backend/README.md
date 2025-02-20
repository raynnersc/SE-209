# Environnement pour le backend (après placement routage)

Tâche a effectuer dans l'ordre suivant:

- import du layout via le fichier .def généré par Innovus (`make defin`)
- import du schéma via le fichier .v généré par Innovus (`make verilog2oa`)
- verification du layout (`make drc`)
- comparaison du layout avec le shéma (`make lvs`)
- extraction d'une netlist `spice` avec éléments parasites (`make ext`)

Le résultat est une netlist spice située dans le répertoire results.

# Commentaires

- Il suffit d'exécuter `make ext` pour enchâiner les différentes étapes à l'exception du DRC
- L'extraction de la netlist utilise des paramêtres par défaut qu'il conviendrait de pouvoir modifier (conditions d'extraction,...)
- Dans la netlist extraite, l'alimentation est un signal global idéal (pas de modélisation du réseau d'alimentation)


# A faire

- l'outil d'extraction semble capable d'extraire le réseau d'alimentation de façon séparée de la netlist par un bon choix d'option. On doit donc 
pouvoir le faire. Reste encore à savoir comment l'exploiter, c'est a dire bâtir une simulation qui fait intervenir les deux éléments (la netlist, et la grille d'alimentation)


# Questions en suspend

- VDD et GND doivent ils être des signaux globaux ou non ? Par défaut, ils sont globaux, du coups l'extraction des parasite ne génère pas de "mesh" pour les alimentations.

# Refaire une extraction avec des paramètres différents

Le fichier de commandes d'extraction créé autoatiquement se trouve dans "work/batch_LVS" et se nomme `batch_QRC.ccl`. 

On peut tester différents valeurs de paramètres d'extraction de la façon suivante

On peut relancer l'extraction "à la main" :
- modifier le fichier `batch_QRC.ccl`
- se placer dans le répertoire work
- lancer `qrc -cmd  batch_LVS/batch_QRC.ccl`

Pour trouver les paramêtres possibles, soit lire la doc, soit utiliser la version interavtive de l'outil

- dans virtuoso (`make gui`), sélectionner `Assura/Run open RUN`, et choisire le répertoire "batch_LVS"
- puis choisir `Run Quantus QRC` , choisir des paramètres (ne pas lancer le run)
- puis choisir 'View Command File" pour examiner la syntaxe correspondant à ces paramêtres
- Corriger le fichier `batch_QRC.ccl` en s'inspirant des résultats visualisés...
