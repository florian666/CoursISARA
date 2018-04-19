## 03/05/2012
## VP
##
## Éléments de scipts pour une ANOVA et ce qui va avec

# exemple de script pour anova 1 :
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# j'appelle numeric ma variable quantitative à expliquer
# j'appelle facteur  ma variable qualitative explicative
# Si besoin, on force une variable numerique en facteur comme ça  :
monFacteur <- as.factor(facteurCodeeEnNumeric)

#  pour tester le script, je crée des données :
numeric <- c(rpois(10,20),rpois(9,17),rpois(11,22))
facteur <- as.factor(rep(c("A","B","C"),c(10,9,11)))
numeric;facteur


# au menu :
#^^^^^^^^^^
# - calcul de moyenne et variance par groupe
# - boxplot
# - table (plan equilibré ou pas ?)
# - homoscédasticité, test de Bartlett
# - normalité
# - anova
# - test de comparaison multiple de moyenne : test HSD de tukey et son graphique

# - calcul de moyenne par groupe
 # pour un facteur
tapply(numeric,facteur,mean)
tapply(numeric,facteur,var) # pour la variance estimée

# - boxplot de numeric en fonction de facteur
boxplot(numeric~facteur)

# - table (plan equilibré ou pas ?)
table(facteur) # retourne une table de contingence

# normalité
# On peut faire un histogramme pour chaque groupe si on a assez de données:
hist(numeric[facteur=="A"])  ## Refaire le même pour B et C

# avec peu de données, un qqplot est judicieux :
qqnorm(numeric[facteur=="A"])
qqline(numeric[facteur=="A"])  # Si les points sont globalement alignés sur la droite les données se comportent comme suivant une loi normale

# on peut faire les 6 figures d'un coup :
par(mfrow=c(2,3)) # pour faire 2*3 graphiques d'un coup
tapply(numeric,facteur,hist)    # histogrammes
qqP <- function(y){qqnorm(y);qqline(y)} # une fonction
tapply(numeric,facteur,qqP)     # qqnorm et qqline

# on peut aussi faire un test de shapiro pour la normalité :
tapply(numeric,facteur,shapiro.test)

# - homoscédasticité, test de Bartlett
 # un facteur
bartlett.test(numeric,facteur)

# le test de bartlett est sensible aux écarts à la normallité
# on peut alors faire un test de fligner :
fligner.test(numeric~facteur)

# - anova
anova(lm(numeric~facteur))

# Test des moyennes deux à deux.
# Attention à la fonction TukeyHSD :
#      - à ecrire avec les majuscules
#      - elle utilise un objet aov (qui est une autre façon de faire une anova)
TukeyHSD(aov(numeric~facteur))
plot(TukeyHSD(aov(numeric~facteur)))

