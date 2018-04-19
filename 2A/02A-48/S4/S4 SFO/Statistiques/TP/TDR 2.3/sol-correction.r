## 04/06/2014
## VP
##
## Exercice pour TDR2.3
## Analyse de sol
## Éléments de réalistion et commentaires

## Importation
sol <- read.table("dt sol2007.csv",header=TRUE, dec=",", sep=";")
head(sol)

## accéder aux colonnes
biom <- sol$biomm
trait <- sol$trait
hori <- sol$hori

##J'ai nommé mes facteurs et ma variable quantitative, mais lorsque je cherche la moyenne avec les effets des deux facteurs j'ai un problème:
tapply(biom, trait*hori,mean)
## Créons donc un facteur supplémentaire croisant hori et trait
fac <- paste(hori,trait)
fac
fac <- as.factor(fac) ## on en fait un facteur (variable quali)
fac

## Calcul des moyenne et écart-type par facteurs
tapply(biom,hori,mean)
tapply(biom,hori,sd)

tapply(biom,trait,mean)
tapply(biom,trait,sd)

tapply(biom,fac,mean)
tapply(biom,fac,sd)

## graphiques
boxplot(biom~hori) # On observe un effet surtout sur les moyennes
boxplot(biom~trait) # On observe un effet sur les variances : pas adapter à une Anova
boxplot(biom~hori*trait) # Tout est là


## test d'homoscédasticité
bartlett.test(biom~trait)
bartlett.test(biom~hori)
bartlett.test(biom~fac)
## dans tous les cas on rejete H0. On ne peut pas confirmer l'homoscédasticité.
# Toutefois, on va contin uer le test.


## test de normalité pour l'anova à deux facteurs
par(mfrow=c(2,2))
lm1 <-lm(biom~trait*hori)
plot(lm1) ## d'après le qqplot, la normalité des résidus est acceptable

##### anovaS
## Anova 1
anova(lm(biom~hori))
anova(lm(biom~trait))
# on observe un effet dans les deux cas. Pourtant vu le boxpplot pour les traitements ça n'a pas grand sens.

## Anova 2 avec interaction
anova(lm(biom~trait*hori)) # effet de chaque facteur et de l'interaction
## L'effet de l'horizon dépend du traitement (et réciproquement)
## On doit interpréter un des facteurs selon les modalités de l'autre.
## En l'occurrence : reprenons le boxplot
boxplot(biom~hori*trait)
# en labour tradi : pas de différence d'activité microbienne selon les horizons
# en labour réduit : l'activité microbienne est forte, moyenne et faible selon les horizons supérfifiels, moyens et profonds, respectivement.

## sans interaction on pourrait faire ça : (pas de sens dans ce cas)
anova(lm(biom~trait+hori))

## On peut compléter l'analyse par un
## test de comparaison multiple de moyennes :

TukeyHSD(aov(biom~fac))
plot(TukeyHSD(aov(biom~fac)))

## mise en forme du graphique :
par(mar=c(5,8,4,3.5))
plot(TukeyHSD(aov(biom~fac)),las=2)

# ne diffèrent pas :
# 18-30 LT-0-7 LT .
# 7-18 LT-0-7 LT .
# 7-18 TR-0-7 LT .
# 7-18 LT-18-30 LT .
# 7-18 TR-18-30 LT .
# 7-18 TR-7-18 LT .

# dit autrement :

# Les LT sont tous ensembles
# 18-30 LT-0-7 LT
# 7-18 LT-0-7 LT
# 7-18 LT-18-30 LT

# et 7-18 TR ressemble aussi aux trois LT
# 7-18 TR-18-30 LT
# 7-18 TR-7-18 LT
# 7-18 TR-0-7 LT

## Les groupes en couleurs :
X11()
boxplot(biom~hori*trait, col=c(2,2,2,3,4,2), las=2)

## Pour faire un joli graphique :
# on peut organiser les modalités de profondeur dans le bonne ordre
levels(hori)
hori2 <- factor(hori, levels=c("0-7","7-18","18-30"), ordered=TRUE)

# hori et hori2 contiennent la même info
data.frame(hori2, hori)

# mais l'ordre est géré différemment :
boxplot(biom~hori2*trait, col=c(2,2,2,3,2,4), las=2)
abline(v=3.5, lty=2)
text(1.5,150, "Labour Tradi")
text(4.5,150, "Travail Réduit")
