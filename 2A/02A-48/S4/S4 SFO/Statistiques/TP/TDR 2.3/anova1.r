## 03/05/2012
## VP
##
## �l�ments de scipts pour une ANOVA et ce qui va avec

# exemple de script pour anova 1 :
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# j'appelle numeric ma variable quantitative � expliquer
# j'appelle facteur  ma variable qualitative explicative
# Si besoin, on force une variable numerique en facteur comme �a  :
monFacteur <- as.factor(facteurCodeeEnNumeric)

#  pour tester le script, je cr�e des donn�es :
numeric <- c(rpois(10,20),rpois(9,17),rpois(11,22))
facteur <- as.factor(rep(c("A","B","C"),c(10,9,11)))
numeric;facteur


# au menu :
#^^^^^^^^^^
# - calcul de moyenne et variance par groupe
# - boxplot
# - table (plan equilibr� ou pas ?)
# - homosc�dasticit�, test de Bartlett
# - normalit�
# - anova
# - test de comparaison multiple de moyenne : test HSD de tukey et son graphique

# - calcul de moyenne par groupe
 # pour un facteur
tapply(numeric,facteur,mean)
tapply(numeric,facteur,var) # pour la variance estim�e

# - boxplot de numeric en fonction de facteur
boxplot(numeric~facteur)

# - table (plan equilibr� ou pas ?)
table(facteur) # retourne une table de contingence

# normalit�
# On peut faire un histogramme pour chaque groupe si on a assez de donn�es:
hist(numeric[facteur=="A"])  ## Refaire le m�me pour B et C

# avec peu de donn�es, un qqplot est judicieux :
qqnorm(numeric[facteur=="A"])
qqline(numeric[facteur=="A"])  # Si les points sont globalement align�s sur la droite les donn�es se comportent comme suivant une loi normale

# on peut faire les 6 figures d'un coup :
par(mfrow=c(2,3)) # pour faire 2*3 graphiques d'un coup
tapply(numeric,facteur,hist)    # histogrammes
qqP <- function(y){qqnorm(y);qqline(y)} # une fonction
tapply(numeric,facteur,qqP)     # qqnorm et qqline

# on peut aussi faire un test de shapiro pour la normalit� :
tapply(numeric,facteur,shapiro.test)

# - homosc�dasticit�, test de Bartlett
 # un facteur
bartlett.test(numeric,facteur)

# le test de bartlett est sensible aux �carts � la normallit�
# on peut alors faire un test de fligner :
fligner.test(numeric~facteur)

# - anova
anova(lm(numeric~facteur))

# Test des moyennes deux � deux.
# Attention � la fonction TukeyHSD :
#      - � ecrire avec les majuscules
#      - elle utilise un objet aov (qui est une autre fa�on de faire une anova)
TukeyHSD(aov(numeric~facteur))
plot(TukeyHSD(aov(numeric~facteur)))

