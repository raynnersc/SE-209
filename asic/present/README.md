# Environnement pour le traitement du design Present_v0 

Pour faire un test simple des scripts, vous pouvez enchâiner les traitement suivants:

```sh
cd sim
make sim
cd ../syn
make syn
cd ../pr
make step1_init     
make step2_floorplan 
make step3_place    
make step4_cts      
make step5_route    
make step6_timing   
make step7_power    
make step8_export   
cd ../backend
make defin
make verilog2oa
make drc
make lvs
make ext
```

Les résultats de traitements, sont accessibles soit dans le sous répertoire ``results`` s'ils doivent être réutiliser pour des étapes ultérieures, soit directement dans le sous répertoire ``work``.

Enfin, les différents outils utilisés peuvent être lancés en mode interactif de façon à examiner les résultats.


# Documentations utilisables

- Utiliser l'outil `cdnshelp`
- Dans l'outil, sélectionner l'icone avec la flèche complétement à droite.
- Puis sélectionner l'icone avec la matrice de points...
- La liste des outils Cadence installés apparait.

Les outils utiles sont:
- XCELIUMMAIN20.03 pour la simulation logique et mixte
- SPECTRE19.10 pour la simulation électrique
- GENUS18.13 pour la synthèse
- INNOVUS17.13 pour le placement routage

- En ce qui concerne la simulation mixte, le document de référence est dans `XCELIUMMAIN20.03` :  `User Guide` : `Spectre AMS Designer ans Xcelium Simulator Mixed-Signal User Guide`
- En ce qui concerne le simulateur électrique, le document de référence est dans `SPECTRE19.10` : `User Guide` : `Spectre Classic Simulator, Spectre APS, Sprectre X, and Spectre XPS User guide`


## Quelques chiffres...

### Simulations électriques post backend
Il s'agit d'une simulation électrique d'une netlist obtenue par extraction Assura, à plat du layout final.

- Le design contient 14660 transistors
- 474557 capacités parasites, 59662 résistances parasites.
- Les grilles de masse et d'alimentation sont idéales
- Le temps de simulation (sur Kronos) est de 3h (multithread total cpu time 23 heures)

### Simulation électriques post placement routage
Il s'agit d'une simulation électrique d'une netlist Verilog obtenue depuis Innovus est  utilisant:
- des netlists "electriques" de chaque porte préextraites dans le design KIT
- un rétroannoatation des éléments parasites dus aux connections (fichier SPEF)
- Le design contient 14660 transistors
- 65498 capacités parasites,  75959 resistances parasite en provenance des netlists extraites des portes du design KIT 
- 9088 capacités parasites, 7872  résistances parasites en provenance du fichier SPEF
- Les grilles de masse et d'alimentation sont idéales
- Le temps de simulation ( sur Kronos) est de 51 minutes (multithread total cpu time  6 heures)

### Simulations électriques port synthèse
Il s'agit d'une simulation électrique d'une netlist Verilog obtenue depuis Genus est  utilisant:
- des netlists "electriques" de chaque porte préextraites dans le design KIT
- un rétroannoatation des éléments parasites estimées dus aux connections (fichier SPEF)
- Le design contient 14317 transistors (il n'y a pas l'abre d'horloge)
- 58625 capacités parasites, 70293 résistances parasites en provenance des netlists extraites des portes du design KIT
- 3476 capacités parasites, 3484 résistances parasites en provenance du fichier SPEF
- Les grilles de masse et d'alimentation sont idéales
- Le temps de simulation ( sur Kronos) est de 44 minutes (multithread 5h30 heures en réalité)


