## 04/06/2014
## VP
##
## Exercice pour TDR2.3
## Analyse de sol
## �l�ments de r�alistion et commentaires

## Importation
sol <- read.table("dt sol2007.csv",header=TRUE, dec=",", sep=";")
head(sol)

## acc�der aux colonnes
biom <- sol$biomm
trait <- sol$trait
hori <- sol$hori

##J'ai nomm� mes facteurs et ma variable quantitative, mais lorsque je cherche la moyenne avec les effets des deux facteurs j'ai un probl�me:
tapply(biom, trait*hori,mean)
## Cr�ons donc un facteur suppl�mentaire croisant hori et trait
fac <- paste(hori,trait)
fac
fac <- as.factor(fac) ## on en fait un facteur (variable quali)
fac

## Calcul des moyenne et �cart-type par facteurs
tapply(biom,hori,mean)
tapply(biom,hori,sd)

tapply(biom,trait,mean)
tapply(biom,trait,sd)

tapply(biom,fac,mean)
tapply(biom,fac,sd)

## graphiques
boxplot(biom~hori) # On observe un effet surtout sur les moyennes
boxplot(biom~trait) # On observe un effet sur les variances : pas adapter � une Anova
boxplot(biom~hori*trait) # Tout est l�


## test d'homosc�dasticit�
bartlett.test(biom~trait)
bartlett.test(biom~hori)
bartlett.test(biom~fac)
## dans tous les cas on rejete H0. On ne peut pas confirmer l'homosc�dasticit�.
# Toutefois, on va contin uer le test.


## test de normalit� pour l'anova � deux facteurs
par(mfrow=c(2,2))
lm1 <-lm(biom~trait*hori)
plot(lm1) ## d'apr�s le qqplot, la normalit� des r�sidus est acceptable

##### anovaS
## Anova 1
anova(lm(biom~hori))
anova(lm(biom~trait))
# on observe un effet dans les deux cas. Pourtant vu le boxpplot pour les traitements �a n'a pas grand sens.

## Anova 2 avec interaction
anova(lm(biom~trait*hori)) # effet de chaque facteur et de l'interaction
## L'effet de l'horizon d�pend du traitement (et r�ciproquement)
## On doit interpr�ter un des facteurs selon les modalit�s de l'autre.
## En l'occurrence : reprenons le boxplot
boxplot(biom~hori*trait)
# en labour tradi : pas de diff�rence d'activit� microbienne selon les horizons
# en labour r�duit : l'activit� microbienne est forte, moyenne et faible selon les horizons sup�rfifiels, moyens et profonds, respectivement.

## sans interaction on pourrait faire �a : (pas de sens dans ce cas)
anova(lm(biom~trait+hori))

## On peut compl�ter l'analyse par un
## test de comparaison multiple de moyennes :

TukeyHSD(aov(biom~fac))
plot(TukeyHSD(aov(biom~fac)))

## mise en forme du graphique :
par(mar=c(5,8,4,3.5))
plot(TukeyHSD(aov(biom~fac)),las=2)

# ne diff�rent pas :
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
# on peut organiser les modalit�s de profondeur dans le bonne ordre
levels(hori)
hori2 <- factor(hori, levels=c("0-7","7-18","18-30"), ordered=TRUE)

# hori et hori2 contiennent la m�me info
data.frame(hori2, hori)

# mais l'ordre est g�r� diff�remment :
boxplot(biom~hori2*trait, col=c(2,2,2,3,2,4), las=2)
abline(v=3.5, lty=2)
text(1.5,150, "Labour Tradi")
text(4.5,150, "Travail R�duit")
