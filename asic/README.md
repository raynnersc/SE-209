# Synthèse et Placement/Routage d'un bloc logique en utilisant la technologie de demo GPDK045

Ce projet est un exemple permettant de conduire de bout en bout le design d'un macro-bloc logique 
destiné à être intégré dans un système sur puce.

L'exemple choisi est un petit bloc de crypto executant l'algorithme `present`, dont on dispose des codes sources RTL, ainsi que d'un
module de test. Les étapes automatisées sont les suivantes:

- Simulation du code RTL via le module de test ([Present_v0/sim](Present_v0/sim))
- Synthèse en utilisant une bibliothèque de cellules standard de la technologie cible. ([Present_v0/syn](Present_v0/syn))
- Placement routage du macro bloc ([Present_v0/pr](Present_v0/pr))
- Verification du dessin final (DRC, LVS) ([Present_v0/backend]([Present_v0/backend))

Les différentes étapes sont décomposées en sous étapes, et il est possible de vérifier le block par simulation:
- Simulation après la sous-étape d'élaboratin de la synthèse ([Present_v0/sim_post_elaborate](Present_v0/sim_post_elaborate])
- Simulation après synthèse ([Present_v0/sim_post_elaborate](Present_v0/sim_post_syn])
- Simulation après placement/routage ([Present_v0/sim_post_elaborate](Present_v0/sim_post_pr])
- Simulation "électrique" après placement/routage ([Present_v0/sim_post_elaborate](Present_v0/sim_post_pr_elec])

Les Makefiles de chaque répertoire contiennent une aide. Il suffit d'exécuter make sans argument.


