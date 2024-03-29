# Statistiques des personnages

Les personnages des joueurs sont définis en termes de jeu par une série
de statistiques qui représentent leurs capacités, leurs forces et leurs
faiblesses.

## Caractéristiques

Ce sont les forces et les faiblesses mentales comme physiques du
personnage. Il y a six caractéristiques : la Force (FOR), l’Intelligence
(INT), la Sagesse (SAG), la Dextérité (DEX), la Constitution (CON) et le
Charisme (CHA). Un personnage a un score dans chaque caractéristique
compris entre 3 (le plus mauvais score possible) et 18 (le meilleur).

## Classe

Il s’agit de la profession d’un aventurier. La classe d’un personnage
définit ses capacités principales. Voir [Classes](Classes/README.md).

## Race

À moins que la classe choisie soit semi-humaine, le personnage est
supposé être un humain.

## Niveau

L’expérience d’un personnage dans sa carrière d’aventurier est mesurée
par son niveau d’expérience. Il commence normalement au premier niveau
(le plus bas pour un aventurier) et progresse à mesure qu’il rencontre
le succès. En atteignant des niveaux plus élevés, le personnage gagne
des capacités toujours plus puissantes, définies par sa classe.

## Points d’expérience (XP)

La progression d’un personnage est mesurée par la capitalisation de
points d’expérience. Ceux-ci sont attribués par l’arbitre à la fin d’une
aventure réussie. Quand un personnage a obtenu suffisamment de points
d’expérience, son niveau augmente. Chaque classe précise le nombre de
points d’expérience requis pour atteindre chaque niveau.

## Caractéristique(s) principale(s)

La ou les caractéristiques les plus importantes pour une classe de
personnage donnée. Le score d’un personnage dans cette ou ces
caractéristique(s) peut affecter la vitesse à laquelle il gagne ses
points d’expérience.

## Alignment

Comme toute autre créature du monde de jeu, un personnage est aligné
avec un des trois principes cosmiques que sont la Loi, la Neutralité et
le Chaos (voir [Alignement](Alignement.md)). Certaines formes
de magie affectent les personnages de manière différente selon leur
alignement. Celui-ci sert aussi de base pour l’interprétation d’un
personnage par le joueur qui l’incarne.

## Points de vie (pv)

La capacité d’un personnage à rester en vie. Il dispose d’un total
maximum de points de vie et d’un total actuel de points de vie, qui sont
notés séparément. Quand un personnage est blessé, son total actuel de
points de vie baisse d’un certain nombre de points (les dégâts). Si ce
chiffre atteint 0, le personnage meurt \! Les points de vie perdus sont
récupérés à travers le repos ou la magie (voir 
[Dégâts et guérison](../Aventure/Tests_dommages_et_sauvegardes.md#dégâts-et-guérison)), 
mais le total actuel ne peut jamais dépasser le total maximum. Ce
dernier n’augmente que quand le personnage gagne un niveau d’expérience.

## Dés de vie (DV)

Le nombre de dés lancés pour déterminer le total maximum de points de
vie d’un personnage. Le type de dés lancés (d4, d6 ou d8) dépend de la
classe du personnage et leur nombre de son niveau. Certaines classes, à
la place ou en plus d’un nouveau dé de vie, offrent des bonus aux points
de vie à certains niveaux.

## Classe d’armure (CA)

La capacité d’un personnage à éviter les dégâts en combat. La Classe
d’armure dépend du score de Dextérité du personnage et du type
d’armure qu’il porte. Plus le score de CA est bas, mieux le personnage
est protégé des coups. Quand les règles mentionnent un bonus à la CA, il
s’agit d’un chiffre que l’on doit soustraire. De même, les malus à la CA
sont additionnés.

## Jet d’attaque « Toucher une Armure de Classe de 0 » (TAC0)

La capacité d’un personnage à blesser ses adversaires en combat, en
fonction de sa classe et de son niveau (NdT : l’abréviation vient de
l’anglais To Hit Armour Class 0). Plus le TAC0 est faible, meilleure
est l’attaque. Pour plus de détails sur les jets d’attaque, voir
[Combat](../Aventure/Combat.md).

## Scores de sauvegarde

La capacité d’un personnage à éviter ou à se protéger de certains effets
dangereux. Le jeu comporte cinq catégories de jets de sauvegarde : mort
(ou poison), baguettes, paralysie (ou pétrification), souffles, sorts
(ou sceptres et bâtons). Les scores de sauvegarde d’un personnage sont
déterminés par sa classe et son niveau. Pour plus de détails, voir
[Jets de sauvegarde](../Aventure/Tests_dommages_et_sauvegardes.md#jets-de-sauvegarde).

## Déplacement

Le déplacement, ou vitesse de déplacement, représente la distance
couverte par le personnage qui se déplace pendant qu’il explore, voyage
ou se bat. Cette valeur est exprimée en mètres. Chaque personnage a un
déplacement de base et un déplacement de rencontre (noté entre
parenthèses). Le déplacement de rencontre est égal au tiers du
déplacement de base. Le déplacement par défaut des personnages est de
36 m (12 m).

## Capacités de classe

Enfin, la classe du personnage détermine les capacités spéciales qu’il a
à sa disposition, y compris les armes qu’il peut utiliser, les armures
qu’il peut porter et les langues qu’il parle.

## Classe d’armure ascendante (règle optionnelle)

Certains groupes de jeu sont habitués à considérer qu’une Classe
d’armure meilleure est mieux représentée par un chiffre plus élevé. Ce
système, appelé Classe d’armure Ascendante (CAA), fonctionne comme suit
:

  - **Classe d’armure :** Les scores de CAA plus élevés sont meilleurs.
    Les bonus à la Classe d’armure s’ajoutent à la CAA, et les malus
    sont soustraits.

  - **Jets d’attaque :** Avec la CAA, plutôt que les matrices d’attaque
    (voir 
    [Matrice de valeurs d’attaque par le TAC0](../Aventure/Tableaux_de_combat.md)),
    la procédure pour résoudre
    une attaque utilise un bonus d’attaque ajouté au d20 (voir
    [Combat](../Aventure/Combat.md) ).

  - **Score de CAA :** La CA d’un monstre et d'une armure est suivie de
    la CAA équivalente \[entre crochets\].

  - **Bonus d’attaque :** Le TAC0 des monstres et des classes est suivi
    du bonus d’attaque équivalent \[entre crochets\].

**Remarque :** L’utilisation de la Classe d’armure Ascendante entraîne
des probabilités d’attaque très légèrement différentes à celles de
l’approche traditionnelle.
